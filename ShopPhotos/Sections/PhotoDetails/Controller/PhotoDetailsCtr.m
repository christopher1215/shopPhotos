//
//  PhotoDetailsCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/25.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PhotoDetailsCtr.h"
#import "PhotoDetailsHead.h"
#import <UIImageView+WebCache.h>
#import "PhotoDetailsFooter.h"
#import "DetailPhotoRequset.h"
#import "PhotoImagesRequset.h"
#import "PhotoImagesModel.h"
#import "PhotoDescriptionRequset.h"
#import "PhotoImagesModel.h"
#import <MJPhotoBrowser.h>
#import "SuperAlbumClassCtr.h"
#import "AlbumClassTabelCtr.h"
#import "ShareCtr.h"
#import "ShareContentSelectCtr.h"
#import <ShareSDK/ShareSDK.h>
#import "HasCollectPhotoRequset.h"
#import "DynamicQRAlert.h"
#import "DownloadImageCtr.h"
#import "PublishPhotosCtr.h"
#import "DynamicImagesModel.h"
#import "CopyRequset.h"


@interface PhotoDetailsCtr ()<UITextViewDelegate,UITextFieldDelegate,PhotoDetailsHeadDelegate,UIScrollViewDelegate,ShareDelegate,PhotoDetailsFooterDelegate>
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *edit;
@property (weak, nonatomic) IBOutlet UIImageView *edit_icon;
@property (weak, nonatomic) IBOutlet UIScrollView *content;
@property (strong, nonatomic) PhotoDetailsHead * head;
@property (strong, nonatomic) PhotoDetailsFooter * foot;
@property (strong, nonatomic) UIView * editView;
@property (strong, nonatomic) UITextView * photoTitle;
@property (strong, nonatomic) UIView * prizeView;
@property (strong, nonatomic) UITextField * photoPrize;
@property (strong, nonatomic) UIView * recommendView;
@property (strong, nonatomic) UILabel * recommendText;
@property (strong, nonatomic) UISwitch * recommendSwitch;
@property (strong, nonatomic) UIView * remarksView;
@property (strong, nonatomic) UILabel * reamrksText;
@property (strong, nonatomic) UITextView * remarksContent;
@property (strong, nonatomic) UIView * photoClass;
@property (strong, nonatomic) UIView * photoClassParentView;
@property (strong, nonatomic) UILabel * photoClassParentText;
@property (strong, nonatomic) UILabel * photoClassParent;
@property (strong, nonatomic) UIView * photoClassSubView;
@property (strong, nonatomic) UILabel * photoClassSubText;
@property (strong, nonatomic) UILabel * photoClassSub;
@property (strong, nonatomic) UIImageView * share;
@property (assign, nonatomic) BOOL editStatu;
@property (strong, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) NSString * classifyID;
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) NSString * subclassID;
@property (strong, nonatomic) ShareCtr * shareView;
@property (strong, nonatomic) UIView * shareSelect;
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
    
    self.head = [[PhotoDetailsHead alloc] init];
    self.head.delegate = self;
    [self.content addSubview:self.head];
    
    self.head.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(self.content,Clearance)
    .topEqualToView(self.content)
    .heightIs(WindowWidth-(Clearance*2));
    
    self.editView = [[UIView alloc] init];
    [self.editView setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:self.editView];
    
    self.editView.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(self.content,Clearance)
    .topSpaceToView(self.head,5)
    .heightIs(160);
    
    
    self.photoTitle = [[UITextView alloc] init];
    self.photoTitle.contentInset = UIEdgeInsetsMake(2,-4,-2,-4);
    self.photoTitle.scrollEnabled = NO;
    self.photoTitle.editable = NO;
    self.photoTitle.delegate = self;
    [self.photoTitle setFont:Font(12)];
    [self.photoTitle setBackgroundColor:[UIColor whiteColor]];
    [self.editView addSubview:self.photoTitle];
    self.photoTitle.sd_layout
    .leftEqualToView(self.editView)
    .topEqualToView(self.editView)
    .rightEqualToView(self.editView)
    .heightIs(50);
    
    self.prizeView = [[UIView alloc] init];
    [self.prizeView setBackgroundColor:[UIColor whiteColor]];
    [self.editView addSubview:self.prizeView];
    self.prizeView.sd_layout
    .leftEqualToView(self.editView)
    .rightEqualToView(self.editView)
    .topSpaceToView(self.photoTitle,3)
    .heightIs(30);
    
    self.photoPrize = [[UITextField alloc] init];
    [self.photoPrize setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    self.photoPrize.keyboardType = UIKeyboardTypeDecimalPad;
    self.photoPrize.textColor = ThemeColor;
    self.photoPrize.delegate = self;
    [self.prizeView addSubview:self.photoPrize];
    self.photoPrize.sd_layout
    .leftEqualToView(self.prizeView)
    .topSpaceToView(self.prizeView,5)
    .bottomSpaceToView(self.prizeView,5)
    .rightSpaceToView(self.prizeView,95);
    UILabel * photoPrize = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 30, 40)];
    [photoPrize setTextColor:ThemeColor];
    [photoPrize setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [photoPrize setText:@"￥"];
    photoPrize.sd_layout.widthIs(10);
    self.photoPrize.leftViewMode = UITextFieldViewModeAlways;
    self.photoPrize.leftView = photoPrize;
    
    
    self.recommendView = [[UIView alloc] init];
    [self.recommendView setBackgroundColor:[UIColor whiteColor]];
    [self.prizeView addSubview:self.recommendView];
    self.recommendView.sd_layout
    .leftSpaceToView(self.photoPrize,5)
    .topEqualToView(self.prizeView)
    .bottomEqualToView(self.prizeView)
    .rightEqualToView(self.prizeView);
    
    
    self.recommendText = [[UILabel alloc] init];
    [self.recommendText setText:@"推荐"];
    [self.recommendText setFont:Font(12)];
    [self.recommendText setTextColor:ThemeColor];
    [self.recommendView addSubview:self.recommendText];
    self.recommendText.sd_layout
    .leftSpaceToView(self.recommendView,0)
    .topEqualToView(self.recommendView)
    .bottomEqualToView(self.recommendView)
    .widthIs(30);
    
    self.recommendSwitch = [[UISwitch alloc] init];
    self.recommendSwitch.onTintColor = ThemeColor;
    self.recommendSwitch.transform = CGAffineTransformMakeScale(0.8,0.8);
    [self.recommendSwitch addTarget:self action:@selector(switchSelected:) forControlEvents:UIControlEventValueChanged];
    [self.recommendView addSubview:self.recommendSwitch];
    self.recommendSwitch.sd_layout
    .rightSpaceToView(self.recommendView,-8)
    .topSpaceToView(self.recommendView,2.5);
    
    self.remarksView = [[UIView alloc] init];
    [self.remarksView setBackgroundColor:[UIColor whiteColor]];
    [self.editView addSubview:self.remarksView];
    self.remarksView.sd_layout
    .leftEqualToView(self.editView)
    .rightEqualToView(self.editView)
    .topSpaceToView(self.prizeView,3)
    .heightIs(25);
    
    self.reamrksText = [[UILabel alloc] init];
    [self.reamrksText setText:@"备注:"];
    [self.reamrksText setTextColor:ColorHex(0X888888)];
    [self.reamrksText setFont:Font(12)];
    [self.remarksView addSubview:self.reamrksText];
    self.reamrksText.sd_layout
    .leftSpaceToView(self.remarksView,2)
    .topSpaceToView(self.remarksView,0)
    .widthIs(30)
    .heightIs(30);
    
    self.remarksContent = [[UITextView alloc] init];
    self.remarksContent.scrollEnabled = NO;
    self.remarksContent.editable = NO;
    self.remarksContent.delegate = self;
    self.remarksContent.contentInset = UIEdgeInsetsMake(2,0,2,0);
    [self.remarksContent setBackgroundColor:[UIColor clearColor]];
    [self.remarksContent setFont:Font(12)];
    [self.remarksView addSubview:self.remarksContent];
    self.remarksContent.sd_layout
    .leftSpaceToView(self.reamrksText,0)
    .topSpaceToView(self.remarksView,0)
    .rightSpaceToView(self.remarksView,0)
    .bottomSpaceToView(self.remarksView,0);
    
    self.photoClass = [[UIView alloc] init];
    [self.photoClass setBackgroundColor:[UIColor clearColor]];
    //self.photoClass.clipsToBounds = YES;
    [self.content addSubview: self.photoClass];
    
    self.photoClass.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(self.content,40)
    .topSpaceToView(self.editView,5)
    .heightIs(30);

 

    self.photoClassParentText = [[UILabel alloc] init];
    [self.photoClassParentText setText:@"分类:"];
    [self.photoClassParentText setTextColor:ColorHex(0X888888)];
    [self.photoClassParentText setFont:Font(12)];
    [self.photoClass addSubview:self.photoClassParentText];
    self.photoClassParentText.sd_layout
    .leftEqualToView(self.photoClass)
    .topEqualToView(self.photoClass)
    .widthIs(30)
    .heightIs(30);
    
    self.photoClassParentView = [[UIView alloc] init];
    [self.photoClassParentView setBackgroundColor:ThemeColor];
    self.photoClassParentView.cornerRadius = 12;
    [self.photoClass addSubview:self.photoClassParentView];
    self.photoClassParentView.sd_layout
    .leftSpaceToView(self.photoClassParentText,0)
    .topSpaceToView(self.photoClass,3)
    .widthIs(50)
    .heightIs(24);

    self.photoClassParent = [[UILabel alloc] init];
    [self.photoClassParent setFont:Font(12)];
    self.photoClassParent.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.photoClassParent setTextColor:[UIColor whiteColor]];
    [self.photoClassParent addTarget:self action:@selector(photoClassParentSelected)];
    [self.photoClassParentView addSubview:self.photoClassParent];
    self.photoClassParent.sd_layout
    .leftSpaceToView(self.photoClassParentView,8)
    .topEqualToView(self.photoClassParentView)
    .rightSpaceToView(self.photoClassParentView ,8)
    .bottomEqualToView(self.photoClassParentView);
    
    
    UILabel * line11 = [[UILabel alloc] init];
    [line11 setText:@">"];
    [line11 setTextColor:ColorHex(0X888888)];
    [line11 setFont:Font(13)];
    [self.photoClass addSubview:line11];
    line11.sd_layout
    .leftSpaceToView(self.photoClassParentView,5)
    .topSpaceToView(self.photoClass,3)
    .heightIs(24)
    .widthIs(10);


    self.photoClassSubView = [[UIView alloc] init];
    self.photoClassSubView.cornerRadius = 12;
    [self.photoClassSubView addTarget:self action:@selector(photoClassSubViewSelected)];
    [self.photoClassSubView setBackgroundColor:ColorHex(0X559EDD)];
    [self.photoClass addSubview:self.photoClassSubView];
    self.photoClassSubView.sd_layout
    .leftSpaceToView(self.photoClassParentView,20)
    .topSpaceToView(self.photoClass,3)
    .widthIs(50)
    .heightIs(24);

    self.photoClassSub = [[UILabel alloc] init];
    [self.photoClassSub setTextColor:[UIColor whiteColor]];
    self.photoClassSub.font = Font(12);
    self.photoClassSub.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.photoClassSubView addSubview:self.photoClassSub];
    self.photoClassSub.sd_layout
    .leftSpaceToView(self.photoClassSubView,8)
    .rightSpaceToView(self.photoClassSubView,8)
    .topEqualToView(self.photoClassSubView)
    .bottomEqualToView(self.photoClassSubView);
    
    
    self.shareSelect = [[UIView alloc] init];
    [self.shareSelect setBackgroundColor:[UIColor clearColor]];
    [self.shareSelect addTarget:self action:@selector(shareViewSelected)];
    [self.content addSubview:self.shareSelect];
    self.shareSelect.sd_layout
    .rightSpaceToView(self.content,0)
    .topEqualToView(self.photoClass)
    .heightIs(40)
    .widthIs(50);
    
    self.share = [[UIImageView alloc] init];
    [self.share setBackgroundColor:[UIColor clearColor]];
    [self.share setContentMode:UIViewContentModeScaleAspectFit];
    [self.share setImage:[UIImage imageNamed:@"ico_dynamic_more"]];
    [self.shareSelect addSubview:self.share];
    self.share.sd_layout
    .rightSpaceToView(self.shareSelect,11)
    .topSpaceToView(self.shareSelect,5)
    .widthIs(20)
    .heightIs(20);

    self.foot = [[PhotoDetailsFooter alloc] init];
    self.foot.delegate = self;
    [self.content addSubview:self.foot];
    self.foot.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.photoClass,5)
    .heightIs(400);
    
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
    [self.remarksView updateLayout];
    [self.editView updateLayout];
    self.photoClass.sd_layout.topSpaceToView(self.editView,3);
    [self.photoClass updateLayout];
    
    
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

