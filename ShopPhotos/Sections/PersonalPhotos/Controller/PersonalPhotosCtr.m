//
//  PersonalPhotosCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/25.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PersonalPhotosCtr.h"
#import "AlbumClassTable.h"
#import "DynamicTableView.h"
#import "AlbumPhotoTableView.h"
#import "AlbumPhotosRequset.h"
#import <MJRefresh.h>
#import "DynamicRequset.h"
#import "PhotoDetailsCtr.h"
#import "PersonalHomeCtr.h"
#import "DynamicImagesModel.h"
#import <MJPhotoBrowser.h>
#import "AlbumClassModel.h"
#import "AlbumPhotosModel.h"
#import "PhotosSearchCtr.h"
#import "PersonalPhotosSearchCtr.h"
#import "UserInfoDrawerCtr.h"
#import "ShareCtr.h"
#import "ShareContentSelectCtr.h"
#import <ShareSDK/ShareSDK.h>
#import "DynamicQRAlert.h"
#import "DownloadImageCtr.h"
#import "PublishPhotoCtr.h"
#import "HasCollectPhotoRequset.h"
#import "AlbumClassTableModel.h"
#import "AlbumClassTableSubModel.h"
//#import "AlbumClassTabelCtr.h"
#import "SearchAllCtr.h"
#import "CopyRequset.h"

@interface PersonalPhotosCtr ()<AlbumPhotoTableViewDelegate,DynamicTableViewDelegate,UserInfoDrawerDelegate,ShareDelegate,AlbumClassTableDelegate>
@property (weak, nonatomic) IBOutlet UIView *search;
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UIView *recommend;
@property (weak, nonatomic) IBOutlet UILabel *recommendText;
@property (weak, nonatomic) IBOutlet UIView *recommendLine;
@property (weak, nonatomic) IBOutlet UIView *dynamic;
@property (weak, nonatomic) IBOutlet UILabel *dynamicText;
@property (weak, nonatomic) IBOutlet UIView *dynamicLine;
@property (weak, nonatomic) IBOutlet UIView *photos;
@property (weak, nonatomic) IBOutlet UIView *photosLine;
@property (weak, nonatomic) IBOutlet UILabel *photosText;
@property (weak, nonatomic) IBOutlet UIView *photosClass;
@property (weak, nonatomic) IBOutlet UILabel *photosClassText;
@property (weak, nonatomic) IBOutlet UIView *photosClassLine;
@property (weak, nonatomic) IBOutlet UIView *content;
@property (strong, nonatomic) UILabel * tempText;
@property (strong, nonatomic) UIView * tempLine;
@property (strong, nonatomic) AlbumPhotoTableView * recommendList;
@property (strong, nonatomic) DynamicTableView * dynamicList;
@property (strong, nonatomic) AlbumPhotoTableView * photosList;
@property (strong, nonatomic) AlbumClassTable * photoClassList;
@property (strong, nonatomic) NSMutableArray * recommendDataArray;
@property (strong, nonatomic) NSMutableArray * dynamicDataArray;
@property (strong, nonatomic) NSMutableArray * photosDataArray;
@property (strong, nonatomic) NSMutableArray * photoClassDataArray;
@property (assign, nonatomic) NSInteger recommendPageIndex;
@property (assign, nonatomic) NSInteger dynamicPageIndex;
@property (assign, nonatomic) NSInteger photosPageIndex;
@property (assign, nonatomic) NSInteger selectType;
@property (strong, nonatomic) UserInfoDrawerCtr * userInfo;
@property (strong, nonatomic) ShareCtr * share;
@property (assign, nonatomic) NSInteger userInfoSelectIndex;
@property (assign, nonatomic) NSInteger shareSelectIndex;
@property (strong, nonatomic) DynamicQRAlert * qrAlert;
@property (strong, nonatomic) UIView * topView;
@end

@implementation PersonalPhotosCtr

- (NSMutableArray *)recommendDataArray{
    if(!_recommendDataArray) _recommendDataArray = [NSMutableArray array];
    return _recommendDataArray;
}

- (NSMutableArray *)dynamicDataArray{
    if(!_dynamicDataArray) _dynamicDataArray = [NSMutableArray array];
    return _dynamicDataArray;
}

- (NSMutableArray *)photosDataArray{
    if(!_photosDataArray) _photosDataArray = [NSMutableArray array];
    return _photosDataArray;
}

