//
//  SuperAlbumClassCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/3.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "SuperAlbumClassCtr.h"
#import "SuperAlbumClassCell.h"
#import "SuperAlbumClassModel.h"
#import "SuperAlbumClassRequset.h"
#import "AlbumClassTabelCtr.h"

@interface SuperAlbumClassCtr ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) UICollectionView * photos;
@property (assign, nonatomic) NSInteger page;
@end

@implementation SuperAlbumClassCtr

- (NSMutableArray *)dataArray{
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    
    [self createAutoLayout];
    
    [self loadNetworkData];
}

- (void)setup{
    [self.back addTarget:self action:@selector(backSelcted)];
    if(self.pageName)[self.pageTitle setText:self.pageName];
}


- (void)backSelcted{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createAutoLayout{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.photos = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.photos.delegate=self;
    self.photos.dataSource=self;
    [self.photos setBackgroundColor:ColorHex(0Xeeeeee)];
    [self.photos registerClass:[SuperAlbumClassCell class] forCellWithReuseIdentifier:SuperAlbumClassCellID];
    [self.view addSubview:self.photos];
    
    
    self.photos.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .bottomEqualToView(self.view);
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = SuperAlbumClassCellID;
    SuperAlbumClassCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WindowWidth-45)/2, 210);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SuperAlbumClassModel * model = [self.dataArray objectAtIndex:indexPath.row];
    AlbumClassTabelCtr * classTable = GETALONESTORYBOARDPAGE(@"AlbumClassTabelCtr");
    classTable.uid = self.uid;
    classTable.subClassID = model.itmeID;
    classTable.pageText = model.name;
    [self.navigationController pushViewController:classTable animated:YES];
}


#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    
    [self showLoad];
    self.page = 1;
    NSDictionary * data = @{@"classifyId":self.classifyId,
                            @"subclassPage":[NSString stringWithFormat:@"%ld",self.page]};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getSubclasses parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        SuperAlbumClassRequset * requset = [[SuperAlbumClassRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0 ){
            if(requset.dataArray.count == 0){
                [weakSelef showToast:@"没有发现子分类"];
            }else{
                [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
                [weakSelef.photos reloadData];
            }
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}
@end
