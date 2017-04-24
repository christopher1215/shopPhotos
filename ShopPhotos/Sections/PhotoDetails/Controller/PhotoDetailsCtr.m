//
//  PhotoDetailsCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/25.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PhotoDetailsCtr.h"
#import "PhotoDetailsHead.h"
#import "PhotosEditView.h"
#import <UIImageView+WebCache.h>
#import "PhotoDetailsFooter.h"
#import "AlbumPhotosRequset.h"
#import "AlbumPhotosModel.h"
#import "PhotoImagesRequset.h"
#import "PhotoImagesModel.h"
#import "PhotoDescriptionRequset.h"
#import "PhotoImagesModel.h"
#import <MJPhotoBrowser.h>
#import "ShareCtr.h"
#import "ShareContentSelectCtr.h"
#import <ShareSDK/ShareSDK.h>
#import "HasCollectPhotoRequset.h"
#import "DynamicQRAlert.h"
#import "DownloadImageCtr.h"
#import "DynamicImagesModel.h"
#import "CopyRequset.h"
#import "PublishPhotoCtr.h"

@interface PhotoDetailsCtr ()<UITextViewDelegate,UITextFieldDelegate,PhotoDetailsHeadDelegate,UIScrollViewDelegate,ShareDelegate,PhotoDetailsFooterDelegate,PhotosEditViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (weak, nonatomic) IBOutlet UIImageView *edit_icon;
@property (weak, nonatomic) IBOutlet UIScrollView *content;
@property (strong, nonatomic) PhotoDetailsHead * head;
@property (strong, nonatomic) PhotosEditView * editHead;
@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * name;
@property (strong, nonatomic) UILabel * date;

@property (strong, nonatomic) PhotoDetailsFooter * foot;
@property (strong, nonatomic) UIView * editView;
@property (strong, nonatomic) UITextView * photoTitle;
//@property (strong, nonatomic) UIView * prizeView;
//@property (strong, nonatomic) UITextField * photoPrize;
//@property (strong, nonatomic) UIView * recommendView;
//@property (strong, nonatomic) UILabel * recommendText;
//@property (strong, nonatomic) UISwitch * recommendSwitch;
@property (strong, nonatomic) UIView * line1;
@property (strong, nonatomic) UIView * line2;

@property (strong, nonatomic) UIView * remarksView;
@property (strong, nonatomic) UILabel * reamrksText;
@property (strong, nonatomic) UITextView * remarksContent;
@property (strong, nonatomic) UIView * photoClass;
@property (strong, nonatomic) UIButton * photoClassParent;
@property (strong, nonatomic) UIButton * photoClassSub;
@property (assign, nonatomic) BOOL editStatu;
@property (strong, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) NSString * classifyID;
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) NSString * subclassID;
@property (strong, nonatomic) ShareCtr * shareView;
@property (strong, nonatomic) UILabel * share;
@property (strong, nonatomic) DynamicQRAlert * qrAlert;
@end

@implementation PhotoDetailsCtr

- (NSMutableArray *)imageArray{
    if(!_imageArray) _imageArray = [NSMutableArray array];
    return _imageArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self createAutoLayout];
    
    [self loadNetworkData];
}

- (void)setup{
    [self.back addTarget:self action:@selector(backSelected)];
    [self.edit addTarget:self action:@selector(editSelected)];
    self.content.delegate = self;
}