- (NSMutableArray *)photoClassDataArray{
    if(!_photoClassDataArray) _photoClassDataArray = [NSMutableArray array];
    return _photoClassDataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self setStyleType:self.initialType];
}

- (void)setup{
    [self.pageTitle setText:self.pageTitleText];
    [self.back addTarget:self action:@selector(backSelected)];
    [self.recommend addTarget:self action:@selector(classTypeSelected:)];
    [self.dynamic addTarget:self action:@selector(classTypeSelected:)];
    [self.photos addTarget:self action:@selector(classTypeSelected:)];
    [self.photosClass addTarget:self action:@selector(classTypeSelected:)];
    [self.search addTarget:self action:@selector(searchSelected)];
    self.tempLine = self.recommendLine;
    self.tempText = self.recommendText;
    
    self.recommendList = [[AlbumPhotoTableView alloc] init];
    self.recommendList.delegate = self;
    [self.content addSubview:self.recommendList];
    
    self.dynamicList = [[DynamicTableView alloc] init];
    self.dynamicList.delegate = self;
    [self.content addSubview:self.dynamicList];
    
    self.photosList = [[AlbumPhotoTableView alloc] init];
    self.photosList.delegate = self;
    [self.content addSubview:self.photosList];
    
    self.photoClassList = [[AlbumClassTable alloc] init];
    self.photoClassList.albumDelegage = self;
    [self.content addSubview:self.photoClassList];
    
    self.recommendPageIndex = 1;
    self.dynamicPageIndex = 1;
    self.photosPageIndex = 1;
    
    __weak __typeof(self)weakSelef = self;
    self.recommendList.photos.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadRecommendNetworkData];
    }];
    
    self.dynamicList.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadDynamicNetworkData];
    }];
    
    self.photosList.photos.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadPhotoNetworkData];
    }];
    
    self.recommendList.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topEqualToView(self.content)
    .bottomEqualToView(self.content);
    
    self.dynamicList.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topEqualToView(self.content)
    .bottomEqualToView(self.content);
    
    self.photosList.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .bottomEqualToView(self.content)
    .topEqualToView(self.content);
    
    self.photoClassList.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topEqualToView(self.content)
    .bottomEqualToView(self.content);
    
    self.userInfo = GETALONESTORYBOARDPAGE(@"UserInfoDrawerCtr");
    self.userInfo.delegate = self;
    [self.view addSubview:self.userInfo.view];
    [self.userInfo closeDrawe];
    [self.userInfo.view setHidden:YES];
    
    
    
    self.share = GETALONESTORYBOARDPAGE(@"ShareCtr");
    self.share.delegate = self;
    [self.view addSubview:self.share.view];
    [self.share.view setHidden:YES];
    [self.share closeAlert];
    
    self.qrAlert = [[DynamicQRAlert alloc] init];
    [self.view addSubview:self.qrAlert];
    self.qrAlert.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    [self.qrAlert setHidden:YES];
    
    self.topView = [[UIView alloc] init];
    [self.topView setBackgroundColor:[UIColor clearColor]];
    [self.topView addTarget:self action:@selector(topViewSelected)];
    [self.view addSubview:self.topView];
    self.topView.sd_layout
    .rightSpaceToView(self.view,10)
    .bottomSpaceToView(self.view,140)
    .widthIs(50)
    .heightIs(50);
    
    UIImageView * topImage = [[UIImageView alloc] init];
    [topImage setContentMode:UIViewContentModeScaleAspectFit];
    [topImage setCornerRadius:3];
    [topImage setImage:[UIImage imageNamed:@"btn_top"]];
    [self.topView addSubview:topImage];
    topImage.sd_layout
    .leftSpaceToView(self.topView,0)
    .rightSpaceToView(self.topView,0)
    .topSpaceToView(self.topView,0)
    .bottomSpaceToView(self.topView,0);
}

