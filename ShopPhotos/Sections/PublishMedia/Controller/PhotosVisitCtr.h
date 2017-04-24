//
//  PhotosVisitCtr.h
//  ShopPhotos
//
//  Created by addcn on 17/1/3.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseViewCtr.h"

@interface PhotosVisitCtr : BaseViewCtr

- (void)setVisiImage:(NSArray *)imageArray startIndex:(NSInteger)index;

@property (strong, nonatomic) NSMutableArray * dataArray;
@property (assign, nonatomic) NSInteger startIndex;
@end
