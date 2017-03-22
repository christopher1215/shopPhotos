//
//  AlbumPhotoTableCell.h
//  ShopPhotos
//
//  Created by addcn on 16/12/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumPhotosMdel.h"

#define AlbumPhotoTableCellID @"AlbumPhotoTableCellID"

@protocol AlbumPhotoTableCellDelegate <NSObject>

- (void)editSelected:(NSIndexPath *)indexPath;

@end

@interface AlbumPhotoTableCell : UICollectionViewCell
@property (assign, nonatomic) BOOL showPrice;
@property (weak, nonatomic) id<AlbumPhotoTableCellDelegate>delegate;
@property (strong, nonatomic) AlbumPhotosMdel * model;
@property (strong, nonatomic) NSIndexPath * indexPath;

@end
