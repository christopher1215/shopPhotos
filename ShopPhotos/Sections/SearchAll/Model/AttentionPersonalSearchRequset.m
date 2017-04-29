//
//  AttentionPersonalSearchRequset.m
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "AttentionPersonalSearchRequset.h"
#import "AttentionPersonalSearchModel.h"

@implementation AttentionPersonalSearchRequset

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        self.dataArray = [NSMutableArray array];
        NSDictionary * datas = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        NSArray * json = [RequestErrorGrab getArrwitKey:@"users" toTarget:datas];
        if(json && json.count > 0){
            for (NSDictionary * user in json) {
                AttentionPersonalSearchModel * model = [[AttentionPersonalSearchModel alloc] init];
                model.date = [RequestErrorGrab getStringwitKey:@"date" toTarget:user];
                model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:user];
                model.qq = [RequestErrorGrab getStringwitKey:@"qq" toTarget:user];
                model.tel = [RequestErrorGrab getStringwitKey:@"tel" toTarget:user];
                model.weixin = [RequestErrorGrab getStringwitKey:@"weixin" toTarget:user];
                model.icon = [RequestErrorGrab getStringwitKey:@"icon" toTarget:user];
                model.itmeID = [RequestErrorGrab getIntegetKey:@"id" toTarget:user];
                model.uid = [RequestErrorGrab getStringwitKey:@"uid" toTarget:user];
                [self.dataArray addObject:model];
            }
        }
        
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }
}

@end
