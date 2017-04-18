//
//  HTTPUserAgent.m
//  platform
//
//  Created by addcn on 16/11/2.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "HTTPUserAgent.h"
#import "DeviceInfo.h"
#import <sys/utsname.h>
#import "LoginLoadModel.h"
#import "UserModel.h"
#import "CongfingURL.h"
#import "NSObject+StoreValue.h"

@implementation HTTPUserAgent

+ (HTTPUserAgent *)getHTTPUserAgent{
    
    static HTTPUserAgent * userAgent = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        userAgent = [[HTTPUserAgent alloc] init];
    });
    
    return userAgent;
    
}

- (NSString *)getUserAgent{
    
    NSMutableString  * userAgent = [[NSMutableString alloc] init];
    [userAgent appendString:@"clients/ios "];
    
    NSString * systemVersion = [self getSystemVersion];
    NSString * systemVersionCode = [self getSystemVersionCode];
    NSString * uuid = [[DeviceInfo alloc] init].UUID;
    NSString * iso = [[DeviceInfo alloc] init].systemVersion;
    
    if(systemVersion && systemVersion.length > 0){
        [userAgent appendFormat:@"version/%@ ",[self getSystemVersion]];
    }
    if(systemVersionCode && systemVersionCode.length > 0){
        [userAgent appendFormat:@"version_code/%@ ",systemVersionCode];
    }
    if(uuid && uuid.length > 0){
        [userAgent appendFormat:@"imei/%@ ",uuid];
    }
    if(iso && iso.length > 0){
        [userAgent appendFormat:@"iso/%@ ",iso];
    }
    
    NSString * token = [self getValueWithKey:ShopPhotosToken];
    if(token && token.length > 0){
        [userAgent appendFormat:@"X-CSRF-TOKEN/%@",token];
    }
    return userAgent;
}

- (NSString *)getToken{
    
    NSString *token = [self getValueWithKey:@"authToken"];
    if(token){
        if(token && token.length > 0){
            return token;
        }
    }
    return @"";
}


- (NSString *)getSystemVersion{
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *) getSystemVersionCode{
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
}

- (NSString *)getMobileModel{
    
    struct utsname system;
    uname(&system);
    NSString *platform = [NSString stringWithCString:system.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7s";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7s Plus";
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    if ([platform isEqualToString:@"i386"])     return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])   return @"iPhone Simulator";
    
    return platform;
}

@end
