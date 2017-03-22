//
//  RequestUtil.m
//  platform
//
//  Created by addcn on 16/7/15.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "RequestUtil.h"
#import "CommonDefine.h"



@implementation RequestUtil

#pragma mark - 保持／设置Cookies
+ (void)saveCookies{
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:cookiesData forKey:SESSIONCOOKKEY];
    [defaults synchronize];
}

+ (void)loadCookies{

    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:SESSIONCOOKKEY]];
    
    NSHTTPCookieStorage * cookieStorage = [[NSHTTPCookieStorage alloc] init];
    
    for (NSHTTPCookie * cookie in cookies){
        [cookieStorage setCookie:cookie];
    }
}

+ (void)removeCookiesDefaults{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:SESSIONCOOKKEY];
}


@end
