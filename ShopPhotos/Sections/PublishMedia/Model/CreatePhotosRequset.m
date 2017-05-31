//
//  createPhotosRequset.m
//  ShopPhotos
//
//  Created by addcn on 17/1/2.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "CreatePhotosRequset.h"

@implementation CreatePhotosRequset

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        self.imagesName = [NSMutableArray array];
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            self.qiniuToken = [RequestErrorGrab getStringwitKey:@"qiniuToken" toTarget:json];
            NSArray * name = [RequestErrorGrab getArrwitKey:@"imagesName" toTarget:json];
            if(name && name.count > 0){
                [self.imagesName addObjectsFromArray:name];
            }
        }
        
    } @catch (NSException *exception) {
        self.message = exception.name;//NETWORKTIPS;
        self.status = 1;
    }
}

@end

