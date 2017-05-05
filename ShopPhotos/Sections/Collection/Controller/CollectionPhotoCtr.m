//
//  CollectionPhotoCtr.m
//  ShopPhotos
//
//  Created by addcn on 16/12/28.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "CollectionPhotoCtr.h"
#import "CollectionTableView.h"
#import "AlbumPhotosRequset.h"
#import "PhotoImagesRequset.h"
#import "DynamicImagesModel.h"
#import "ShareContentSelectCtr.h"
#import "DownloadImageCtr.h"
#import "CopyRequset.h"
#import "HasCollectPhotoRequset.h"
#import "DynamicQRAlert.h"
#import <MJRefresh.h>
#import "PhotoDetailsCtr.h"
#import "AlbumPhotosModel.h"
#import "PhotosEditView.h"
#import "MoreAlert.h"
#import "SearchAllCtr.h"
#import "PublishPhotoCtr.h"
#import "PhotoImagesModel.h"
#import "PersonalHomeCtr.h"
#import "ShareCtr.h"
#import <ShareSDK/ShareSDK.h>
#import "SPVideoPlayer.h"

@interface CollectionPhotoCtr ()<MoreAlertDelegate,PhotosEditViewDelegate,CollectionTableViewDelegate,ShareDelegate>

@property (weak, nonatomic) IBOutlet UIButton *back;
//@property (weak, nonatomic) IBOutlet UIView *more;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (strong, nonatomic) CollectionTableView * table;
@property (strong, nonatomic) MoreAlert * moreAlert;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) NSMutableArray * photoArray;
@property (strong, nonatomic) NSMutableArray * videoArray;
@property (strong, nonatomic) PhotosEditView * editHead;
@property (strong, nonatomic) UIButton * editOption;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger itmeSelectedIndex;
@property (strong, nonatomic) ShareCtr * shareView;
@property (strong, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) DynamicQRAlert * qrAlert;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;
@property (weak, nonatomic) IBOutlet UIView *movieView;

@end

@implementation CollectionPhotoCtr

- (NSMutableArray *)imageArray{
    if(!_imageArray) _imageArray = [NSMutableArray array];
    return _imageArray;
}

- (NSMutableArray *)dataArray{
    if(!_dataArray)_dataArray = [NSMutableArray array];
    return _dataArray;
}

- (NSMutableArray *)videoArray{
    if(!_videoArray)_videoArray = [NSMutableArray array];
    return _videoArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self createAutoLayout];
}

- (void)setup{
    
    [self.back setTitle:self.str_from forState:UIControlStateNormal];

    [self.back addTarget:self action:@selector(backSelected)];
    [self.edit addTarget:self action:@selector(editSelected)];
    [self.search addTarget:self action:@selector(searchSelected)];
    [self.movieView addTarget:self action:@selector(videoSelected)];
}

