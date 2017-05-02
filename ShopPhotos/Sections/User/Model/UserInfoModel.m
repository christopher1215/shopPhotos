//
//  UserInfoModel.m
//  ShopPhotos
//
//  Created by addcn on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status)return;
        NSDictionary * result = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(result && result.count > 0){
            NSDictionary * user = [RequestErrorGrab getDicwitKey:@"user" toTarget:result];
            if(user && user.count > 0){
                self.uid = [RequestErrorGrab getStringwitKey:@"uid" toTarget:user];
                self.address = [RequestErrorGrab getStringwitKey:@"address" toTarget:user];
                self.avatar = [RequestErrorGrab getStringwitKey:@"avatar" toTarget:user];
                self.bg_image = [RequestErrorGrab getStringwitKey:@"bg_image" toTarget:user];
                self.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:user];
                self.name_abbr = [RequestErrorGrab getStringwitKey:@"name_abbr" toTarget:user];
                self.phone = [RequestErrorGrab getStringwitKey:@"phone" toTarget:user];
                self.qq = [RequestErrorGrab getStringwitKey:@"qq" toTarget:user];
                self.settings = [RequestErrorGrab getDicwitKey:@"settings" toTarget:user];
                self.signature = [RequestErrorGrab getStringwitKey:@"signature" toTarget:user];
                self.wechat = [RequestErrorGrab getStringwitKey:@"wechat" toTarget:user];
                self.email = [RequestErrorGrab getStringwitKey:@"email" toTarget:user];
                self.concerned = [RequestErrorGrab getIntegetKey:@"concerned" toTarget:user];
                self.integral = [RequestErrorGrab getIntegetKey:@"integral" toTarget:user];
            }
        }
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }
}

@end
