//
//  PhotosControllerCell.h
//  PhotosDemo
//
//  Created by 廖检成 on 17/1/10.
//  Copyright © 2017年 Stanley. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const PhotosControllerCellID = @"PhotosControllerCellID";

@protocol PhotosControllerCellDelegate <NSObject>

- (void)imageSelected:(NSIndexPath *)indexPath;

@end

@interface PhotosControllerCell : UICollectionViewCell

@property (strong, nonatomic) UIImage * icon;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (weak, nonatomic) id <PhotosControllerCellDelegate>delegate;
@property (assign, nonatomic) BOOL selectStatu;


@end
