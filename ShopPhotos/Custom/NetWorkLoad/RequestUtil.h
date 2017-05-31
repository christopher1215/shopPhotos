//
//
//
//  功能：网络相关工具类
//  开发：廖检成
//  时间：2016.7.15
//

#import <Foundation/Foundation.h>

@interface RequestUtil : NSObject

/**
 *  保存cookie
 */
+ (void)saveCookies;

/**
 *  设置cookie
 */
+ (void)loadCookies;

@end
