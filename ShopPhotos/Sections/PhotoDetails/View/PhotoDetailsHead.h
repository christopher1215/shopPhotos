//
//  PhotoDetailsHead.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/25.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

#define Clearance 10

@protocol PhotoDetailsHeadDelegate <NSObject>

- (void)photoDetailsHeadSelectType:(NSInteger)type select:(NSInteger)indexPath;

@end

@interface PhotoDetailsHead : BaseView
@property (weak, nonatomic)id<PhotoDetailsHeadDelegate>delegate;
- (CGFloat)setStyle:(NSArray *)imageArray;

@end
