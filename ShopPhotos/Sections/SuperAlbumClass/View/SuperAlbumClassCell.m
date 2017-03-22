//
//  SuperAlbumClassCell.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/3.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "SuperAlbumClassCell.h"
#import <UIView+SDAutoLayout.h>
#import "CommonDefine.h"
#import <UIImageView+WebCache.h>

@interface SuperAlbumClassCell ()
@property (strong, nonatomic) UIView * shadowb;
@property (strong, nonatomic) UIView * shadowt;
@property (strong, nonatomic) UIView * content;
@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * title;

@end

@implementation SuperAlbumClassCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAutoLayout];
    }
    return self;
}

- (void)createAutoLayout{
    
    self.shadowb = [[UIView alloc] init];
    [self.shadowb setBackgroundColor:ColorHexA(0XCCCCCC,0.7)];
    [self.contentView addSubview:self.shadowb];
    
    self.shadowt = [[UIView alloc] init];
    [self.shadowt setBackgroundColor:ColorHexA(0XBBBBBB,1)];
    [self.contentView addSubview:self.shadowt];
    
    self.content = [[UIView alloc] init];
    [self.content setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.content];
    
    
    self.shadowb.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView(self.contentView,6)
    .bottomSpaceToView(self.contentView,6);
    
    self.shadowt.sd_layout
    .leftEqualToView(self.contentView)
    .rightSpaceToView(self.contentView,2)
    .topSpaceToView(self.contentView,3)
    .bottomSpaceToView(self.contentView,3);
    
    self.content.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightSpaceToView(self.contentView,6);
    
    self.icon = [[UIImageView alloc] init];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.icon setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview:self.icon];
    self.icon.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topEqualToView(self.content)
    .heightIs(160);
    
    self.title = [[UILabel alloc] init];
    self.title.numberOfLines = 2;
    [self.title setFont:Font(14)];
    [self.content addSubview:self.title];
    self.title.sd_layout
    .leftSpaceToView(self.content,10)
    .rightSpaceToView(self.content,10)
    .topSpaceToView(self.icon,5)
    .heightIs(40);
}

- (void)setModel:(SuperAlbumClassModel *)model{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    [self.title setText:model.name];
}

@end