#pragma mark - OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topViewSelected{
    
    if(self.selectType == 100){
        [self.recommendList.photos setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if(self.selectType == 101){
        [self.dynamicList.table setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if(self.selectType == 102){
        [self.photosList.photos setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if(self.selectType == 103){
        [self.photoClassList.table setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}


- (void)searchSelected{
    
//    PersonalPhotosSearchCtr * photo = GETALONESTORYBOARDPAGE(@"PersonalPhotosSearchCtr");
//    photo.uid = self.uid;
//    [self.navigationController pushViewController:photo animated:YES];
    
    SearchAllCtr * search = GETALONESTORYBOARDPAGE(@"SearchAllCtr");
    [self.navigationController pushViewController:search animated:YES];
    
}

- (void)classTypeSelected:(UITapGestureRecognizer *)tap{
    
    NSInteger type = tap.view.tag;
    [self setStyleType:type];
    
}

- (void)setStyleType:(NSInteger)type{
    self.selectType = type;
    [self.tempLine setHidden:YES];
    [self.tempText setTextColor:ColorHex(0X000000)];
    
    if(type == 100){
        [self.topView setHidden:NO];
        [self.recommendText setTextColor:ColorHex(0XFF500D)];
        [self.recommendLine setHidden:NO];
        self.tempLine = self.recommendLine;
        self.tempText = self.recommendText;
        [self.content bringSubviewToFront:self.recommendList];
        
        if(self.recommendDataArray.count == 0){
            [self.recommendList.photos.mj_header beginRefreshing];
        }
    }else if(type == 101){
        [self.topView setHidden:NO];
        [self.dynamicText setTextColor:ColorHex(0XFF500D)];
        [self.dynamicLine setHidden:NO];
        self.tempLine = self.dynamicLine;
        self.tempText = self.dynamicText;
        [self.content bringSubviewToFront:self.dynamicList];
        if(self.dynamicDataArray.count == 0){
            [self.dynamicList.table.mj_header beginRefreshing];
        }
        
    }else if(type == 102){
        [self.topView setHidden:NO];
        [self.photosText setTextColor:ColorHex(0XFF500D)];
        [self.photosLine setHidden:NO];
        self.tempLine = self.photosLine;
        self.tempText = self.photosText;
        [self.content bringSubviewToFront:self.photosList];
        
        if(self.photosDataArray.count == 0){
            [self.photosList.photos.mj_header beginRefreshing];
        }
        
        
    }else if(type == 103){
        [self.topView setHidden:YES];
        [self.photosClassText setTextColor:ColorHex(0XFF500D)];
        [self.photosClassLine setHidden:NO];
        self.tempLine = self.photosClassLine;
        self.tempText = self.photosClassText;
        [self.content bringSubviewToFront:self.photoClassList];
        
        if(self.photoClassDataArray.count == 0){
            [self loadClassPhotoData:@{@"uid":self.uid}];
        }
    }
    
}

#pragma mark - UserInfoDrawerDelegate
- (void)userInfoDrawerHeadSelected:(NSInteger)type{
    
    if(type == 1){
        DynamicModel * model = [self.dynamicDataArray objectAtIndex:self.userInfoSelectIndex];
        NSMutableArray *photos = [NSMutableArray array];
        MJPhoto * photo = [[MJPhoto alloc] init];
        if([model.user objectForKey:@"icon"]){
            photo.url = [NSURL URLWithString:[model.user objectForKey:@"icon"]];
            [photos addObject:photo];
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = 0;
            browser.photos = photos;
            [browser show];
        }
    }
}
- (void)userInfoDrawerCellSelected:(UserInfoModel *)model WithType:(NSInteger)type{
    
    if(type == 0){
        
        PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
        personalHome.uid = model.uid;
        personalHome.twoWay = self.twoWay;
        [self.navigationController pushViewController:personalHome animated:YES];
        
    }else if(type == 1){
    }else if(type == 2){
        
        NSString * chatStr = model.weixin;
        if(chatStr && chatStr.length > 0){
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = chatStr;
        }else{
            [self showToast:@"微信号为空"];
        }
        __weak __typeof(self)weakSelef = self;
        NSString * msg = [NSString stringWithFormat:@"微信号已复制，可以进入微信粘贴"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"打开微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"] options:@{} completionHandler:nil];
            }else{
                [weakSelef showToast:@"您没有安装微信"];
            }
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if(type == 3){
        
        NSString * qqStr = model.qq;
        if(qqStr && qqStr.length >0){
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = qqStr;
        }else {
            [self showToast:@"QQ号为空"];
            return;
        }
        
        __weak __typeof(self)weakSelef = self;
        NSString * msg = [NSString stringWithFormat:@"QQ号已复制，可以进入QQ粘贴"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"打开QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mqq://"] options:@{} completionHandler:nil];
            }else{
                [weakSelef showToast:@"您没有安装QQ"];
            }
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - ShareDelegate
#pragma mark - ShareDelegate
- (void)shareSelected:(NSInteger)type{
    
    DynamicModel * model = [self.dynamicDataArray objectAtIndex:self.shareSelectIndex];
    NSMutableArray * urlImages = [NSMutableArray array];
    for(DynamicImagesModel * subModel in model.images){
        [urlImages addObject:subModel.bigImageUrl];
    }
    
    NSString * photoStr = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,[model.user objectForKey:@"uid"],model.photosID];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:photoStr
                                     images:nil
                                        url:nil
                                      title:photoStr
                                       type:SSDKContentTypeAuto];
    switch (type) {
        case 1: //微信好友
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = photoStr;
            [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
            }];
        }
            break;
        case 2:// 朋友圈
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = model.title;
            ShareContentSelectCtr * shareSelect = GETALONESTORYBOARDPAGE(@"ShareContentSelectCtr");
            shareSelect.dataArray = model.images;
            [self.navigationController pushViewController:shareSelect animated:YES];
        }
            break;
        case 3:// QQ好友
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = photoStr;
            [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
            }];
        }
            
            break;
        case 4:// 复制相册
        {
            
            if([self.photosUserID isEqualToString:self.uid]){
                [self showToast:@"不能复制自己的相册"];
                break;
            }else{
                [self getAllowPurview:@{@"uid":self.uid}];
            }
        }
            break;
        case 5:// 复制链接
        {
//            NSString * text = [NSString stringWithFormat:@"%@/photo/detail/%@",URLHead,[model.user objectForKey:@"uid"],model.photosID];
            NSString * text = [NSString stringWithFormat:@"%@/photo/detail/%@",URLHead,[model.user objectForKey:@"uid"]];
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [self showToast:@"复制成功"];
        }
            
            break;
        case 6:// 复制标题
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = model.title;
            [self showToast:@"复制成功"];
        }
            break;
        case 7:// 查看二维码
        {
            self.qrAlert.titleText = model.title;
            self.qrAlert.contentText = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,[model.user objectForKey:@"uid"],model.photosID];
            [self.qrAlert showAlert];
        }
            
            break;
        case 8:// 收藏相册
        {

            if([self.photosUserID isEqualToString:self.uid]){
                [self showToast:@"不能收藏自己的相册"];
                break;
            }else{
                [self hasCollectPhoto:@{@"photoId":model.photosID}];
            }
            
            
        }
            break;
        case 9:// 下载图片
        {
            DownloadImageCtr * shareSelect = GETALONESTORYBOARDPAGE(@"DownloadImageCtr");
            shareSelect.dataArray = model.images;
            [self.navigationController pushViewController:shareSelect animated:YES];
            
        }
            break;
    }
    
}

