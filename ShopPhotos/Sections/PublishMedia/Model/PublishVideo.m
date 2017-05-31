//
//  PublishTask.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/7.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PublishVideo.h"
#import "CongfingURL.h"
#import "NSObject+StoreValue.h"
#import "HTTPRequest.h"
#import "AddHandleImageNameRequset.h"
#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "CreatePhoto2Model.h"
#import "CreateVideo1Model.h"
#define PublishURL @"http://upload.qiniu.com"

@interface PublishVideo ()
@property (strong, nonatomic) NSMutableDictionary * postData;
@property (strong, nonatomic) CompletePulish completeStatu;
@property (strong, nonatomic)AppDelegate *appd;
@end

@implementation PublishVideo

- (void)startTask:(NSDictionary *)data complete:(CompletePulish)completeStatu {
    _completeStatu = completeStatu;
    NSLog(@"---- > %@",self);
    _appd = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.postData = [[NSMutableDictionary alloc] initWithDictionary:data];
    //    NSDictionary * pod = @{@"filename":@"", @"subclassification_id":@"0"};
    [self createVideo1];
}

- (void)createVideo1{
    
    NSDictionary * data = @{@"video":@{@"filename":@"video.mp4",@"size":[self.postData objectForKey:@"videosize"]},
                            @"cover":@{@"filename":@"cover.png",@"size":[self.postData objectForKey:@"coversize"]}};
    //[self showLoad];
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl :[NSString stringWithFormat:@"%@%@",config.createVideo1,[self.appd getParameterString]] parametric:data succed:^(id responseObject) {
        NSLog(@"%@",responseObject);
        CreateVideo1Model * requset = [[CreateVideo1Model alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            NSLog(@"%@",requset.qiniuToken);
            NSDictionary * postData = @{@"token":requset.qiniuToken,
                                        @"coverkey":requset.cover,
                                        @"videokey":requset.video};
            [weakSelef postImageToQiniu:postData];
        }
    } failure:^(NSError *error){
        _completeStatu(NO);
    }];
}

- (void)postImageToQiniu:(NSDictionary *)data{
    //    __weak __typeof(self)weakSelef = self;
    NSArray * keys = [[NSArray alloc] initWithObjects:[data objectForKey:@"coverkey"],[data objectForKey:@"videokey"], nil];
    if(keys && keys.count > 0){
        NSInteger index = 0;
        __block NSInteger count = 0;
        for(NSString * key in keys){
//            NSArray * images = [self.postData objectForKey:imagesKey];
            
            NSDictionary * postData = @{@"key":key,
                                        @"token":[data objectForKey:@"token"]};
            CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer.timeoutInterval = 300;
            

            [manager POST:config.createVideo2 parameters:postData constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                if(index == 0){
                    [formData appendPartWithFileData:[self.postData objectForKey:@"cover"] name:@"file" fileName:@"cover.png" mimeType:@"image/jpeg"];
                }
                else{
                    [formData appendPartWithFileData:[self.postData objectForKey:@"video"] name:@"file" fileName:@"video.png" mimeType:@"video/mp4"];
                }
            }progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                NSLog(@"%@",responseObject);
                ++count;
                if ((index+1) == keys.count) {
//                    [self.postData setValue:[data objectForKey:@"coverkey"] forKey:@"coverkey"];
//                    [self.postData setValue:[data objectForKey:@"videokey"] forKey:@"videokey"];
                    [self saveVideo:data];
                }
            }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error.userInfo);
                //[weakSelef closeLoad];
                //[weakSelef showToast:@"上传失败"];
                _completeStatu(NO);
            }];
            
            index ++;
        }
    }
}

- (void)saveVideo:(NSDictionary *)keydata{
    //[self showLoad];
    
    NSDictionary * data = @{@"title":[self.postData objectForKey:@"title"],
                            @"video":[keydata objectForKey:@"videokey"],
                            @"cover":[keydata objectForKey:@"coverkey"]};
    
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    //    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl :[NSString stringWithFormat:@"%@%@",config.createVideo3,[self.appd getParameterString]] parametric:data succed:^(id responseObject) {
        //[weakSelef closeLoad];
        NSLog(@"上传成功%@",responseObject);
        //[weakSelef showToast:@"上传成功"];
        _completeStatu(YES);
        
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        // [weakSelef showToast:@"上传失败"];
        _completeStatu(NO);
    }];
}

- (NSString *)getDateSetting{
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString * locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}

@end
