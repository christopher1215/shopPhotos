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
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            self.icon = [RequestErrorGrab getStringwitKey:@"icon" toTarget:json];
            self.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:json];
            self.qq = [RequestErrorGrab getStringwitKey:@"qq" toTarget:json];
            self.weixin = [RequestErrorGrab getStringwitKey:@"weixin" toTarget:json];
            self.tel = [RequestErrorGrab getStringwitKey:@"tel" toTarget:json];
            self.qq_qrCode = [RequestErrorGrab getStringwitKey:@"qq_qrCode" toTarget:json];
            self.wx_qrCode = [RequestErrorGrab getStringwitKey:@"wx_qrCode" toTarget:json];
            self.uid = [RequestErrorGrab getStringwitKey:@"uid" toTarget:json];
            self.signature = [RequestErrorGrab getStringwitKey:@"signature" toTarget:json];
            self.address = [RequestErrorGrab getStringwitKey:@"address" toTarget:json];
            self.config = [RequestErrorGrab getDicwitKey:@"config" toTarget:json];
        }
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }
}

@end
