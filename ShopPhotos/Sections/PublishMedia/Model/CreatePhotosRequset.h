//
//  createPhotosRequset.h
//  ShopPhotos
//
//  Created by addcn on 17/1/2.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface CreatePhotosRequset : BaseModel

@property (strong, nonatomic) NSString * qiniuToken;
@property (strong, nonatomic) NSMutableArray * imagesName;
@end
