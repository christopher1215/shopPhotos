//
//  UserInfoDrawerModel.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoDrawerModel : BaseModel

@property (strong, nonatomic) NSString * icon;
@property (strong, nonatomic) NSString * name;
@property (assign, nonatomic) BOOL chat;

@end
