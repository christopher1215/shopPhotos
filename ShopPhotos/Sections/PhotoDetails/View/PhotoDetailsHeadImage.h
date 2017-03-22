//
//  PhotoDetailsHeadImage.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/25.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

#define ImageHeight 120

@interface PhotoDetailsHeadImage : BaseView
@property (strong, nonatomic) UIImageView * image;
@property (strong, nonatomic) UIImageView * cover;
@property (strong, nonatomic) UIView * editView;
@property (strong, nonatomic) UIButton * settingBtn;
@property (strong, nonatomic) UIButton * deleteBtn;
- (void)setImageCover:(BOOL)cover;
- (void)setEditStyle:(BOOL)edit;
@end
