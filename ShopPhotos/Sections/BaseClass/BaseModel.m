//
//  BaseModel.m
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)analyticInterface:(NSDictionary *)data{
    // code
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        
    } @catch (NSException *exception) {
        
        self.status = 1;
        self.message = exception.name;//NETWORKTIPS;
    }
    
}
@end
