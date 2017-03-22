//
//  PhotoDetailsHeadImage.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/25.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PhotoDetailsHeadImage.h"

@implementation PhotoDetailsHeadImage
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createAutoLayout];
    }
    return self;
}

- (void)createAutoLayout{
    
    self.image = [[UIImageView alloc] init];
    [self.image setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.image];
    
    self.cover = [[UIImageView alloc] init];
    [self.cover setBackgroundColor:[UIColor clearColor]];
    [self.cover setImage:[UIImage imageNamed:@"cover"]];
    [self addSubview:self.cover];
    [self.cover setHidden:YES];
    
    self.editView = [[UIView alloc] init];
    [self.editView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self addSubview:self.editView];
    
    self.settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.settingBtn setTitle:@"设为封面" forState:UIControlStateNormal];
    [self.settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.editView addSubview:self.settingBtn];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.editView addSubview:self.deleteBtn];
    
    self.image.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    self.cover.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .widthIs(40)
    .heightIs(40);
    
    self.editView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    self.settingBtn.sd_layout
    .leftEqualToView(self.editView)
    .rightEqualToView(self.editView)
    .topEqualToView(self.editView)
    .heightIs((((WindowWidth - 20)/3)-5)/2);
    
    self.deleteBtn.sd_layout
    .leftEqualToView(self.editView)
    .rightEqualToView(self.editView)
    .topSpaceToView(self.settingBtn,0)
    .heightIs((((WindowWidth - 20)/3)-5)/2);
    
    [self.editView setHidden:YES];
    
}

- (void)setImageCover:(BOOL)cover{
    [self.cover setHidden:!cover];
}
- (void)setEditStyle:(BOOL)edit{
    if(self.cover.hidden){
        [self.editView setHidden:!edit];
    }else{
        [self.editView setHidden:YES];
    }
}

@end
