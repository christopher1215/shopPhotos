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
#import <MJRefresh.h>
#import "PhotoDetailsCtr.h"
#import "AlbumPhotosMdel.h"
#import "PhotosEditView.h"
#import "MoreAlert.h"
#import "SearchAllCtr.h"
#import "PublishPhotosCtr.h"
#import "PersonalHomeCtr.h"

@interface CollectionPhotoCtr ()<MoreAlertDelegate,PhotosEditViewDelegate,CollectionTableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *more;
@property (weak, nonatomic) IBOutlet UIView *search;
@property (strong, nonatomic) CollectionTableView * table;
@property (strong, nonatomic) MoreAlert * moreAlert;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) PhotosEditView * editHead;
@property (strong, nonatomic) UIButton * editOption;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger itmeSelectedIndex;

@end
@implementation CollectionPhotoCtr

- (NSMutableArray *)dataArray{
    if(!_dataArray)_dataArray = [NSMutableArray array];
    return _dataArray;
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
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.more addTarget:self action:@selector(moreSelected)];
    [self.search addTarget:self action:@selector(searchSelected)];
}

- (void)createAutoLayout{
    
    self.table = [[CollectionTableView alloc] init];
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
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
    
}

#pragma mark - OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topViewSelected{
    [self.table.table setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)moreSelected{
    
    [self.moreAlert showAlert];
}

- (void)searchSelected{
    
    SearchAllCtr * search = GETALONESTORYBOARDPAGE(@"SearchAllCtr");
    [self.navigationController pushViewController:search animated:YES];
}

- (void)photosOptionSelected{
    
    NSMutableArray * editArray = [NSMutableArray array];
    for(AlbumPhotosMdel * model in self.dataArray){
        if(model.selected){
            [editArray addObject:model];
        }
    }
    NSMutableString * cancelIDs = [NSMutableString string];
    for(NSInteger index = 0; index<editArray.count;index++){
        AlbumPhotosMdel * mdoel = [editArray objectAtIndex:index];
        if(index==0){
            [cancelIDs appendString:mdoel.photosID];
        }else{
            [cancelIDs appendFormat:@"*%@",mdoel.photosID];
        }
    }
    
    if(editArray.count == 0){
        ShowAlert(@"当前未选中哦！");
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
        AlbumPhotosMdel * model = [weakSelef.dataArray objectAtIndex:weakSelef.itmeSelectedIndex];
        model.selected = NO;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
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

#pragma mark - MoreAlertDelegate
- (void)moreAlertSelected:(NSInteger)indexPath{
    
    if(indexPath == 0){
        // 编辑
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

#pragma mark - CollectionTableViewDelegate
- (void)editSelected:(NSIndexPath *)indexPath{

    AlbumPhotosMdel * model = [self.dataArray objectAtIndex:indexPath.row];
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

- (void)collctionSelected:(NSIndexPath *)indexPath{
    self.itmeSelectedIndex = indexPath.row;
    AlbumPhotosMdel * model = [self.dataArray objectAtIndex:indexPath.row];
    model.selected = YES;
    [self photosOptionSelected];
    
}
- (void)tableDidSelected:(NSIndexPath *)indexPath{
    AlbumPhotosMdel * model = [self.dataArray objectAtIndex:indexPath.row];
    PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
    photoDetails.photoId = model.photosID;
    [self.navigationController pushViewController:photoDetails animated:YES];
}

- (void)collctionUserSelecte:(NSIndexPath *)indexPath{
    AlbumPhotosMdel * model = [self.dataArray objectAtIndex:indexPath.row];
    PersonalHomeCtr * home = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
    home.uid = [model.user objectForKey:@"uid"];
    home.twoWay = YES;
    [self.navigationController pushViewController:home animated:YES];
    
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":@"1",
                            @"pageSize":@"30",
                            @"keyWord":@"false",
                            @"subclassification_id":@"0"};
    self.pageIndex = 1;
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getCollectPhotos parametric:data succed:^(id responseObject){
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
            [weakSelef.dataArray removeAllObjects];
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.table loadData:weakSelef.dataArray];
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
                            @"keyWord":@"false",
                            @"subclassification_id":@"0"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getCollectPhotos parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);

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
    [HTTPRequest requestPOSTUrl:self.congfing.cancelCollectPhotos parametric:data succed:^(id responseObject){
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
@end
