//
//  AttentionModel.h
//  ShopPhotos
//
//  Created by addcn on 16/12/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface AttentionModel : BaseModel

@property (strong, nonatomic) NSString * date;
@property (strong, nonatomic) NSString * icon;
@property (strong, nonatomic) NSString * itmeID;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * qq;
@property (assign, nonatomic) BOOL star;
@property (strong, nonatomic) NSString * tel;
@property (assign, nonatomic) BOOL twoWay;
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) NSString * weixin;

@end