- (void)createAutoLayout{
    
    if (self.isVideo) {
        [self.movieView setHidden:YES];
    }
    
    self.table = [[CollectionTableView alloc] init];
    self.table.delegate = self;
    self.table.isVideo = self.isVideo;
    [self.view addSubview:self.table];
    
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64+55)
    .bottomEqualToView(self.view);
    
    __weak __typeof(self)weakSelef = self;
    self.table.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadNetworkData];
    }];
    [self.table.table.mj_header beginRefreshing];
    
    self.moreAlert = [[MoreAlert alloc] init];
    self.moreAlert.mode = PhotosModel;
    self.moreAlert.delegate = self;
    [self.view addSubview:self.moreAlert];
    [self.moreAlert setHidden:YES];
    self.moreAlert.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    self.editHead = [[PhotosEditView alloc] init];
    self.editHead.delegate = self;
    [self.view addSubview:self.editHead];
    [self.editHead setHidden:YES];
    self.editHead.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(64);
    
    self.editOption = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.editOption setTitle:@"取消收藏" forState:UIControlStateNormal];
    [self.editOption setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.editOption setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.editOption];
    [self.editOption addTarget:self action:@selector(photosOptionSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.editOption setHidden:YES];
    self.editOption.sd_layout
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(64);
    
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

#pragma mark - OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topViewSelected{
    [self.table.table setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)editSelected{
    
    for(AlbumPhotosModel * model in self.dataArray){
        model.openEdit = YES;
    }
    [self.table loadData:self.dataArray];
    [self.editHead setHidden:NO];
    [self.editOption setHidden:NO];
    self.table.sd_layout.bottomSpaceToView(self.view,64);
    [self.table updateLayout];
//    [self.moreAlert showAlert];
}

- (void)searchSelected{
    
    SearchAllCtr * search = GETALONESTORYBOARDPAGE(@"SearchAllCtr");
    [self.navigationController pushViewController:search animated:YES];
}

- (void)photosOptionSelected{
    
    NSMutableArray * editArray = [NSMutableArray array];
    for(AlbumPhotosModel * model in self.dataArray){
        if(model.selected){
            [editArray addObject:model];
        }
    }
    NSMutableString * cancelIDs = [NSMutableString string];
    for(NSInteger index = 0; index<editArray.count;index++){
        AlbumPhotosModel * mdoel = [editArray objectAtIndex:index];
        if(index==0){
            [cancelIDs appendString:mdoel.Id];
        }else{
            [cancelIDs appendFormat:@"*%@",mdoel.Id];
        }
    }
    
    if(editArray.count == 0){
        SPAlert(@"当前未选中哦！",self);
        return;
    }
    // 删除
    NSDictionary * data = @{@"photosId":cancelIDs};
    __weak __typeof(self)weakSelef = self;
    NSString * msg = [NSString stringWithFormat:@"确定取消收藏%ld项",editArray.count];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [weakSelef loadDeletePhotos:data];
        [weakSelef photosEditSelected:1];
        weakSelef.editHead.allSelectStatus = NO;
        [weakSelef.editHead setSelectedCount:0];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        AlbumPhotosModel * model = [weakSelef.dataArray objectAtIndex:weakSelef.itmeSelectedIndex];
        model.selected = NO;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) videoSelected {
    
    CollectionPhotoCtr * videoCollectCtrl = GETALONESTORYBOARDPAGE(@"CollectionPhotoCtr");
    videoCollectCtrl.uid = self.uid;
    videoCollectCtrl.str_from = @"返回";
    videoCollectCtrl.isVideo = YES;
    [self.navigationController pushViewController:videoCollectCtrl animated:YES];
    
}

#pragma mark - PhotosEditViewDelegate
- (void)photosEditSelected:(NSInteger)type{
    
    if(type == 1){
        // 取消
        for(AlbumPhotosModel * model in self.dataArray){
            model.openEdit = NO;
        }
        [self.table loadData:self.dataArray];
        [self.editHead setHidden:YES];
        [self.editOption setHidden:YES];
        self.table.sd_layout.bottomSpaceToView(self.view,0);
        [self.table updateLayout];
    }else{
        // 全选/清除
        NSInteger count = 0;
        for(AlbumPhotosModel * model in self.dataArray){
            if(model.selected && model.openEdit){
                count++;
            }
        }
        if(count == self.dataArray.count){
            // 清除
            for(AlbumPhotosModel * model in self.dataArray){
                model.selected = NO;
            }
            [self.editHead setSelectedCount:0];
            self.editHead.allSelectStatus = NO;
        }else{
            // 全选
            for(AlbumPhotosModel * model in self.dataArray){
                model.selected = YES;
            }
            [self.editHead setSelectedCount:self.dataArray.count];
            self.editHead.allSelectStatus = YES;
        }
        [self.table loadData:self.dataArray];
    }
}

#pragma mark - MoreAlertDelegate
- (void) moreAlertSelected:(NSInteger)indexPath {
    if(indexPath == 0){
        // 编辑
        for(AlbumPhotosModel * model in self.dataArray){
            model.openEdit = YES;
        }
        [self.table loadData:self.dataArray];
        [self.editHead setHidden:NO];
        [self.editOption setHidden:NO];
        self.table.sd_layout.bottomSpaceToView(self.view,64);
        [self.table updateLayout];
        
    }else if(indexPath == 1){
        NSLog(@"上传相册");
        PublishPhotoCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
        [self.navigationController pushViewController:pulish animated:YES];
    }
}

#pragma mark - CollectionTableViewDelegate
- (void)editSelected:(NSIndexPath *)indexPath{

    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    model.selected = !model.selected;
    [self.table loadData:self.dataArray];
    NSInteger count = 0;
    for(AlbumPhotosModel * model in self.dataArray){
        if(model.openEdit && model.selected){
            count++;
        }
    }
    [self.editHead setSelectedCount:count];
    if(count == self.dataArray.count){
        self.editHead.allSelectStatus = YES;
    }else{
        self.editHead.allSelectStatus = NO;
    }
}

- (void)collectionSelected:(NSIndexPath *)indexPath{
    self.itmeSelectedIndex = indexPath.row;
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    model.selected = YES;
    [self photosOptionSelected];
    
}
- (void)tableDidSelected:(NSIndexPath *)indexPath{
    
    if (self.isVideo) {
        SPVideoPlayer *videoView = [[SPVideoPlayer alloc] init];
        videoView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
        [self.view addSubview:videoView];
        
        AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
        [videoView playVideo:model.video];
        
    }
    else{
        AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
        PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
        photoDetails.photoId = model.Id;
        [self.navigationController pushViewController:photoDetails animated:YES];
    }
}

- (void)collectionUserSelecte:(NSIndexPath *)indexPath{
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    PersonalHomeCtr * home = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
    home.uid = [model.user objectForKey:@"uid"];
    home.twoWay = YES;
    [self.navigationController pushViewController:home animated:YES];
    
}

- (void)shareClicked:(NSIndexPath *)indexPath {
    self.itmeSelectedIndex = indexPath.row;
    [self showLoad];
    [self getPhotoImages];
    [self.shareView showAlert];
}

- (void) getPhotoImages {
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:self.itmeSelectedIndex];

    NSDictionary * detailPhotodata = @{@"photoId":model.Id};
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getPhotoImages parametric:detailPhotodata succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"获取相册图片 -- >%@",responseObject);
        PhotoImagesRequset * requset = [[PhotoImagesRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [weakSelef.imageArray removeAllObjects];
            [weakSelef.imageArray addObjectsFromArray:requset.dataArray];
        }
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        //[weakSelef closeLoad];
    }];
}

