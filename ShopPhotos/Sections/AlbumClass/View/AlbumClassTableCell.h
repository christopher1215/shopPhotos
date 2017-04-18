//
//  AlbumClassTableCell.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//


#import "BaseViewCell.h"
#import "AlbumClassTableSubModel.h"

#define AlbumClassTableCellID @"AlbumClassTableCellID"

@protocol AlbumClassTableCellDelegate <NSObject>

- (void)albumClassTableSelectType:(NSInteger)type selectPath:(NSIndexPath *)indexPath;

@end

@interface AlbumClassTableCell : BaseViewCell

@property (strong, nonatomic) NSIndexPath * indexPath;
@property (assign, nonatomic) BOOL showPrice;
@property (weak, nonatomic) id<AlbumClassTableCellDelegate>delegate;
@property (strong, nonatomic) AlbumClassTableSubModel * model;

- (void)createAutoLayout:(BOOL)isSubClass;

@end
