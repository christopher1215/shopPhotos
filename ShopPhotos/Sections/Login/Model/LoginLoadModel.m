//
//  LoginLoadModel.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "LoginLoadModel.h"
#import "UserModel.h"
#import "NSObject+StoreValue.h"

@implementation LoginLoadModel

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status)return;
        NSDictionary * result = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(result && result.count > 0){
            self.userID = [RequestErrorGrab getStringwitKey:@"uid" toTarget:result];
            if(self.userID && self.userID.length > 0){
                UserModel * userModel = [[UserModel alloc] init];
                userModel.userID = self.userID;
                [self setValue:userModel WithKey:CacheUserModel];
            }
        }
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }
}

@end