- (void)createAutoLayout{
    
    self.editHead = [[PhotosEditView alloc] init];
    self.editHead.delegate = self;
    [self.editHead.all setTitle:@"完成" forState:UIControlStateNormal];
    [self.editHead.title setText:@"相册详情"];

    [self.view addSubview:self.editHead];
    [self.editHead setHidden:YES];
    self.editHead.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(62);

    UIView *userInfo = [[UIView alloc]init];
    [self.content addSubview:userInfo];
    userInfo.sd_layout
    .leftEqualToView(self.content)
    .topEqualToView(self.content)
    .rightEqualToView(self.content)
    .heightIs(50);
    
    self.icon = [[UIImageView alloc] init];
    [userInfo addSubview:self.icon];
    self.icon.sd_layout
    .leftEqualToView(userInfo)
    .topSpaceToView(userInfo,5)
    .widthIs(42)
    .heightIs(42);
    
    self.name = [[UILabel alloc] init];
    [self.name setTextColor:[UIColor blackColor]];
    [self.name setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [userInfo addSubview:self.name];
    self.name.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(userInfo,5)
    .rightEqualToView(userInfo)
    .heightIs(20);
    
    self.date = [[UILabel alloc] init];
    [self.date setFont:Font(13)];
    [self.date setTextColor:ColorHex(0X808080)];
    [userInfo addSubview:self.date];
    self.date.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(self.name,5)
    .rightSpaceToView(userInfo,50)
    .heightIs(18);
    
    self.head = [[PhotoDetailsHead alloc] init];
    self.head.delegate = self;
    [self.content addSubview:self.head];
    self.head.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(self.content,Clearance)
    .topSpaceToView(userInfo,10)
    .heightIs(WindowWidth-(Clearance*2));
    
    self.photoTitle = [[UITextView alloc] init];
    self.photoTitle.contentInset = UIEdgeInsetsMake(2,-4,-2,-4);
    self.photoTitle.scrollEnabled = NO;
    self.photoTitle.editable = NO;
    self.photoTitle.delegate = self;
    [self.photoTitle setFont:Font(15)];
    [self.photoTitle setTextColor:[UIColor darkGrayColor]];
    [self.photoTitle setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:self.photoTitle];
    self.photoTitle.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(_content,Clearance)
    .topSpaceToView(self.head,5)
    .heightIs(50);

    
    self.remarksView = [[UIView alloc] init];
    [self.remarksView setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:self.remarksView];
    self.remarksView.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(self.content,Clearance)
    .topSpaceToView(self.photoTitle,3)
    .heightIs(65);

    self.line1 = [[UIView alloc]init];
    [self.line1 setBackgroundColor:ColorHex(0xebebeb)];
    [self.remarksView addSubview:_line1];
    self.line1.sd_layout
    .leftSpaceToView(_remarksView,Clearance)
    .rightSpaceToView(_remarksView,Clearance)
    .topSpaceToView(_remarksView,0)
    .heightIs(1);
    
    self.reamrksText = [[UILabel alloc] init];
    [self.reamrksText setText:@"备注:"];
    [self.reamrksText setTextColor:ColorHex(0xebebeb)];
    [self.reamrksText setFont:Font(15)];
    [self.remarksView addSubview:self.reamrksText];
    self.reamrksText.sd_layout
    .leftSpaceToView(self.remarksView,2)
    .topSpaceToView(self.remarksView,3)
    .widthIs(40)
    .heightIs(30);
    
    self.remarksContent = [[UITextView alloc] init];
    self.remarksContent.scrollEnabled = NO;
    self.remarksContent.editable = NO;
    self.remarksContent.delegate = self;
    self.remarksContent.contentInset = UIEdgeInsetsMake(2,0,2,0);
    [self.remarksContent setBackgroundColor:[UIColor clearColor]];
    [self.remarksContent setFont:Font(15)];
    [self.remarksContent setTextColor:[UIColor darkGrayColor]];
    [self.remarksView addSubview:self.remarksContent];
    self.remarksContent.sd_layout
    .leftSpaceToView(self.reamrksText,0)
    .topSpaceToView(self.remarksView,0)
    .rightSpaceToView(self.remarksView,0)
    .heightIs(50);
    
    self.line2 = [[UIView alloc]init];
    [self.line2 setBackgroundColor:ColorHex(0xe0e0e0)];
    [_remarksView addSubview:_line2];
    self.line2.sd_layout
    .leftSpaceToView(_remarksView,Clearance)
    .rightSpaceToView(_remarksView,Clearance)
    .bottomSpaceToView(_remarksView,0)
    .heightIs(1);
    
    self.photoClass = [[UIView alloc] init];
    [self.photoClass setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview: self.photoClass];
    self.photoClass.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(self.content,Clearance)
    .topSpaceToView(_remarksView,0)
    .heightIs(40);

    self.photoClassParent = [[UIButton alloc] init];
    [self.photoClassParent.titleLabel setFont:Font(12)];
    [self.photoClassParent setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.photoClassParent.layer.cornerRadius = 5;
    self.photoClassParent.layer.borderWidth = 1;
    self.photoClassParent.layer.borderColor = ColorHex(0xe0e0e0).CGColor;
//    [self.photoClassParent addTarget:self action:@selector(photoClassParentSelected)];
    [self.photoClass addSubview:_photoClassParent];
    self.photoClassParent.sd_layout
    .leftSpaceToView(self.photoClass,0)
    .topSpaceToView(self.photoClass,10)
    .heightIs(25);
    
    UILabel * line3 = [[UILabel alloc] init];
    [line3 setText:@">"];
    [line3 setTextColor:ColorHex(0X888888)];
    [line3 setFont:Font(13)];
    [self.photoClass addSubview:line3];
    line3.sd_layout
    .leftSpaceToView(self.photoClassParent,5)
    .topSpaceToView(self.photoClass,13)
    .heightIs(20)
    .widthIs(10);

    self.photoClassSub = [[UIButton alloc] init];
    [self.photoClassSub.titleLabel setFont:Font(12)];
    [self.photoClassSub setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.photoClassSub.layer.cornerRadius = 5;
    self.photoClassSub.layer.borderWidth = 1;
    self.photoClassSub.layer.borderColor = ColorHex(0xe0e0e0).CGColor;
//    [self.photoClassSub addTarget:self action:@selector(photoClassSubViewSelected)];
    [self.photoClass addSubview:_photoClassSub];
    self.photoClassSub.sd_layout
    .leftSpaceToView(line3,5)
    .topSpaceToView(self.photoClass,10)
    .heightIs(25);

    self.share = [[UILabel alloc] init];
    [self.share setFont:Font(19)];
    [self.share setText:@"..."];
    [self.share addTarget:self action:@selector(shareViewSelected)];
    self.share.textAlignment = NSTextAlignmentLeft;
    [self.photoClass addSubview:self.share];
    self.share.sd_layout
    .rightSpaceToView(self.photoClass,0)
    .topSpaceToView(self.photoClass,10)
    .widthIs(15)
    .heightIs(20);

// editView
    /*
    _editView = [[UIView alloc]init];
    [self.content addSubview:_editView];
    _editView.sd_layout
    .topEqualToView(_photoTitle)
    .leftEqualToView(_content)
    .rightEqualToView(_content)
    .heightIs(300);
    [_editView setHidden:YES];
    
    UIButton * btnCancel = [[UIButton alloc]init];
    [_editView addSubview:btnCancel];
    [btnCancel addTarget:self action:@selector(clearPhotoTitle)];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_close_grey"] forState:UIControlStateNormal];
    btnCancel.sd_layout
    .rightSpaceToView(_editView,15)
    .topSpaceToView(_editView,10)
    .widthIs(16)
    .heightIs(16);
    
    UIView *eline1 = [[UIView alloc]init];
    [eline1 setBackgroundColor:ColorHex(0xebebeb)];
    [_editView addSubview:eline1];
    eline1.sd_layout
    .leftEqualToView(_editView)
    .rightEqualToView(_editView)
    .topEqualToView(_editView)
    .heightIs(10);

    self.reamrksText = [[UILabel alloc] init];
    [self.reamrksText setText:@"备注:"];
    [self.reamrksText setTextColor:ColorHex(0xebebeb)];
    [self.reamrksText setFont:Font(15)];
    [self.remarksView addSubview:self.reamrksText];
    self.reamrksText.sd_layout
    .leftSpaceToView(self.remarksView,2)
    .topSpaceToView(self.remarksView,3)
    .widthIs(40)
    .heightIs(30);
    
    self.remarksContent = [[UITextView alloc] init];
    self.remarksContent.scrollEnabled = NO;
    self.remarksContent.editable = NO;
    self.remarksContent.delegate = self;
    self.remarksContent.contentInset = UIEdgeInsetsMake(2,0,2,0);
    [self.remarksContent setBackgroundColor:[UIColor clearColor]];
    [self.remarksContent setFont:Font(15)];
    [self.remarksContent setTextColor:[UIColor darkGrayColor]];
    [self.remarksView addSubview:self.remarksContent];
    self.remarksContent.sd_layout
    .leftSpaceToView(self.reamrksText,0)
    .topSpaceToView(self.remarksView,0)
    .rightSpaceToView(self.remarksView,0)
    .heightIs(50);
    
    UIView *eline2 = [[UIView alloc]init];
    [eline2 setBackgroundColor:ColorHex(0xebebeb)];
    [_editView addSubview:eline2];
    eline2.sd_layout
    .leftSpaceToView(_editView,Clearance)
    .rightSpaceToView(_editView,Clearance)
    .topSpaceToView(_editView,Clearance)
    .heightIs(1);
    
    UILabel *lab = [[UILabel alloc] init];
    [lab setFont:Font(19)];
    [self.share setText:@"..."];
    [self.share addTarget:self action:@selector(shareViewSelected)];
    self.share.textAlignment = NSTextAlignmentLeft;
    [self.photoClass addSubview:self.share];
    self.share.sd_layout
    .rightSpaceToView(self.photoClass,0)
    .topSpaceToView(self.photoClass,10)
    .widthIs(15)
    .heightIs(20);
    
    
    
    
    */
    
    self.foot = [[PhotoDetailsFooter alloc] init];
    self.foot.delegate = self;
    [self.content addSubview:self.foot];
    self.foot.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.photoClass,5)
    .heightIs(400);

    /*
    if(self.persona){
        [self.recommendView setHidden:YES];
        [self.remarksView setHidden:YES];
        [self.edit setHidden:YES];
        self.remarksView.sd_layout.heightIs(1);
        self.remarksView.sd_layout.topSpaceToView(self.prizeView,0);
        self.editView.sd_layout.heightIs(115);
    }else{
        [self.recommendView setHidden:NO];
        [self.remarksView setHidden:NO];
        [self.edit setHidden:NO];
        self.remarksView.sd_layout.heightIs(30);
        self.remarksView.sd_layout.topSpaceToView(self.prizeView,3);
        self.editView.sd_layout.heightIs(160);
    }
    */
//    [self.remarksView updateLayout];
//    [self.editView updateLayout];
//    self.photoClass.sd_layout.topSpaceToView(self.line2,3);
//    [self.photoClass updateLayout];
    
    
    self.shareView = GETALONESTORYBOARDPAGE(@"ShareCtr");
    self.shareView.delegate = self;
    [self.view addSubview:self.shareView.view];
    [self.shareView.view setHidden:YES];
    [self.shareView closeAlert];
    
    self.qrAlert = [[DynamicQRAlert alloc] init];
    [self.view addSubview:self.qrAlert];
    self.qrAlert.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    [self.qrAlert setHidden:YES];

    UIView * topView = [[UIView alloc] init];
    [topView setBackgroundColor:[UIColor clearColor]];
    [topView addTarget:self action:@selector(topViewSelected)];
    [self.view addSubview:topView];
    topView.sd_layout
    .rightSpaceToView(self.view,10)
    .bottomSpaceToView(self.view,140)
    .widthIs(50)
    .heightIs(50);
    
    UIImageView * topImage = [[UIImageView alloc] init];
    [topImage setContentMode:UIViewContentModeScaleAspectFit];
    [topImage setCornerRadius:3];
    [topImage setImage:[UIImage imageNamed:@"btn_top"]];
    [topView addSubview:topImage];
    topImage.sd_layout
    .leftSpaceToView(topView,0)
    .rightSpaceToView(topView,0)
    .topSpaceToView(topView,0)
    .bottomSpaceToView(topView,0);
}

- (void)topViewSelected{
    [self.content setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        
        return true;
        
    } else {
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            
            return true;
            
        } else {
            
            return false;
            
        }
    }
}

- (void)setPhotoDetailsContent:(AlbumPhotosModel *)data{
    
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:[data.photoId]]];
    self.icon.layer.cornerRadius = _icon.frame.size.width/2;
    self.icon.layer.masksToBounds = TRUE;
    
    [self.name setText:data.title];
    [self.date setText:[NSString stringWithFormat:@"%@ 上传",data.dateDiff]];
    
    PhotoImagesRequset * requset = [[PhotoImagesRequset alloc] init];
    [requset analyticInterface:data.images];
    if(requset.status == 0){
        [self.imageArray removeAllObjects];
        [self.imageArray addObjectsFromArray:requset.dataArray];
        self.head.sd_layout.heightIs([self.head setStyle:self.imageArray]);
        [self.head updateLayout];
        self.foot.sd_layout.heightIs([self.foot setStyle:self.imageArray]);
        [self.foot updateLayout];
        [self.content setContentSize:CGSizeMake(0, self.foot.top+self.foot.height)];
        [self.content updateLayout];
    }
    
    self.subclassID = [data.subclass objectForKey:@"id"];
    self.uid = [data.user objectForKey:@"uid"];
    self.classifyID = [data.classify objectForKey:@"id"];
    [self.photoTitle setText:data.title];
    
    if([self.uid isEqualToString:self.photosUserID]){
        [self.edit setHidden:NO];
        [self.search setHidden:NO];
    }else{
        [self.edit setHidden:YES];
        [self.search setHidden:YES];
        [self.remarksView setHidden:YES];
        [self.line2 setHidden:YES];
        self.photoClass.sd_layout.topSpaceToView(_photoTitle,5);
    }
    
    [self.photoClass updateLayout];
    self.photoTitle.sd_layout.heightIs([self heightForString:self.photoTitle andWidth:self.photoTitle.width]);
    [self.photoTitle updateLayout];
    
    NSString *classify = [data.classify objectForKey:@"name"];
    if(classify && classify.length > 0){
        [self.photoClassParent setTitle:classify forState:UIControlStateNormal];
        [self.photoClassParent setHidden:NO];
    }else{
        [self.photoClassParent setHidden:YES];
    }
    NSString *subclass = [data.subclass objectForKey:@"name"];
    if(subclass && subclass.length > 0){
        [self.photoClassSub setTitle:subclass forState:UIControlStateNormal];
        [self.photoClassSub setHidden:NO];
    }else{
        [self.photoClassSub setHidden:YES];
    }
    
    [self.foot setDateTitle:data.dateDiff];
    
    CGFloat photoClassMaxWidth = WindowWidth - 120;
    CGSize parentSize = [self.photoClassParent.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.photoClassParent.titleLabel.font,NSFontAttributeName,nil]];
    
    CGSize subSize = [self.photoClassSub.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.photoClassSub.titleLabel.font,NSFontAttributeName,nil]];
    
    if(parentSize.width > photoClassMaxWidth-16){
        parentSize.width = photoClassMaxWidth-16;
        subSize.width = 0;
    }else{
        
        if(subSize.width > photoClassMaxWidth - parentSize.width - 16){
            subSize.width = photoClassMaxWidth - parentSize.width - 16;
        }
    }
    
    self.photoClassParent.sd_layout.widthIs(parentSize.width+16);
    self.photoClassSub.sd_layout.widthIs(subSize.width+16);
    [self.photoClassParent updateLayout];
    [self.photoClassSub updateLayout];
}

- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

#pragma mark - OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareViewSelected{
    [self.shareView showAlert];
}

- (void)switchSelected:(UISwitch *)swt{
    NSString * recommend = @"";
    [self changePhotoDetails:@{@"name":self.photoTitle.text,
                               @"recommend":recommend,
                               @"description":self.remarksContent.text,
                               @"photo_id":self.photoId}];
}

- (void)editSelected{
    
//    [self.editHead setHidden:NO];
//    [self.foot setHidden:YES];
    for(PhotoImagesModel * model in self.imageArray) {
        model.edit = YES;
    }
    
    PublishPhotoCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
    pulish.imageArray = self.imageArray;
    [self.navigationController pushViewController:pulish animated:YES];
//    [self presentViewController:pulish animated:YES completion:nil];
    /*
    [self.head setStyle:self.imageArray];
    self.remarksContent.scrollEnabled = YES;
    self.remarksContent.editable = YES;
     */
}

-(void)clearPhotoTitle {
}

#pragma mark - PhotoEditViewDelegate
- (void)photosEditSelected:(NSInteger)type
{
    if (type == 1) {
        
        self.remarksContent.scrollEnabled = NO;
        self.remarksContent.editable = NO;
        for(PhotoImagesModel * model in self.imageArray){
            model.edit = NO;
        }
        [self.head setStyle:self.imageArray];
        
        NSString * recommend = @"";
        NSString * remarksContentText = self.remarksContent.text;
        if(remarksContentText.length == 0){
            [self changePhotoDetails:@{@"name":self.photoTitle.text,
                                       @"description":@" ",
                                       @"recommend":recommend,
                                       @"photo_id":self.photoId}];
        }else{
            [self changePhotoDetails:@{@"name":self.photoTitle.text,
                                       @"recommend":recommend,
                                       @"description":self.remarksContent.text,
                                       @"photo_id":self.photoId}];
        }
        
    }
    else if (type == 2) {}
    
    [self.editHead setHidden:YES];
    [self.foot setHidden:NO];
}

- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
    
}


#pragma mark - ShareDelegate
- (void)shareSelected:(NSInteger)type{
    
    NSMutableArray * urlImages = [NSMutableArray array];
    for(PhotoImagesModel * model in self.imageArray){
        [urlImages addObject:model.bigImageUrl];
    }
    
    NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.uid,self.photoId];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:nil
                                        url:nil
                                      title:text
                                       type:SSDKContentTypeAuto];
    
    switch (type) {
        case 1: //微信好友
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
            }];
        }
            break;
        case 2:// 朋友圈
        {
            
            NSMutableArray * images = [NSMutableArray array];
            for(PhotoImagesModel * imageModel in self.imageArray){
                DynamicImagesModel * model = [[DynamicImagesModel alloc] init];
                model.bigImageUrl = imageModel.bigImageUrl;
                model.thumbnailUrl = imageModel.thumbnailUrl;
                [images addObject:model];
            }
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.photoTitle.text;
            ShareContentSelectCtr * shareSelect = GETALONESTORYBOARDPAGE(@"ShareContentSelectCtr");
            shareSelect.dataArray = images;
            [self.navigationController pushViewController:shareSelect animated:YES];
        }
            break;
        case 3:// QQ好友
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
            }];
        }
            
            break;
        case 4:// 复制相册
        {
            
            NSString * uid = self.uid;
            if(uid && uid.length > 0){
                if([self.photosUserID isEqualToString:uid]){
                    [self showToast:@"不能复制自己的相册"];
                    break;
                }
                
                [self getAllowPurview:@{@"uid":self.uid}];
            }
        }
            break;
        case 5:// 复制链接
        {
            NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.uid,self.photoId];
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [self showToast:@"复制成功"];
        }
            
            break;
        case 6:// 复制标题
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.photoTitle.text;
            [self showToast:@"复制成功"];
        }
            break;
        case 7:// 查看二维码
        {
            self.qrAlert.titleText = self.photoTitle.text;
            self.qrAlert.contentText = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.uid,self.photoId];
            [self.qrAlert showAlert];
        }
            
            break;
        case 8:// 收藏相册
        {
            NSString * uid = self.uid;
            if(uid && uid.length > 0){
                if([self.photosUserID isEqualToString:uid]){
                    [self showToast:@"不能收藏自己的相册"];
                    break;
                }
            }
            
            [self hasCollectPhoto:@{@"photoId":self.photoId}];
        }
            break;
        case 9:// 下载图片
        {
            NSMutableArray * images = [NSMutableArray array];
            for(PhotoImagesModel * imageModel in self.imageArray){
                DynamicImagesModel * model = [[DynamicImagesModel alloc] init];
                model.bigImageUrl = imageModel.bigImageUrl;
                model.thumbnailUrl = imageModel.thumbnailUrl;
                [images addObject:model];
            }
            
            DownloadImageCtr * shareSelect = GETALONESTORYBOARDPAGE(@"DownloadImageCtr");
            shareSelect.dataArray = images;
            [self.navigationController pushViewController:shareSelect animated:YES];
            
        }
            break;
    }
}

