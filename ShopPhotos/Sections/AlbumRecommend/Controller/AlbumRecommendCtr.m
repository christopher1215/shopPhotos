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
#import "AlbumPhotosModel.h"
#import "PhotosEditView.h"
#import "PhotosOptionView.h"
#import "SearchAllCtr.h"
#import "PhotoDetailsCtr.h"
#import "PublishPhotoCtr.h"

#import "PhotoImagesRequset.h"
#import "DynamicImagesModel.h"
#import "ShareContentSelectCtr.h"
#import "DownloadImageCtr.h"
#import "CopyRequset.h"
#import "HasCollectPhotoRequset.h"
#import <ShareSDK/ShareSDK.h>
#import "PhotoImagesModel.h"


@interface AlbumRecommendCtr ()<MoreAlertDelegate,PhotosEditViewDelegate,PhotosOptionViewDelegate,AlbumPhotoTableViewDelegate>
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
@property (strong, nonatomic) NSMutableArray * imageArray;

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
    [self dataArray];
    [self imageArray];
    [self.back addTarget:self action:@selector(backSelected)];
    [self.edit addTarget:self action:@selector(editSelected)];
    [self.search addTarget:self action:@selector(searchSelected)];
}

- (void)createAutoLayout{

    self.table = [[AlbumPhotoTableView alloc] init];
    self.table.delegate = self;
    self.table.isVideo = NO;
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
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topViewSelected{
    [self.table.photos setContentOffset:CGPointMake(0, 0) animated:YES];
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

#pragma mark - PhotosOptionViewDelegate
- (void)photosOptionSelected:(NSInteger)type{
    
    NSMutableArray * editArray = [NSMutableArray array];
    
    for(AlbumPhotosModel * model in self.dataArray){
        if(model.selected){
            [editArray addObject:model];
        }
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    for(NSInteger index = 0; index < editArray.count; index++){
        AlbumPhotosModel * model = [editArray objectAtIndex:index];
        [data setValue:model.Id forKey:[NSString stringWithFormat:@"photosId[%ld]",(long)index]];
    }
    
    if(editArray.count == 0){
        SPAlert(@"当前未选中哦！",self);
        return;
    }

    if(type == 1){
        [data setValue:@"0" forKey:@"recommend"];
        __weak __typeof(self)weakSelef = self;
        NSString * msg = [NSString stringWithFormat:@"确定取消推荐%ld项",(unsigned long)editArray.count];
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
        NSLog(@"上传相册");
        PublishPhotoCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
        [self.navigationController pushViewController:pulish animated:YES];
    }
}

#pragma mark - AlbumPhotoTableViewDelegate
- (void)albumPhotoSelectPath:(NSInteger)indexPath{
    if(indexPath >= self.dataArray.count) return;
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath];
    PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
    photoDetails.photoId = model.Id;
    [self.navigationController pushViewController:photoDetails animated:YES];
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
//    [self showLoad];
    [self getPhotoImages];
    [self.appd showShareview:@"photo" collected:NO model:[self.dataArray objectAtIndex:indexPath.row] from:self];
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    self.page = 1;
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                            @"pageSize":@"30",
                            @"keyWord":@"false"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getRecommendPhotos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
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
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                            @"pageSize":@"30",
                            @"keyWord":@"false"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getRecommendPhotos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){

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

- (void)loadUpdatePhotos:(NSDictionary *)data{

    [self showLoad];
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    
    for (PhotoImagesModel *image in self.imageArray) {
        if (image.isCover) {
            [data setValue:image.Id forKey:@"coverImageId"];
        }
    }
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPUTUrl :[NSString stringWithFormat:@"%@%@",config.handleRecommendPhotos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
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
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef closeLoad];
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
- (void)pyqClicked:(NSIndexPath *)indexPath {
    self.itmeSelectedIndex = indexPath.row;
    //    [self showLoad];
    [self getPhotoImages];
    NSMutableArray * images = [NSMutableArray array];
    for(PhotoImagesModel * imageModel in _imageArray){
        DynamicImagesModel * model = [[DynamicImagesModel alloc] init];
        model.bigImageUrl = imageModel.bigImageUrl;
        model.thumbnailUrl = imageModel.thumbnailUrl;
        [images addObject:model];
    }
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
    
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = model.title;
    ShareContentSelectCtr * shareSelect = GETALONESTORYBOARDPAGE(@"ShareContentSelectCtr");
    shareSelect.dataArray = images;
    [self.navigationController pushViewController:shareSelect animated:YES];
}

- (void)getPhotoImages{
    [_imageArray removeAllObjects];
    AlbumPhotosModel * pModel = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
    
    for(NSDictionary * image in pModel.images){
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
