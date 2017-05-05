//
//  CollectionTableView.m
//  ShopPhotos
//
//  Created by addcn on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "CollectionTableView.h"
//#import "CollectionTableCell.h"
#import "StaticCollectionViewCell.h"


@interface CollectionTableView ()<UICollectionViewDelegate,UICollectionViewDataSource,StaticCollectionViewCellDelegate>
@property (strong, nonatomic) NSMutableArray * dataArray;
@end

@implementation CollectionTableView

- (NSMutableArray *)dataArray{
    if(!_dataArray)_dataArray = [NSMutableArray array];
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
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.table = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.table.delegate=self;
    self.table.dataSource=self;
    [self.table setBackgroundColor:ColorHex(0xFFFFFF)];
    //    [self.table registerClass:[CollectionTableCell class] forCellWithReuseIdentifier:CollectionTableCellID];
    [self.table registerClass:[StaticCollectionViewCell class] forCellWithReuseIdentifier:CollectionTableCellID];
    [self addSubview:self.table];
    
    self.table.sd_layout
    .leftSpaceToView(self,5)
    .rightSpaceToView(self,5)
    .topSpaceToView(self,5)
    .bottomSpaceToView(self,5);
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
    
    StaticCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionTableCellID forIndexPath:indexPath];
    [cell createAutoLayout:self.isVideo cellType:2];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    cell.indexPath = indexPath;
    if(!cell.delegate)cell.delegate = self;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableDidSelected:)]){
        [self.delegate tableDidSelected:indexPath];
    }
    
}

#pragma mark - CollectionTableCellDelegate
- (void)editSelected:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(editSelected:)]){
        [self.delegate editSelected:indexPath];
    }
    
}
- (void)collctionSelected:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(collctionSelected:)]){
        [self.delegate collectionSelected:indexPath];
    }
}

- (void)collctionUserSelecte:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(collctionUserSelecte:)]){
        [self.delegate collectionUserSelecte:indexPath];
    }
}

- (void)shareClicked:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareClicked:)]){
        [self.delegate shareClicked:indexPath];
    }
}

@end