- (void)setPhotoDetailsContent:(DetailPhotoRequset *)data{
    self.subclassID = data.subclassID;
    self.uid = data.userID;
    self.classifyID = data.classifyID;
    [self.photoTitle setText:data.name];

    
    if([self.uid isEqualToString:self.photosUserID]){
        
        [self.recommendView setHidden:NO];
        [self.remarksView setHidden:NO];
        [self.edit setHidden:NO];
        self.remarksView.sd_layout.heightIs(30);
        self.remarksView.sd_layout.topSpaceToView(self.prizeView,3);
        self.editView.sd_layout.heightIs(160);
        
        [self.photoPrize setHidden:NO];
       
        
    }else{
        
        [self.recommendView setHidden:YES];
        [self.remarksView setHidden:YES];
        [self.edit setHidden:YES];
        self.remarksView.sd_layout.heightIs(1);
        self.remarksView.sd_layout.topSpaceToView(self.prizeView,0);
        self.editView.sd_layout.heightIs(115);
        
        if(data.showPrice){
            [self.photoPrize setHidden:NO];
        }else{
            [self.photoPrize setHidden:YES];
        }
    }
    
    
    [self.remarksView updateLayout];
    [self.editView updateLayout];
    self.photoClass.sd_layout.topSpaceToView(self.editView,3);
    [self.photoClass updateLayout];
    self.photoTitle.sd_layout.heightIs([self heightForString:self.photoTitle andWidth:self.photoTitle.width]);
    [self.photoTitle updateLayout];
    [self.photoPrize setText:data.price];
    if([data.recommend isEqualToString:@"true"]){
        [self.recommendSwitch setOn:YES animated:YES];
    }else{
        [self.recommendSwitch setOn:NO animated:YES];
    }
    
    
    if(data.classifyName && data.classifyName.length > 0){
        [self.photoClassParent setText:data.classifyName];
        [self.photoClassParentView setHidden:NO];
    }else{
        [self.photoClassParentView setHidden:YES];
    }
    if(data.subclassName && data.subclassName.length > 0){
        [self.photoClassSub setText:data.subclassName];
        [self.photoClassSubView setHidden:NO];
    }else{
        [self.photoClassSubView setHidden:YES];
    }
    
    
    [self.foot setDateTitle:data.date];
    [self.editView updateLayout];
    self.editView.sd_layout.heightIs(self.remarksView.height+self.remarksView.top_sd);
    [self.editView updateLayout];
    
    
    
    CGFloat photoClassMaxWidth = WindowWidth - 120;
    CGSize parentSize = [self.photoClassParent.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.photoClassParent.font,NSFontAttributeName,nil]];
    
    CGSize subSize = [self.photoClassSub.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.photoClassSub.font,NSFontAttributeName,nil]];
    if(parentSize.width > photoClassMaxWidth-16){
        parentSize.width = photoClassMaxWidth-16;
        subSize.width = 0;
    }else{
        
        if(subSize.width > photoClassMaxWidth - parentSize.width - 16){
            subSize.width = photoClassMaxWidth - parentSize.width - 16;
        }
    }

    
    self.photoClassParentView.sd_layout.widthIs(parentSize.width+16);
    self.photoClassSubView.sd_layout.widthIs(subSize.width+16);
    [self.photoClassParentView updateLayout];
    [self.photoClassSubView updateLayout];
    
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

