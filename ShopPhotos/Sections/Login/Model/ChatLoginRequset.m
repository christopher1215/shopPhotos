//
//  ChatLoginRequset.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/7.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "ChatLoginRequset.h"
#import "UserModel.h"
#import "NSObject+StoreValue.h"

@implementation ChatLoginRequset

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status)return;
        NSDictionary * result = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(result && result.count > 0){
            self.authToken = [RequestErrorGrab getStringwitKey:@"authToken" toTarget:result];
            [self setValue:self.authToken WithKey:@"authToken"];
            self.imToken = [RequestErrorGrab getStringwitKey:@"imToken" toTarget:result];
            NSDictionary * user = [RequestErrorGrab getDicwitKey:@"user" toTarget:result];
            if(user && user.count > 0){
                UserModel * userModel = [[UserModel alloc] init];
                
                userModel.uid = [RequestErrorGrab getStringwitKey:@"uid" toTarget:user];
                userModel.address = [RequestErrorGrab getStringwitKey:@"address" toTarget:user];
                userModel.avatar = [RequestErrorGrab getStringwitKey:@"avatar" toTarget:user];
                userModel.bg_image = [RequestErrorGrab getStringwitKey:@"bg_image" toTarget:user];
                userModel.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:user];
                userModel.phone = [RequestErrorGrab getStringwitKey:@"phone" toTarget:user];
                userModel.qq = [RequestErrorGrab getStringwitKey:@"qq" toTarget:user];
                userModel.settings = [RequestErrorGrab getDicwitKey:@"settings" toTarget:user];
                userModel.signature = [RequestErrorGrab getStringwitKey:@"signature" toTarget:user];
                userModel.wechat = [RequestErrorGrab getStringwitKey:@"wechat" toTarget:user];
                userModel.email = [RequestErrorGrab getStringwitKey:@"email" toTarget:user];
                
                [self setValue:userModel WithKey:CacheUserModel];
            }
        }
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }}

@end
