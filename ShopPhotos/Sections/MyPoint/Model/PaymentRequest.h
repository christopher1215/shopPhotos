//
//  PaymentRequest.h
//  ShopPhotos
//
//  Created by Macbook on 03/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface PaymentRequest : BaseModel
@property (strong, nonatomic) NSString * orderId;
@property (strong, nonatomic) NSString * timestamps;
@property (strong, nonatomic) NSDictionary * config;
@property (strong, nonatomic) NSString * configStr;

@end