- (void)photoClassParentSelected{
    
    SuperAlbumClassCtr * superClass = GETALONESTORYBOARDPAGE(@"SuperAlbumClassCtr");
    superClass.classifyId = self.classifyID;
    superClass.pageName = self.photoClassParent.text;
    superClass.uid = self.uid;
    [self.navigationController pushViewController:superClass animated:YES];
    
}
- (void)photoClassSubViewSelected{
    AlbumClassTabelCtr * classTable = GETALONESTORYBOARDPAGE(@"AlbumClassTabelCtr");
    classTable.uid = self.uid;
    classTable.subClassID = self.subclassID;
    classTable.pageText = self.photoClassSub.text;
    [self.navigationController pushViewController:classTable animated:YES];
}

- (void)switchSelected:(UISwitch *)swt{
    NSString * recommend = @"";

    if(self.recommendSwitch.on){
        recommend = @"true";
    }else{
        recommend = @"false";
    }
    
    [self changePhotoDetails:@{@"name":self.photoTitle.text,
                               @"price":self.photoPrize.text,
                               @"recommend":recommend,
                               @"description":self.remarksContent.text,
                               @"photo_id":self.photoId}];
}

- (void)editSelected{
    
    self.editStatu = !self.editStatu;
    if(self.editStatu){
        for(PhotoImagesModel * model in self.imageArray){
            model.edit = YES;
        }
        [self.edit_icon setImage:[UIImage imageNamed:@"ico_confirm_black"]];
        [self.head setStyle:self.imageArray];
        self.photoTitle.editable = YES;
        self.photoTitle.scrollEnabled = YES;
        self.photoTitle.cornerRadius = 2;
        self.photoTitle.borderColor = ColorHex(0XEEEEEE);
        self.photoTitle.borderWidth = 1;
        
        self.prizeView.cornerRadius = 2;
        self.prizeView.borderWidth = 1;
        self.prizeView.borderColor = ColorHex(0XEEEEEE);
        
        self.remarksView.cornerRadius = 2;
        self.remarksView.borderColor = ColorHex(0XEEEEEE);
        self.remarksView.borderWidth = 1;
        
        self.remarksContent.scrollEnabled = YES;
        self.remarksContent.editable = YES;
    }else{
        [self.edit_icon setImage:[UIImage imageNamed:@"btn_edit_black"]];
        self.photoTitle.editable = NO;
        self.photoTitle.scrollEnabled = NO;
        self.photoTitle.borderWidth = 0;
        self.prizeView.borderWidth = 0;
        self.remarksView.borderWidth = 0;
        
        self.remarksContent.scrollEnabled = NO;
        self.remarksContent.editable = NO;
        [self.photoPrize resignFirstResponder];
        for(PhotoImagesModel * model in self.imageArray){
            model.edit = NO;
        }
        [self.head setStyle:self.imageArray];
        
        NSString * recommend = @"";
        if(self.recommendSwitch.on){
            recommend = @"true";
        }else{
            recommend = @"false";
        }
        
        NSString * remarksContentText = self.remarksContent.text;
        if(remarksContentText.length == 0){
            [self changePhotoDetails:@{@"name":self.photoTitle.text,
                                       @"price":self.photoPrize.text,
                                       @"description":@" ",
                                       @"recommend":recommend,
                                       @"photo_id":self.photoId}];
        }else{
            [self changePhotoDetails:@{@"name":self.photoTitle.text,
                                       @"price":self.photoPrize.text,
                                       @"recommend":recommend,
                                       @"description":self.remarksContent.text,
                                       @"photo_id":self.photoId}];
        }
    }
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
        [urlImages addObject:model.big];
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
                model.big = imageModel.big;
                model.thumbnails = imageModel.thumbnails;
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
                model.big = imageModel.big;
                model.thumbnails = imageModel.thumbnails;
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
        
        NSString * getImageStrUrl = imageModel.big;
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
    if (textField == self.photoPrize) {
        return self.editStatu;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == self.photoPrize){
        if(![self isPureInt:string]){
            [self showToast:@"请输入正确的价格"];
            return NO;
        }
    }
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
        self.remarksView.sd_layout.heightIs(size.height);
        [self.remarksView updateLayout];
    }
    
    
    self.editView.sd_layout.heightIs(self.remarksView.height+self.remarksView.top_sd);
    [self.editView updateLayout];
    [self.content setContentSize:CGSizeMake(0, self.foot.top+self.foot.height)];
}



