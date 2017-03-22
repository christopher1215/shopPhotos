//
//  CollectionTableView.m
//  ShopPhotos
//
//  Created by addcn on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "CollectionTableView.h"
#import "CollectionTableCell.h"

@interface CollectionTableView ()<UICollectionViewDelegate,UICollectionViewDataSource,CollectionTableCellDelegate>
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
    [self.table setBackgroundColor:ColorHex(0Xeeeeee)];
    [self.table registerClass:[CollectionTableCell class] forCellWithReuseIdentifier:CollectionTableCellID];
    [self addSubview:self.table];
    
    self.table.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self,0)
    .bottomEqualToView(self);
    
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
   
    CollectionTableCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionTableCellID forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    cell.indexPath = indexPath;
    if(!cell.delegate)cell.delegate = self;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((WindowWidth-20)/2, 235);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 5, 10, 5);
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
        [self.delegate collctionSelected:indexPath];
    }
}

- (void)collctionUserSelecte:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(collctionUserSelecte:)]){
        [self.delegate collctionUserSelecte:indexPath];
    }
}

@end
