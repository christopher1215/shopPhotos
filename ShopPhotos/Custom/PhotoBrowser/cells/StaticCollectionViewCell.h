//
//  StaticCollectionViewCell.h
//  ShopPhotos
//
//  Created by Park Jin Hyok on 4/8/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#ifndef StaticCollectionViewCell_h
#define StaticCollectionViewCell_h


#import <UIKit/UIKit.h>
#import "AlbumPhotosMdel.h"

@protocol StaticCollectionViewCellDelegate <NSObject>

- (void)editSelected:(NSIndexPath *)indexPath;
- (void)collectionSelected:(NSIndexPath *)indexPath;
- (void)collectionUserSelecte:(NSIndexPath *)indexPath;
- (void)shareClicked:(NSIndexPath *)indexPath;

@end

@interface StaticCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<StaticCollectionViewCellDelegate>delegate;
@property (strong, nonatomic) AlbumPhotosMdel * model;
@property (strong, nonatomic) NSIndexPath * indexPath;

- (void)createAutoLayout:(BOOL)isVideo cellType:(int) type;

@end


#endif /* StaticCollectionViewCell_h */