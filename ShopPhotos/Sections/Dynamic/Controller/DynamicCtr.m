//
//  DynamicCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "DynamicCtr.h"
#import "DynamicViewCell.h"
#import "UserInfoDrawerCtr.h"
#import "AppDelegate.h"
#import <MJRefresh.h>
#import "AlbumPhotosRequset.h"
#import "UserInfoModel.h"
#import <MJPhotoBrowser.h>
#import "DynamicImagesModel.h"
#import "SearchAllCtr.h"
#import "DynamicTableView.h"
#import "MoreAlert.h"
#import "AddFriendAlert.h"
#import "QRCodeScanCtr.h"
#import "PersonalHomeCtr.h"
#import "PhotoDetailsCtr.h"
#import <ShareSDK/ShareSDK.h>
#import "PublishPhotoCtr.h"
#import "DynamicImagesModel.h"
#import "SharedItem.h"
#import "ShareContentSelectCtr.h"
#import "HasCollectPhotoRequset.h"
#import "DownloadImageCtr.h"
#import "CopyRequset.h"
#import "AlbumPhotosModel.h"
#import "SPVideoPlayer.h"
#import "AddUserViewController.h"
#import "ChattingViewController.h"
#import "PhotoImagesModel.h"
#import <AFNetworking.h>
#import "KSPhotoBrowser.h"

@interface DynamicCtr ()<DynamicTableViewDelegate,MoreAlertDelegate,AddFriendAlertDelegate,UserInfoDrawerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *more;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (strong, nonatomic) UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *scan;
@property (weak, nonatomic) IBOutlet UIView *head;

@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) UserInfoDrawerCtr * userInfo;
@property (strong, nonatomic) DynamicTableView * table;
@property (strong, nonatomic) MoreAlert * moreAlert;
@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) AddFriendAlert * addAlert;
@property (assign, nonatomic) NSInteger userInfoSelectIndex;
@property (assign, nonatomic) NSInteger shareSelectIndex;
@property (strong, nonatomic) NSMutableArray * imageArray;

@end

@implementation DynamicCtr


- (NSMutableArray *)imageArray {
    if(!_imageArray) _imageArray = [NSMutableArray array];
    return _imageArray;
}
- (NSMutableArray *)dataArray{
    if(!_dataArray)_dataArray = [NSMutableArray array];
    return _dataArray;
}

