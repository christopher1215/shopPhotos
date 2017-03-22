//
//  AlbumPhotosRequset.h
//  ShopPhotos
//
//  Created by addcn on 16/12/24.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface AlbumPhotosRequset : BaseModel

@property (assign, nonatomic) NSInteger pagination;
@property (assign, nonatomic) NSInteger pageCount;
@property (assign, nonatomic) NSInteger resultsLength;
@property (strong, nonatomic) NSMutableArray * dataArray;

@end