#pragma mark - AlbumClassTableDelegate
- (void)albumClassTableSelected:(NSIndexPath *)indexPath{
    
    AlbumClassTableModel * model = [self.photoClassDataArray objectAtIndex:indexPath.section];
    AlbumClassTableSubModel * subModel = [model.dataArray objectAtIndex:indexPath.row];
/*    AlbumClassTable * classTable = GETALONESTORYBOARDPAGE(@"AlbumClassTabelCtr");
    classTable.uid = self.uid;
    classTable.subClassID = [NSString stringWithFormat:@"%ld",subModel.classfiyId];
    classTable.pageText = subModel.name;
    [self.navigationController pushViewController:classTable animated:YES];
 */
}


#pragma mark - AlbumPhotoTableViewDelegate
- (void)albumPhotoSelectPath:(NSInteger)indexPath{
    NSString * photosID = @"";
    if(self.selectType == 100){
        NSLog(@"推荐");
        AlbumPhotosModel * model = [self.recommendDataArray objectAtIndex:indexPath];
        photosID = model.Id;
        
    }else if(self.selectType == 102){
        NSLog(@"相册");
        AlbumPhotosModel * model = [self.photosDataArray objectAtIndex:indexPath];
        photosID = model.Id;
    }
    PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
    photoDetails.photoId = photosID;
    photoDetails.persona = YES;
    [self.navigationController pushViewController:photoDetails animated:YES];
}
- (void)albumEditSelectPath:(NSInteger)indexPath{
}