- (void)getAllowPurview:(NSDictionary *)data{
    
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.isPassiveUserAllow parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        CopyRequset * model = [[CopyRequset alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            
            if(model.allow){
                PublishPhotoCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
                AlbumPhotosModel * albumModel = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
/*
                pulish.is_copy = YES;
                pulish.photoTitleText = albumModel.title;
                pulish.photoTitleText = @"";
                pulish.imageCopy = [[NSMutableArray alloc] initWithArray:self.imageArray];*/
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

#pragma mark - ShareDelegate
- (void)shareSelected:(NSInteger)type{
    
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
    NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.uid,model.Id];
    
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
            pasteboard.string = model.title;
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
            NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.uid,model.Id];
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
            self.qrAlert.contentText = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.uid,model.title];
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
            
            [self hasCollectPhoto:@{@"photoId":model.Id}];
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

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":@"1",
                            @"pageSize":@"30",
                            @"keyWord":@"false"};
    self.pageIndex = 1;
    __weak __typeof(self)weakSelef = self;
    
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getCollectVideos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        [weakSelef.table.table.mj_header endRefreshing];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.pageIndex ++;
            weakSelef.table.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkMoreData];
            }];
            [weakSelef.videoArray removeAllObjects];
            [weakSelef.videoArray addObjectsFromArray:requset.dataArray];
            if (weakSelef.isVideo == YES) {
                [weakSelef.dataArray removeAllObjects];
                [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
                [weakSelef.table loadData:weakSelef.dataArray];
            }
            else {
                [weakSelef.collectLabel setText:[NSString stringWithFormat:@"我的收藏视频(%ld)",weakSelef.videoArray.count]];
            }
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef.table.table.mj_header endRefreshing];
        [weakSelef showToast:NETWORKTIPS];
    }];
    
    
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getCollectPhotos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        [weakSelef.table.table.mj_header endRefreshing];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.pageIndex ++;
            weakSelef.table.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkMoreData];
            }];
            if(requset.dataArray.count < 30){
                [weakSelef.table.table.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelef.table.table.mj_footer resetNoMoreData];
            }
            [weakSelef.photoArray removeAllObjects];
            [weakSelef.photoArray addObjectsFromArray:requset.dataArray];
            if (weakSelef.isVideo == NO) {
                [weakSelef.dataArray removeAllObjects];
                [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
                [weakSelef.table loadData:weakSelef.dataArray];
            }
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef.table.table.mj_header endRefreshing];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)loadNetworkMoreData{
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.pageIndex],
                            @"pageSize":@"30",
                            @"keyWord":@"false"};
    
    __weak __typeof(self)weakSelef = self;
    
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getCollectVideos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        [weakSelef.table.table.mj_header endRefreshing];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.pageIndex ++;
            weakSelef.table.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkMoreData];
            }];
            [weakSelef.videoArray removeAllObjects];
            [weakSelef.videoArray addObjectsFromArray:requset.dataArray];
            [weakSelef.collectLabel setText:[NSString stringWithFormat:@"我的收藏视频(%ld)",weakSelef.videoArray.count]];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef.table.table.mj_header endRefreshing];
        [weakSelef showToast:NETWORKTIPS];
    }];
    
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getCollectPhotos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){

        [weakSelef.table.table.mj_footer endRefreshing];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.pageIndex ++;
            if(requset.dataArray.count < 30){
                [weakSelef.table.table.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelef.table.table.mj_footer resetNoMoreData];
            }
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.table loadMoreData:requset.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.table.table.mj_footer endRefreshing];
    }];
}

- (void)loadDeletePhotos:(NSDictionary *)data{
    NSLog(@"%@",data);
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.cancelCollectPhotos parametric:data succed:^(id responseObject) {
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"取消收藏成功"];
            [weakSelef loadNetworkData];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
}

// click movie view

@end
