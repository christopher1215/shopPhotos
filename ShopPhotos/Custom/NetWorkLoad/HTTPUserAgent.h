//
//
//
//  功能：获取网络请求头部信息
//  开发：Stanley
//  时间：2016.11.2
//

#import <Foundation/Foundation.h>

#define ADDCNUSERAGENTKEY   @"User-Agent"

@interface HTTPUserAgent : NSObject

+ (HTTPUserAgent *)getHTTPUserAgent;

- (NSString *)getUserAgent;

- (NSString *)getToken;
@end
