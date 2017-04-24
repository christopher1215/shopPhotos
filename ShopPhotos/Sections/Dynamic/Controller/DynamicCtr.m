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
#import "DynamicRequset.h"
#import "UserInfoModel.h"
#import <MJPhotoBrowser.h>
#import "DynamicImagesModel.h"
#import "ShareCtr.h"
#import "SearchAllCtr.h"
#import "DynamicTableView.h"
#import "MoreAlert.h"
#import "AddFriendAlert.h"
#import "QRCodeScanCtr.h"
#import "PersonalHomeCtr.h"
#import "PhotoDetailsCtr.h"
#import <ShareSDK/ShareSDK.h>
#import "PublishPhotosCtr.h"
#import "DynamicImagesModel.h"
#import "SharedItem.h"
#import "ShareContentSelectCtr.h"
#import "DynamicQRAlert.h"
#import "HasCollectPhotoRequset.h"
#import "DownloadImageCtr.h"
#import "CopyRequset.h"

@interface DynamicCtr ()<DynamicTableViewDelegate,MoreAlertDelegate,AddFriendAlertDelegate,UserInfoDrawerDelegate,ShareDelegate>

@property (weak, nonatomic) IBOutlet UIButton *more;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (strong, nonatomic) UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *scan;
@property (weak, nonatomic) IBOutlet UIView *head;

@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) UserInfoDrawerCtr * userInfo;
@property (strong, nonatomic) ShareCtr * share;
@property (strong, nonatomic) DynamicTableView * table;
@property (strong, nonatomic) MoreAlert * moreAlert;
@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) AddFriendAlert * addAlert;
@property (assign, nonatomic) NSInteger userInfoSelectIndex;
@property (assign, nonatomic) NSInteger shareSelectIndex;
@property (strong, nonatomic) DynamicQRAlert * qrAlert;

@end

@implementation DynamicCtr

- (NSMutableArray *)dataArray{
    if(!_dataArray)_dataArray = [NSMutableArray array];
    return _dataArray;
}

- (id)init {
    self = [super init];
    
    self.isBackButton = FALSE;
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
    
    if (self.isBackButton == TRUE) {
        [_scan removeFromSuperview];
        _back = [[UIButton alloc] init];
        [_back setImage:[UIImage imageNamed:@"btn_back_black"] forState:UIControlStateNormal];
        [_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_back setTitle:@"首页" forState:UIControlStateNormal];
        [_back.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];

        [_head addSubview:_back];
        _back.sd_layout
        .leftSpaceToView(_head,15)
        .bottomSpaceToView(_head,10)
        .widthIs(80)
        .heightIs(20);
        
        [_back addTarget:self action:@selector(backSelected)];
    }
    
    [self.search addTarget:self action:@selector(searchSelected)];
    [self.scan addTarget:self action:@selector(qrScanSelected)];
    [self.more addTarget:self action:@selector(moreSelected)];
    
    self.table = [[DynamicTableView alloc] init];
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .bottomSpaceToView(self.view,49);
    
    self.userInfo = GETALONESTORYBOARDPAGE(@"UserInfoDrawerCtr");
    self.userInfo.delegate = self;
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self.userInfo.view];
    [self.userInfo closeDrawe];
    [self.userInfo.view setHidden:YES];
    
    
    
    self.share = GETALONESTORYBOARDPAGE(@"ShareCtr");
    self.share.delegate = self;
    [appDelegate.window addSubview:self.share.view];
    [self.share.view setHidden:YES];
    [self.share closeAlert];
    
    __weak __typeof(self)weakSelef = self;
    self.table.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelef loadNetworkData];
    }];
    [self.table.table.mj_header beginRefreshing];
    
    self.moreAlert = [[MoreAlert alloc] init];
    [self.view addSubview:self.moreAlert];
    self.moreAlert.mode = OptionModel;
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
    
    self.qrAlert = [[DynamicQRAlert alloc] init];
    [appDelegate.window addSubview:self.qrAlert];
    self.qrAlert.sd_layout
    .leftEqualToView(appDelegate.window)
    .rightEqualToView(appDelegate.window)
    .topEqualToView(appDelegate.window)
    .bottomEqualToView(appDelegate.window);
    [self.qrAlert setHidden:YES];
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
    [self moreAlertSelected:1];
}

- (void)moreSelected{
    [self.moreAlert showAlert];
}

