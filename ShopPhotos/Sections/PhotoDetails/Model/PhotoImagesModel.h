//
//  PhotoImagesModel.h
//  ShopPhotos
//
//  Created by addcn on 16/12/31.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface PhotoImagesModel : BaseModel

@property (strong, nonatomic) NSString * Id;
@property (strong, nonatomic) NSString * imageLink_id;
@property (strong, nonatomic) NSString * thumbnailUrl;
@property (strong, nonatomic) NSString * bigImageUrl;
@property (strong, nonatomic) NSString * srcUrl;
@property (assign, nonatomic) UIImage *photo;
@property (assign, nonatomic) BOOL isCover;
@property (assign, nonatomic) BOOL isNew;
@property (assign, nonatomic) BOOL edit;

@end
