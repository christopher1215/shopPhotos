//
//  DynamicImagesModel.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface DynamicImagesModel : BaseModel

@property (strong, nonatomic) NSString * big;
@property (strong, nonatomic) NSString * thumbnails;
@property (assign, nonatomic) NSInteger  imageID;
@property (assign, nonatomic) BOOL select;

@end
