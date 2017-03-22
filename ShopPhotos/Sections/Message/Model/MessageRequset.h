//
//  MessageRequset.h
//  ShopPhotos
//
//  Created by addcn on 16/12/28.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface MessageRequset : BaseModel

@property (strong, nonatomic) NSMutableArray * dataArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger pageCount;
@property (assign, nonatomic) NSInteger resultsLength;

@end
