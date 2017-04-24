//
//  createPhoto2Model.m
//  ShopPhotos
//
//  Created by addcn on 17/1/2.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "CreatePhoto2Model.h"

@implementation CreatePhoto2Model

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        self.key = [RequestErrorGrab getStringwitKey:@"key" toTarget:data];
        self.hash = [RequestErrorGrab getStringwitKey:@"hash" toTarget:data];
    } @catch (NSException *exception) {
        self.message = NETWORKTIPS;
        self.status = 1;
    }
}

@end

