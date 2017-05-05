//
//  PointLogRequest.h
//  ShopPhotos
//
//  Created by Macbook on 04/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface PointLogRequest : BaseModel
@property (assign, nonatomic) NSInteger pagination;
@property (assign, nonatomic) NSInteger pageCount;
@property (assign, nonatomic) NSInteger resultsLength;
@property (strong, nonatomic) NSMutableArray * dataArray;

@end
