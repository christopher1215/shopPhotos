//
//  PublishTask.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/7.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PublishTask.h"
#import "CongfingURL.h"
#import "NSObject+StoreValue.h"
#import "HTTPRequest.h"
#import "CreatePhotosRequset.h"
#import "AddHandleImageNameRequset.h"
#import <UIKit/UIKit.h>
#import <AFNetworking.h>

#define PublishURL @"http://upload.qiniu.com"


@interface PublishTask ()

@property (strong, nonatomic) NSMutableDictionary * postData;
@property (strong, nonatomic) CompletePulish completeStatu;

@end

@implementation PublishTask

- (void)startTask:(NSDictionary *)data complete:(CompletePulish)completeStatu{
    _completeStatu = completeStatu;
    NSLog(@"---- > %@",self);
    
    self.postData = [[NSMutableDictionary alloc] initWithDictionary:data];
    NSDictionary * pod = @{@"name":@"",
                           @"price":@"",
                         @"subclassification_id":@"0"};
    [self createPhotos:pod];
}

- (void)createPhotos:(NSDictionary *)data{
    
    //[self showLoad];
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.createPhoto parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        CreatePhotosRequset * requset = [[CreatePhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            NSLog(@"%@",requset.photosID);
            
            NSMutableString * imageName = [NSMutableString string];
            [weakSelef.postData setValue:requset.photosID forKey:photosIDKey];
            NSArray * images = [weakSelef.postData objectForKey:imagesKey];
            NSLog(@"当前的照片有%ld",images.count);
            
            for(NSInteger index = 0;index<images.count;index++){
                if(index == 0){
                    [imageName appendFormat:@"%@_%ld.png",[self getDateSteing],index];
                }else{
                    [imageName appendFormat:@"*%@_%ld.png",[self getDateSteing],index];
                }
            }
            [self addHandleImageName:@{@"images":imageName}];
        }
    } failure:^(NSError *error){
        _completeStatu(NO);
        //[weakSelef closeLoad];
        //[weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)addHandleImageName:(NSDictionary *)data{
    
    //[self showLoad];
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
//    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.handleImagesName parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        AddHandleImageNameRequset * requset = [[AddHandleImageNameRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            
            NSDictionary * postDat = @{@"token":requset.uploadToken,
                                       @"key":requset.images};
            [self postImageToQiniu:postDat];
            
        }else{
            //[weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        //[weakSelef showToast:NETWORKTIPS];
        _completeStatu(NO);
    }];
}


- (void)postImageToQiniu:(NSDictionary *)data{
    
//    __weak __typeof(self)weakSelef = self;
    NSArray * images = [data objectForKey:@"key"];
    NSMutableString  * imageName = [[NSMutableString alloc] init];
    NSMutableString * dataSize = [[NSMutableString alloc] init];
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
            NSDictionary * postDat = @{@"key":key,
                                       @"token":[data objectForKey:@"token"]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer.timeoutInterval = 300;
            [manager POST:PublishURL parameters:postDat constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSString *fileName = [NSString  stringWithFormat:@"%@.png", [self getDateSteing]];
                if(imageData){
                    [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
                }
                
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                NSLog(@"%@",responseObject);
                ++count;
                NSLog(@"%ld---->>>><<<<<<-- %ld",count,images.count);
                BaseModel * model  = [[BaseModel alloc] init];
                [model analyticInterface:responseObject];
                if(count == images.count){
                    NSLog(@"55555 %@",imageName);
                    [self.postData setValue:imageName forKey:imageNameKey];
                    [self.postData setValue:dataSize forKey:dataSizeKey];
                    [self useSave];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error.userInfo);
                //[weakSelef closeLoad];
                //[weakSelef showToast:@"上传失败"];
                _completeStatu(NO);
            }];
            
            index ++;
        }
    }
}


- (void)useSave{
    
    NSString * recommend = [self.postData objectForKey:recommendSwhKey];
    NSString * subName = [self.postData objectForKey:subEnterTextKey];
    NSString * faName = [self.postData objectForKey:faherEnterTextKey];
    NSString * imageName = [self.postData objectForKey:imageNameKey];
    NSString * dataSize = [self.postData objectForKey:dataSizeKey];
    NSString * price = [self.postData objectForKey:priceKey];;
    NSString * name = [self.postData objectForKey:publishNameKey];
    NSString * classify_id = [self.postData objectForKey:classify_idKey];
    NSString * subclassification_id = [self.postData objectForKey:subclassification_idKey];
    NSString * postPhotosID = [self.postData objectForKey:photosIDKey];
    NSString * description = [self.postData objectForKey:descriptionKey];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionary];
    [data setValue:imageName forKey:@"images"];
    [data setValue:dataSize forKey:@"filesSize"];
    [data setValue:price forKey:@"price"];
    [data setValue:name forKey:@"name"];
    [data setValue:recommend forKey:@"recommend"];
    [data setValue:faName forKey:@"newClassifyName"];
    [data setValue:subName forKey:@"newSubclassificationName"];
    [data setValue:subclassification_id forKey:@"subclassification_id"];
    [data setValue:classify_id forKey:@"classify_id"];
    [data setValue:postPhotosID forKey:@"photo_id"];
    [data setValue:description forKey:@"description"];
    [self savePhotos:data];
    
}



- (void)savePhotos:(NSDictionary *)data{
    
    //[self showLoad];
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
//    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.mobileSavePhoto parametric:data succed:^(id responseObject){
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

- (NSString *)getDateSteing{
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString * locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}

@end
