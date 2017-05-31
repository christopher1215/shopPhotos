/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	View controller for camera interface.
*/

@import AVFoundation;
@import Photos;

#import "PublishVideoCtr.h"
#import "AVCamPreviewView.h"
#import "AVCamPhotoCaptureDelegate.h"
#import "CommonDefine.h"
#import <UIView+SDAutoLayout.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <TZImagePickerController.h>
#import <TZImageManager.h>
#import "PublishVideo.h"

static void * SessionRunningContext = &SessionRunningContext;

typedef NS_ENUM( NSInteger, AVCamSetupResult ) {
	AVCamSetupResultSuccess,
	AVCamSetupResultCameraNotAuthorized,
	AVCamSetupResultSessionConfigurationFailed
};

typedef NS_ENUM( NSInteger, AVCamCaptureMode ) {
	AVCamCaptureModePhoto = 0,
	AVCamCaptureModeMovie = 1
};

typedef NS_ENUM( NSInteger, AVCamLivePhotoMode ) {
	AVCamLivePhotoModeOn,
	AVCamLivePhotoModeOff
};

@interface AVCaptureDeviceDiscoverySession (Utilities)

- (NSInteger)uniqueDevicePositionsCount;

@end

@implementation AVCaptureDeviceDiscoverySession (Utilities)

- (NSInteger)uniqueDevicePositionsCount
{
	NSMutableArray<NSNumber *> *uniqueDevicePositions = [NSMutableArray array];
	
	for ( AVCaptureDevice *device in self.devices ) {
		if ( ! [uniqueDevicePositions containsObject:@(device.position)] ) {
			[uniqueDevicePositions addObject:@(device.position)];
		}
	}
	
	return uniqueDevicePositions.count;
}

@end

@interface PublishVideoCtr () <AVCaptureFileOutputRecordingDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>{
    NSTimer * countTimer;
}

// Session management.
@property (nonatomic, weak) IBOutlet AVCamPreviewView *previewView;

@property (nonatomic) AVCamSetupResult setupResult;
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic, getter=isSessionRunning) BOOL sessionRunning;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;

// Device configuration.
@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (nonatomic, weak) IBOutlet UILabel *cameraUnavailableLabel;
@property (nonatomic) AVCaptureDeviceDiscoverySession *videoDeviceDiscoverySession;

// Capturing photos.
//@property (nonatomic, weak) IBOutlet UIButton *photoButton;
//@property (nonatomic, weak) IBOutlet UIButton *livePhotoModeButton;
@property (nonatomic) AVCamLivePhotoMode livePhotoMode;

@property (nonatomic) AVCapturePhotoOutput *photoOutput;
@property (nonatomic) NSMutableDictionary<NSNumber *, AVCamPhotoCaptureDelegate *> *inProgressPhotoCaptureDelegates;
@property (nonatomic) NSInteger inProgressLivePhotoCapturesCount;

// Recording movies.
@property (nonatomic, weak) IBOutlet UIButton *recordButton;
//@property (nonatomic, weak) IBOutlet UIButton *resumeButton;

@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) NSURL * outputFileURL;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIView *publishView;
@property (weak, nonatomic) IBOutlet UIButton *closePublishButton;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UIView *seperate;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UITextView *videoDescription;
@property (weak, nonatomic) IBOutlet UIButton *clearDescriptionButton;

@property (strong,nonatomic) UIImage * coverImage;
//@property (strong,nonatomic) NSURL * videoUrl;
@property (strong,nonatomic) NSString * videoUrl;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (assign, nonatomic) float countdown;
@property (weak, nonatomic) IBOutlet UIProgressView *progressTime;
@end

@implementation PublishVideoCtr

#pragma mark View Controller Life Cycle

- (void)viewDidLoad
{
	[super viewDidLoad];

    [self createPublishview];
    
    self.recordButton.layer.cornerRadius = self.recordButton.frame.size.width/2;
    self.recordButton.layer.masksToBounds = YES;
    self.recordButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.recordButton.layer.borderWidth = 2.0f;
    

    self.clearButton.hidden = YES;
    self.saveButton.hidden = YES;
    
	// Disable UI. The UI is enabled if and only if the session starts running.
//	self.cameraButton.enabled = NO;
//	self.recordButton.enabled = NO;
	
	// Create the AVCaptureSession.
	self.session = [[AVCaptureSession alloc] init];
	
	// Create a device discovery session.
	NSArray<AVCaptureDeviceType> *deviceTypes = @[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInDuoCamera];
	self.videoDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
	
	// Set up the preview view.
	self.previewView.session = self.session;
	
	// Communicate with the session and other session objects on this queue.
	self.sessionQueue = dispatch_queue_create( "session queue", DISPATCH_QUEUE_SERIAL );
	
	self.setupResult = AVCamSetupResultSuccess;
	
	/*
		Check video authorization status. Video access is required and audio
		access is optional. If audio access is denied, audio is not recorded
		during movie recording.
	*/
	switch ( [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] )
	{
		case AVAuthorizationStatusAuthorized:
		{
			// The user has previously granted access to the camera.
			break;
		}
		case AVAuthorizationStatusNotDetermined:
		{
			/*
				The user has not yet been presented with the option to grant
				video access. We suspend the session queue to delay session
				setup until the access request has completed.
				
				Note that audio access will be implicitly requested when we
				create an AVCaptureDeviceInput for audio during session setup.
			*/
			dispatch_suspend( self.sessionQueue );
			[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^( BOOL granted ) {
				if ( ! granted ) {
					self.setupResult = AVCamSetupResultCameraNotAuthorized;
				}
				dispatch_resume( self.sessionQueue );
			}];
			break;
		}
		default:
		{
			// The user has previously denied access.
			self.setupResult = AVCamSetupResultCameraNotAuthorized;
			break;
		}
	}
	
	/*
		Setup the capture session.
		In general it is not safe to mutate an AVCaptureSession or any of its
		inputs, outputs, or connections from multiple threads at the same time.
		
		Why not do all of this on the main queue?
		Because -[AVCaptureSession startRunning] is a blocking call which can
		take a long time. We dispatch session setup to the sessionQueue so
		that the main queue isn't blocked, which keeps the UI responsive.
	*/
	dispatch_async( self.sessionQueue, ^{
		[self configureSession];
	} );
}