- (id)init {
    self = [super init];
    
    self.isMyDynamic = FALSE;
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.dataArray.count == 0){
        [self.table.table.mj_header beginRefreshing];
    }else{
        [self loadNetworkData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup{
    [self dataArray];
    [self imageArray];
    
    if (self.isMyDynamic == TRUE) {
        [_scan removeFromSuperview];
        _back = [[UIButton alloc] init];
        [_back setImage:[UIImage imageNamed:@"btn_back_black"] forState:UIControlStateNormal];
        [_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_back setTitle:@" 首页" forState:UIControlStateNormal];
        [_back.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        [_back setContentEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
        [_head addSubview:_back];
        _back.sd_layout
        .leftSpaceToView(_head,0)
        .bottomSpaceToView(_head,0)
        .widthIs(60)
        .heightIs(44);
        
        [_back addTarget:self action:@selector(backSelected)];
        _lblTitle.text = @"我的动态";
    } else {
        _lblTitle.text = @"动态";
    }
    
    [self.search addTarget:self action:@selector(searchSelected)];
    [self.scan addTarget:self action:@selector(qrScanSelected)];
    [self.more addTarget:self action:@selector(moreSelected)];
    
    self.table = [[DynamicTableView alloc] init];
    self.table.delegate = self;
    self.table.isMyDynamic = self.isMyDynamic;
    [self.view addSubview:self.table];
    
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .bottomSpaceToView(self.view,_isMyDynamic?0:49);
    
    self.userInfo = GETALONESTORYBOARDPAGE(@"UserInfoDrawerCtr");
    self.userInfo.delegate = self;
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self.userInfo.view];
    [self.userInfo closeDrawe];
    [self.userInfo.view setHidden:YES];
    
    __weak __typeof(self)weakSelef = self;
    self.table.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelef loadNetworkData];
    }];
    [self.table.table.mj_header beginRefreshing];
    
    self.moreAlert = [[MoreAlert alloc] init];
    [self.view addSubview:self.moreAlert];
    self.moreAlert.mode = _isMyDynamic? OptionModel : DynamicTabModel;
    self.moreAlert.delegate = self;
    [self.moreAlert setHidden:YES];
    self.moreAlert.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    
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

#pragma mark - OnClick
- (void)searchSelected{
    SearchAllCtr * search = GETALONESTORYBOARDPAGE(@"SearchAllCtr");
    [self.navigationController pushViewController:search animated:YES];
}

- (void)topViewSelected{
    [self.table.table setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)qrScanSelected {
    [self moreAlertSelected:2];
}

- (void)moreSelected{
    [self.moreAlert showAlert];
}

#pragma mark - MoreAlertDelegate
- (void)moreAlertSelected:(NSInteger)indexPath{
    
    if(indexPath == 0){
        PublishPhotoCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
        [self.navigationController pushViewController:pulish animated:YES];
    }else if(indexPath == 2){
        QRCodeScanCtr * qrCode = [[QRCodeScanCtr alloc] init];
        [self.navigationController pushViewController:qrCode animated:YES];
    }else if(indexPath == 1){
        AddUserViewController *vc=[[AddUserViewController alloc] initWithNibName:@"AddUserViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        //        if(!self.addAlert){
        //            self.addAlert = [[AddFriendAlert alloc] init];
        //            AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //            [appDelegate.window addSubview:self.addAlert];
        //            self.addAlert.delegate = self;
        //            self.addAlert.sd_layout
        //            .leftEqualToView(appDelegate.window)
        //            .rightEqualToView(appDelegate.window)
        //            .topEqualToView(appDelegate.window)
        //            .bottomEqualToView(appDelegate.window);
        //        }
        //        [self.addAlert showAlert];
    }
    
}

#pragma mark - AddFriendAlertDelegate
- (void)addFriendSure:(NSString *)uid{
    if(uid && uid.length > 0){
        if([uid isEqualToString:self.photosUserID]){
            [self showToast:@"不能关注自己哦"];
        }else{
            [self concernUserData:@{@"uid":uid}];
        }
        
    }else{
        [self showToast:@"请输入有图号"];
    }
}
- (void)useQRCodeScan{
    QRCodeScanCtr * qrCode = [[QRCodeScanCtr alloc] init];
    [self.navigationController pushViewController:qrCode animated:YES];
}

#pragma mark - UserInfoDrawerDelegate
- (void)userInfoDrawerHeadSelected:(NSInteger)type{
    
    if(type == 1){
        //        DynamicModel * model = [self.dataArray objectAtIndex:self.userInfoSelectIndex];
        AlbumPhotosModel * model = [self.dataArray objectAtIndex:self.userInfoSelectIndex];
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
    
    NSLog(@"--%@ -- %@",model.wechat,model.qq);
    
    if(type == 0){
        
        PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
        personalHome.uid = model.uid;
        personalHome.twoWay = YES;
        [self.navigationController pushViewController:personalHome animated:YES];
        
    }else if(type == 1){
    }else if(type == 2){
        
        NSString * chatStr = model.wechat;
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

- (void) getPhotoImages {
    [_imageArray removeAllObjects];
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:self.shareSelectIndex];
    
    for(NSDictionary * image in model.images){
        PhotoImagesModel * model = [[PhotoImagesModel alloc] init];
        model.Id = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"id" toTarget:image]];
        //                model.imageLink_id = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"imageLink_id" toTarget:images]];
        model.thumbnailUrl = [RequestErrorGrab getStringwitKey:@"thumbnailUrl" toTarget:image];
        model.bigImageUrl = [RequestErrorGrab getStringwitKey:@"bigImageUrl" toTarget:image];
        model.srcUrl = [RequestErrorGrab getStringwitKey:@"srcUrl" toTarget:image];
        model.isCover = [RequestErrorGrab getBooLwitKey:@"isCover" toTarget:image];
        if (model.isCover) {
            [_imageArray insertObject:model atIndex:0];
        }else{
            [_imageArray addObject:model];
        }
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    [self closeLoad];
    
    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
        [self showToast:@"下载失败"];
    } else {
        NSLog(@"saved");
        [self showToast:@"下载完成"];
    }
}

#pragma mark - DynamicViewCellDelegate
- (void)cellSelectType:(NSInteger)type tableViewCelelIndexPath:(NSIndexPath *)indexPath{
    
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    
    if(type == 1){
        self.userInfoSelectIndex = indexPath.row;
        NSString * uid = [model.user objectForKey:@"uid"];
        if(uid && uid.length > 0 && self.isMyDynamic == NO){
            [self loadUserNetworkData:@{@"uid":uid}];
        }
    }
    else if(type == 2){
        self.shareSelectIndex = indexPath.row;
        [self.appd showShareview:model.type collected:model.collected model:model from:self];
    }
    else if(type == 3){
        self.userInfoSelectIndex = indexPath.row;
        NSString * uid = [model.user objectForKey:@"uid"];
        if(uid && uid.length > 0 && self.isMyDynamic == NO){
            [self loadUserNetworkData:@{@"uid":uid}];
        }
    }
    else if (type == 4) { // collect
        if ([self.photosUserID isEqualToString:[model.user objectForKey:@"uid"]]) {
            [self showToast:@"不能收藏自己的相册"];
        }
        else {
            if (model.collected == YES) {
                // cancel collect
                if ([model.type isEqualToString:@"photo"]) [self cancelCollectPhotos:@{@"photosId[0]":model.Id}];
                if ([model.type isEqualToString:@"video"]) [self cancelCollectVideos:@{@"videosId[0]":model.Id}];
                
            }
            else {
                // add collect
                if ([model.type isEqualToString:@"photo"]) [self collectPhoto:@{@"photoId":model.Id}];
                if ([model.type isEqualToString:@"video"]) [self collectVideo:@{@"videoId":model.Id}];
            }
        }
    }
    else if (type == 5) { // chat
        NSLog(@"%ld", type);
        NSString * uid = [model.user objectForKey:@"uid"];
        if ([self.photosUserID isEqualToString:uid]) {
            [self showToast:@"不允许进入聊天"];
        }
        else {
            if(uid && uid.length > 0){
                ChattingViewController *conversationVC = [[ChattingViewController alloc]init];
                conversationVC.conversationType = ConversationType_PRIVATE;
                conversationVC.targetId = uid;
                conversationVC.name = [model.user objectForKey:@"name"];
                [self.navigationController pushViewController:conversationVC animated:YES];
            }
        }
    }
    else if (type == 6) { // pengyou qiu
        NSLog(@"%ld", type);
        self.shareSelectIndex  = indexPath.row;
        AlbumPhotosModel * model = [self.dataArray objectAtIndex:self.shareSelectIndex];
        [self getPhotoImages];
        if ([model.type isEqualToString:@"photo"]) {
            NSMutableArray * images = [NSMutableArray array];
            for(PhotoImagesModel * imageModel in _imageArray){
                DynamicImagesModel * model = [[DynamicImagesModel alloc] init];
                model.bigImageUrl = imageModel.bigImageUrl;
                model.thumbnailUrl = imageModel.thumbnailUrl;
                [images addObject:model];
            }
            
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = model.title;
            ShareContentSelectCtr * shareSelect = GETALONESTORYBOARDPAGE(@"ShareContentSelectCtr");
            shareSelect.dataArray = images;
            [self.navigationController pushViewController:shareSelect animated:YES];
            
        } else {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.photosUserID,model.Id];
            [shareParams SSDKSetupShareParamsByText:@""
                                             images:model.cover
                                                url:[NSURL URLWithString:text]
                                              title:@"有图分享"
                                               type:SSDKContentTypeAuto];
            [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
            }];
        }

    }
    else if (type == 7) { // delete
        if ([model.type isEqualToString:@"photo"]) [self deleteMyPhotos:@{@"photosId[0]":model.Id}];
        if ([model.type isEqualToString:@"video"]) [self deleteMyVideos:@{@"videosId[0]":model.Id}];
    }
}

- (void)cellImageSelected:(NSInteger)tag TabelViewCellIndexPath:(NSIndexPath *)indexPath{
    
    if (tag > -1) {
        AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
        NSInteger count = model.images.count;
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            NSDictionary * imageModel = [model.images objectAtIndex:i];
            NSString * url = [imageModel objectForKey:@"bigImageUrl"];
            UIImageView * imageView = [[UIImageView alloc] init];
            KSPhotoItem * item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
            [photos addObject:item];
        }
        
        if(photos.count > 0){
            KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:photos selectedIndex:tag];
            [browser showFromViewController:self];
        }
    }
    else {
        // click video
        SPVideoPlayer *videoView = [[SPVideoPlayer alloc] init];
        videoView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
        if (_isMyDynamic) {
            [self.view addSubview:videoView];
        } else {
            [self.tabBarController.view addSubview:videoView];
        }
        AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
        [videoView playVideo:model.video];
    }
}