#pragma mark - MoreAlertDelegate
- (void)moreAlertSelected:(NSInteger)indexPath{
    
    if(indexPath == 0){
        PublishPhotosCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotosCtr");
        [self.navigationController pushViewController:pulish animated:YES];
    }else if(indexPath == 1){
        QRCodeScanCtr * qrCode = [[QRCodeScanCtr alloc] init];
        [self.navigationController pushViewController:qrCode animated:YES];
    }else if(indexPath == 2){
        if(!self.addAlert){
            self.addAlert = [[AddFriendAlert alloc] init];
            AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.window addSubview:self.addAlert];
            self.addAlert.delegate = self;
            self.addAlert.sd_layout
            .leftEqualToView(appDelegate.window)
            .rightEqualToView(appDelegate.window)
            .topEqualToView(appDelegate.window)
            .bottomEqualToView(appDelegate.window);
        }
        [self.addAlert showAlert];
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
        DynamicModel * model = [self.dataArray objectAtIndex:self.userInfoSelectIndex];
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

    NSLog(@"--%@ -- %@",model.weixin,model.qq);
    
    if(type == 0){
        
        PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
        personalHome.uid = model.uid;
        personalHome.twoWay = YES;
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

//860088881@qq.com
//Cai520235
// 1811353565   caishunlong520
#pragma mark - ShareDelegate
- (void)shareSelected:(NSInteger)type{
    
    DynamicModel * model = [self.dataArray objectAtIndex:self.shareSelectIndex];
    NSMutableArray * urlImages = [NSMutableArray array];
    for(DynamicImagesModel * subModel in model.images){
        [urlImages addObject:subModel.bigImageUrl];
    }
    
    NSLog(@"%@",model.user);
    
    
    NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,[model.user objectForKey:@"uid"],model.photosID];
    
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
            pasteboard.string = text;
            [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
            }];
        }
            
            break;
        case 4:// 复制相册
        {
            
            NSString * uid = [model.user objectForKey:@"uid"];
            if(uid && uid.length > 0){
                if([self.photosUserID isEqualToString:uid]){
                    [self showToast:@"不能复制自己的相册"];
                    break;
                }
                
                [self getAllowPurview:@{@"uid":[model.user objectForKey:@"uid"]}];
            }
        }
            break;
        case 5:// 复制链接
        {
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
            NSString * uid = [model.user objectForKey:@"uid"];
            if(uid && uid.length > 0){
                if([self.photosUserID isEqualToString:uid]){
                    [self showToast:@"不能收藏自己的相册"];
                    break;
                }
            }
            
            [self hasCollectPhoto:@{@"photoId":[NSString stringWithFormat:@"%@",model.photosID]}];
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


#pragma mark - DynamicViewCellDelegate
- (void)cellSelectType:(NSInteger)type tableViewCelelIndexPath:(NSIndexPath *)indexPath{
    
    DynamicModel * model = [self.dataArray objectAtIndex:indexPath.row];
    
    if(type == 1){
        self.userInfoSelectIndex = indexPath.row;
        NSString * uid = [model.user objectForKey:@"uid"];
        if(uid && uid.length > 0){
            [self loadUserNetworkData:@{@"uid":uid}];
        }
    }else if(type == 2){
        self.shareSelectIndex = indexPath.row;
        [self.share showAlert];
    }else if(type == 3){
        self.userInfoSelectIndex = indexPath.row;
        NSString * uid = [model.user objectForKey:@"uid"];
        if(uid && uid.length > 0){
            [self loadUserNetworkData:@{@"uid":uid}];
        }
    }
}

- (void)cellImageSelected:(NSInteger)tag TabelViewCellIndexPath:(NSIndexPath *)indexPath{
    
    
    DynamicModel * model = [self.dataArray objectAtIndex:indexPath.row];
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
    DynamicModel * model = [self.dataArray objectAtIndex:indexPath.row];
    NSString * uid = [model.user objectForKey:@"uid"];
    
    PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
    photoDetails.photoId = model.photosID;
    if(uid && ![uid isEqualToString:self.photosUserID]){
        photoDetails.persona = YES;
    }
        
    [self.navigationController pushViewController:photoDetails animated:YES];
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    self.pageIndex= 1;
    NSDictionary * data = @{@"uid":self.photosUserID,
                            @"page":[NSString stringWithFormat:@"%ld",self.pageIndex],
                            @"pageSize":@"20",
                            @"getAll":@"true"};
    NSLog(@"%@",data);
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getNewDynamics parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        [weakSelef.table.table.mj_header endRefreshing];
        DynamicRequset * requset = [[DynamicRequset alloc] init];
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
            }
            [weakSelef.dataArray removeAllObjects];
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.table loadData:weakSelef.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.table.table.mj_header endRefreshing];
    }];
}

- (void)loadNetworkMoreData{
    
    NSDictionary * data = @{@"uid":self.photosUserID,
                            @"page":[NSString stringWithFormat:@"%ld",self.pageIndex],
                            @"pageSize":@"20",
                            @"getAll":@"true"};
    NSLog(@"%@",data);
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getNewDynamics parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        [weakSelef.table.table.mj_footer endRefreshing];
        
        DynamicRequset * requset = [[DynamicRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.pageIndex ++;
            if(requset.dataArray.count == 20){
                [weakSelef.table.table.mj_footer resetNoMoreData];
            }else{
                [weakSelef.table.table.mj_footer endRefreshingWithNoMoreData];
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
        [weakSelef showToast:NETWORKTIPS];
    }];
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
                DynamicModel * model = [weakSelef.dataArray objectAtIndex:self.shareSelectIndex];
                PublishPhotosCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotosCtr");
                pulish.is_copy = YES;
                pulish.photoTitleText = model.title;
                pulish.imageCopy = [[NSMutableArray alloc] initWithArray:model.images];
                
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
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已经收藏该相册，是否取消收藏" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                    
                    [weakSelef cancelCollectPhotos:@{@"photosId":[NSString stringWithFormat:@"%@,",[data objectForKey:@"photoId"]]}];
                    
                }]];
                [weakSelef presentViewController:alert animated:YES completion:nil];
            }else{                
                [weakSelef collectPhotoData:@{@"photosId":[NSString stringWithFormat:@"%@,",[data objectForKey:@"photoId"]]}];
            }
            
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)collectPhotoData:(NSDictionary *)data{
    
    NSLog(@"%@",data);
    NSLog(@"%@",self.congfing.collectPhotos);
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.collssssCopy parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
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

- (void)cancelCollectPhotos:(NSDictionary * )data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.cancelCollectPhotos parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [weakSelef showToast:@"取消收藏成功"];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

@end
