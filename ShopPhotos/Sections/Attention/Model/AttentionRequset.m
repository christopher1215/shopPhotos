//
//  AttentionRequset.m
//  ShopPhotos
//
//  Created by addcn on 16/12/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AttentionRequset.h"
#import "AttentionModel.h"

@implementation AttentionRequset

- (void)analyticInterface:(NSDictionary *)data{

    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status)return;
        self.dataArray = [NSMutableArray array];
        NSArray * json = [RequestErrorGrab getArrwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            
            for(NSDictionary * attention in json){
                
                AttentionModel  * model = [[AttentionModel alloc] init];
                model.date = [RequestErrorGrab getStringwitKey:@"date" toTarget:attention];
                model.icon = [RequestErrorGrab getStringwitKey:@"icon" toTarget:attention];
                model.itmeID = [RequestErrorGrab getStringwitKey:@"id" toTarget:attention];
                model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:attention];
                model.qq = [RequestErrorGrab getStringwitKey:@"qq" toTarget:attention];
                model.star = [RequestErrorGrab getBooLwitKey:@"star" toTarget:attention];
                model.tel = [RequestErrorGrab getStringwitKey:@"tel" toTarget:attention];
                model.twoWay = [RequestErrorGrab getBooLwitKey:@"twoWay" toTarget:attention];
                model.uid = [RequestErrorGrab getStringwitKey:@"uid" toTarget:attention];
                model.weixin = [RequestErrorGrab getStringwitKey:@"weixin" toTarget:attention];
                if(model.star){
                    [self.dataArray insertObject:model atIndex:0];
                }else{
                  [self.dataArray addObject:model];
                }
                
            }
        }
        
        
    } @catch (NSException *exception) {
        
    }
}

@end
