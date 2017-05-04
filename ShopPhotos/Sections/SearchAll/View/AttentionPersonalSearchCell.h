//
//  AttentionPersonalSearchCell.h
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionPersonalSearchModel.h"

#define  AttentionPersonalSearchCellID @"AttentionPersonalSearchCellID"

@interface AttentionPersonalSearchCell : UICollectionViewCell

@property (strong, nonatomic) AttentionPersonalSearchModel * model;

@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * name;
@property (strong, nonatomic) UIView * line;
@property (strong, nonatomic) UIImageView * accessory;


@end
