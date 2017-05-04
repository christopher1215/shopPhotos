//
//  HomePageCountModel.m
//  ShopPhotos
//
//  Created by addcn on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "HomePageCountModel.h"

@implementation HomePageCountModel

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status) return;
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        self.collectPhotosCount =  [RequestErrorGrab getIntegetKey:@"collectPhotosCount" toTarget:json];
        self.collectVideosCount =  [RequestErrorGrab getIntegetKey:@"collectVideosCount" toTarget:json];
        self.noticesCount =  [RequestErrorGrab getIntegetKey:@"noticesCount" toTarget:json];
        self.conernsCount =  [RequestErrorGrab getIntegetKey:@"conernsCount" toTarget:json];
        self.passiveConcernsCount =  [RequestErrorGrab getIntegetKey:@"passiveConcernsCount" toTarget:json];
        self.integral = [RequestErrorGrab getIntegetKey:@"integral" toTarget:json];
        self.capacity = [RequestErrorGrab getIntegetKey:@"capacity" toTarget:json];
        self.unfinishedOrdersCount = [RequestErrorGrab getIntegetKey:@"unfinishedOrdersCount" toTarget:json];
        self.used = [RequestErrorGrab getStringwitKey:@"used" toTarget:json];
        
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }
    
}

@end
