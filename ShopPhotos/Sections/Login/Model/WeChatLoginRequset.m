//
//  WeChatLoginRequset.m
//  ShopPhotos
//
//  Created by addcn on 17/1/6.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "WeChatLoginRequset.h"
#import "UserModel.h"
#import "NSObject+StoreValue.h"

@implementation WeChatLoginRequset

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status == 0){
           self.userID = [RequestErrorGrab getStringwitKey:@"data" toTarget:data];
            if(self.userID && self.userID.length > 0 && self.status == 0){
                UserModel * userModel = [[UserModel alloc] init];
                userModel.uid = self.userID;
                [self setValue:userModel WithKey:CacheUserModel];
            }
        }else{
           self.userData = [RequestErrorGrab getDicwitKey:@"data" toTarget:data]; 
        }
        
        
        
        
        
        
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = exception.name;//NETWORKTIPS;
    }
}

@end