- (void)dynamicTableCellSelected:(NSIndexPath *)indexPath{
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    NSString * uid = [model.user objectForKey:@"uid"];
    
    PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
    photoDetails.photoId = model.Id;
    if(uid && ![uid isEqualToString:self.photosUserID]){
        photoDetails.persona = YES;
    }
    
    [self.navigationController pushViewController:photoDetails animated:YES];
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData {
    self.pageIndex= 1;
    NSDictionary * data = @{@"uid":self.photosUserID,
                            @"page":[NSString stringWithFormat:@"%ld",self.pageIndex],
                            @"pageSize":@"20"};
    NSLog(@"%@",data);
    __weak __typeof(self)weakSelef = self;
    
    NSString *serverApi = @"";
    if (self.isMyDynamic) {
        serverApi = self.congfing.getUserDynamics;
    }
    else {
        serverApi = self.congfing.getNewDynamics;
    }
    
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        [weakSelef.table.table.mj_header endRefreshing];
        //        DynamicRequset * requset = [[DynamicRequset alloc] init];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.pageIndex ++;
            weakSelef.table.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkMoreData];
            }];
            
            if(requset.dataArray.count == 20){
                [weakSelef.table.table.mj_footer resetNoMoreData];
            }else{
                [weakSelef.table.table.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.table.table.mj_footer setHidden:YES];
            }
            [weakSelef.dataArray removeAllObjects];
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.table loadData:weakSelef.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef.table.table.mj_header endRefreshing];
    }];
}

