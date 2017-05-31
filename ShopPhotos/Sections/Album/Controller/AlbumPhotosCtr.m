//
//  AlbumPhotosCtr.m
//  ShopPhotos
//
//  Created by addcn on 16/12/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AlbumPhotosCtr.h"
#import "AlbumPhotoTableView.h"
#import "AlbumPhotosRequset.h"
#import <MJRefresh.h>
#import "PhotoDetailsCtr.h"
#import "AlbumPhotosModel.h"
#import "PhotosEditView.h"
#import "MoreAlert.h"
#import "SearchAllCtr.h"
#import "PublishPhotoCtr.h"
#import "SPVideoPlayer.h"
#import "PhotoImagesRequset.h"
#import "DynamicImagesModel.h"
#import "ShareContentSelectCtr.h"
#import "DownloadImageCtr.h"
#import "CopyRequset.h"
#import "HasCollectPhotoRequset.h"
#import "DynamicQRAlert.h"
#import <ShareSDK/ShareSDK.h>
#import "PhotoImagesModel.h"
#import "ChangeClassAlert.h"

@interface AlbumPhotosCtr ()<MoreAlertDelegate,PhotosEditViewDelegate,AlbumPhotoTableViewDelegate,ChangeClassAlertDelegate>

@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;

@property (strong, nonatomic) AlbumPhotoTableView * table;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) MoreAlert * moreAlert;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) PhotosEditView * editHead;
@property (strong, nonatomic) UIButton * editOption;

@property (assign, nonatomic) NSInteger itmeSelectedIndex;
@property (strong, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) DynamicQRAlert * qrAlert;
@property (strong, nonatomic) ChangeClassAlert * changeAlert;

@end

@implementation AlbumPhotosCtr

- (NSMutableArray *)imageArray {
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
    if(self.dataArray.count > 0){
        [self loadNetworkData];
    }else{
        [self.table.photos.mj_header beginRefreshing]; 
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self createAutoLayout];
}

- (void)setup{
    
    [self dataArray];
    [self imageArray];
    [self.back addTarget:self action:@selector(backSelected)];
    if ([self.type isEqualToString:@"video"]) {
        [self.edit setImage:[UIImage imageNamed:@"ico_delete2"] forState:UIControlStateNormal];
        [self.edit setContentMode:UIViewContentModeScaleAspectFit];
        [self.edit addTarget:self action:@selector(editSelected)];
    } else {
        [self.edit addTarget:self action:@selector(addSelected)];
    }
    
    [self.search addTarget:self action:@selector(searchSelected)];
}

- (void)createAutoLayout{
    
    self.page = 1;

    self.table = [[AlbumPhotoTableView alloc] init];
    
    if([self.type isEqualToString:@"photo"]){
        self.table.isVideo = NO;
    }
    else if([self.type isEqualToString:@"video"]){
        self.table.isVideo = YES;
    }
    
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .bottomEqualToView(self.view);
    
    [self.pageTitle setText:_ptitle];
    if ([_pageTitle.text isEqualToString:@"所有相册"] == NO) {
        [_back setTitle:@" 返回" forState:UIControlStateNormal];
    }
    
    __weak __typeof(self)weakSelef = self;
    self.table.photos.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadNetworkData];
    }];
    
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
    [self.editOption setTitle:@"删除" forState:UIControlStateNormal];
    [self.editOption setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.editOption setBackgroundColor:[UIColor whiteColor]];
    [self.editOption setBorderColor:[UIColor lightGrayColor]];
    [self.editOption setBorderWidth:1.0f];
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
    
    self.changeAlert = [[ChangeClassAlert alloc] init];
    self.changeAlert.delegate = self;
    [self.view addSubview:self.changeAlert];
    [self.changeAlert setHidden:YES];
    self.changeAlert.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);

}

