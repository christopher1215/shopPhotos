//
//  CreateVideo1Model.m
//  ShopPhotos
//
//  Created by  on 4/28/17.
//  Copyright © 2017 addcn. All rights reserved.
//
#import "CreateVideo1Model.h"

@implementation CreateVideo1Model

- (void)analyticInterface:(NSDictionary *)data {
    
    @try {
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            self.qiniuToken = [RequestErrorGrab getStringwitKey:@"qiniuToken" toTarget:json];
            self.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:json];
            self.video = [RequestErrorGrab getStringwitKey:@"video" toTarget:json];
        }
        
    } @catch (NSException *exception) {
        self.message = exception.name;//NETWORKTIPS;
        self.status = 1;
    }
}

@end
