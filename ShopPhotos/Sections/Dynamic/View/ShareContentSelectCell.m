//
//  ShareContentSelectCell.m
//  ShopPhotos
//
//  Created by addcn on 17/1/3.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "ShareContentSelectCell.h"
#import <UIView+SDAutoLayout.h>
#import "CommonDefine.h"
#import "UIView+Extension.h"
#import <UIImageView+WebCache.h>

@interface ShareContentSelectCell ()

@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UIImageView * image;

@end

@implementation ShareContentSelectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image = [[UIImageView alloc] init];
        [self.image setContentMode:UIViewContentModeScaleAspectFit];
        [self.image setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.image];
        
        self.icon = [[UIImageView alloc] init];
        [self.icon setImage:[UIImage imageNamed:@"btn_circle_selected"]];
        [self.contentView addSubview:self.icon];
        
        self.image.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topEqualToView(self.contentView)
        .bottomEqualToView(self.contentView);
        
        self.icon.sd_layout
        .rightEqualToView(self.contentView)
        .topEqualToView(self.contentView)
        .widthIs(30)
        .heightIs(30);
    }
    return self;
}

- (void)setModel:(DynamicImagesModel *)model{
    
    if(model.select){
        [self.icon setImage:[UIImage imageNamed:@"btn_circle_default"]];
    }else{
        [self.icon setImage:[UIImage imageNamed:@"btn_circle_selected"]];
    }
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.thumbnails]];
}

@end
