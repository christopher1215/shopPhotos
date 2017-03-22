//
//  PhotoImagesModel.h
//  ShopPhotos
//
//  Created by addcn on 16/12/31.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface PhotoImagesModel : BaseModel

@property (strong, nonatomic) NSString * imageID;
@property (strong, nonatomic) NSString * imageLink_id;
@property (strong, nonatomic) NSString * thumbnails;
@property (strong, nonatomic) NSString * big;
@property (strong, nonatomic) NSString * source;
@property (assign, nonatomic) BOOL isCover;
@property (assign, nonatomic) BOOL edit;

@end
