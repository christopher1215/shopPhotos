//
//  PublishTask.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/7.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PublishPhoto.h"
#import "CongfingURL.h"
#import "NSObject+StoreValue.h"
#import "HTTPRequest.h"
#import "CreatePhotosRequset.h"
#import "AddHandleImageNameRequset.h"
#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "CreatePhoto2Model.h"
#define PublishURL @"http://upload.qiniu.com"


@interface PublishPhoto ()
@property (strong, nonatomic) NSMutableDictionary * postData;
@property (strong, nonatomic) CompletePulish completeStatu;
@property (strong, nonatomic)AppDelegate *appd;
@end

@implementation PublishPhoto

- (void)startTask:(NSDictionary *)data complete:(CompletePulish)completeStatu {
    _completeStatu = completeStatu;
    NSLog(@"---- > %@",self);
    _appd = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.postData = [[NSMutableDictionary alloc] initWithDictionary:data];
//    NSDictionary * pod = @{@"filename":@"", @"subclassification_id":@"0"};
    [self createPhoto1];
}

- (void)createPhoto1{
    
    NSArray *imageArray = [self.postData objectForKey:@"images"];
    int index = 0;
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    
    for(NSData *imgData in imageArray) {
        [data setValue:[NSString stringWithFormat:@"%d.png",index+1] forKey:[NSString stringWithFormat:@"images[%d][filename]",index]];
        [data setValue:[NSString stringWithFormat:@"%ld",imgData.length] forKey:[NSString stringWithFormat:@"images[%d][size]",index]];
        index++;
    }
    
    //[self showLoad];
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl :[NSString stringWithFormat:@"%@%@",config.createPhoto1,[self.appd getParameterString]] parametric:data succed:^(id responseObject) {
        NSLog(@"%@",responseObject);
        CreatePhotosRequset * requset = [[CreatePhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            NSLog(@"%@",requset.qiniuToken);
            NSDictionary * postData = @{@"token":requset.qiniuToken,
                                       @"key":requset.imagesName};
            [weakSelef postImageToQiniu:postData];
        }
    } failure:^(NSError *error){
        _completeStatu(NO);
    }];
}

- (void)postImageToQiniu:(NSDictionary *)data{
    
//    __weak __typeof(self)weakSelef = self;
    NSArray * images = [data objectForKey:@"key"];
    NSMutableString  * imageName = [[NSMutableString alloc] init];
    NSMutableString * dataSize = [[NSMutableString alloc] init];
    NSMutableArray *aryRet = [[NSMutableArray alloc] init];
    if(images && images.count > 0){
        NSInteger index = 0;
       __block NSInteger count = 0;
        for(NSString * key in images){
            NSArray * images = [self.postData objectForKey:imagesKey];
            NSData *imageData = [images objectAtIndex:index];
            
            if(index == 0){
                [imageName appendFormat:@"%@",key];
                [dataSize appendFormat:@"%ld",imageData.length];
            }else{
                [imageName appendFormat:@"*%@",key];
                [dataSize appendFormat:@"*%ld",imageData.length];
            }
            NSDictionary * postData = @{@"key":key,
                                       @"token":[data objectForKey:@"token"]};
            CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer.timeoutInterval = 300;
            [manager POST:config.createPhoto2 parameters:postData constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSString *fileName = [NSString  stringWithFormat:@"%@.png", [self getDateSetting]];
                if(imageData){
                    [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
                }
            }progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                NSLog(@"%@",responseObject);
                ++count;
                NSLog(@"%ld---->>>><<<<<<-- %ld",count,images.count);
                CreatePhoto2Model * model  = [[CreatePhoto2Model alloc] init];
                [model analyticInterface:responseObject];
                [aryRet addObject:@{@"hash":model.hhash,@"key":model.key}];
                if ((index+1) == images.count) {
                    [self.postData setValue:aryRet forKey:@"imagekeys"];
                    [self savePhotos];
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

- (void)savePhotos{
    //[self showLoad];
    
    NSArray *imageinfoArray = [self.postData objectForKey:@"imagekeys"];
    int index = 0;
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    
    [data setValue:[self.postData objectForKey:@"classifyName"] forKey:@"classifyName"];
    [data setValue:[self.postData objectForKey:@"subclassName"] forKey:@"subclassName"];
    [data setValue:[self.postData objectForKey:@"title"] forKey:@"title"];
    [data setValue:[self.postData objectForKey:@"description"] forKey:@"description"];
    [data setValue:[self.postData objectForKey:@"recommend"] forKey:@"recommend"];
    
    int idxCover = [[self.postData objectForKey:@"idxCover"] intValue];
    for(NSDictionary *imgInfo in imageinfoArray) {
        [data setValue:[imgInfo objectForKey:@"key"] forKey:[NSString stringWithFormat:@"images[%d][filename]",index]];
        if (index == idxCover) {
            [data setValue:@"1" forKey:[NSString stringWithFormat:@"images[%d][cover]",index]];
        }
        else {
            [data setValue:@"0" forKey:[NSString stringWithFormat:@"images[%d][cover]",index]];
        }
        
        index++;
    }
    
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
//    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl :[NSString stringWithFormat:@"%@%@",config.createPhoto3,[self.appd getParameterString]] parametric:data succed:^(id responseObject) {
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
