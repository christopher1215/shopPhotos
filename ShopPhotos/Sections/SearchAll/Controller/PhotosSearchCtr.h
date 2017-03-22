//
//  PhotosSearchCtr.h
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseViewCtr.h"

@interface PhotosSearchCtr : BaseViewCtr
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) NSString * searchKey;
@property (strong, nonatomic) NSString * pageTitle;
@property (assign, nonatomic) BOOL is_self;
@end
