//
//  UserModel.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"


#define CacheUserModel @"CacheUserModelKeY"
#define FirstRun @"FirstRun"


@interface UserModel : BaseModel

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
@property (strong, nonatomic) NSDictionary * settings;
- (void)analyticInterface:(NSDictionary *)data;

@end
