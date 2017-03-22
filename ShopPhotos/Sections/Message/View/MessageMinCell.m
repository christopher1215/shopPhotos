//
//  MessageMinCell.m
//  ShopPhotos
//
//  Created by addcn on 17/1/5.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "MessageMinCell.h"
#import <UIImageView+WebCache.h>

@interface MessageMinCell ()

@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * name;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UIView * line;

@end

@implementation MessageMinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createAutoLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createAutoLayout{
    
    self.icon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.icon];
    self.icon.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,20)
    .bottomSpaceToView(self.contentView,20)
    .widthIs(40);
    
    self.name = [[UILabel alloc] init];
    [self.name setFont:Font(13)];
    [self.contentView addSubview:self.name];
    self.name.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15)
    .heightIs(25);
    
    self.title = [[UILabel alloc] init];
    [self.title setFont:Font(13)];
    [self.title setTextColor:ColorHex(0X808080)];
    [self.contentView addSubview:self.title];
    self.title.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(self.name,0)
    .rightSpaceToView(self.contentView,15)
    .heightIs(25);
    
    self.line = [[UIView alloc] init];
    [self.line setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.contentView addSubview:self.line];
    self.line.sd_layout
    .leftSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15)
    .bottomEqualToView(self.contentView)
    .heightIs(1);
    
}

- (void)setModel:(MessageModel *)model{
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    [self.name setText:model.title];
    [self.title setText:model.content];
}

@end
