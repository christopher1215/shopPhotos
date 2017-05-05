//
//  PointLog.h
//  ShopPhotos
//
//  Created by Macbook on 04/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface PointLog : BaseModel
@property (strong, nonatomic) NSString * diff;
@property (strong, nonatomic) NSString * date;
@property (strong, nonatomic) NSString * dateDiff;
@property (strong, nonatomic) NSString * desc;
@property (strong, nonatomic) NSString * integral;

@end
