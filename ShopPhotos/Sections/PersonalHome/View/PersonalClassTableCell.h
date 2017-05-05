//
//  AlbumClassTableCell.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//


#import "BaseViewCell.h"
#import "AlbumClassTableSubModel.h"

#define PersonalClassTableCellID @"PersonalClassTableCellID"

@protocol PersonalClassTableCellDelegate <NSObject>

//- (void)personalClassTableSelectType:(NSInteger)type selectPath:(NSIndexPath *)indexPath;

@end

@interface PersonalClassTableCell : BaseViewCell

@property (strong, nonatomic) NSIndexPath * indexPath;
@property (assign, nonatomic) BOOL showPrice;
@property (weak, nonatomic) id<PersonalClassTableCellDelegate>delegate;
@property (strong, nonatomic) NSDictionary * model;

@end
