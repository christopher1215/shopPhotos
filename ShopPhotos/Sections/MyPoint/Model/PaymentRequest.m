//
//  PaymentRequest.m
//  ShopPhotos
//
//  Created by Macbook on 03/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "PaymentRequest.h"

@implementation PaymentRequest
- (void)analyticInterface:(NSDictionary *)data{
    @try {
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status)return;
        
        NSDictionary * order = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        self.config = [RequestErrorGrab getDicwitKey:@"config" toTarget:order];
        self.configStr = [RequestErrorGrab getStringwitKey:@"config" toTarget:order];
        self.orderId = [RequestErrorGrab getStringwitKey:@"orderId" toTarget:order];
        self.timestamps = [RequestErrorGrab getStringwitKey:@"timestamps" toTarget:order];
    } @catch (NSException *exception) {
        self.message = NETWORKTIPS;
        self.status = 0;
    }
}


@end
