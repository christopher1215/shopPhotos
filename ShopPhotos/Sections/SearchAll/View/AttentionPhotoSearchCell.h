//
//  AttentionPhotoSearchCell.h
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlbumPhotosModel.h"

#define AttentionPhotoSearchCellID @"AttentionPhotoSearchCellID"

@protocol AttentionPhotoSearchCellDelegate  <NSObject>

- (void)userContenSelected:(NSIndexPath *)indexPath;
- (void)shareClicked:(NSIndexPath *)indexPath;

@end

@interface AttentionPhotoSearchCell : UICollectionViewCell
@property (strong, nonatomic) AlbumPhotosModel * model;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (assign, nonatomic) id<AttentionPhotoSearchCellDelegate>delegate;
@end