- (void)createPublishview{
    
//    self.view.backgroundColor = ColorHex(0xf5f5f5);
    
    self.publishView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(315);
    self.publishView.backgroundColor = [UIColor whiteColor];
    
    self.closePublishButton.sd_layout
    .topSpaceToView(self.publishView,33)
    .leftSpaceToView(self.publishView,15)
    .heightIs(17)
    .widthIs(35);
    
    
    self.publishButton.sd_layout
    .topSpaceToView(self.publishView,33)
    .rightSpaceToView(self.publishView,15)
    .heightIs(17)
    .widthIs(35);

    self.seperate.sd_layout
    .topSpaceToView(self.publishView,64)
    .leftEqualToView(self.publishView)
    .rightEqualToView(self.publishView)
    .heightIs(1);

    self.videoImageView.sd_layout
    .topSpaceToView(self.seperate,10)
    .leftSpaceToView(self.publishView,15)
    .widthIs(140)
    .heightIs(140);
    self.videoImageView.sd_cornerRadius = [NSNumber numberWithDouble:5.0];
    
    UIButton *videoPlayButton = [[UIButton alloc] initWithFrame:CGRectMake(self.videoImageView.frame.size.width/4, self.videoImageView.frame.size.height/4, self.videoImageView.frame.size.width/2, self.videoImageView.frame.size.height/2)];
    [self.videoImageView addSubview:videoPlayButton];
    [videoPlayButton setBackgroundImage:[UIImage imageNamed:@"btn_movie"] forState:UIControlStateNormal];
    videoPlayButton.sd_cornerRadius = [NSNumber numberWithDouble:5.0];
//    videoPlayButton.alpha = 0.5;
    
    self.videoDescription.sd_layout
    .topSpaceToView(self.videoImageView,15)
    .leftSpaceToView(self.publishView,15)
    .rightSpaceToView(self.publishView,15)
    .heightIs(50);
    self.videoDescription.text = @"";
    
    self.clearDescriptionButton.sd_layout
    .topSpaceToView(self.videoDescription,10)
    .rightSpaceToView(self.publishView,15)
    .widthIs(16)
    .heightIs(16);
    
    self.seperate.backgroundColor = ColorHex(0xeeeeee);
    
    self.publishView.hidden = YES;
    self.previewView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	dispatch_async( self.sessionQueue, ^{
		switch ( self.setupResult )
		{
			case AVCamSetupResultSuccess:
			{
				// Only setup observers and start the session running if setup succeeded.
				[self addObservers];
				[self.session startRunning];
				self.sessionRunning = self.session.isRunning;
				break;
			}
			case AVCamSetupResultCameraNotAuthorized:
			{
				dispatch_async( dispatch_get_main_queue(), ^{
					NSString *message = NSLocalizedString( @"AVCam doesn't have permission to use the camera, please change privacy settings", @"Alert message when the user has denied access to the camera" );
					UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
					UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
					[alertController addAction:cancelAction];
					// Provide quick access to Settings.
					UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Settings", @"Alert button to open Settings" ) style:UIAlertActionStyleDefault handler:^( UIAlertAction *action ) {
						[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
					}];
					[alertController addAction:settingsAction];
					[self presentViewController:alertController animated:YES completion:nil];
				} );
				break;
			}
			case AVCamSetupResultSessionConfigurationFailed:
			{
				dispatch_async( dispatch_get_main_queue(), ^{
					NSString *message = NSLocalizedString( @"Unable to capture media", @"Alert message when something goes wrong during capture session configuration" );
					UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
					UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
					[alertController addAction:cancelAction];
					[self presentViewController:alertController animated:YES completion:nil];
				} );
				break;
			}
		}
	} );
}

