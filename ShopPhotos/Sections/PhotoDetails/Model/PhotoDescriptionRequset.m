//
//  PhotoDescriptionRequset.m
//  ShopPhotos
//
//  Created by addcn on 16/12/31.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PhotoDescriptionRequset.h"

@implementation PhotoDescriptionRequset

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        self.photoDesciption = [RequestErrorGrab getStringwitKey:@"data" toTarget:data];
    } @catch (NSException *exception) {
        self.message = exception.name;//NETWORKTIPS;
        self.status = 1;
    }
}

@end
