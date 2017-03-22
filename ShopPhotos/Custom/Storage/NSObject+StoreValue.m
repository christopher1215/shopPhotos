//
//  NSObject+StoreValue.m
//  StoreValue
//
//  Created by YouXianMing on 15/9/29.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import "NSObject+StoreValue.h"
#import "StoreValue.h"

@implementation NSObject (StoreValue)

- (void)setValue:(id)value WithKey:(NSString *)key; {

    [[StoreValue sharedInstance] setValue:value withKey:key];
}

- (id)getValueWithKey:(NSString *)key {

    return [[StoreValue sharedInstance] getValueWithKey:key];
}

- (void)removeValueWithKey:(NSString *)key{
    [[StoreValue sharedInstance] removeValueWithKey:key];
}
@end
