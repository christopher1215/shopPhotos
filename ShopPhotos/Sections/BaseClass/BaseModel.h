//
//  BaseModel.h
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonDefine.h"
#import "RequestErrorGrab.h"

@interface BaseModel : NSObject

@property (strong, nonatomic) NSString * message;
@property (assign, nonatomic) NSInteger status;

- (void)analyticInterface:(NSDictionary *)data;

@end
