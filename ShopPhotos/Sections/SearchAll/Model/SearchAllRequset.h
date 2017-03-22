//
//  SearchAllRequset.h
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface SearchAllRequset : BaseModel

@property (strong, nonatomic) NSMutableArray * users;
@property (strong, nonatomic) NSMutableArray * photos;
@property (strong, nonatomic) NSMutableArray * selfPhotos;

@end