#pragma mark - PhotoDetailsFooterDelegate
- (void)footerImageSelcted:(NSInteger)indexPath{
    
    NSInteger count = self.imageArray.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        PhotoImagesModel * imageModel = [self.imageArray objectAtIndex:i];
        
        NSString * getImageStrUrl = imageModel.bigImageUrl;
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString: getImageStrUrl];
        [photos addObject:photo];
    }
    if(photos.count > 0){
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = indexPath;
        browser.photos = photos;
        [browser show];
    }
}

#pragma makr - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
/*
    if (textField == self.photoPrize) {
        return self.editStatu;
    }
  */
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   /*
    if(textField == self.photoPrize){
        if(![self isPureInt:string]){
            [self showToast:@"请输入正确的价格"];
            return NO;
        }
    }
    */
    return YES;
}

#pragma makr - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
   
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    if(size.height < 30) size.height = 30;
    if(textView == self.photoTitle){
        textView.sd_layout.heightIs(size.height);
        [textView updateLayout];
    }else if(textView == self.remarksContent){
//        self.remarksView.sd_layout.heightIs(size.height);
//        [self.remarksView updateLayout];
    }
    
    
//    self.editView.sd_layout.heightIs(self.remarksView.height+self.remarksView.top_sd);
//    [self.editView updateLayout];
    [self.content setContentSize:CGSizeMake(0, self.foot.top+self.foot.height)];
}

