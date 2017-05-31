//
//  hasCollectPhotoRequset.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/4.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "HasCollectPhotoRequset.h"

@implementation HasCollectPhotoRequset

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        self.hasCollect = [RequestErrorGrab getBooLwitKey:@"data" toTarget:data];
        
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = exception.name;//NETWORKTIPS;
    }
}

@end
