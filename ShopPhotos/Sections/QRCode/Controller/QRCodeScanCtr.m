//
//  QRCodeScanCtr.m
//  ShopPhotos
//
//  Created by addcn on 16/12/27.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "QRCodeScanCtr.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanOcclusionView.h"
#import "ScanTipsView.h"
#import "ScanLineView.h"
#import "ScanBorderView.h"
#import "ScanNavigation.h"
#import "ReadQRCode.h"
#import "UserInfoModel.h"
#import "PersonalHomeCtr.h"
#import "PhotoDetailsCtr.h"
#import "ErrMsgViewController.h"

@interface QRCodeScanCtr ()<ScanNavigationDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    ErrMsgViewController *popupErrVC;

}
@property (strong, nonatomic) ScanOcclusionView * occlusion;
@property (strong, nonatomic) ScanTipsView * tips;
@property (strong, nonatomic) ScanLineView * line;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (assign, nonatomic) CGRect scanRect;
@property (strong, nonatomic) NSString * resultURL;
@property (strong, nonatomic) ScanNavigation * navigation;
@property (strong, nonatomic) UIView * optionView;
@property (strong, nonatomic) UIView * glisteningView;
@property (strong, nonatomic) UIImageView * glisteningIocn;
@property (strong, nonatomic) UILabel * glisteningText;
@property (assign, nonatomic) BOOL glistenStatu;
@property (strong, nonatomic) UIView * photoView;
@property (strong, nonatomic) UIImageView * photoIcon;
@property (strong, nonatomic) UILabel * photoText;

@end

@implementation QRCodeScanCtr

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startScan];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self turnOffLed];
    [self stopScan];
}



- (void)dealloc{
    [self.line stopScan];
    for(UIView * view in self.view.subviews){
        [view removeFromSuperview];
    }
    self.session = nil;
    self.output = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    popupErrVC = [[ErrMsgViewController alloc] initWithNibName:@"ErrMsgViewController" bundle:nil];
    [self stCreateView];
    
    [self checkScanCode];
}

#pragma mark - 创建视图
- (void)stCreateView{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(someMethod) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.scanRect = CGRectMake((self.view.frame.size.width-250)/2, 180, 250, 250);
    
    self.occlusion = [[ScanOcclusionView alloc] initWithRect:self.scanRect];
    [self.occlusion setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:self.occlusion];
    
    self.tips = [[ScanTipsView alloc] initWithFrame:CGRectMake((WindowWidth-280)/2, 110, 280, 36)];
    [self.view addSubview:self.tips];
    
    self.line = [[ScanLineView alloc] initWithFrame:self.scanRect];
    [self.view addSubview:self.line];
    
    
    self.optionView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-250)/2, 460, 250, 80)];
    [self.view addSubview:self.optionView];
    [self.optionView setBackgroundColor:[UIColor clearColor]];
    
    self.glisteningView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [self.glisteningView setBackgroundColor:[UIColor clearColor]];
    [self.glisteningView addTarget:self action:@selector(glisteningSelected)];
    [self.optionView addSubview:self.glisteningView];
    
    self.glisteningIocn = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40,40)];
    [self.glisteningIocn setImage:[UIImage imageNamed:@"closelightgli"]];
    [self.glisteningIocn setContentMode:UIViewContentModeScaleAspectFit];
    [self.glisteningView addSubview:self.glisteningIocn];
    
    self.glisteningText = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 80, 30)];
    [self.glisteningText setTextAlignment:NSTextAlignmentCenter];
    [self.glisteningText setText:@"开灯"];
    [self.glisteningText setFont:Font(15)];
    [self.glisteningText setTextColor:[UIColor whiteColor]];
    [self.glisteningView addSubview:self.glisteningText];
    
    self.photoView = [[UIView alloc] initWithFrame:CGRectMake(170, 0, 80, 80)];
    [self.photoView setBackgroundColor:[UIColor clearColor]];
    [self.photoView addTarget:self action:@selector(photoSelected)];
    [self.optionView addSubview:self.photoView];
    
    self.photoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    [self.photoIcon setContentMode:UIViewContentModeScaleAspectFit];
    [self.photoIcon setImage:[UIImage imageNamed:@"gallerywhite"]];
    [self.photoView addSubview:self.photoIcon];
    
    self.photoText = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 80, 30)];
    [self.photoText setTextColor:[UIColor whiteColor]];
    [self.photoText setTextAlignment:NSTextAlignmentCenter];
    [self.photoText setFont:Font(15)];
    [self.photoText setText:@"从图库选择"];
    [self.photoView addSubview:self.photoText];
    
    
    
    
    CGRect borderRect = CGRectMake(self.scanRect.origin.x-5, self.scanRect.origin.y-5, self.scanRect.size.width+10, self.scanRect.size.height+10);
    
    // 四个边角
    ScanBorderView * topLeft = [[ScanBorderView alloc] initWithType:BorderTopLeft];
    topLeft.frame = borderRect;
    [self.view addSubview:topLeft];
    
    ScanBorderView * topRight = [[ScanBorderView alloc] initWithType:BorderTopRight];
    topRight.frame = borderRect;
    [self.view addSubview:topRight];
    
    ScanBorderView * lowerLeft = [[ScanBorderView alloc] initWithType:BorderLowerLeft];
    lowerLeft.frame = borderRect;
    [self.view addSubview:lowerLeft];
    
    ScanBorderView * lowerRight = [[ScanBorderView alloc] initWithType:BorderLowerRight];
    lowerRight.frame = borderRect;
    [self.view addSubview:lowerRight];
    
    self.navigation = [[ScanNavigation alloc] init];
    self.navigation.delegate = self;
    [self.view addSubview:self.navigation];
    
    self.navigation.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(64);
}

