//
//  PersonalSubClassPhotoTable.h
//  ShopPhotos
//
//  Created by Macbook on 10/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseView.h"

static NSString * PersonalSubClassPhotoTableCellID = @"PersonalSubClassPhotoTableCellID";

@protocol PersonalSubClassPhotoTableDelegate  <NSObject>

- (void)editSelected:(NSIndexPath *)indexPath;
- (void)collectionSelected:(NSIndexPath *)indexPath;
- (void)tableDidSelected:(NSIndexPath *)indexPath;
- (void)collectionUserSelecte:(NSIndexPath *)indexPath;
- (void)shareClicked:(NSIndexPath *)indexPath;
- (void)pyqClicked:(NSIndexPath *)indexPath;
- (void)favoriteClicked:(NSIndexPath *)indexPath;

@end

@interface PersonalSubClassPhotoTable : BaseView

@property (strong, nonatomic) UICollectionView * table;
@property (weak, nonatomic) id<PersonalSubClassPhotoTableDelegate>delegate;

- (void)loadData:(NSArray *)dataArray;
- (void)loadMoreData:(NSArray *)dataArray;

@end
