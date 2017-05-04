//
//  HomePageCountModel.h
//  ShopPhotos
//
//  Created by addcn on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface HomePageCountModel : BaseModel

@property (assign, nonatomic) NSInteger collectPhotosCount;
@property (assign, nonatomic) NSInteger collectVideosCount;
@property (assign, nonatomic) NSInteger noticesCount;
@property (assign, nonatomic) NSInteger conernsCount;
@property (assign, nonatomic) NSInteger passiveConcernsCount;
@property (assign, nonatomic) NSInteger integral;
@property (assign, nonatomic) NSInteger capacity;
@property (assign, nonatomic) NSInteger unfinishedOrdersCount;
@property (strong, nonatomic) NSString * used;

@end
