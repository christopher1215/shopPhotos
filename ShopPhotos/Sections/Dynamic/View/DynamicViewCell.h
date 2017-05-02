//
//  DynamicViewCell.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/19.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseViewCell.h"
#import "DynamicModel.h"

static NSString * CellID = @"DynamicViewCell";

@protocol DynamicViewCellDelegate <NSObject>

- (void)cellSelectType:(NSInteger)type tableViewCelelIndexPath:(NSIndexPath *)indexPath;
- (void)cellImageSelected:(NSInteger)tag TabelViewCellIndexPath:(NSIndexPath *)indexPath;

@end

@interface DynamicViewCell : BaseViewCell

@property (weak, nonatomic) id<DynamicViewCellDelegate>delegate;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (strong, nonatomic) DynamicModel * model;
@property (assign, nonatomic) BOOL isMyDynamic;

- (void)createAutoLayout;

@end
