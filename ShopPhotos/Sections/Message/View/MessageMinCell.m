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
@property (strong, nonatomic) UIImageView * avatar;
@property (strong, nonatomic) UILabel * name;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UILabel * date;
@property (strong, nonatomic) UIView * line;
@property (strong, nonatomic) UIView * badge;

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
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    self.icon = [[UIImageView alloc] init];
    [self.icon setImage:[UIImage imageNamed:@"btn_circle_default"]];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.icon setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.icon];
    self.icon.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,10)
    .widthIs(30);

    self.avatar = [[UIImageView alloc] init];
    [self.contentView addSubview:self.avatar];
    self.avatar.sd_layout
    .leftSpaceToView(self.contentView,60)
    .centerYIs(40)
    .heightIs(50)
    .widthIs(50);
    self.avatar.cornerRadius = 25;
    
    self.name = [[UILabel alloc] init];
    [self.name setFont:FontBold(14)];
    [self.contentView addSubview:self.name];
    self.name.sd_layout
    .leftSpaceToView(self.avatar,10)
    .topSpaceToView(self.contentView,15)
    .heightIs(25);
    
    self.title = [[UILabel alloc] init];
    [self.title setFont:Font(14)];
    [self.title setTextColor:[UIColor darkGrayColor]];
    [self.contentView addSubview:self.title];
    self.title.sd_layout
    .leftSpaceToView(self.name,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,15)
    .heightIs(25);
    
    self.date = [[UILabel alloc] init];
    [self.date setFont:Font(13)];
    [self.date setTextColor:ColorHex(0X808080)];
    [self.contentView addSubview:self.date];
    self.date.sd_layout
    .leftSpaceToView(self.avatar,10)
    .topSpaceToView(self.name,0)
    .rightSpaceToView(self.contentView,15)
    .heightIs(25);
    
    self.line = [[UIView alloc] init];
    [self.line setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.contentView addSubview:self.line];
    self.line.sd_layout
    .leftSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,0)
    .bottomEqualToView(self.contentView)
    .heightIs(1);
    
    self.badge = [[UIView alloc] init];
    [self.badge setBackgroundColor:[UIColor redColor]];
    self.badge.cornerRadius = 5;
    [self.contentView addSubview:self.badge];
    
    self.badge.sd_layout
    .rightEqualToView(self.avatar)
    .topEqualToView(self.avatar)
    .widthIs(10)
    .heightIs(10);
}

- (void)setModel:(MessageModel *)model{
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    [self.name setText: model.name];
    [self.title setText:model.title];
    [self.date setText:model.date];
    self.name.sd_layout.widthIs([self getWidthWithTitle:model.name font:FontBold(14)]);
    
    if(model.edit){
        [self.icon setHidden:NO];
        self.avatar.sd_layout.leftSpaceToView(self.contentView,60);
    }else{
        [self.icon setHidden:YES];
        self.avatar.sd_layout.leftSpaceToView(self.contentView,15);
    }

    [self.name updateLayout];
    [self.avatar updateLayout];
    [self.title updateLayout];
    [self.date updateLayout];
    if(model.editSelect){
        [self.icon setImage:[UIImage imageNamed:@"btn_circle_selected"]];
    }else{
        [self.icon setImage:[UIImage imageNamed:@"btn_circle_default"]];
    }

    if ([model.state isEqualToString:@"waiting"]) {
        [self.badge setHidden:NO];
    } else {
        [self.badge setHidden:YES];
    }

}
-(CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}
@end
