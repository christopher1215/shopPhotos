//
//  AttentionPersonalSearchCell.m
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "AttentionPersonalSearchCell.h"
#import <UIView+SDAutoLayout.h>
#import <UIImageView+WebCache.h>
#import "CommonDefine.h"
#import "UIView+Extension.h"

@interface AttentionPersonalSearchCell  ()

@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * name;
@property (strong, nonatomic) UIView * line;

@end

@implementation AttentionPersonalSearchCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creteAutoLayout];
        [self setBackgroundColor:ColorHex(0Xeeeeee)];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)creteAutoLayout{
    
    self.icon = [[UIImageView alloc] init];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:self.icon];
    
    self.name = [[UILabel alloc] init];
    [self.name setFont:Font(13)];
    [self.contentView addSubview:self.name];
    
    self.line = [[UIView alloc] init];
    [self.line setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.contentView addSubview:self.line];
    
    self.icon.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,10)
    .widthIs(40);
    
    self.name.sd_layout
    .leftSpaceToView(self.icon,5)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10);
    
    self.line.sd_layout
    .leftEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(1);
    
}

- (void)setModel:(AttentionPersonalSearchModel *)model{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.name setText:model.name];
}

@end
