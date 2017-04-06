//
//  WeChatLoginRequset.h
//  ShopPhotos
//
//  Created by addcn on 17/1/6.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface WeChatLoginRequset : BaseModel

@property (strong, nonatomic) NSDictionary * userData;
@property (strong, nonatomic) NSString * userID;

@end
