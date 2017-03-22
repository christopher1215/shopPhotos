//
//  MessageCell.h
//  ShopPhotos
//
//  Created by addcn on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseViewCell.h"
#import "MessageModel.h"

#define MessageCellID @"MessageCellID"

@interface MessageCell : BaseViewCell

@property (strong, nonatomic) MessageModel * model;

@end