- (void)viewDidDisappear:(BOOL)animated
{
	dispatch_async( self.sessionQueue, ^{
		if ( self.setupResult == AVCamSetupResultSuccess ) {
			[self.session stopRunning];
			[self removeObservers];
		}
	} );
	
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotate
{
	// Disable autorotation of the interface when recording is in progress.
	return ! self.movieFileOutput.isRecording;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	
	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
	
	if ( UIDeviceOrientationIsPortrait( deviceOrientation ) || UIDeviceOrientationIsLandscape( deviceOrientation ) ) {
		self.previewView.videoPreviewLayer.connection.videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
	}
}

- (void) showPublishView {
    self.view.backgroundColor = ColorHex(0xf5f5f5);
    self.previewView.hidden = YES;
    self.publishView.hidden = NO;
}

#pragma mark Session Management

// Call this on the session queue.
- (void)configureSession
{
	if ( self.setupResult != AVCamSetupResultSuccess ) {
		return;
	}
	
	NSError *error = nil;
	
	[self.session beginConfiguration];
	
	/*
		We do not create an AVCaptureMovieFileOutput when setting up the session because the
		AVCaptureMovieFileOutput does not support movie recording with AVCaptureSessionPresetPhoto.
	*/
	self.session.sessionPreset = AVCaptureSessionPresetMedium;
	
	// Add video input.
	
	// Choose the back dual camera if available, otherwise default to a wide angle camera.
	AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDuoCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
	if ( ! videoDevice ) {
		// If the back dual camera is not available, default to the back wide angle camera.
		videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
		
		// In some cases where users break their phones, the back wide angle camera is not available. In this case, we should default to the front wide angle camera.
		if ( ! videoDevice ) {
			videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
		}
	}
	AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
	if ( ! videoDeviceInput ) {
		NSLog( @"Could not create video device input: %@", error );
		self.setupResult = AVCamSetupResultSessionConfigurationFailed;
		[self.session commitConfiguration];
		return;
	}
	if ( [self.session canAddInput:videoDeviceInput] ) {
		[self.session addInput:videoDeviceInput];
		self.videoDeviceInput = videoDeviceInput;
		
		dispatch_async( dispatch_get_main_queue(), ^{
			/*
				Why are we dispatching this to the main queue?
				Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView
				can only be manipulated on the main thread.
				Note: As an exception to the above rule, it is not necessary to serialize video orientation changes
				on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
				
				Use the status bar orientation as the initial video orientation. Subsequent orientation changes are
				handled by -[AVCamCameraViewController viewWillTransitionToSize:withTransitionCoordinator:].
			*/
			UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
			AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationPortrait;
			if ( statusBarOrientation != UIInterfaceOrientationUnknown ) {
				initialVideoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
			}
			
			self.previewView.videoPreviewLayer.connection.videoOrientation = initialVideoOrientation;
		} );
	}
	else {
		NSLog( @"Could not add video device input to the session" );
		self.setupResult = AVCamSetupResultSessionConfigurationFailed;
		[self.session commitConfiguration];
		return;
	}
	/*
	// Add audio input.
	AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
	AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
	if ( ! audioDeviceInput ) {
		NSLog( @"Could not create audio device input: %@", error );
	}
	if ( [self.session canAddInput:audioDeviceInput] ) {
		[self.session addInput:audioDeviceInput];
	}
	else {
		NSLog( @"Could not add audio device input to the session" );
	}
	
	// Add photo output.
	AVCapturePhotoOutput *photoOutput = [[AVCapturePhotoOutput alloc] init];
	if ( [self.session canAddOutput:photoOutput] ) {
		[self.session addOutput:photoOutput];
		self.photoOutput = photoOutput;
		
		self.photoOutput.highResolutionCaptureEnabled = YES;
		self.photoOutput.livePhotoCaptureEnabled = self.photoOutput.livePhotoCaptureSupported;
		self.livePhotoMode = self.photoOutput.livePhotoCaptureSupported ? AVCamLivePhotoModeOn : AVCamLivePhotoModeOff;
		
		self.inProgressPhotoCaptureDelegates = [NSMutableDictionary dictionary];
		self.inProgressLivePhotoCapturesCount = 0;
	}
	else {
		NSLog( @"Could not add photo output to the session" );
		self.setupResult = AVCamSetupResultSessionConfigurationFailed;
		[self.session commitConfiguration];
		return;
	}
    
    */
	//Add Movie output
    AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    if ( [self.session canAddOutput:movieFileOutput] )
    {
        [self.session addOutput:movieFileOutput];
        self.session.sessionPreset = AVCaptureSessionPresetMedium;
        AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ( connection.isVideoStabilizationSupported ) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        self.movieFileOutput = movieFileOutput;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            self.recordButton.enabled = YES;
        } );
    }
    
    
	self.backgroundRecordingID = UIBackgroundTaskInvalid;
	
	[self.session commitConfiguration];
}
- (IBAction)closeRecordView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resumeInterruptedSession:(id)sender
{
	dispatch_async( self.sessionQueue, ^{
		/*
			The session might fail to start running, e.g., if a phone or FaceTime call is still
			using audio or video. A failure to start the session running will be communicated via
			a session runtime error notification. To avoid repeatedly failing to start the session
			running, we only try to restart the session running in the session runtime error handler
			if we aren't trying to resume the session running.
		*/
		[self.session startRunning];
		self.sessionRunning = self.session.isRunning;
		if ( ! self.session.isRunning ) {
			dispatch_async( dispatch_get_main_queue(), ^{
				NSString *message = NSLocalizedString( @"Unable to resume", @"Alert message when unable to resume the session running" );
				UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
				[alertController addAction:cancelAction];
				[self presentViewController:alertController animated:YES completion:nil];
			} );
		}
		else {
			dispatch_async( dispatch_get_main_queue(), ^{
//				self.resumeButton.hidden = YES;
			} );
		}
	} );
}


