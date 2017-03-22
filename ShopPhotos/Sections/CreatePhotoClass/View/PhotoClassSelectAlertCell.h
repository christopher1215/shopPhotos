//
//  PhotoClassSelectAlertCell.h
//  ShopPhotos
//
//  Created by addcn on 16/12/30.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseViewCell.h"
#import "AlbumClassTableModel.h"



static NSString * PhotoClassSelectAlertCellID = @"PhotoClassSelectAlertCellID";

@protocol PhotoClassSelectAlertCellDelegate <NSObject>

- (void)photoClassSelectAlertCellSelected:(NSIndexPath *)indexPath;

@end

@interface PhotoClassSelectAlertCell : BaseViewCell

@property (strong, nonatomic) AlbumClassTableModel * model;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (weak, nonatomic) id<PhotoClassSelectAlertCellDelegate>delegate;


@end
