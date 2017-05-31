//
//  PersonalPhotosSearchCtr.m
//  ShopPhotos
//
//  Created by addcn on 17/1/4.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PersonalPhotosSearchCtr.h"
#import "AlbumPhotoTableView.h"
#import <MJRefresh.h>
#import "AlbumPhotosRequset.h"
#import "AlbumPhotosModel.h"
#import "PhotoDetailsCtr.h"

@interface PersonalPhotosSearchCtr ()<AlbumPhotoTableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIView *search;
@property (strong, nonatomic) AlbumPhotoTableView * table;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (assign, nonatomic) NSInteger pageIndex;
@end

@implementation PersonalPhotosSearchCtr
- (NSMutableArray *)dataArray{
    
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup{
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.search addTarget:self action:@selector(searchSelected)];
    self.table = [[AlbumPhotoTableView alloc] init];
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,114)
    .bottomEqualToView(self.view);
}

#pragma mark - OnClick
- (void)backSelected{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)searchSelected{
    [self.searchText resignFirstResponder];
    if(!self.searchText.text ||self.searchText.text.length == 0){
        SPAlert(@"请输入搜索关键字",self);
        return;
    }
    
    [self.dataArray removeAllObjects];
    [self.table.photos reloadData];
    
    [self loadSearchData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setEditing:YES];
}

#pragma mark - AlbumPhotoTableViewDelegate
- (void)albumPhotoSelectPath:(NSInteger)indexPath{
    
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath];
    PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
    photoDetails.photoId = model.Id;
    [self.navigationController pushViewController:photoDetails animated:YES];
    
    
}

#pragma makr - AFNetworking网络加载
- (void)loadSearchData{
    if ([self.searchText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 0) {
        [self showToast:@"请输入关键字"];
        return;
    }
    
    [self showLoad];
    self.pageIndex = 1;
    
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                            @"pageSize":@"30",
                            @"keyWord":self.searchText.text};
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getUserPhotos parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        [weakSelef.table.photos.mj_header endRefreshing];
        
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            
            weakSelef.pageIndex ++;
            weakSelef.table.photos.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkMoreData];
            }];
            if(requset.dataArray.count < 30){
                [weakSelef.table.photos.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.table.photos.mj_footer setHidden:YES];
                if(requset.dataArray.count == 0){
                    [weakSelef showToast:@"未搜索到结果"];
                }
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
        [weakSelef closeLoad];
        [weakSelef.table.photos.mj_header endRefreshing];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}
- (void)shareClicked:(NSIndexPath *)indexPath {
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    [self.appd showShareview:model.type collected:model.collected model:model from:self];
}

- (void)loadNetworkMoreData{
    [self showLoad];
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                            @"pageSize":@"30",
                            @"keyWord":self.searchText.text};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getUserPhotos parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        [weakSelef closeLoad];
        [weakSelef.table.photos.mj_header endRefreshing];
        
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.pageIndex ++;
            if(requset.dataArray.count < 30){
                [weakSelef.table.photos.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.table.photos.mj_footer setHidden:YES];
            }else{
                [weakSelef.table.photos.mj_footer resetNoMoreData];
            }
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.table loadData:weakSelef.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef.table.photos.mj_header endRefreshing];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

@end
