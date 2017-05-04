//
//  AlbumPhotoTableView.m
//  ShopPhotos
//
//  Created by addcn on 16/12/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AlbumPhotoTableView.h"
//#import "AlbumPhotoTableCell.h"
#import "StaticCollectionViewCell.h"
#import <MJRefresh.h>

@interface AlbumPhotoTableView ()<UICollectionViewDelegate,UICollectionViewDataSource,StaticCollectionViewCellDelegate>

@property (strong, nonatomic) NSMutableArray * dataArray;

@end

@implementation AlbumPhotoTableView

- (NSMutableArray *)dataArray{
    
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createAutoLayout];
    }
    return self;
}

- (void)createAutoLayout{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.photos = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.photos.delegate=self;
    self.photos.dataSource=self;
    [self.photos setBackgroundColor:ColorHex(0XFFFFFF)];
    [self.photos registerClass:[StaticCollectionViewCell class] forCellWithReuseIdentifier:@"AlbumPhotoTableCellID"];
    [self addSubview:self.photos];
 
    
    self.photos.sd_layout
    .leftSpaceToView(self,5)
    .rightSpaceToView(self,5)
    .topSpaceToView(self,5)
    .bottomSpaceToView(self,5);
    
    //self.photos.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)loadData:(NSArray *)dataArray{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:dataArray];
    [self.photos reloadData];
    
}
- (void)loadMoreData:(NSArray *)dataArray{
    
    [self.dataArray addObjectsFromArray:dataArray];
    [self.photos reloadData];
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"AlbumPhotoTableCellID";
    StaticCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell createAutoLayout:self.isVideo cellType:1];
    cell.indexPath = indexPath;
    if(!cell.delegate)cell.delegate = self;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WindowWidth-15)/2, 70 + (WindowWidth - 15)/2);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 0, 5, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 5;
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(albumPhotoSelectPath:)]){
        [self.delegate albumPhotoSelectPath:indexPath.row];
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark --AlbumPhotoTableCellDelegate

- (void)editSelected:(NSIndexPath *)indexPath{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(albumEditSelectPath:)]){
        [self.delegate albumEditSelectPath:indexPath.row];
    }
}

- (void)shareClicked:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareClicked:)]){
        [self.delegate shareClicked:indexPath];
    }
}

- (void)collectionSelected:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(albumPhotoSelectPath:)]){
        [self.delegate albumPhotoSelectPath:indexPath.row];
    }
}

- (void)collectionUserSelecte:(NSIndexPath *)indexPath {
}

@end