#pragma mark - PhotoDetailsHeadDelegate
- (void)photoDetailsHeadSelectType:(NSInteger)type select:(NSInteger)indexPath{
    if(type == 1){
        NSInteger count = self.imageArray.count;
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            PhotoImagesModel * imageModel = [self.imageArray objectAtIndex:i];
            
            NSString * getImageStrUrl = imageModel.big;
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
                         @"imageId":imageModel.imageID}];
    }
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    
    [self getDetailPhoto];
    
    [self getPhotoImages];
    
    [self getPhotoDescription];
}

- (void)getDetailPhoto{
    
    if(!self.subclassID){
        [self showLoad];
    }
    //[self showLoad];
    
    NSDictionary * detailPhotodata = @{@"photoId":self.photoId};
    NSLog(@"url -- %@",self.congfing.getDetailPhoto);
    __weak __typeof(self)weakSelef = self;
    // 获取相册详情内容
    [HTTPRequest requestPOSTUrl:self.congfing.getDetailPhoto parametric:detailPhotodata succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"获取相册详情内容 -- >%@",responseObject);
        DetailPhotoRequset * requset = [[DetailPhotoRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [weakSelef setPhotoDetailsContent:requset];
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

- (void)getPhotoDescription{
    NSDictionary * detailPhotodata = @{@"photoId":self.photoId};
    NSLog(@"url -- %@",self.congfing.getDetailPhoto);
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
            
            
            weakSelef.remarksView.sd_layout.heightIs([weakSelef heightForString:weakSelef.remarksContent andWidth:weakSelef.remarksContent.width]);
            [weakSelef.remarksView updateLayout];
            weakSelef.editView.sd_layout.heightIs(weakSelef.remarksView.height+weakSelef.remarksView.top_sd);
            [weakSelef.editView updateLayout];
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

- (void)setCover:(NSDictionary *)data{
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.setCover parametric:data succed:^(id responseObject){
       // [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        PhotoDescriptionRequset * requset = [[PhotoDescriptionRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [weakSelef getPhotoImages];
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
            [weakSelef getPhotoImages];
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
            [weakSelef getPhotoDescription];
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
                PublishPhotosCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotosCtr");
                pulish.is_copy = YES;
                pulish.photoTitleText = self.photoTitle.text;
                pulish.imageCopy = [[NSMutableArray alloc] initWithArray:self.imageArray];
                [weakSelef.navigationController pushViewController:pulish animated:YES];
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
