//
//  PhotosEditView.h
//  ShopPhotos
//
//  Created by addcn on 16/12/26.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol PhotosEditViewDelegate <NSObject>

- (void)photosEditSelected:(NSInteger)type;

@end

@interface PhotosEditView : BaseView

@property (weak, nonatomic) id<PhotosEditViewDelegate>delegate;
@property (assign, nonatomic) BOOL allSelectStatus;

@property (strong, nonatomic) UIButton * cancel;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UIButton * all;

- (void)setSelectedCount:(NSInteger)count;
@end