#pragma mark Device Configuration
- (IBAction)flashOnOff:(id)sender {
    dispatch_async( self.sessionQueue, ^{
        AVCaptureDevice *currentVideoDevice = self.videoDeviceInput.device;
        [currentVideoDevice lockForConfiguration:nil]; //you must lock before setting torch mode
        
        if (currentVideoDevice.torchMode == AVCaptureTorchModeOn) {
            if ([currentVideoDevice isTorchModeSupported:AVCaptureTorchModeOff]) {
                [currentVideoDevice setTorchMode:AVCaptureTorchModeOff];
            }
        }
        else if (currentVideoDevice.torchMode == AVCaptureTorchModeOff) {
            if ([currentVideoDevice isTorchModeSupported:AVCaptureTorchModeOn]) {
                [currentVideoDevice setTorchMode:AVCaptureTorchModeOn];
            }
        }
        [currentVideoDevice unlockForConfiguration];
    });
}

- (IBAction)changeCamera:(id)sender
{
	self.cameraButton.enabled = NO;
	self.recordButton.enabled = NO;
	
	dispatch_async( self.sessionQueue, ^{
		AVCaptureDevice *currentVideoDevice = self.videoDeviceInput.device;
		AVCaptureDevicePosition currentPosition = currentVideoDevice.position;
		
		AVCaptureDevicePosition preferredPosition;
		AVCaptureDeviceType preferredDeviceType;
		
		switch ( currentPosition )
		{
			case AVCaptureDevicePositionUnspecified:
			case AVCaptureDevicePositionFront:
				preferredPosition = AVCaptureDevicePositionBack;
				preferredDeviceType = AVCaptureDeviceTypeBuiltInDuoCamera;
				break;
			case AVCaptureDevicePositionBack:
				preferredPosition = AVCaptureDevicePositionFront;
				preferredDeviceType = AVCaptureDeviceTypeBuiltInWideAngleCamera;
				break;
		}
		
		NSArray<AVCaptureDevice *> *devices = self.videoDeviceDiscoverySession.devices;
		AVCaptureDevice *newVideoDevice = nil;
		
		// First, look for a device with both the preferred position and device type.
		for ( AVCaptureDevice *device in devices ) {
			if ( device.position == preferredPosition && [device.deviceType isEqualToString:preferredDeviceType] ) {
				newVideoDevice = device;
				break;
			}
		}
		
		// Otherwise, look for a device with only the preferred position.
		if ( ! newVideoDevice ) {
			for ( AVCaptureDevice *device in devices ) {
				if ( device.position == preferredPosition ) {
					newVideoDevice = device;
					break;
				}
			}
		}
		
		if ( newVideoDevice ) {
			AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:newVideoDevice error:NULL];
			
			[self.session beginConfiguration];
			
			// Remove the existing device input first, since using the front and back camera simultaneously is not supported.
			[self.session removeInput:self.videoDeviceInput];
			
			if ( [self.session canAddInput:videoDeviceInput] ) {
				[[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
				
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:newVideoDevice];
				
				[self.session addInput:videoDeviceInput];
				self.videoDeviceInput = videoDeviceInput;
			}
			else {
				[self.session addInput:self.videoDeviceInput];
			}
			
			AVCaptureConnection *movieFileOutputConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
			if ( movieFileOutputConnection.isVideoStabilizationSupported ) {
				movieFileOutputConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
			}
			
			/*
				Set Live Photo capture enabled if it is supported. When changing cameras, the
				`livePhotoCaptureEnabled` property of the AVCapturePhotoOutput gets set to NO when
				a video device is disconnected from the session. After the new video device is
				added to the session, re-enable Live Photo capture on the AVCapturePhotoOutput if it is supported.
			 */
			self.photoOutput.livePhotoCaptureEnabled = self.photoOutput.livePhotoCaptureSupported;
			
			[self.session commitConfiguration];
		}
		
		dispatch_async( dispatch_get_main_queue(), ^{
			self.cameraButton.enabled = YES;
            self.recordButton.enabled = YES;
		} );
	} );
}

- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
	CGPoint devicePoint = [self.previewView.videoPreviewLayer captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:gestureRecognizer.view]];
	[self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
	dispatch_async( self.sessionQueue, ^{
		AVCaptureDevice *device = self.videoDeviceInput.device;
		NSError *error = nil;
		if ( [device lockForConfiguration:&error] ) {
			/*
				Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation.
				Call set(Focus/Exposure)Mode() to apply the new point of interest.
			*/
			if ( device.isFocusPointOfInterestSupported && [device isFocusModeSupported:focusMode] ) {
				device.focusPointOfInterest = point;
				device.focusMode = focusMode;
			}
			
			if ( device.isExposurePointOfInterestSupported && [device isExposureModeSupported:exposureMode] ) {
				device.exposurePointOfInterest = point;
				device.exposureMode = exposureMode;
			}
			
			device.subjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange;
			[device unlockForConfiguration];
		}
		else {
			NSLog( @"Could not lock device for configuration: %@", error );
		}
	} );
}

#pragma mark Capturing Photos

- (void)capturePhoto
{
	/*
		Retrieve the video preview layer's video orientation on the main queue before
		entering the session queue. We do this to ensure UI elements are accessed on
		the main thread and session configuration is done on the session queue.
	*/
	AVCaptureVideoOrientation videoPreviewLayerVideoOrientation = self.previewView.videoPreviewLayer.connection.videoOrientation;

	dispatch_async( self.sessionQueue, ^{
		
		// Update the photo output's connection to match the video orientation of the video preview layer.
		AVCaptureConnection *photoOutputConnection = [self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
		photoOutputConnection.videoOrientation = videoPreviewLayerVideoOrientation;
		
		// Capture a JPEG photo with flash set to auto and high resolution photo enabled.
		AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettings];
		photoSettings.flashMode = AVCaptureFlashModeAuto;
		photoSettings.highResolutionPhotoEnabled = YES;
		if ( photoSettings.availablePreviewPhotoPixelFormatTypes.count > 0 ) {
			photoSettings.previewPhotoFormat = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : photoSettings.availablePreviewPhotoPixelFormatTypes.firstObject };
		}
		if ( self.livePhotoMode == AVCamLivePhotoModeOn && self.photoOutput.livePhotoCaptureSupported ) { // Live Photo capture is not supported in movie mode.
			NSString *livePhotoMovieFileName = [NSUUID UUID].UUIDString;
			NSString *livePhotoMovieFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[livePhotoMovieFileName stringByAppendingPathExtension:@"mov"]];
			photoSettings.livePhotoMovieFileURL = [NSURL fileURLWithPath:livePhotoMovieFilePath];
		}
		
		// Use a separate object for the photo capture delegate to isolate each capture life cycle.
		AVCamPhotoCaptureDelegate *photoCaptureDelegate = [[AVCamPhotoCaptureDelegate alloc] initWithRequestedPhotoSettings:photoSettings willCapturePhotoAnimation:^{
			dispatch_async( dispatch_get_main_queue(), ^{
				self.previewView.videoPreviewLayer.opacity = 0.0;
				[UIView animateWithDuration:0.25 animations:^{
					self.previewView.videoPreviewLayer.opacity = 1.0;
				}];
			} );
		} capturingLivePhoto:^( BOOL capturing ) {
			/*
				Because Live Photo captures can overlap, we need to keep track of the
				number of in progress Live Photo captures to ensure that the
				Live Photo label stays visible during these captures.
			*/
			dispatch_async( self.sessionQueue, ^{
				if ( capturing ) {
					self.inProgressLivePhotoCapturesCount++;
				}
				else {
					self.inProgressLivePhotoCapturesCount--;
				}
				
				NSInteger inProgressLivePhotoCapturesCount = self.inProgressLivePhotoCapturesCount;
				dispatch_async( dispatch_get_main_queue(), ^{
					if ( inProgressLivePhotoCapturesCount > 0 ) {
//						self.capturingLivePhotoLabel.hidden = NO;
					}
					else if ( inProgressLivePhotoCapturesCount == 0 ) {
//						self.capturingLivePhotoLabel.hidden = YES;
					}
					else {
						NSLog( @"Error: In progress live photo capture count is less than 0" );
					}
				} );
			} );
		} completed:^( AVCamPhotoCaptureDelegate *photoCaptureDelegate ) {
			// When the capture is complete, remove a reference to the photo capture delegate so it can be deallocated.
			dispatch_async( self.sessionQueue, ^{
				self.inProgressPhotoCaptureDelegates[@(photoCaptureDelegate.requestedPhotoSettings.uniqueID)] = nil;
			} );
		}];
		
		/*
			The Photo Output keeps a weak reference to the photo capture delegate so
			we store it in an array to maintain a strong reference to this object
			until the capture is completed.
		*/
		self.inProgressPhotoCaptureDelegates[@(photoCaptureDelegate.requestedPhotoSettings.uniqueID)] = photoCaptureDelegate;
		[self.photoOutput capturePhotoWithSettings:photoSettings delegate:photoCaptureDelegate];
	} );
}

#pragma mark Recording Movies

