//
//  CollectionTableCell.h
//  ShopPhotos
//
//  Created by addcn on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumPhotosMdel.h"


static NSString * CollectionTableCellID = @"CollectionTableCellID";

@protocol CollectionTableCellDelegate <NSObject>

- (void)editSelected:(NSIndexPath *)indexPath;
- (void)collctionSelected:(NSIndexPath *)indexPath;
- (void)collctionUserSelecte:(NSIndexPath *)indexPath;
- (void)shareClicked:(NSIndexPath *)indexPath;

@end

@interface CollectionTableCell : UICollectionViewCell

@property (weak, nonatomic) id<CollectionTableCellDelegate>delegate;
@property (strong, nonatomic) AlbumPhotosMdel * model;
@property (strong, nonatomic) NSIndexPath * indexPath;

@end
