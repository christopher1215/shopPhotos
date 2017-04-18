//
//  PublishPhotoCtr.m
//  ShopPhotos
//
//  Created by Park Jin Hyok on 4/13/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "PublishPhotoCtr.h"
#import "PhotoDetailsHead.h"
#import <TZImagePickerController.h>

//#import <UITextView+Placeholder.h>

@interface PublishPhotoCtr ()<UIScrollViewDelegate,PhotoDetailsHeadDelegate,UITextViewDelegate,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mtitle;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_ok;
@property (weak, nonatomic) IBOutlet UIScrollView *content;

@property (strong, nonatomic) PhotoDetailsHead * photos;
@property (strong, nonatomic) UITextView * photoTitle;

@property (strong, nonatomic) UITextView * remarksContent;
@property (strong, nonatomic) UIView * photoClassView;
@property (strong, nonatomic) UILabel * photoClassContent;
@property (strong, nonatomic) UIImageView * recommendSwitch;

@end

@implementation PublishPhotoCtr
/*
- (NSMutableArray *)imageArray{
    if(!self.imageArray)
        self.imageArray = [NSMutableArray array];
    return self.imageArray;
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btn_cancel addTarget:self action:@selector(backSelected)];
    [self.btn_ok addTarget:self action:@selector(okSelected)];
    self.content.delegate = self;
    
    [self createAutoLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.content setContentSize:CGSizeMake(0, _photoClassView.top+_photoClassView.height+20)];
    NSLog(@"%f", _photoClassView.top);
}
- (void)createAutoLayout {
    
    self.photos = [[PhotoDetailsHead alloc] init];
    
    self.photos.delegate = self;
    [self.content addSubview:self.photos];
    self.photos.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(self.content,Clearance)
    .topSpaceToView(self.content,Clearance)
    .heightIs([self.photos setStyle:self.imageArray mode:YES]);
    
    self.photoTitle = [[UITextView alloc] init];
    self.photoTitle.contentInset = UIEdgeInsetsMake(2,-4,-2,-4);
    self.photoTitle.delegate = self;
    [self.photoTitle setFont:Font(15)];
    [self.photoTitle setBorderWidth:1.0];
    [self.photoTitle setBorderColor:ColorHex(0xe0e0e0)];
    [self.photoTitle setTextColor:[UIColor darkGrayColor]];
    [self.photoTitle setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:self.photoTitle];
    self.photoTitle.sd_layout
    .leftSpaceToView(_content,Clearance)
    .rightSpaceToView(_content,Clearance+30)
    .topSpaceToView(self.photos,5)
    .heightIs(60);
    
    UIButton * btnClear = [[UIButton alloc]init];
    [_content addSubview:btnClear];
    [btnClear addTarget:self action:@selector(clearPhotoTitle)];
    [btnClear setBackgroundImage:[UIImage imageNamed:@"btn_close_grey"] forState:UIControlStateNormal];
    btnClear.sd_layout
    .rightSpaceToView(_content,15)
    .bottomEqualToView(_photoTitle)
    .widthIs(16)
    .heightIs(16);
    
    UIView *line1 = [[UIView alloc]init];
    [line1 setBackgroundColor:ColorHex(0xebebeb)];
    [_content addSubview:line1];
    line1.sd_layout
    .leftEqualToView(_content)
    .rightEqualToView(_content)
    .topSpaceToView(_photoTitle,15)
    .heightIs(10);
    
    UIView *remarksView = [[UIView alloc] init];
    [self.content addSubview:remarksView];
    remarksView.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topEqualToView(line1)
    .heightIs(120);

    UILabel *reamrksTitle = [[UILabel alloc] init];
    [reamrksTitle setText:@"备注"];
    [reamrksTitle setTextColor:[UIColor blackColor]];
    [reamrksTitle setFont:Font(17)];
    [remarksView addSubview:reamrksTitle];
    reamrksTitle.sd_layout
    .leftSpaceToView(remarksView,Clearance)
    .topSpaceToView(remarksView,20)
    .widthIs(40)
    .heightIs(30);
    
    self.remarksContent = [[UITextView alloc] init];
    self.remarksContent.delegate = self;
    self.remarksContent.contentInset = UIEdgeInsetsMake(2,0,2,0);
    [self.remarksContent setBackgroundColor:[UIColor clearColor]];
    [self.remarksContent setFont:Font(15)];
    [self.remarksContent setTextColor:[UIColor darkGrayColor]];
    [remarksView addSubview:self.remarksContent];
    self.remarksContent.sd_layout
    .leftSpaceToView(reamrksTitle,15)
    .topSpaceToView(remarksView,20)
    .rightSpaceToView(remarksView,15)
    .heightIs(50);
    
    UIView *line2 = [[UIView alloc]init];
    [line2 setBackgroundColor:ColorHex(0xe0e0e0)];
    [remarksView addSubview:line2];
    line2.sd_layout
    .leftSpaceToView(remarksView,Clearance)
    .rightSpaceToView(remarksView,Clearance)
    .topSpaceToView(_remarksContent,15)
    .heightIs(1);
    
    UILabel *reamrksNote = [[UILabel alloc] init];
    [reamrksNote setText:@"*备注信息仅自己可见"];
    [reamrksNote setTextColor:[UIColor grayColor]];
    [reamrksNote setFont:Font(15)];
    [reamrksNote setTextAlignment:NSTextAlignmentRight];
    [remarksView addSubview:reamrksNote];
    reamrksNote.sd_layout
    .rightSpaceToView(remarksView,Clearance)
    .topSpaceToView(line2,10)
    .widthIs(150)
    .heightIs(30);
    
    UIView *line3 = [[UIView alloc]init];
    [line3 setBackgroundColor:ColorHex(0xebebeb)];
    [_content addSubview:line3];
    line3.sd_layout
    .leftEqualToView(_content)
    .rightEqualToView(_content)
    .topSpaceToView(remarksView,15)
    .heightIs(10);
    
    _photoClassView = [[UIView alloc] init];
    [self.content addSubview:_photoClassView];
    _photoClassView.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(line3,0)
    .heightIs(100);
    
    UILabel *photoClassTitle = [[UILabel alloc] init];
    [photoClassTitle setText:@"选择分类"];
    [photoClassTitle setTextColor:[UIColor blackColor]];
    [photoClassTitle setFont:Font(17)];
    [_photoClassView addSubview:photoClassTitle];
    photoClassTitle.sd_layout
    .leftSpaceToView(_photoClassView,Clearance)
    .topSpaceToView(_photoClassView,10)
    .widthIs(100)
    .heightIs(30);
    
    UIView *photoClassContentView = [[UIView alloc]init];
    [_photoClassView addSubview:photoClassContentView];
    photoClassContentView.sd_layout
    .rightEqualToView(_photoClassView)
    .topEqualToView(_photoClassView)
    .leftSpaceToView(photoClassTitle,20)
    .heightIs(50);
    [photoClassContentView addTarget:self action:@selector(selectPhotoClass)];
    
    UIButton *arrow_right = [[UIButton alloc] init];
    [arrow_right setBackgroundImage:[UIImage imageNamed:@"ico_arrow_right"] forState:UIControlStateNormal];
    [photoClassContentView addSubview:arrow_right];
    arrow_right.sd_layout
    .rightSpaceToView(photoClassContentView,10)
    .centerYEqualToView(photoClassContentView)
    .widthIs(16)
    .heightIs(16);
    
    _photoClassContent = [[UILabel alloc] init];
    [_photoClassContent setText:@"耐克/2017新款"];
    [_photoClassContent setTextColor:ColorHex(0x4893d7)];
    [_photoClassContent setFont:Font(18)];
    [_photoClassContent setTextAlignment:NSTextAlignmentRight];
    [photoClassContentView addSubview:_photoClassContent];
    _photoClassContent.sd_layout
    .leftEqualToView(photoClassContentView)
    .rightSpaceToView(arrow_right,5)
    .centerYEqualToView(photoClassContentView)
    .heightIs(20);
    
    UIView *line4 = [[UIView alloc]init];
    [line4 setBackgroundColor:ColorHex(0xe0e0e0)];
    [_photoClassView addSubview:line4];
    line4.sd_layout
    .leftSpaceToView(_photoClassView,Clearance)
    .rightSpaceToView(_photoClassView,Clearance)
    .topSpaceToView(photoClassContentView,0)
    .heightIs(1);
    
    UILabel *recommendClassTitle = [[UILabel alloc] init];
    [recommendClassTitle setText:@"是否推荐"];
    [recommendClassTitle setTextColor:[UIColor blackColor]];
    [recommendClassTitle setFont:Font(17)];
    [_photoClassView addSubview:recommendClassTitle];
    recommendClassTitle.sd_layout
    .leftSpaceToView(_photoClassView,Clearance)
    .topSpaceToView(line4,10)
    .widthIs(100)
    .heightIs(30);
    
    _recommendSwitch = [[UIImageView alloc] init];
    [_recommendSwitch setImage:[UIImage imageNamed:@"switch_off"]];
    [_photoClassView addSubview:_recommendSwitch];
    _recommendSwitch.sd_layout
    .rightSpaceToView(_photoClassView,Clearance)
    .topSpaceToView(line4,10)
    .widthIs(52)
    .heightIs(30);
    [_recommendSwitch addTarget:self action:@selector(selectRecommendSwitch)];
}

// Target methods
- (void) backSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) okSelected {}
- (void) clearPhotoTitle {}
- (void) selectPhotoClass {}
- (void) selectRecommendSwitch{}

/*
- (void) setImageArray:(NSMutableArray *)imageArray {
    
    self.imageArray = imageArray;
}
*/

#pragma makr - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
}

#pragma mark - PhotoDetailsHeadDelegate
- (void)photoDetailsHeadSelectType:(NSInteger)type select:(NSInteger)indexPath{
    if(type == 1){
    }else if(type == 2){
    }else if(type == 3){
    }else if(type == 4){ //add new image
    }
}

- (void)photoDetailsHeadAddImage:(UIImageView *)imageView select:(NSInteger)indexPath {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        SPAlert(@"请允许相册访问",self);
        return;
    }
    
    NSInteger count = 9 - self.imageArray.count;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.photoWidth = 960;
    imagePickerVc.photoPreviewMaxWidth = 960;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto){
        if(assets && assets.count >0){
            [self.imageArray addObjectsFromArray:photos];
        }
//        [self createImage];
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

@end
