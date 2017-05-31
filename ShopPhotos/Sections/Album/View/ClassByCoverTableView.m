//
//  ClassByCoverTableView.m
//  ShopPhotos
//
//  Created by Macbook on 15/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "ClassByCoverTableView.h"
#import <MJRefresh.h>
#import "ClassByCoverTableViewCell.h"

@interface ClassByCoverTableView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ClassByCoverTableView

- (void)setDataArray:(NSMutableArray *)dataArray{
    
    if(dataArray){
        if(!_dataArray) _dataArray = [NSMutableArray array];
        if(_dataArray.count > 0) [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:dataArray];
        [self.classes reloadData];
    }
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
    self.classes = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.classes.delegate=self;
    self.classes.dataSource=self;
    [self.classes setBackgroundColor:ColorHex(0XF5F5F5)];
    [self.classes registerClass:[ClassByCoverTableViewCell class] forCellWithReuseIdentifier:ClassByCoverCellID];
    [self addSubview:self.classes];
    
    
    self.classes.sd_layout
    .leftSpaceToView(self,5)
    .rightSpaceToView(self,5)
    .topSpaceToView(self,5)
    .bottomSpaceToView(self,5);
    
    //self.classes.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
}
#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = ClassByCoverCellID;
    ClassByCoverTableViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WindowWidth-15)/2, 40 + (WindowWidth - 15)/2);
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


@end
