//
//  StringCheck.h
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/15.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringCheck : NSObject

#pragma mark - 是否全为数字
+ (BOOL)isPureInt:(NSString*)string;
#pragma mark - 是否全为空格
+ (BOOL)isEmpty:(NSString *)str;
#pragma mark - 是否为邮箱
+ (BOOL)isValidateEmail:(NSString *)email;
#pragma mark - 是否为手机号码
+ (BOOL) isValidateMobile:(NSString *)mobile;
@end
