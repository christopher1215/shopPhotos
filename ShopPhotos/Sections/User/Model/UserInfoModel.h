//
//  UserInfoModel.h
//  ShopPhotos
//
//  Created by addcn on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * signature;
@property (strong, nonatomic) NSString * qq;
@property (strong, nonatomic) NSString * wechat;
@property (strong, nonatomic) NSString * phone;
@property (strong, nonatomic) NSString * address;
@property (strong, nonatomic) NSString * avatar;
@property (strong, nonatomic) NSString * bg_image;
@property (strong, nonatomic) NSString * name_abbr;
@property (strong, nonatomic) NSString * email;
@property (assign, nonatomic) NSInteger integral;
@property (assign, nonatomic) NSInteger concerned;
@property (strong, nonatomic) NSDictionary * settings;
- (void)analyticInterface:(NSDictionary *)data;

@end