#pragma mark - OnClick
- (void)navigationComeBack{
 
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)glisteningSelected{
    
    if(self.glistenStatu){
        [self turnOffLed];
        
        [self.glisteningIocn setImage:[UIImage imageNamed:@"closelightgli"]];
        [self.glisteningText setTextColor:[UIColor whiteColor]];
        
    }else{
      [self turnOnLed];
        [self.glisteningIocn setImage:[UIImage imageNamed:@"closelightglishow"]];
        [self.glisteningText setTextColor:ThemeColor];
    }
    self.glistenStatu = !self.glistenStatu;
}

- (void)photoSelected{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        ShowAlert(@"请允许相册访问");
        SPAlert(@"请允许相册访问",self);
        return;
    }
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];;
}
#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * iamge = info[UIImagePickerControllerOriginalImage];
    if(iamge){
        NSString * stt = [ReadQRCode readQRCodeFromImage:iamge];
        if(stt && stt){
            [self codeResultHandle:stt];
        }else{
            [self showToast:@"抱歉! 内容不识别"];
        }
        
    }else{
        [self showToast:@"抱歉! 内容不识别"];
    }
}


// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark - 检测相机权限
- (void)checkScanCode{
    
    AVAuthorizationStatus status =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    //用户授权
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //更新UI操作
                        [self stCreateScanCode];
                    });
                    
                }else{
                    NSLog(@"用户明确地拒绝授权,请打开权限");
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            [self stCreateScanCode];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            //SPAlert(@"請在“設置－隱私－相機選項中，允許8591訪問您的相機",self);
            SPAlert(@"请在设置－隐私－相机选项中，允许有图访问您的相机",self);
            break;
        default:
            break;
    }
}

#pragma mark - 创建二维码扫描器
- (void)stCreateScanCode{
    
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    [self.session addInput:input];
    [self.session addOutput:self.output];
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    layer.zPosition = -1;
    [self.view.layer addSublayer:layer];
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock: ^(NSNotification *_Nonnull note) {
        weakSelf.output.rectOfInterest = [layer metadataOutputRectOfInterestForRect:weakSelf.scanRect];
    }];
    layer.zPosition = -1;
    for(UIView * view in self.view.subviews){
        if(![view isKindOfClass:[AVCaptureMetadataOutput class]]){
          [self.view bringSubviewToFront:view];
        }else{
            [self.view sendSubviewToBack:view];
        }
    }
}


#pragma mark - 锁屏情况
- (void)someMethod{
    [self startScan];
}