#pragma mark - PhotoDetailsHeadDelegate
- (void)photoDetailsHeadSelectType:(NSInteger)type select:(NSInteger)indexPath{
    if(type == 1){
        NSInteger count = self.imageArray.count;
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            PhotoImagesModel * imageModel = [self.imageArray objectAtIndex:i];
            
            NSString * getImageStrUrl = imageModel.bigImageUrl;
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString: getImageStrUrl];
            [photos addObject:photo];
        }
        if(photos.count > 0){
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = indexPath;
            browser.photos = photos;
            [browser show];
        }
    }else if(type == 2){
        [self editSelected];
        PhotoImagesModel * imageModel = [self.imageArray objectAtIndex:indexPath];
        [self deleteImage:@{@"imageLinks":imageModel.imageLink_id}];
    }else if(type == 3){
        [self editSelected];
        PhotoImagesModel * imageModel = [self.imageArray objectAtIndex:indexPath];
        [self setCover:@{@"photoId":self.photoId,
                         @"imageId":imageModel.Id}];
    }
}

- (void)photoDetailsHeadAddImage:(UIImageView *)image select:(NSInteger)indexPath {}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    
    [self getDetailPhoto];
//    [self getPhotoImages];
//    [self getPhotoDescription];
}

- (void)getDetailPhoto{
    
    if(!self.subclassID){
        [self showLoad];
    }
    //[self showLoad];
    
    NSDictionary * data = @{@"photoId":self.photoId};
    __weak __typeof(self)weakSelef = self;
    // 获取相册详情内容
    [HTTPRequest requestGETUrl :[NSString stringWithFormat:@"%@%@",self.congfing.getPhoto,[self.appd getParameterString]] parametric:data succed:^(id responseObject) {
        [weakSelef closeLoad];
        NSLog(@"获取相册详情内容 -- >%@",responseObject);
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [weakSelef setPhotoDetailsContent:[requset.dataArray objectAtIndex:0]];
            [weakSelef.content setContentSize:CGSizeMake(0, weakSelef.foot.top+weakSelef.foot.height)];
            [weakSelef.content updateLayout];
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

/*
- (void)getPhotoDescription{
    NSDictionary * detailPhotodata = @{@"photoId":self.photoId};
    NSLog(@"url -- %@",self.congfing.getPhoto);
    __weak __typeof(self)weakSelef = self;
    // 获取相册备注
    [HTTPRequest requestPOSTUrl:self.congfing.getPhotoDescription parametric:detailPhotodata succed:^(id responseObject){
        NSLog(@"获取相册备注 -- >%@",responseObject);
        PhotoDescriptionRequset * requset = [[PhotoDescriptionRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            
            if([self isEmpty:requset.photoDesciption]){
                
                [weakSelef.remarksContent setText:@""];
            }else{
                [weakSelef.remarksContent setText:requset.photoDesciption];
            }
            
//            weakSelef.editView.sd_layout.heightIs(weakSelef.remarksView.height+weakSelef.remarksView.top_sd);
//            [weakSelef.editView updateLayout];
            [weakSelef.content setContentSize:CGSizeMake(0, weakSelef.foot.top+weakSelef.foot.height)];
            [weakSelef.content updateLayout];
        }
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)getPhotoImages{
    
    NSDictionary * detailPhotodata = @{@"photoId":self.photoId};
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getPhotoImages parametric:detailPhotodata succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"获取相册图片 -- >%@",responseObject);
        PhotoImagesRequset * requset = [[PhotoImagesRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [weakSelef.imageArray removeAllObjects];
            [weakSelef.imageArray addObjectsFromArray:requset.dataArray];
            weakSelef.head.sd_layout.heightIs([weakSelef.head setStyle:weakSelef.imageArray]);
            [weakSelef.head updateLayout];
            weakSelef.foot.sd_layout.heightIs([weakSelef.foot setStyle:weakSelef.imageArray]);
            [weakSelef.foot updateLayout];
            [weakSelef.content setContentSize:CGSizeMake(0, weakSelef.foot.top+weakSelef.foot.height)];
            [weakSelef.content updateLayout];
        }
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        //[weakSelef closeLoad];
    }];
}
*/

- (void)setCover:(NSDictionary *)data{
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.setCover parametric:data succed:^(id responseObject){
       // [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        PhotoDescriptionRequset * requset = [[PhotoDescriptionRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
//            [weakSelef getPhotoImages];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)deleteImage:(NSDictionary *)data{
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.removeImageLinks parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        PhotoDescriptionRequset * requset = [[PhotoDescriptionRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
//            [weakSelef getPhotoImages];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)changePhotoDetails:(NSDictionary *)data{
    
    NSLog(@"%@",data);
    NSLog(@"%@",self.congfing.photoUpdates);
    
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.updatePhoto parametric:data succed:^(id responseObject){
      //  [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        PhotoDescriptionRequset * requset = [[PhotoDescriptionRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [weakSelef showToast:@"修改成功"];
            [weakSelef getDetailPhoto];
//            [weakSelef getPhotoDescription];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)getAllowPurview:(NSDictionary *)data{
    
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.isAllow parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        CopyRequset * model = [[CopyRequset alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            
            if(model.allow){
/*                PublishPhotosCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotosCtr");
                pulish.is_copy = YES;
                pulish.photoTitleText = self.photoTitle.text;
                pulish.imageCopy = [[NSMutableArray alloc] initWithArray:self.imageArray];
                [weakSelef.navigationController pushViewController:pulish animated:YES];*/
            }else{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"对方设置了限制复制，是否发送请求复制" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                    
                    [weakSelef sendCopyRequest:data];
                    
                }]];
                
                [weakSelef presentViewController:alert animated:YES completion:nil];
            }
            
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)sendCopyRequest:(NSDictionary *)data{
    
    NSLog(@"1--- %@",data);
    
    NSLog(@"2--- %@",self.congfing.sendCopyRequest);
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.sendCopyRequest parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"发送成功，请耐心等待"];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}


- (void)hasCollectPhoto:(NSDictionary *)data{
    
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.hasCollectPhoto parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        HasCollectPhotoRequset * requset = [[HasCollectPhotoRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            
            if(requset.hasCollect){
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已经收藏该相册，是否取消收藏" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                    
                    [weakSelef cancelCollectPhotos:@{@"photosId":[NSString stringWithFormat:@"%@,",[data objectForKey:@"photoId"]]}];
                }]];
                
                [weakSelef presentViewController:alert animated:YES completion:nil];
            }else{
                [weakSelef collectPhoto:data];
            }
            
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)collectPhoto:(NSDictionary *)data{
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.collssssCopy parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [weakSelef showToast:@"收藏成功"];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)cancelCollectPhotos:(NSDictionary * )data{
    
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.cancelCollectPhotos parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [weakSelef showToast:@"取消收藏成功"];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

@end
