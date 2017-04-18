//
//  AlbumRecommendCtr.m
//  ShopPhotos
//
//  Created by addcn on 16/12/26.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AlbumRecommendCtr.h"
#import "AlbumPhotosRequset.h"
#import "AlbumPhotoTableView.h"
#import <MJRefresh.h>
#import "MoreAlert.h"
#import "AlbumPhotosMdel.h"
#import "PhotosEditView.h"
#import "PhotosOptionView.h"
#import "SearchAllCtr.h"
#import "PhotoDetailsCtr.h"
#import "PublishPhotosCtr.h"

#import "PhotoImagesRequset.h"
#import "DynamicImagesModel.h"
#import "ShareContentSelectCtr.h"
#import "DownloadImageCtr.h"
#import "CopyRequset.h"
#import "HasCollectPhotoRequset.h"
#import "DynamicQRAlert.h"
#import "ShareCtr.h"
#import <ShareSDK/ShareSDK.h>
#import "PhotoImagesModel.h"


@interface AlbumRecommendCtr ()<MoreAlertDelegate,PhotosEditViewDelegate,PhotosOptionViewDelegate,AlbumPhotoTableViewDelegate,ShareDelegate>
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (strong, nonatomic) AlbumPhotoTableView * table;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) MoreAlert * moreAlert;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) PhotosEditView * editHead;
@property (strong, nonatomic) PhotosOptionView * editOption;
@property (assign, nonatomic) NSInteger itmeSelectedIndex;
@property (strong, nonatomic) ShareCtr * shareView;
@property (strong, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) DynamicQRAlert * qrAlert;



@end

@implementation AlbumRecommendCtr

- (NSMutableArray *)imageArray{
    if(!_imageArray) _imageArray = [NSMutableArray array];
    return _imageArray;
}

- (NSMutableArray *)dataArray{
    
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.dataArray.count == 0){
        [self.table.photos.mj_header beginRefreshing];
    }else{
        [self loadNetworkData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self createAutoLayout];
}

- (void)setup {
    [self.back addTarget:self action:@selector(backSelected)];
    [self.edit addTarget:self action:@selector(editSelected)];
    [self.search addTarget:self action:@selector(searchSelected)];
}