#pragma mark - OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topViewSelected{
    [self.table.photos setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)addSelected{
    
    [self.moreAlert showAlert];
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
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    for(NSInteger index = 0; index<editArray.count;index++){
        AlbumPhotosModel * model = [editArray objectAtIndex:index];
        [data setValue:model.Id forKey:[NSString stringWithFormat:@"photosId[%ld]",(long)index]];
    }
    
    if(editArray.count == 0){
        SPAlert(@"当前未选中哦！",self);
        return;
    }
    // 删除
    
    __weak __typeof(self)weakSelef = self;
    NSString * msg = [NSString stringWithFormat:@"确定删除%ld项",(unsigned long)editArray.count];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [weakSelef loadDeletePhotos:data];
        [weakSelef photosEditSelected:1];
        weakSelef.editHead.allSelectStatus = NO;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - PhotosEditViewDelegate
- (void)photosEditSelected:(NSInteger)type{
    
    if(type == 1){
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
- (void)editSelected{
    [self moreAlertSelected:0];
}
#pragma mark - MoreAlertDelegate
- (void)moreAlertSelected:(NSInteger)indexPath{
    
    if(indexPath == 0){
        
        for(AlbumPhotosModel * model in self.dataArray){
            model.openEdit = YES;
        }
        [self.table loadData:self.dataArray];
        [self.editHead setHidden:NO];
        [self.editOption setHidden:NO];
        self.table.sd_layout.bottomSpaceToView(self.view,64);
        [self.table updateLayout];
        
    }else if(indexPath == 1){
        PublishPhotoCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
        [self.navigationController pushViewController:pulish animated:YES];
    }
}

#pragma mark - AlbumPhotoTableViewDelegate
- (void)albumPhotoSelectPath:(NSInteger)indexPath{
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath];
    if ([model.type isEqualToString:@"photo"]) {
        PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
        photoDetails.photoId = model.Id;
        [self.navigationController pushViewController:photoDetails animated:YES];
    }
    else {
        SPVideoPlayer *videoView = [[SPVideoPlayer alloc] init];
        videoView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
        [self.view addSubview:videoView];
        [videoView playVideo:model.video];
    }
    
}

- (void)albumEditSelectPath:(NSInteger)indexPath{
    
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath];
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

- (void)shareClicked:(NSIndexPath *)indexPath {
    self.itmeSelectedIndex = indexPath.row;
    [self getPhotoImages];
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    [self.appd showShareview:model.type collected:NO model:model from:self];
}

- (void)editClicked:(NSIndexPath *)indexPath {
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    _changeAlert.addClass = NO;
    _changeAlert.isVideoUpdate = YES;
    _changeAlert.index = indexPath.row;
    _changeAlert.dName = model.title;
    [_changeAlert showAlert];
    
}
- (void)editClassName:(NSString *)name indexClass:(NSInteger)index{
    if(!name || name.length == 0){
        SPAlert(@"请输入视频名",self);
        return;
    }
    if ([name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 0) {
        [self showToast:@"视频不允许为空格"];
        return;
    }
    
    [self changeClassName:index className:name];
    
}
- (void)changeClassName:(NSInteger)index className:(NSString *)name {
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:index];
    [self showLoad];
    NSDictionary *data = @{@"videoId":model.Id, @"title":name};
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    
    __weak __typeof(self)weakSelef = self;
    
    [HTTPRequest requestPUTUrl :[NSString stringWithFormat:@"%@%@",config.updateVideo,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            AlbumPhotosModel * tmpModel = [self.dataArray objectAtIndex:index];
            tmpModel.title = name;
            [weakSelef.table loadData:weakSelef.dataArray];

        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}
- (void)pyqClicked:(NSIndexPath *)indexPath {
    self.itmeSelectedIndex = indexPath.row;
    //    [self showLoad];
    [self getPhotoImages];
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
    if ([self.type isEqualToString:@"video"]) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.photosUserID,model.Id];
        [shareParams SSDKSetupShareParamsByText:@""
                                         images:model.cover
                                            url:[NSURL URLWithString:text]
                                          title:@"有图分享"
                                           type:SSDKContentTypeAuto];
        [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
        }];

    } else {
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
        
    }
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    self.page = 1;
    NSDictionary * data = @{@"uid":self.photosUserID,
                            @"page":[NSString stringWithFormat:@"%ld",self.page],
                            @"pageSize":@"30",
                            @"keyWord":@"false"};
//                            @"subclassification_id":@"0"};
    __weak __typeof(self)weakSelef = self;
    
    NSString *serverApi = @"";
    if ([self.type isEqualToString:@"photo"]) {
        if (_subClassid > -1) {
            serverApi = self.congfing.getSubclassPhotos;
            data = @{@"subclassId":[NSString stringWithFormat:@"%ld",(long)_subClassid],
                     @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                     @"pageSize":@"30"};
        }
        else {
            serverApi = self.congfing.getUserPhotos;
        }
    }
    else if ([self.type isEqualToString:@"video"]){
        serverApi = self.congfing.getUserVideos;
    }
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"1  %@",responseObject);

        [weakSelef.table.photos.mj_header endRefreshing];
       
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
             weakSelef.page ++;
            weakSelef.table.photos.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkMoreData];
            }];
            if(requset.dataArray.count < 30){
                [weakSelef.table.photos.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.table.photos.mj_footer setHidden:YES];
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
        
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];

    }];
}

- (void)loadNetworkMoreData{
    
    NSDictionary * data = @{@"uid":self.photosUserID,
                            @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                            @"pageSize":@"30",
                            @"keyWord":@"false",
                            @"subclassification_id":@"0"};
    
    __weak __typeof(self)weakSelef = self;
    NSString *serverApi = @"";
    if ([self.type isEqualToString:@"photo"]) {
        serverApi = self.congfing.getUserPhotos;
    }
    else if ([self.type isEqualToString:@"video"]){
        serverApi = self.congfing.getUserVideos;
    }
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        
        [weakSelef.table.photos.mj_footer endRefreshing];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.page ++;
            if(requset.dataArray.count < 30){
                [weakSelef.table.photos.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.table.photos.mj_footer setHidden:YES];
            }else{
                 [weakSelef.table.photos.mj_footer resetNoMoreData];
            }
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.table loadMoreData:requset.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef.table.photos.mj_footer endRefreshing];
    }];
}

- (void)loadDeletePhotos:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",self.congfing.deletePhotos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){

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
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef closeLoad];
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
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)getCopyAccept:(NSDictionary *)data{
    
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.isPassiveUserAllow,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"1  %@",responseObject);
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        CopyRequset * model = [[CopyRequset alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            if(model.allow){
                PublishPhotoCtr * publish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
//                AlbumPhotosModel * albumModel = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
                /*
                publish.is_copy = YES;
                publish.photoTitleText = albumModel.title;
                publish.photoTitleText = @"";
                publish.imageCopy = [[NSMutableArray alloc] initWithArray:self.imageArray];
                 */
                [weakSelef.navigationController pushViewController:publish animated:YES];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"对方设置了限制复制，是否发送请求复制" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [weakSelef sendCopyRequest:data];
                    
                }]];
                
                [weakSelef presentViewController:alert animated:YES completion:nil];
            }
            
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void) getPhotoImages {
    [_imageArray removeAllObjects];
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
    
    for(NSDictionary * image in model.images){
        PhotoImagesModel * model = [[PhotoImagesModel alloc] init];
        model.Id = [NSString stringWithFormat:@"%ld",(long)[RequestErrorGrab getIntegetKey:@"id" toTarget:image]];
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

@end
