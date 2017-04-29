//
//  AttentionTableCell.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/19.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseViewCell.h"
#import "AttentionModel.h"

#define AttentionTableCellID @"AttentionTableCellID"

@protocol AttentionTableCellDelegate  <NSObject>

- (void)attentionSelected:(NSIndexPath *)indexPath;
- (void)concernSelected:(NSIndexPath *)indexPath;

@end

@interface AttentionTableCell : BaseViewCell

@property (strong, nonatomic) AttentionModel * model;
@property (assign, nonatomic) BOOL attentionStatu;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (strong, nonatomic) id<AttentionTableCellDelegate>delegate;
@end
