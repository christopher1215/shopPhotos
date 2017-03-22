//
//  UserInfoModel.h
//  ShopPhotos
//
//  Created by addcn on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

@property (strong, nonatomic) NSString * icon;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * qq;
@property (strong, nonatomic) NSString * weixin;
@property (strong, nonatomic) NSString * tel;
@property (strong, nonatomic) NSString * signature;
@property (strong, nonatomic) NSString * qq_qrCode;
@property (strong, nonatomic) NSString * wx_qrCode;
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) NSString * address;
@property (strong, nonatomic) NSDictionary * config;

@end
