//
//  ProductModel.h
//  ShopPhotos
//
//  Created by Macbook on 03/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface ProductModel : BaseModel
@property (assign, nonatomic) int productId;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * desc;
@property (strong, nonatomic) NSString * discount;
@property (strong, nonatomic) NSString * price;
@property (assign, nonatomic) int integral;

@end
