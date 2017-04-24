//
//
//
//  功能：基于AFNetWorking封装的请求库
//  开发：Stanley
//  时间：2016.11.1
//

#import <Foundation/Foundation.h>

#define ContentType @"application/json",@"text/plain", @"text/json", @"text/javascript",@"text/html"

typedef void(^Success)(id responseObject);
typedef void(^Failure)(NSError *error);

@interface HTTPRequest : NSObject


#pragma mark - 异步GET请求
+(void)requestGETUrl:(NSString*)url
          parametric:(NSDictionary*)dic
              succed:(Success)succed
             failure:(Failure)failure;


#pragma mark - 异步POST请求
+(void)requestPOSTUrl:(NSString*)url
           parametric:(NSDictionary*)dic
               succed:(Success)succed
              failure:(Failure)failure;

#pragma mark - 异步PUT请求
+(void)requestPUTUrl:(NSString*)url
          parametric:(NSDictionary*)dic
              succed:(Success)succed
             failure:(Failure)failure;
#pragma mark - 异步DELETE请求
+(void)requestDELETEUrl:(NSString*)url
             parametric:(NSDictionary*)dic
                 succed:(Success)succed
                failure:(Failure)failure;

#pragma mark - 上传图片
+(void)Manager:(NSString*)url
        Method:(NSString*)Method
           dic:(NSDictionary*)dic
          file:(NSData *)data
      fileName:(NSString *)fileName
 requestSucced:(Success)Succed
requestfailure:(Failure)failure;

@end
