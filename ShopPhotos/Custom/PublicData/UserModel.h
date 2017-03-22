//
//  UserModel.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"


#define CacheUserModel @"CacheUserModelKeY"


@interface UserModel : BaseModel

@property (strong, nonatomic) NSString * userID;
@property (strong, nonatomic) NSString * token;

@end
