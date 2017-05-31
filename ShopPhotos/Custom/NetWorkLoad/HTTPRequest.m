//
//  HTTPRequest.m
//  platform
//
//  Created by addcn on 16/11/1.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "HTTPRequest.h"
#import <AFNetworking.h>
#import "HTTPUserAgent.h"
#import "Util.h"
#import "RequestUtil.h"
#import "CongfingURL.h"
#import "NSObject+StoreValue.h"

#define RequestGet  @"GET"
#define RequestPost @"Post"
#define RequestPut  @"Put"


@implementation HTTPRequest

//默认网络请求时间
static const NSUInteger kDefaultTimeoutInterval = 10;

#pragma mark - 异步GET请求
+ (void)requestGETUrl:(NSString*)url
           parametric:(NSDictionary*)dic
               succed:(Success)succed
              failure:(Failure)failure{
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary:dic];
    //    NSString * token = [[HTTPUserAgent getHTTPUserAgent] getToken];
    //    if(token && token.length > 0){
    //        [data setValue:[NSString stringWithFormat:@"Bearer %@", [[HTTPUserAgent getHTTPUserAgent] getToken]] forKey:@"Authorization"];
    //    }
    [HTTPRequest Manager:url Method:RequestGet dic:data requestSucced:^(id responseObject) {
        
        if(succed)succed(responseObject);
        
    } requestfailure:^(NSError *error) {
        
        if(failure)failure(error);
        
    }];
}

#pragma mark - 异步POST请求
+ (void)requestPOSTUrl:(NSString*)url
            parametric:(NSDictionary*)dic
                succed:(Success)succed
               failure:(Failure)failure{
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSLog(@"--- > %@",data);
    
    [HTTPRequest Manager:url Method:RequestPost dic:data requestSucced:^(id responseObject) {
        
        if(succed)succed(responseObject);
        
    } requestfailure:^(NSError *error) {
        
        if(failure)failure(error);
    }];
}

+ (void)requestPUTUrl:(NSString*)url
           parametric:(NSDictionary*)dic
               succed:(Success)succed
              failure:(Failure)failure{
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary:dic];
    //    NSString * token = [[HTTPUserAgent getHTTPUserAgent] getToken];
    //    if(token && token.length > 0){
    //        [data setValue:[NSString stringWithFormat:@"Bearer %@", [[HTTPUserAgent getHTTPUserAgent] getToken]] forKey:@"Authorization"];
    //    }
    [data setValue:@"put" forKey:@"_method"];
    
    NSLog(@"--- > %@",data);
    
    [HTTPRequest Manager:url Method:RequestPost dic:data requestSucced:^(id responseObject) {
        
        if(succed)succed(responseObject);
        
    } requestfailure:^(NSError *error) {
        
        if(failure)failure(error);
    }];
}
+ (void)requestDELETEUrl:(NSString*)url
              parametric:(NSDictionary*)dic
                  succed:(Success)succed
                 failure:(Failure)failure{
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary:dic];
    //    NSString * token = [[HTTPUserAgent getHTTPUserAgent] getToken];
    //    if(token && token.length > 0){
    //        [data setValue:[NSString stringWithFormat:@"Bearer %@", [[HTTPUserAgent getHTTPUserAgent] getToken]] forKey:@"Authorization"];
    //    }
    [data setValue:@"delete" forKey:@"_method"];
    
    NSLog(@"--- > %@",data);
    
    [HTTPRequest Manager:url Method:RequestPost dic:data requestSucced:^(id responseObject) {
        
        if(succed)succed(responseObject);
        
    } requestfailure:^(NSError *error) {
        
        if(failure)failure(error);
    }];
}

#pragma mark - 网络请求
+ (void)Manager:(NSString*)url
         Method:(NSString*)Method
            dic:(NSDictionary*)dic
  requestSucced:(Success)Succed
 requestfailure:(Failure)failure{
    
    //[RequestUtil loadCookies];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kDefaultTimeoutInterval;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    [manager.requestSerializer setValue:[[HTTPUserAgent getHTTPUserAgent] getUserAgent] forHTTPHeaderField:ADDCNUSERAGENTKEY];
    NSString * token = [[HTTPUserAgent getHTTPUserAgent] getToken];
    if(token && token.length > 0){
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [[HTTPUserAgent getHTTPUserAgent] getToken]] forHTTPHeaderField:@"Authorization"];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:ContentType, nil];
    
    
    if ([Method isEqualToString:RequestGet]) {
        
        [manager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //[RequestUtil saveCookies];
            
            if(Succed)Succed(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if(failure)failure(error);
        }];
        
    }else{
        
        [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //[RequestUtil saveCookies];
            if(Succed)Succed(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if(failure)failure(error);
        }];
    }
}

+ (void)Manager:(NSString*)url
         Method:(NSString*)Method
            dic:(NSDictionary*)dic
           file:(NSData *)data
       fileName:(NSString *)fileName
  requestSucced:(Success)Succed
 requestfailure:(Failure)failure{
    
    NSMutableDictionary * postData = [NSMutableDictionary dictionaryWithDictionary:dic];
    [postData setValue:[[HTTPUserAgent getHTTPUserAgent] getToken] forKey:@"_token"];
    
    //[RequestUtil loadCookies];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[[HTTPUserAgent getHTTPUserAgent] getUserAgent] forHTTPHeaderField:ADDCNUSERAGENTKEY];
    NSString * token = [[HTTPUserAgent getHTTPUserAgent] getToken];
    if(token && token.length > 0){
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [[HTTPUserAgent getHTTPUserAgent] getToken]] forHTTPHeaderField:@"Authorization"];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:ContentType, nil];
    [manager POST:url parameters:postData constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *file = [NSString  stringWithFormat:@"%@.jpg", dateString];
        [formData appendPartWithFileData:data name:fileName fileName:file mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        //[RequestUtil saveCookies];
        if(Succed)Succed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)failure(error);
    }];
    
}

#pragma mark -  ssl 验证
+ (AFSecurityPolicy*)customSecurityPolicy{
    
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"uootu.com" ofType:@"cer"];
    NSData * certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates =  [[NSSet alloc] initWithObjects:certData,nil];
    return securityPolicy;
}

@end
