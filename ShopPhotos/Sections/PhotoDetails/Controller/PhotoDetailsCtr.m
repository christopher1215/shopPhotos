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
#import "ShareContentSelectCtr.h"
#import <ShareSDK/ShareSDK.h>
#import "HasCollectPhotoRequset.h"
#import "DownloadImageCtr.h"
#import "DynamicImagesModel.h"
#import "CopyRequset.h"
#import "PublishPhotoCtr.h"
#import "KSPhotoBrowser.h"
#import "AlbumPhotosCtr.h"
#import "AlbumClassCtr.h"
#import "ClassByCoverCtr.h"
#import "SearchAllCtr.h"

@interface PhotoDetailsCtr ()<UITextViewDelegate,UITextFieldDelegate,PhotoDetailsHeadDelegate,UIScrollViewDelegate,PhotoDetailsFooterDelegate>
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
@property (assign, nonatomic) NSInteger  classifyID;
@property (strong, nonatomic) NSString * uid;
@property (assign, nonatomic) NSInteger subclassID;
@property (nonatomic, assign) BOOL  isCollected;
@property (nonatomic, assign) BOOL  isRecommeded;
@property (strong, nonatomic) UILabel * share;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) AlbumPhotosModel *photosModel;
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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadNetworkData];
}

- (void)setup{
    [self.back addTarget:self action:@selector(backSelected)];
    [self.edit addTarget:self action:@selector(editSelected)];
    [self.search addTarget:self action:@selector(searchSelected)];
    self.content.delegate = self;
}
- (void)searchSelected{
    
    SearchAllCtr * search = GETALONESTORYBOARDPAGE(@"SearchAllCtr");
    [self.navigationController pushViewController:search animated:YES];
}

