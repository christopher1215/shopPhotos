//
//  UserModel.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "UserModel.h"
#import "NSObject+StoreValue.h"

@implementation UserModel

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
                [self setValue:self WithKey:CacheUserModel];
            }
        }
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = exception.name;//NETWORKTIPS;
    }
}
@end
