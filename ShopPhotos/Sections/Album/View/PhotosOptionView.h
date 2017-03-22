//
//  PhotosOptionView.h
//  ShopPhotos
//
//  Created by addcn on 16/12/26.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol PhotosOptionViewDelegate <NSObject>

- (void)photosOptionSelected:(NSInteger)type;

@end

@interface PhotosOptionView : BaseView

@property (weak, nonatomic) id<PhotosOptionViewDelegate>delegate;

@end