#pragma mark - 开始扫描
- (void)startScan{
    
    [self.session startRunning];
    [self.line setHidden:NO];
}

#pragma mark - 停止扫描
- (void)stopScan{
    
    [self.session stopRunning];
    [self.line setHidden:YES];
}

#pragma mark - 扫描结果获取
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self stopScan];
            
            NSLog(@"%@",metadataObj.stringValue);
            //[self showToast:[NSString stringWithFormat:@"%@",metadataObj.stringValue]];
            [self codeResultHandle:metadataObj.stringValue];
        }
    }
}

- (void)codeResultHandle:(NSString *)result{

    // 这里需要处理两种形式的结果： (1) http://www.uootu.com//uid (2)http://www.uootu.com//uid/photo/detail/id
    
//    if([result rangeOfString:@"uootu.com/"].length > 0){
//        NSRange range = [result rangeOfString:@"uootu.com/"];
//        result = [result substringFromIndex:range.location+range.length];
//        NSLog(@"result -- %@",result);
//    }else{
//        [self startScan];
//        [self showToast:@"抱歉! 内容不识别"];
//        return;
//    }
//    
//    NSRange range = [result rangeOfString:@"/photo/detail/"];
//    if(range.length > 0){
//        // 相册详情
//        NSString * uid =  [result substringToIndex:range.location];
//        NSString * photoID = [result substringFromIndex:range.location+range.length];
//        if(!uid) uid = @"";
//        if(!photoID) photoID = @"";
//        if([uid isEqualToString:self.photosUserID]){
//            [self startScan];
//            [self showToast:@"不能关注自己"];
//            return;
//        }
//        [self loadPhotoData:@{@"uid":uid,@"photoID":photoID}];
//        
//    }else{
//        if([result isEqualToString:self.photosUserID]){
//            [self startScan];
//            [self showToast:@"不能关注自己"];
//            return;
//        }
//        [self loadUserData:@{@"uid":result}];
//    }
    [self showLoad];
    NSDictionary *data = @{@"uid":result};
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.concernUser,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [popupErrVC showInView:self animated:YES type:@"success" message:@"关注成功"];
            //[weakSelef showToast:@"关注成功"];
            //                [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [popupErrVC showInView:self animated:YES type:@"error" message:model.message];
            //            [weakSelef showToast:model.message];
        }
    } failure:^(NSError * error){
        [popupErrVC showInView:self animated:YES type:@"error" message:@"不是有图二维码"];
        //[weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef closeLoad];
    }];

}
- (void)closePopupErr {
    [popupErrVC removeAnimate];
}

-(void)turnOffLed {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}

-(void)turnOnLed {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }   
}

- (void)loadUserData:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getUserInfo parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        UserInfoModel * infoModel = [[UserInfoModel alloc] init];
        [infoModel analyticInterface:responseObject];
        if(infoModel.status == 0 && infoModel.uid && infoModel.uid.length > 0){
            
            PersonalHomeCtr * home = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
            home.uid = infoModel.uid;
            home.caan = YES;
            [self.navigationController pushViewController:home animated:YES];
        }else{
            [weakSelef startScan];
            [weakSelef showToast:@"抱歉! 内容不识别"];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef startScan];
    }];
}


- (void)loadPhotoData:(NSDictionary *)data{
    
    NSDictionary * uidData = @{@"uid":[data objectForKey:@"uid"]};
    NSString * photoData = [data objectForKey:@"photoID"];
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getUserInfo parametric:uidData succed:^(id responseObject){
        [weakSelef closeLoad];
        UserInfoModel * infoModel = [[UserInfoModel alloc] init];
        [infoModel analyticInterface:responseObject];
        if(infoModel.status == 0 && infoModel.uid && infoModel.uid.length > 0){
            PhotoDetailsCtr * home = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
            home.photoId = photoData;
            [self.navigationController pushViewController:home animated:YES];
        }else{
            [weakSelef startScan];
            [weakSelef showToast:@"抱歉! 内容不识别"];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef startScan];
    }];
}

- (void)concernUserData:(NSDictionary *)data{
    
   
}



@end
