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
        self.collectsCount =  [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"collectsCount" toTarget:json]];
        self.noticesCount = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"noticesCount" toTarget:json]];
        self.totalCapacity = [RequestErrorGrab getStringwitKey:@"totalCapacity" toTarget:json];
        self.used = [RequestErrorGrab getStringwitKey:@"used" toTarget:json];
        
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }
    
}

@end
