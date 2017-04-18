//
//  AlbumPhotoTableView.h
//  ShopPhotos
//
//  Created by addcn on 16/12/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol AlbumPhotoTableViewDelegate  <NSObject>

- (void)albumPhotoSelectPath:(NSInteger)indexPath;
- (void)albumEditSelectPath:(NSInteger)indexPath;
- (void)shareClicked:(NSIndexPath *)indexPath;

@end

@interface AlbumPhotoTableView : BaseView

@property (weak, nonatomic) id<AlbumPhotoTableViewDelegate>delegate;
@property (strong, nonatomic)UICollectionView * photos;
@property (assign, nonatomic) BOOL showPrice;
- (void)loadData:(NSArray *)dataArray;
- (void)loadMoreData:(NSArray *)dataArray;

@end