- (void)createAutoLayout{
    
    self.editHead = [[PhotosEditView alloc] init];
//    self.editHead.delegate = self;
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
    .leftSpaceToView(userInfo,10)
    .topSpaceToView(userInfo,5)
    .widthIs(39)
    .heightIs(39);
    
    self.name = [[UILabel alloc] init];
    [self.name setTextColor:ColorHex(0x333333)];
    [self.name setFont:[UIFont fontWithName:@"PingFang SC" size:16]];
    [userInfo addSubview:self.name];
    self.name.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(userInfo,5)
    .rightEqualToView(userInfo)
    .heightIs(20);
    
    self.date = [[UILabel alloc] init];
    [self.date setFont:[UIFont fontWithName:@"PingFang SC" size:11]];
    [self.date setTextColor:ColorHex(0x7e8599)];
    [userInfo addSubview:self.date];
    self.date.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(self.name,3)
    .rightSpaceToView(userInfo,50)
    .heightIs(13);
    
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
    [self.photoTitle setFont:Font(13)];
    [self.photoTitle setTextColor:ColorHex(0x7e8599)];
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
    .topSpaceToView(self.photoTitle,8)
    .heightIs(65);

    self.line1 = [[UIView alloc]init];
    [self.line1 setBackgroundColor:ColorHex(0xeeeeee)];
    [self.content addSubview:_line1];
    self.line1.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(self.content,Clearance)
    .topSpaceToView(self.photoTitle,8)
    .heightIs(1);
    
    self.reamrksText = [[UILabel alloc] init];
    [self.reamrksText setText:@"备注:"];
    [self.reamrksText setTextColor:ColorHex(0xebebeb)];
    [self.reamrksText setFont:Font(13)];
    [self.content addSubview:self.reamrksText];
    self.reamrksText.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .topSpaceToView(self.photoTitle,8)
    .widthIs(40)
    .heightIs(30);
    
    self.remarksContent = [[UITextView alloc] init];
    self.remarksContent.contentInset = UIEdgeInsetsMake(2,0,2,0);
    self.remarksContent.scrollEnabled = NO;
    self.remarksContent.editable = NO;
    self.remarksContent.delegate = self;
    [self.remarksContent setBackgroundColor:[UIColor clearColor]];
    [self.remarksContent setFont:Font(13)];
    [self.remarksContent setTextColor:ColorHex(0x7e8599)];
    [self.content addSubview:self.remarksContent];
    self.remarksContent.sd_layout
    .leftSpaceToView(self.reamrksText,0)
    .topSpaceToView(self.photoTitle,5)
    .rightSpaceToView(self.content,Clearance)
    .heightIs(50);
    
    self.line2 = [[UIView alloc]init];
    [self.line2 setBackgroundColor:ColorHex(0xeeeeee)];
    [_content addSubview:_line2];
    self.line2.sd_layout
    .leftSpaceToView(_content,Clearance)
    .rightSpaceToView(_content,Clearance)
    .topSpaceToView(_remarksContent,0)
    .heightIs(1);
    
    self.photoClass = [[UIView alloc] init];
    [self.photoClass setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview: self.photoClass];
    self.photoClass.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(self.content,Clearance)
    .topSpaceToView(_line2,0)
    .heightIs(40);

    self.photoClassParent = [[UIButton alloc] init];
    [self.photoClassParent.titleLabel setFont:Font(10)];
    [self.photoClassParent setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.photoClassParent.layer.cornerRadius = 5;
    self.photoClassParent.layer.borderWidth = 1;
    self.photoClassParent.layer.borderColor = ColorHex(0xe0e0e0).CGColor;
    [self.photoClassParent addTarget:self action:@selector(photoClassParentSelected)];
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
    [self.photoClassSub.titleLabel setFont:Font(10)];
    [self.photoClassSub setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.photoClassSub.layer.cornerRadius = 5;
    self.photoClassSub.layer.borderWidth = 1;
    self.photoClassSub.layer.borderColor = ColorHex(0xe0e0e0).CGColor;
    [self.photoClassSub addTarget:self action:@selector(photoClassSubViewSelected)];
    [self.photoClass addSubview:_photoClassSub];
    self.photoClassSub.sd_layout
    .leftSpaceToView(line3,5)
    .topSpaceToView(self.photoClass,10)
    .heightIs(25);

    
    self.share = [[UILabel alloc] init];
    [self.share setFont:Font(22)];
    [self.share setText:@"..."];
    [self.share setTextColor:ColorHex(0x4c5364)];
    [self.share addTarget:self action:@selector(shareViewSelected)];
    self.share.textAlignment = NSTextAlignmentCenter;
    [self.photoClass addSubview:self.share];
    self.share.sd_layout
    .rightSpaceToView(self.photoClass,0)
    .topSpaceToView(self.photoClass,0)
    .widthIs(40)
    .heightIs(30);

    self.foot = [[PhotoDetailsFooter alloc] init];
    self.foot.delegate = self;
    [self.content addSubview:self.foot];
    self.foot.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.photoClass,5)
    .heightIs(400);

    UIView * topView = [[UIView alloc] init];
    [topView setBackgroundColor:[UIColor clearColor]];
    [topView addTarget:self action:@selector(topViewSelected)];
    [self.view addSubview:topView];
    topView.sd_layout
    .rightSpaceToView(self.view,10)
    .bottomSpaceToView(self.view,90)
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
- (void) photoClassSubViewSelected{
    AlbumPhotosCtr * albumPhotos = GETALONESTORYBOARDPAGE(@"AlbumPhotosCtr");
    albumPhotos.type = @"photo";
    albumPhotos.uid = _uid;
    albumPhotos.subClassid = _subclassID;
    albumPhotos.ptitle = self.photoClassSub.titleLabel.text;
    [self.navigationController pushViewController:albumPhotos animated:YES];
    
}
-(void)photoClassParentSelected{
    AlbumClassTableModel * model = [[AlbumClassTableModel alloc] init];
    model.Id = _classifyID;
    model.name = self.photoClassParent.titleLabel.text;
    
//    AlbumClassCtr * albumClass = GETALONESTORYBOARDPAGE(@"AlbumClassCtr");
//    albumClass.isSubClass = YES;
//    albumClass.uid = _uid;
//    albumClass.parentModel = model;
//    albumClass.isFromUploadPhoto = NO;
//    albumClass.isFromCopyPhoto = NO;
//    albumClass.fromCtr = self;
//    [self.navigationController pushViewController:albumClass animated:YES];
    
    ClassByCoverCtr *vc = [[ClassByCoverCtr alloc] initWithNibName:@"ClassByCoverCtr" bundle:nil];
    vc.parentModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setPhotoDetailsContent:(AlbumPhotosModel *)data{
    
    self.photosModel = [[AlbumPhotosModel alloc] init];
    self.photosModel = data;
    
//    NSDictionary *userInfo =
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[data.user objectForKey:@"avatar"]]];
    
    self.icon.layer.cornerRadius = _icon.frame.size.width/2;
    self.icon.layer.masksToBounds = TRUE;
    
    [self.name setText:data.title];
    [self.date setText:[NSString stringWithFormat:@"%@ 上传",data.createdAt]];
    
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
    
    self.subclassID = [[data.subclass objectForKey:@"id"] integerValue];
    self.uid = [data.user objectForKey:@"uid"];
    self.classifyID = [[data.classify objectForKey:@"id"] integerValue];
    self.isCollected = data.collected;
    self.isRecommeded = data.recommend;
    [self.photoTitle setText:data.title];
//    if (data.title.length > 0) {
//        [self.lblTitle setText:data.title];
//    }
    
    [self.editHead.title setText:data.title];
    [self.remarksContent setText:data.desc];
    
    if([self.uid isEqualToString:self.photosUserID]){
        [self.edit setHidden:NO];
        [self.search setHidden:NO];
    }else{
        [self.edit setHidden:YES];
        [self.search setHidden:YES];
//        [self.remarksView setHidden:YES];
        [self.reamrksText setHidden:YES];
        [self.remarksContent setHidden:YES];
        [self.line2 setHidden:YES];
        self.photoClass.sd_layout.topSpaceToView(_photoTitle,8);
    }
    
    [self.photoClass updateLayout];
    self.photoTitle.sd_layout.heightIs([self heightForString:self.photoTitle andWidth:self.photoTitle.width]);
    [self.photoTitle updateLayout];

    self.remarksContent.sd_layout.heightIs([self heightForString:self.remarksContent andWidth:self.remarksContent.width]);
    [self.remarksContent updateLayout];

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
    
    [self.foot setDateTitle:data.createdAt];
    
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
    [self.appd showShareview:self.photosModel.type collected:self.isCollected model:self.photosModel from:self];
}

- (void)editSelected{
    
    for(PhotoImagesModel * model in self.imageArray) {
        model.edit = YES;
    }
    
    PublishPhotoCtr * publish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
    publish.editData = @{@"images":self.imageArray, @"title":self.photoTitle.text,
                         @"remarks":self.remarksContent.text,@"photoId":self.photoId,
                         @"headtitle":self.lblTitle.text,@"parentclass":self.photoClassParent.titleLabel.text,
                         @"subclass":self.photoClassSub.titleLabel.text,@"recommend":[NSNumber numberWithBool:self.isRecommeded]};
    publish.isAdd = YES;
    
    [self.navigationController pushViewController:publish animated:YES];
}

-(void)clearPhotoTitle {
}

- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

#pragma mark - PhotoDetailsFooterDelegate
- (void)footerImageSelcted:(NSInteger)indexPath{
    
    NSInteger count = self.imageArray.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        PhotoImagesModel * imageModel = [self.imageArray objectAtIndex:i];
            
        NSString * url = imageModel.bigImageUrl;
        UIImageView * imageView = [[UIImageView alloc] init];
        KSPhotoItem * item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
        [photos addObject:item];
    }
    if(photos.count > 0){
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:photos selectedIndex:indexPath];
        
        [browser showFromViewController:self];
    }
}

#pragma mark - PhotoDetailsHeadDelegate
- (void)photoDetailsHeadSelectType:(NSInteger)type select:(NSInteger)indexPath{
    if(type == 1){
        NSInteger count = self.imageArray.count;
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            PhotoImagesModel * imageModel = [self.imageArray objectAtIndex:i];
            NSString * url = imageModel.bigImageUrl;
            UIImageView * imageView = [[UIImageView alloc] init];
            KSPhotoItem * item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
            [photos addObject:item];
        }
        if(photos.count > 0){
            KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:photos selectedIndex:indexPath];
            
            [browser showFromViewController:self];
        }
        
    }
}


- (void)photoDetailsHeadAddImage:(UIImageView *)image select:(NSInteger)indexPath {}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    [self getDetailPhoto];
//    [self getPhotoImages];
//    [self getPhotoDescription];
}

- (void)getDetailPhoto {
    if(!self.subclassID) {
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
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

@end
