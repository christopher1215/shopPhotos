//
//  CopyRequset.m
//  ShopPhotos
//
//  Created by addcn on 17/1/10.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "CopyRequset.h"

@implementation CopyRequset


- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        self.allow  = [RequestErrorGrab getBooLwitKey:@"data" toTarget:data];
        
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = exception.name;//NETWORKTIPS;
    }
}

@end