#pragma mark - DynamicTableViewDelegate
- (void)cellSelectType:(NSInteger)type tableViewCelelIndexPath:(NSIndexPath *)indexPath{
    
    DynamicModel * model = [self.dynamicDataArray objectAtIndex:indexPath.row];
    
    if(type == 1){
        NSString * uid = [model.user objectForKey:@"uid"];
        if(uid && uid.length > 0){
            [self loadUserNetworkData:@{@"uid":uid}];
        }
        NSLog(@"icon");
        self.userInfoSelectIndex = indexPath.row;
        
    }else if(type == 2){
        self.shareSelectIndex = indexPath.row;
        [self.share showAlert];
        NSLog(@"share");
        
    }else if(type == 3){
        NSString * uid = [model.user objectForKey:@"uid"];
        if(uid && uid.length > 0){
            self.userInfoSelectIndex = indexPath.row;
            NSString * uid = [model.user objectForKey:@"uid"];
            if(uid && uid.length > 0){
                [self loadUserNetworkData:@{@"uid":uid}];
            }

        }
    }
}

- (void)cellImageSelected:(NSInteger)tag TabelViewCellIndexPath:(NSIndexPath *)indexPath{
    
    DynamicModel * model = [self.dynamicDataArray objectAtIndex:indexPath.row];
    NSInteger count = model.images.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        DynamicImagesModel * imageModel = [model.images objectAtIndex:i];
        
        NSString * getImageStrUrl = imageModel.bigImageUrl;
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString: getImageStrUrl];
        [photos addObject:photo];
    }
    if(photos.count > 0){
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = tag;
        browser.photos = photos;
        [browser show];
    }
}

- (void)dynamicTableCellSelected:(NSIndexPath *)indexPath{
     DynamicModel * model = [self.dynamicDataArray objectAtIndex:indexPath.row];
    PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
    photoDetails.photoId = model.photosID;
    [self.navigationController pushViewController:photoDetails animated:YES];
}

#pragma makr - AFNetworking网络加载
- (void)loadRecommendNetworkData{
    self.recommendPageIndex = 1;
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.recommendPageIndex],
                            @"pageSize":@"30",
                            @"keyWord":@"false",
                            @"subclassification_id":@"0"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getRecommendPhotos parametric:data succed:^(id responseObject){
        [weakSelef.recommendList.photos.mj_header endRefreshing];
        NSLog(@"%@",responseObject);
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.recommendPageIndex ++;
            weakSelef.recommendList.photos.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadRecommendMoreNetworkData];
            }];
            if(requset.dataArray.count == 30){
                [weakSelef.recommendList.photos.mj_footer resetNoMoreData];
            }else{
                [weakSelef.recommendList.photos.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelef.recommendDataArray removeAllObjects];
            [weakSelef.recommendDataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.recommendList loadData:weakSelef.recommendDataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.recommendList.photos .mj_header endRefreshing];
    }];
}

- (void)loadRecommendMoreNetworkData{
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.recommendPageIndex],
                            @"pageSize":@"30",
                            @"keyWord":@"false",
                            @"subclassification_id":@"0"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getRecommendPhotos parametric:data succed:^(id responseObject){
        [weakSelef.recommendList.photos.mj_footer endRefreshing];
        
        NSLog(@"%@",responseObject);
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.recommendPageIndex ++;
            if(requset.dataArray.count == 30){
                [weakSelef.recommendList.photos.mj_footer resetNoMoreData];
            }else{
                [weakSelef.recommendList.photos.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelef.recommendDataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.recommendList loadMoreData:requset.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef.recommendList.photos.mj_footer endRefreshing];
        [weakSelef showToast:NETWORKTIPS];
    }];
    
}

- (void)loadDynamicNetworkData{
    
    self.dynamicPageIndex = 1;
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.dynamicPageIndex],
                            @"pageSize":@"20",
                            @"getAll":@"false"};
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getNewDynamics parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        [weakSelef.dynamicList.table.mj_header endRefreshing];
        
        DynamicRequset * requset = [[DynamicRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.dynamicPageIndex ++;
            weakSelef.dynamicList.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadDynamicNetworkMoreData];
            }];
            if(requset.dataArray.count == 20){
                 [weakSelef.dynamicList.table.mj_footer resetNoMoreData];
            }else{
                [weakSelef.dynamicList.table.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelef.dynamicDataArray removeAllObjects];
            [weakSelef.dynamicDataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.dynamicList loadData:requset.dataArray];
            
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.dynamicList.table.mj_header endRefreshing];
    }];
}

