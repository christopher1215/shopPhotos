//
//  PointLogRequest.m
//  ShopPhotos
//
//  Created by Macbook on 04/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "PointLogRequest.h"
#import "PointLog.h"
@implementation PointLogRequest
- (void)analyticInterface:(NSDictionary *)data{
    @try {
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status)return;
        
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            self.pageCount = [RequestErrorGrab getIntegetKey:@"pageSize" toTarget:json];
            self.dataArray = [NSMutableArray array];
            NSArray * logs = [RequestErrorGrab getArrwitKey:@"logs" toTarget:json];
            
            if(logs && logs.count > 0){
                for(NSDictionary * log in logs){
                    [self.dataArray addObject:[self analysting:log]];
                }
            }
        }
    } @catch (NSException *exception) {
        self.message = NETWORKTIPS;
        self.status = 0;
    }
}
- (PointLog *) analysting:(NSDictionary *)photo {
    
    PointLog * model = [[PointLog alloc] init];
    model.dateDiff = [RequestErrorGrab getStringwitKey:@"dateDiff" toTarget:photo];
    model.diff = [NSString stringWithFormat:@"%ld", (long)[RequestErrorGrab getIntegetKey:@"diff" toTarget:photo]];
    model.desc = [RequestErrorGrab getStringwitKey:@"description" toTarget:photo];
    model.date = [RequestErrorGrab getStringwitKey:@"date" toTarget:photo];
    model.integral = [RequestErrorGrab getStringwitKey:@"integral" toTarget:photo];
    return model;
}

@end
