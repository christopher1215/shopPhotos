//
//  CollectionTableView.h
//  ShopPhotos
//
//  Created by addcn on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol CollectionTableViewDelegate  <NSObject>

- (void)editSelected:(NSIndexPath *)indexPath;
- (void)collctionSelected:(NSIndexPath *)indexPath;
- (void)tableDidSelected:(NSIndexPath *)indexPath;
- (void)collctionUserSelecte:(NSIndexPath *)indexPath;

@end

@interface CollectionTableView : BaseView
@property (strong, nonatomic) UICollectionView * table;
@property (weak, nonatomic) id<CollectionTableViewDelegate>delegate;

- (void)loadData:(NSArray *)dataArray;
- (void)loadMoreData:(NSArray *)dataArray;
@end