- (IBAction)toggleMovieRecording:(id)sender
{
	/*
		Disable the Camera button until recording finishes, and disable
		the Record button until recording starts or finishes.
		
		See the AVCaptureFileOutputRecordingDelegate methods.
	 */
    if (self.cameraButton.enabled == YES) {
//        [self capturePhoto];
    }

    self.cameraButton.enabled = NO;
	self.recordButton.enabled = NO;
    self.clearButton.hidden = YES;
    self.saveButton.hidden = YES;
	
	/*
		Retrieve the video preview layer's video orientation on the main queue
		before entering the session queue. We do this to ensure UI elements are
		accessed on the main thread and session configuration is done on the session queue.
	*/
    __weak __typeof(self)weakSelf = self;
	AVCaptureVideoOrientation videoPreviewLayerVideoOrientation = self.previewView.videoPreviewLayer.connection.videoOrientation;
	dispatch_async( self.sessionQueue, ^{
		if ( ! weakSelf.movieFileOutput.isRecording ) {
			if ( [UIDevice currentDevice].isMultitaskingSupported ) {
				/*
					Setup background task.
					This is needed because the -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:]
					callback is not received until AVCam returns to the foreground unless you request background execution time.
					This also ensures that there will be time to write the file to the photo library when AVCam is backgrounded.
					To conclude this background execution, -[endBackgroundTask:] is called in
					-[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:] after the recorded file has been saved.
				*/
				weakSelf.backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
			}
			
			// Update the orientation on the movie file output video connection before starting recording.
			AVCaptureConnection *movieFileOutputConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
			movieFileOutputConnection.videoOrientation = videoPreviewLayerVideoOrientation;
			
			// Start recording to a temporary file.
			NSString *outputFileName = [NSUUID UUID].UUIDString;
			NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[outputFileName stringByAppendingPathExtension:@"mov"]];
            
			[weakSelf.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
		}
		else {
			[weakSelf.movieFileOutput stopRecording];
		}
	} );
}
- (void)countDownSec:(NSTimer *)timer{
    self.countdown = self.countdown + 0.01 ;
    if(self.countdown <= 10.01){
        NSString * title = [NSString stringWithFormat:@"%.1f",self.countdown];
        [self.lblTime setText:title];
        [self.progressTime setProgress:self.countdown / 10 animated:NO];
    }else{
        [self toggleMovieRecording:nil];
        [countTimer invalidate];
        countTimer = nil;
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
	// Enable the Record button to let the user stop the recording.
	dispatch_async( dispatch_get_main_queue(), ^{
		self.recordButton.enabled = YES;
        self.recordButton.backgroundColor = ColorHex(0xff1111);
		[self.recordButton setTitle:NSLocalizedString( @"停止录", @"Recording button stop title" ) forState:UIControlStateNormal];
        self.countdown = 0;
        countTimer = [NSTimer scheduledTimerWithTimeInterval: 0.01f
                                                      target: self
                                                    selector:@selector(countDownSec:)
                                                    userInfo: nil repeats:YES];

	});
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
	/*
		Note that currentBackgroundRecordingID is used to end the background task
		associated with this recording. This allows a new recording to be started,
		associated with a new UIBackgroundTaskIdentifier, once the movie file output's
		`recording` property is back to NO — which happens sometime after this method
		returns.
		
		Note: Since we use a unique file path for each recording, a new recording will
		not overwrite a recording currently being saved.
	*/
	UIBackgroundTaskIdentifier currentBackgroundRecordingID = self.backgroundRecordingID;
	self.backgroundRecordingID = UIBackgroundTaskInvalid;
    self.outputFileURL = outputFileURL;
	
	dispatch_block_t cleanup = ^{
        if ( [[NSFileManager defaultManager] fileExistsAtPath:self.outputFileURL.path] ) {
            [[NSFileManager defaultManager] removeItemAtPath:self.outputFileURL.path error:NULL];
        }
        
		if ( currentBackgroundRecordingID != UIBackgroundTaskInvalid ) {
			[[UIApplication sharedApplication] endBackgroundTask:currentBackgroundRecordingID];
		}
	};
	 
	BOOL success = YES;
	
	if ( error ) {
		NSLog( @"Movie file finishing error: %@", error );
		success = [error.userInfo[AVErrorRecordingSuccessfullyFinishedKey] boolValue];
	}
    if (self.countdown <= 3) {
        success = NO;
        [countTimer invalidate];
        countTimer = nil;

        [self clearVideo:nil];
        [self showToast:@"录制时长不能小于3秒钟"];
    }
	if ( success ) {
        self.clearButton.hidden = NO;
        self.saveButton.hidden = NO;
        
        [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
            if ( status == PHAuthorizationStatusAuthorized ) {
                // Save the movie file to the photo library and cleanup.
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                    options.shouldMoveFile = YES;
                    PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAsset];
                    [creationRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:self.outputFileURL options:options];
                } completionHandler:^( BOOL success, NSError *error ) {
                    if ( ! success ) {
                        NSLog( @"Could not save movie to photo library: %@", error );
                    }
                    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
                    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchOptions];
                    PHAsset *lastAsset = [fetchResult lastObject];
                    TZImageManager *imageManager = [[TZImageManager alloc]init];
                    [imageManager getVideoOutputPathWithAsset:lastAsset completion:^(NSString *videoPath){
                        self.videoUrl = videoPath;
                        UIImage * cover = [self firstFrame:[NSURL fileURLWithPath:self.videoUrl]];
                        self.videoImageView.image = cover;
                        self.coverImage = [[UIImage alloc] init];
                        self.coverImage = cover;

                    }];


                    cleanup();
                }];
            }
            else {
                cleanup();
            }
        }];
	}
    else {
        cleanup();
    }
	
	// Enable the Camera and Record buttons to let the user switch camera and start another recording.
	dispatch_async( dispatch_get_main_queue(), ^{
		// Only enable the ability to change camera if the device has more than one camera.
		self.cameraButton.enabled = ( self.videoDeviceDiscoverySession.uniqueDevicePositionsCount > 1 );
		self.recordButton.enabled = YES;
        self.recordButton.backgroundColor = ColorHex(0x3a9dec);
		[self.recordButton setTitle:NSLocalizedString( @"开始录", @"Recording button record title" ) forState:UIControlStateNormal];
        [countTimer invalidate];
        countTimer = nil;

	});
}
- (UIImage *)firstFrame:(NSURL *)videoURL {
    
    // courtesy of null0pointer and Javi Campaña
    // http://stackoverflow.com/questions/10221242/first-frame-of-a-video-using-avfoundation
    
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    UIImage* image = [UIImage imageWithCGImage:[generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
    
    return image;
}
- (IBAction)saveVideo:(id)sender {

    [self showPublishView];
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        SPAlert(@"请允许相册访问",self);
//        return;
//    }
//    
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//    imagePickerVc.allowPickingVideo = YES;
//    imagePickerVc.allowPickingOriginalPhoto = NO;
//    imagePickerVc.allowPickingImage = NO;
//    imagePickerVc.photoWidth = 960;
//    imagePickerVc.photoPreviewMaxWidth = 960;
//    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *cover, PHAsset *assets){
//        if(assets) {
//            self.videoImageView.image = cover;
//            self.coverImage = [[UIImage alloc] init];
//            self.coverImage = cover;
//            
//            TZImageManager *imageManager = [[TZImageManager alloc]init];
//            [imageManager getVideoOutputPathWithAsset:assets completion:^(NSString *videoPath){
//                self.videoUrl = videoPath;
//            }];
//            [self showPublishView];
///*
//            PHVideoRequestOptions *videoUrlRequest = [[PHVideoRequestOptions alloc] init];
//            videoUrlRequest.version = PHVideoRequestOptionsVersionOriginal;
//            videoUrlRequest.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
//            
//            [[PHImageManager defaultManager] requestAVAssetForVideo:assets options:videoUrlRequest resultHandler:^(AVAsset * asset, AVAudioMix * audioMix, NSDictionary * info)
//            {
//                if ([asset isKindOfClass:[AVURLAsset class]]) {
//                    AVURLAsset* urlAsset = (AVURLAsset*)asset;
//                    self.videoUrl = urlAsset.URL;
//                    
////                    NSNumber *size;
////                    [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
////                    NSInteger fileLength = size.integerValue;
////                    self.videoUrl = [[urlAsset.URL absoluteString] stringByResolvingSymlinksInPath];
//                }
//            }];*/
//        }
//    }];
//    
//    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (IBAction)clearVideo:(id)sender {
    
    dispatch_block_t cleanup = ^{
        if ( [[NSFileManager defaultManager] fileExistsAtPath:self.outputFileURL.path] ) {
            [[NSFileManager defaultManager] removeItemAtPath:self.outputFileURL.path error:NULL];
        }
    };
    
    cleanup();
    [self.lblTime setText:@"0.0"];
    [self.progressTime setProgress:0 animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        NSString *moviePath = [videoUrl path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
        }
    }
}

#pragma mark KVO and Notifications

- (void)addObservers
{
	[self.session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:SessionRunningContext];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.videoDeviceInput.device];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:self.session];
	
	/*
		A session can only run when the app is full screen. It will be interrupted
		in a multi-app layout, introduced in iOS 9, see also the documentation of
		AVCaptureSessionInterruptionReason. Add observers to handle these session
		interruptions and show a preview is paused message. See the documentation
		of AVCaptureSessionWasInterruptedNotification for other interruption reasons.
	*/
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionWasInterrupted:) name:AVCaptureSessionWasInterruptedNotification object:self.session];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInterruptionEnded:) name:AVCaptureSessionInterruptionEndedNotification object:self.session];
}

