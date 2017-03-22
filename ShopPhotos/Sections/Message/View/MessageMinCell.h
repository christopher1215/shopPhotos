//
//  MessageMinCell.h
//  ShopPhotos
//
//  Created by addcn on 17/1/5.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseViewCell.h"
#import "MessageModel.h"

#define MessageMinCellID @"MessageMinCellID"

@interface MessageMinCell : BaseViewCell
@property (strong, nonatomic) MessageModel * model;
@end
