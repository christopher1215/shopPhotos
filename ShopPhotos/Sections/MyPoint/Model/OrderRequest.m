//
//  OrderRequest.m
//  ShopPhotos
//
//  Created by Macbook on 03/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "OrderRequest.h"
#import "OrderModel.h"

@implementation OrderRequest
- (void)analyticInterface:(NSDictionary *)data{
    @try {
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status)return;
        
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            self.pageCount = [RequestErrorGrab getIntegetKey:@"pageSize" toTarget:json];
            self.dataArray = [NSMutableArray array];
            NSArray * orders = [RequestErrorGrab getArrwitKey:@"order" toTarget:json];
            
            if(orders && orders.count > 0){
                for(NSDictionary * photo in orders){
                    [self.dataArray addObject:[self analysting:photo]];
                }
            }
        }
    } @catch (NSException *exception) {
        self.message = exception.name;//NETWORKTIPS;
        self.status = 0;
    }
}
- (OrderModel *) analysting:(NSDictionary *)photo {
    
    OrderModel * model = [[OrderModel alloc] init];
    model.orderId = [RequestErrorGrab getIntegetKey:@"orderId" toTarget:photo];
    model.dateDiff = [RequestErrorGrab getStringwitKey:@"dateDiff" toTarget:photo];
    model.paidFee = [RequestErrorGrab getStringwitKey:@"paidFee" toTarget:photo];
    model.productId = [RequestErrorGrab getStringwitKey:@"productId" toTarget:photo];
    model.createdAt = [RequestErrorGrab getStringwitKey:@"createdAt" toTarget:photo];
    model.channel = [RequestErrorGrab getStringwitKey:@"channel" toTarget:photo];
    model.createdAt = [RequestErrorGrab getStringwitKey:@"createdAt" toTarget:photo];
    model.state = [RequestErrorGrab getBooLwitKey:@"state" toTarget:photo];
    
    return model;
}

@end
