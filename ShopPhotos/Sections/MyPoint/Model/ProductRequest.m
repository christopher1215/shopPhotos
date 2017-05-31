//
//  ProductRequest.m
//  ShopPhotos
//
//  Created by Macbook on 03/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "ProductRequest.h"
#import "ProductModel.h"

@implementation ProductRequest
- (void)analyticInterface:(NSDictionary *)data{
    @try {
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status)return;
        
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            self.dataArray = [NSMutableArray array];
            NSArray * products = [RequestErrorGrab getArrwitKey:@"products" toTarget:json];
            
            if(products && products.count > 0){
                for(NSDictionary * product in products){
                    [self.dataArray addObject:[self analysting:product]];
                }
            }
        }
    } @catch (NSException *exception) {
        self.message = exception.name;//NETWORKTIPS;
        self.status = 0;
    }
}
- (ProductModel *) analysting:(NSDictionary *)photo {
    
    ProductModel * model = [[ProductModel alloc] init];
    model.productId = [RequestErrorGrab getIntegetKey:@"id" toTarget:photo];
    model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:photo];
    model.desc = [RequestErrorGrab getStringwitKey:@"description" toTarget:photo];
    model.discount = [RequestErrorGrab getStringwitKey:@"discount" toTarget:photo];
    model.price = [RequestErrorGrab getStringwitKey:@"price" toTarget:photo];
    model.integral = [RequestErrorGrab getIntegetKey:@"integral" toTarget:photo];
    
    return model;
}

@end