- (void)createAutoLayout{

    self.table = [[AlbumPhotoTableView alloc] init];
    self.table.delegate = self;
    self.table.showPrice = YES;
    [self.view addSubview:self.table];
    
    __weak __typeof(self)weakSelef = self;
    self.table.photos.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadNetworkData];
    }];
    
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .bottomSpaceToView(self.view,0);
    
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
    
    self.editOption = [[PhotosOptionView alloc] init];
    [self.view addSubview:self.editOption];
    self.editOption.delegate = self;
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
    [self.table.photos setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)editSelected{
    for(AlbumPhotosMdel * model in self.dataArray){
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

#pragma mark - PhotosEditViewDelegate
- (void)photosEditSelected:(NSInteger)type{

    if(type == 1){
        // 取消
        for(AlbumPhotosMdel * model in self.dataArray){
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
        for(AlbumPhotosMdel * model in self.dataArray){
            if(model.selected && model.openEdit){
                count++;
            }
        }
        
        if(count == self.dataArray.count){
            // 清除
            for(AlbumPhotosMdel * model in self.dataArray){
                model.selected = NO;
            }
            [self.editHead setSelectedCount:0];
            self.editHead.allSelectStatus = NO;
        }else{
            // 全选
            for(AlbumPhotosMdel * model in self.dataArray){
                model.selected = YES;
            }
            [self.editHead setSelectedCount:self.dataArray.count];
            self.editHead.allSelectStatus = YES;
        }
        [self.table loadData:self.dataArray];
    }
}

#pragma mark - PhotosOptionViewDelegate
- (void)photosOptionSelected:(NSInteger)type{
    
    NSMutableArray * editArray = [NSMutableArray array];
    
    for(AlbumPhotosMdel * model in self.dataArray){
        if(model.selected){
            [editArray addObject:model];
        }
    }
    
    NSMutableString * cancelIDs = [NSMutableString string];
    for(NSInteger index = 0; index<editArray.count;index++){
        AlbumPhotosMdel * mdoel = [editArray objectAtIndex:index];
        if(index!=0){
            [cancelIDs appendFormat:@"*%@",mdoel.photosID];
        }else{
            [cancelIDs appendString:mdoel.photosID];
        }
    }
    
    if(editArray.count == 0){
        SPAlert(@"当前未选中哦！",self);
        return;
    }

    if(type == 1){
        NSDictionary * data = @{@"type":@"recommend",
                                @"value":@"false",
                                @"photoIds":cancelIDs};
        __weak __typeof(self)weakSelef = self;
        NSString * msg = [NSString stringWithFormat:@"确定取消推荐%ld项",editArray.count];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [weakSelef loadUpdatePhotos:data];
            [weakSelef photosEditSelected:1];
            weakSelef.editHead.allSelectStatus = NO;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
       // 删除
            NSDictionary * data = @{@"photo_ids":cancelIDs};
        
        __weak __typeof(self)weakSelef = self;
        NSString * msg = [NSString stringWithFormat:@"确定删除%ld项",editArray.count];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [weakSelef loadDeletePhotos:data];
            [weakSelef photosEditSelected:1];
            weakSelef.editHead.allSelectStatus = NO;
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - MoreAlertDelegate
- (void)moreAlertSelected:(NSInteger)indexPath{
    
    if(indexPath == 0){
    
        for(AlbumPhotosMdel * model in self.dataArray){
            model.openEdit = YES;
        }
        [self.table loadData:self.dataArray];
        [self.editHead setHidden:NO];
        [self.editOption setHidden:NO];
        self.table.sd_layout.bottomSpaceToView(self.view,64);
        [self.table updateLayout];
        
    }else if(indexPath == 1){
        NSLog(@"上传相册");
        PublishPhotosCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotosCtr");
        [self.navigationController pushViewController:pulish animated:YES];
    }
}

#pragma mark - AlbumPhotoTableViewDelegate
- (void)albumPhotoSelectPath:(NSInteger)indexPath{
    if(indexPath >= self.dataArray.count) return;
    AlbumPhotosMdel * model = [self.dataArray objectAtIndex:indexPath];
    PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
    photoDetails.photoId = model.photosID;
    [self.navigationController pushViewController:photoDetails animated:YES];
}

- (void)albumEditSelectPath:(NSInteger)indexPath{
    
    AlbumPhotosMdel * model = [self.dataArray objectAtIndex:indexPath];
    model.selected = !model.selected;
    [self.table loadData:self.dataArray];
    NSInteger count = 0;
    for(AlbumPhotosMdel * model in self.dataArray){
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

- (void)shareClicked:(NSIndexPath *)indexPath {
    self.itmeSelectedIndex = indexPath.row;
    [self showLoad];
    [self getPhotoImages];
    [self.shareView showAlert];
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    self.page = 1;
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.page],
                            @"pageSize":@"30",
                            @"keyWord":@"false",
                            @"subclassification_id":@"0"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getRecommendPhotos parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        [weakSelef.table.photos.mj_header endRefreshing];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.page++;
            weakSelef.table.photos.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkMoreData];
            }];
            if(requset.dataArray.count < 30){
                [weakSelef.table.photos.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelef.table.photos.mj_footer resetNoMoreData];
            }
            [weakSelef.dataArray removeAllObjects];
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.table loadData:weakSelef.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef.table.photos.mj_header endRefreshing];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)loadNetworkMoreData{
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.page],
                            @"pageSize":@"30",
                            @"keyWord":@"false",
                            @"subclassification_id":@"0"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getRecommendPhotos parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        
        [weakSelef.table.photos.mj_footer endRefreshing];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.page ++;
            if(requset.dataArray.count < 30){
                [weakSelef.table.photos.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelef.table.photos.mj_footer resetNoMoreData];
            }
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.table loadMoreData:requset.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.table.photos.mj_footer endRefreshing];
    }];
}


- (void)loadUpdatePhotos:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.batchPhotos parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"取消成功"];
            [weakSelef loadNetworkData];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
}

- (void)loadDeletePhotos:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.deletePhotos parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"删除成功"];
            [weakSelef loadNetworkData];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
}

#pragma mark - ShareDelegate
- (void)shareSelected:(NSInteger)type{
    
    AlbumPhotosMdel * model = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
    NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.uid,model.photosID];
    
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
            pasteboard.string = model.name;
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
            NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.uid,model.photosID];
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [self showToast:@"复制成功"];
        }
            
            break;
        case 6:// 复制标题
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = model.name;
            [self showToast:@"复制成功"];
        }
            break;
        case 7:// 查看二维码
        {
            self.qrAlert.titleText = model.name;
            self.qrAlert.contentText = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.uid,model.photosID];
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
            
            [self hasCollectPhoto:@{@"photoId":model.photosID}];
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
                AlbumPhotosMdel * albumModel = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
                
                pulish.is_copy = YES;
                pulish.photoTitleText = albumModel.name;
                pulish.photoTitleText = @"";
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

- (void)getPhotoImages{
    AlbumPhotosMdel * model = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
    
    NSDictionary * detailPhotodata = @{@"photoId":model.photosID};
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

@end
