//
//  DynamicImagesModel.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface DynamicImagesModel : BaseModel

@property (strong, nonatomic) NSString * bigImageUrl;
@property (strong, nonatomic) NSString * thumbnailUrl;
@property (assign, nonatomic) NSInteger  Id;
@property (assign, nonatomic) BOOL select;

@end
