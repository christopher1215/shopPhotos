//
//  PhotosController.m
//  PhotosDemo
//
//  Created by 廖检成 on 17/1/10.
//  Copyright © 2017年 Stanley. All rights reserved.
//

#import "PhotosController.h"
#import "PhotosControllerCell.h"
#import "FZJBigPhotoController.h"
#import "CommonDefine.h"

@interface PhotosController ()<UICollectionViewDelegate,UICollectionViewDataSource,PhotosControllerCellDelegate>

@property (strong, nonatomic) UICollectionView * table;
@property (strong, nonatomic) UIView * selectOption;
@property (strong, nonatomic) UILabel * optionTitle;
@property (strong, nonatomic) UIButton * comple;

@end

@implementation PhotosController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createAutoLayout];
    
}


- (void)createAutoLayout{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.table = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.table.delegate=self;
    self.table.dataSource=self;
    [self.table setBackgroundColor:[UIColor whiteColor]];
    [self.table registerClass:[PhotosControllerCell class] forCellWithReuseIdentifier:PhotosControllerCellID];
    [self.view addSubview:self.table];
    self.table.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-50);
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"所有照片";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.navigationItem.titleView = title;
    
    self.selectOption = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    [self.view addSubview:self.selectOption];
    self.optionTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 50)];
    [self.optionTitle setTextAlignment:NSTextAlignmentCenter];
    [self.optionTitle setText:[NSString stringWithFormat:@"0/%ld",self.maxIndex]];
    [self.optionTitle setBackgroundColor:[UIColor whiteColor]];
    [self.selectOption addSubview:self.optionTitle];
    
    self.comple = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 8, 50, 34)];
    [self.comple setTitle:@"完成" forState:UIControlStateNormal];
    self.comple.titleLabel.font = Font(14);
    [self.comple setBackgroundColor:[UIColor whiteColor]];
    [self.comple setTitleColor:[UIColor colorWithRed:1 green:84/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
    [self.comple addTarget:self action:@selector(SuperBackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.selectOption addSubview:self.comple];
    
}

- (void)SuperBackBtnClicked{
    if(self.delegate && [self.delegate respondsToSelector:@selector(photosSelecteImages:)]){
        NSMutableArray * array = [NSMutableArray array];
        for(STPhotosModel * model in self.dataArray){
            if(model.select){
                [array addObject:model];
            }
        }
        
        [self.delegate photosSelecteImages:array];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData:(NSArray *)dataArray{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:dataArray];
    [self.table reloadData];
    
}
- (void)loadMoreData:(NSArray *)dataArray{
    
    [self.dataArray addObjectsFromArray:dataArray];
    [self.table reloadData];
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotosControllerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotosControllerCellID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if(!cell.delegate)cell.delegate = self;
    STPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    
    PHAsset *asset = model.asset;
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    //仅显示缩略图，不控制质量显示
    /**
     PHImageRequestOptionsResizeModeNone,
     PHImageRequestOptionsResizeModeFast, //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像
     PHImageRequestOptionsResizeModeExact //精确的加载与传入size相匹配的图像
     */
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = YES;
    option.synchronous = YES;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        //解析出来的图片
        cell.icon = image;
    }];
    
    cell.selectStatu = model.select;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((self.view.frame.size.width - 40)/4, (self.view.frame.size.width - 40)/4);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FZJBigPhotoController * big = [[FZJBigPhotoController alloc] init];
    big.fetchResult = self.dataArray;
    big.select = indexPath.row;
    [self.navigationController pushViewController:big animated:YES];
    
}

- (void)imageSelected:(NSIndexPath *)indexPath{
    
    STPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    model.select = !model.select;
    
    NSInteger count = 0;
    
    for(STPhotosModel * model in self.dataArray){
        if(model.select){
            count ++;
        }
    }
    
    if(count <= self.maxIndex){
        [self.table reloadData];
    }else{
      model.select = !model.select;
    }
    
    [self setCount:count];
}

- (void)setCount:(NSInteger)count{
    if(count > self.maxIndex){
        NSString * msg = [NSString stringWithFormat:@"最大选择%ld张",self.maxIndex];
        ShowAlert(msg);
        return;
    }
    [self.optionTitle setText:[NSString stringWithFormat:@"%ld/%ld",count,self.maxIndex]];
}

@end
