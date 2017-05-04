//
//  AttentionPersonalSearchModel.h
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface AttentionPersonalSearchModel : BaseModel

@property (strong, nonatomic) NSString * address;
@property (strong, nonatomic) NSString * bg_image;
@property (strong, nonatomic) NSString * avatar;
@property (assign, nonatomic) BOOL concerned;
@property (strong, nonatomic) NSString * signature;
@property (strong, nonatomic) NSString * name_abbr;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * qq;
@property (strong, nonatomic) NSDictionary * settings;
@property (strong, nonatomic) NSString * phone;
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) NSString * wechat;

@end