- (void)loadNetworkMoreData{
    
    NSDictionary * data = @{@"uid":self.photosUserID,
                            @"page":[NSString stringWithFormat:@"%ld",self.pageIndex],
                            @"pageSize":@"20"};
    NSLog(@"%@",data);
    __weak __typeof(self)weakSelef = self;
    
    NSString *serverApi = @"";
    if (self.isMyDynamic) {
        serverApi = self.congfing.getUserDynamics;
    }
    else {
        serverApi = self.congfing.getNewDynamics;
    }
    
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        [weakSelef.table.table.mj_footer endRefreshing];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        
        //        DynamicRequset * requset = [[DynamicRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.pageIndex ++;
            if(requset.dataArray.count == 20){
                [weakSelef.table.table.mj_footer resetNoMoreData];
            }else{
                [weakSelef.table.table.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.table.table.mj_footer setHidden:YES];
            }
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.table loadMoreData:requset.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        [weakSelef.table.table.mj_footer endRefreshing];
    }];
}

#pragma makr - AFNetworking网络加载
- (void)loadUserNetworkData:(NSDictionary *)data{
    
    __weak __typeof(self)weakSelef = self;
    [self showLoad];
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getUserInfo,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        [self closeLoad];
        
        UserInfoModel * infoModel = [[UserInfoModel alloc] init];
        [infoModel analyticInterface:responseObject];
        if(infoModel.uid.length > 0){
            if (weakSelef.isMyDynamic == NO) {
                PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
                personalHome.uid = infoModel.uid;
                personalHome.twoWay = infoModel.concerned;
                personalHome.username = infoModel.name;
                [self.navigationController pushViewController:personalHome animated:YES];
            } else {
                
            }
            //[weakSelef.userInfo setStyle:infoModel];
            //[weakSelef.userInfo showDrawe];
        }else{
            [weakSelef closeLoad];
            [weakSelef showToast:infoModel.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)concernUserData:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.concernUser parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"关注成功"];
            PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
            personalHome.uid = [data objectForKey:@"uid"];
            personalHome.twoWay = YES;
            [self.navigationController pushViewController:personalHome animated:YES];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)collectPhoto:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.collectPhoto,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"收藏成功"];
            [weakSelef loadNetworkData];
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}
- (void)collectVideo:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.collectVideo,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"收藏成功"];
            [weakSelef loadNetworkData];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)cancelCollectPhotos:(NSDictionary * )data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",self.congfing.cancelCollectPhotos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [weakSelef showToast:@"取消收藏成功"];
            [weakSelef loadNetworkData];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)cancelCollectVideos:(NSDictionary * )data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",self.congfing.cancelCollectVideos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [weakSelef showToast:@"取消收藏成功"];
            [weakSelef loadNetworkData];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)deleteMyPhotos:(NSDictionary * )data{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除自己的动态时，同时会删除该相册，确认删除?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self deleteDynamic:data apiStr:self.congfing.deletePhotos];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)deleteDynamic:(NSDictionary * )data apiStr:(NSString *)apiStr {
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",apiStr,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [weakSelef showToast:@"删除成功"];
            [weakSelef loadNetworkData];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
    
}
- (void)deleteMyVideos:(NSDictionary * )data{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除自己的动态时，同时会删除该相册，确认删除?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self deleteDynamic:data apiStr:self.congfing.deleteVideos];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