- (void)loadDynamicNetworkMoreData{
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.dynamicPageIndex],
                            @"pageSize":@"20",
                            @"getAll":@"false"};
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getNewDynamics parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        [weakSelef.dynamicList.table.mj_footer endRefreshing];
        
        DynamicRequset * requset = [[DynamicRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.dynamicPageIndex ++;
            if(requset.dataArray.count == 20){
                [weakSelef.dynamicList.table.mj_footer resetNoMoreData];
            }else{
                [weakSelef.dynamicList.table.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelef.dynamicDataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.dynamicList loadMoreData:requset.dataArray];
            
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.dynamicList.table.mj_footer endRefreshing];
    }];
}

- (void)loadPhotoNetworkData{
    self.photosPageIndex = 1;
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.photosPageIndex],
                            @"pageSize":@"30",
                            @"keyWord":@"false",
                            @"subclassification_id":@"0"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getUserPhotos parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        [weakSelef.photosList.photos.mj_header endRefreshing];
        
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.photosPageIndex ++;
            weakSelef.photosList.photos.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadPhotoNetworkMoreData];
            }];
            if(requset.dataArray.count == 30){
                [weakSelef.photosList.photos.mj_footer resetNoMoreData];
            }else{
                [weakSelef.photosList.photos.mj_footer endRefreshingWithNoMoreData];
            }

            [weakSelef.photosDataArray removeAllObjects];
            [weakSelef.photosDataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.photosList loadData:requset.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef.photosList.photos.mj_header endRefreshing];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)loadPhotoNetworkMoreData{
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.photosPageIndex],
                            @"pageSize":@"30",
                            @"keyWord":@"false",
                            @"subclassification_id":@"0"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getUserPhotos parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        [weakSelef.photosList.photos.mj_footer endRefreshing];
        
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.photosPageIndex ++;
            if(requset.dataArray.count == 30){
                [weakSelef.photosList.photos.mj_footer resetNoMoreData];
            }else{
                [weakSelef.photosList.photos.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelef.photosDataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.photosList loadMoreData:requset.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef.photosList.photos.mj_footer endRefreshing];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)loadClassPhotoData:(NSDictionary *)data{
    
    [self showLoad];
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.getClassifies parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        AlbumClassModel * model = [[AlbumClassModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef.photoClassDataArray addObjectsFromArray:model.dataArray];
            weakSelef.photoClassList.dataArray = model.dataArray;
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

#pragma makr - AFNetworking网络加载
- (void)loadUserNetworkData:(NSDictionary *)data{
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getUserInfo parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        
        UserInfoModel * infoModel = [[UserInfoModel alloc] init];
        [infoModel analyticInterface:responseObject];
        if(infoModel.status == 0){
            [weakSelef.userInfo setStyle:infoModel];
            [weakSelef.userInfo showDrawe];
        }else{
            [self showToast:infoModel.message];
        }
    } failure:nil];
}



- (void)getAllowPurview:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.isAllow parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        CopyRequset * model = [[CopyRequset alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            
            if(model.allow){
                DynamicModel * model = [weakSelef.dynamicDataArray objectAtIndex:weakSelef.shareSelectIndex];
/*                PublishPhotoCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
                pulish.is_copy = YES;
                pulish.photoTitleText = model.title;
                pulish.imageCopy = [[NSMutableArray alloc] initWithArray:model.images];
                
                [weakSelef.navigationController pushViewController:pulish animated:YES]; */
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
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)sendCopyRequest:(NSDictionary *)data{
    
    NSLog(@"1--- %@",data);
    
    NSLog(@"2--- %@",self.congfing.sendCopyRequest);
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.sendCopyRequest parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"发送成功，请耐心等待"];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)hasCollectPhoto:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.hasCollectPhoto parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        HasCollectPhotoRequset * requset = [[HasCollectPhotoRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            
            if(requset.hasCollect){
                [weakSelef showToast:@"已经收藏"];
            }else{
                
                [weakSelef collectPhoto:data];
            }
            
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)collectPhoto:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.collssssCopy parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [weakSelef showToast:@"收藏成功"];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}
@end
