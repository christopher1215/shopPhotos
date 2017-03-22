//
//  DeviceInfo.m
//  platform
//
//  Created by addcn on 16/11/2.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "DeviceInfo.h"
#import <UIKit/UIKit.h>
#import "NSObject+StoreValue.h"

@implementation DeviceInfo

- (NSString *)name{
    return [[UIDevice alloc] init].name;
}

- (NSString *)type{
    return [[UIDevice alloc] init].localizedModel;
}

- (NSString *)systemVersion{
    return [[UIDevice alloc] init].systemVersion;
}

- (NSString *)UUID{
    
    NSString * UUID = [self getValueWithKey:@"UUIDKey"];
    if(UUID && UUID.length > 0) return UUID;
    
    UUID = [[NSUUID UUID] UUIDString];
    [self setValue:UUID WithKey:@"UUIDKey"];
    return UUID;
}
@end
