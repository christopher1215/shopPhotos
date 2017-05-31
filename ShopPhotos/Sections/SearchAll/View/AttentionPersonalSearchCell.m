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
@end

@implementation AttentionPersonalSearchCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creteAutoLayout];
        //[self setBackgroundColor:ColorHex(0Xeeeeee)];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)creteAutoLayout{
    
    self.icon = [[UIImageView alloc] init];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:self.icon];
    
    self.name = [[UILabel alloc] init];
    [self.name setFont:Font(15)];
    [self.contentView addSubview:self.name];
    
    self.line = [[UIView alloc] init];
    [self.line setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.contentView addSubview:self.line];
    
    self.icon.sd_layout
    .leftSpaceToView(self.contentView,16)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,10)
    .widthIs(40);
    self.icon.cornerRadius = 20;
    
    self.name.sd_layout
    .leftSpaceToView(self.icon,14)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,50);
    
    self.line.sd_layout
    .leftSpaceToView(self.contentView, 16)
    .bottomEqualToView(self.contentView)
    .rightSpaceToView(self.contentView,16)
    .heightIs(1);

    self.accessory = [[UIImageView alloc] init];
    [self.accessory setImage:[UIImage imageNamed:@"ico_arrow_right"]];
    [self.accessory setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:self.accessory];
    self.accessory.sd_layout
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,23)
    .heightIs(16)
    .widthIs(16);

}

- (void)setModel:(AttentionPersonalSearchModel *)model{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    [self.name setText:model.name];
}

@end
