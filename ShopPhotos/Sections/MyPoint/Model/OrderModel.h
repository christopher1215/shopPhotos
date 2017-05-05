//
//  OrderModel.h
//  ShopPhotos
//
//  Created by Macbook on 03/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface OrderModel : BaseModel
@property (assign, nonatomic) int orderId;
@property (strong, nonatomic) NSString * paidFee;
@property (strong, nonatomic) NSString * createdAt;
@property (strong, nonatomic) NSString * dateDiff;
@property (strong, nonatomic) NSString * productId;
@property (assign, nonatomic) BOOL state;
@property (strong, nonatomic) NSString * channel;

@end
