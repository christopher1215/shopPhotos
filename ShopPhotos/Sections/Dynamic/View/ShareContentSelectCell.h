//
//  ShareContentSelectCell.h
//  ShopPhotos
//
//  Created by addcn on 17/1/3.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicImagesModel.h"

#define ShareContentSelectCellID @"ShareContentSelectCellID"

@interface ShareContentSelectCell : UICollectionViewCell

@property (strong, nonatomic) DynamicImagesModel * model;
@end