- (void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.session removeObserver:self forKeyPath:@"running" context:SessionRunningContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( context == SessionRunningContext ) {
		BOOL isSessionRunning = [change[NSKeyValueChangeNewKey] boolValue];
		
		dispatch_async( dispatch_get_main_queue(), ^{
			// Only enable the ability to change camera if the device has more than one camera.
			self.cameraButton.enabled = isSessionRunning && ( self.videoDeviceDiscoverySession.uniqueDevicePositionsCount > 1 );
//			self.photoButton.enabled = isSessionRunning;
		} );
	}
	else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)subjectAreaDidChange:(NSNotification *)notification
{
	CGPoint devicePoint = CGPointMake( 0.5, 0.5 );
	[self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

- (void)sessionRuntimeError:(NSNotification *)notification
{
	NSError *error = notification.userInfo[AVCaptureSessionErrorKey];
	NSLog( @"Capture session runtime error: %@", error );
	
	/*
		Automatically try to restart the session running if media services were
		reset and the last start running succeeded. Otherwise, enable the user
		to try to resume the session running.
	*/
	if ( error.code == AVErrorMediaServicesWereReset ) {
		dispatch_async( self.sessionQueue, ^{
			if ( self.isSessionRunning ) {
				[self.session startRunning];
				self.sessionRunning = self.session.isRunning;
			}
			else {
				dispatch_async( dispatch_get_main_queue(), ^{
//					self.resumeButton.hidden = NO;
				} );
			}
		} );
	}
	else {
//		self.resumeButton.hidden = NO;
	}
}

- (void)sessionWasInterrupted:(NSNotification *)notification
{
	/*
		In some scenarios we want to enable the user to resume the session running.
		For example, if music playback is initiated via control center while
		using AVCam, then the user can let AVCam resume
		the session running, which will stop music playback. Note that stopping
		music playback in control center will not automatically resume the session
		running. Also note that it is not always possible to resume, see -[resumeInterruptedSession:].
	*/
	BOOL showResumeButton = NO;
	
	AVCaptureSessionInterruptionReason reason = [notification.userInfo[AVCaptureSessionInterruptionReasonKey] integerValue];
	NSLog( @"Capture session was interrupted with reason %ld", (long)reason );
	
	if ( reason == AVCaptureSessionInterruptionReasonAudioDeviceInUseByAnotherClient ||
		reason == AVCaptureSessionInterruptionReasonVideoDeviceInUseByAnotherClient ) {
		showResumeButton = YES;
	}
	else if ( reason == AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableWithMultipleForegroundApps ) {
		// Simply fade-in a label to inform the user that the camera is unavailable.
		self.cameraUnavailableLabel.alpha = 0.0;
		self.cameraUnavailableLabel.hidden = NO;
		[UIView animateWithDuration:0.25 animations:^{
			self.cameraUnavailableLabel.alpha = 1.0;
		}];
	}
	/*
	if ( showResumeButton ) {
		// Simply fade-in a button to enable the user to try to resume the session running.
		self.resumeButton.alpha = 0.0;
		self.resumeButton.hidden = NO;
		[UIView animateWithDuration:0.25 animations:^{
			self.resumeButton.alpha = 1.0;
		}];
	}*/
}

- (void)sessionInterruptionEnded:(NSNotification *)notification
{
	NSLog( @"Capture session interruption ended" );
/*
	if ( ! self.resumeButton.hidden ) {
		[UIView animateWithDuration:0.25 animations:^{
			self.resumeButton.alpha = 0.0;
		} completion:^( BOOL finished ) {
			self.resumeButton.hidden = YES;
		}];
	}*/
	if ( ! self.cameraUnavailableLabel.hidden ) {
		[UIView animateWithDuration:0.25 animations:^{
			self.cameraUnavailableLabel.alpha = 0.0;
		} completion:^( BOOL finished ) {
			self.cameraUnavailableLabel.hidden = YES;
		}];
	}
}

// Publish View actions
- (IBAction)cancelPublish:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)publishVideo:(id)sender {

    if (self.videoDescription.text.length <= 0) {
        [self showToast:@"请输入视频说明"];
        return;
    }
    NSMutableDictionary * postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:self.videoDescription.text forKey:@"title"];
    
    //    [self clearSelected:NO];
    [self showToast:@"正在上传,请保存网络通畅"];
    [self showLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData =  [self compressOriginalImage:self.coverImage toMaxDataSizeKBytes:300];
        NSData *videoData = [NSData dataWithContentsOfFile:self.videoUrl];

        [postData setValue:imageData forKey:@"cover"];
        [postData setValue:[NSString stringWithFormat:@"%ld", (unsigned long)imageData.length] forKey:@"coversize"];
        
        [postData setValue:videoData forKey:@"video"];
        [postData setValue:[NSString stringWithFormat:@"%ld", (unsigned long)videoData.length] forKey:@"videosize"];
        
        // 耗时的操作
        PublishVideo * task = [[PublishVideo alloc] init];
        
        [task startTask:postData complete:^(BOOL stuta) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self closeLoad];
                if(stuta){
                    [self showToast:@"上传成功"];
                    NSError *error;
                    if (![[NSFileManager defaultManager] removeItemAtPath:self.videoUrl error:&error]) {
                        NSLog(@"Delete error: %@", error);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self showToast:@"上传失败，请检查网络是否通畅，或者重新尝试"];
                }
            });
        }];
    });
}

- (IBAction)clearDescription:(id)sender {
    self.videoDescription.text = @"";

}

- (NSData *) readVideo:(NSString *) videoUrl {
    
    NSData *data = nil;
//    NSError *error = nil;
//    NSFileHandle *fileHandele = [NSFileHandle fileHandleForReadingAtPath:videoUrl];
    
    return data;
}

- (NSData *) compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size {
    
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

@end
