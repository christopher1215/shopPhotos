//
//  AddHandleImageNameRequset.m
//  ShopPhotos
//
//  Created by addcn on 17/1/2.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "AddHandleImageNameRequset.h"

@implementation AddHandleImageNameRequset

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        self.images = [NSMutableArray array];
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            NSArray * name = [RequestErrorGrab getArrwitKey:@"names" toTarget:json];
            if(name && name.count > 0){
                [self.images addObjectsFromArray:name];
            }
            
            self.uploadToken = [RequestErrorGrab getStringwitKey:@"uploadToken" toTarget:json];
        }
        
        
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }
}

@end
