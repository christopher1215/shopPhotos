//
//  ChatLoginCtr.h
//  ShopPhotos
//
//  Created by addcn on 17/1/6.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseViewCtr.h"

typedef NS_ENUM(NSInteger, LoginType) {
    
    TypeWechatSession = 1,
    TypeQQSession,
    
};

@interface ChatLoginCtr : BaseViewCtr

@property (strong, nonatomic) NSMutableDictionary * userData;

@property (assign, nonatomic) LoginType type;

@end
