//
//  MessageCell.m
//  ShopPhotos
//
//  Created by addcn on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "MessageCell.h"
#import <UIImageView+WebCache.h>

@interface MessageCell ()

@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UIImageView * avatar;
@property (strong, nonatomic) UILabel * name;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UILabel * msgContent;
@property (strong, nonatomic) UILabel * date;
@property (strong, nonatomic) UIView * line;
@property (strong, nonatomic) UIView * badge;


@end

@implementation MessageCell

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
    
    self.avatar = [[UIImageView alloc] init];
    [self.avatar setImage:[UIImage imageNamed:@"default-avatar.png"]];
    [self.avatar setContentMode:UIViewContentModeScaleAspectFit];
    [self.avatar setBackgroundColor:[UIColor clearColor]];
    self.avatar.cornerRadius = 25;
    [self.contentView addSubview:self.avatar];
    
    self.name = [[UILabel alloc] init];
    [self.name setFont:FontBold(14)];
    [self.contentView addSubview:self.name];
    
    self.title = [[UILabel alloc] init];
    [self.title setFont:Font(14)];
    [self.title setTextColor:[UIColor darkGrayColor]];
    [self.contentView addSubview:self.title];

    //    self.title = [[UILabel alloc] init];
//    [self.title setText:@""];
//    [self.title setFont:Font(13)];
//    [self.title setBackgroundColor:[UIColor clearColor]];
//    [self.contentView addSubview:self.title];
//    
//    self.msgContent = [[UILabel alloc] init];
//    self.msgContent.numberOfLines = 0;
//    [self.msgContent setText:@""];
//    [self.msgContent setFont:Font(13)];
//    [self.msgContent setTextColor:ColorHex(0X808080)];
//    [self.msgContent setBackgroundColor:[UIColor clearColor]];
//    [self.contentView addSubview:self.msgContent];
    
    self.date = [[UILabel alloc] init];
    [self.date setText:@""];
    [self.date setFont:Font(13)];
    [self.date setTextColor:ColorHex(0X808080)];
    [self.date setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.date];
    
    self.line = [[UIView alloc] init];
    [self.line setBackgroundColor:ColorHex(0Xeeeeee)];
    [self.contentView addSubview:self.line];
    
    self.icon.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,10)
    .widthIs(30);
    
    self.avatar.sd_layout
    .leftSpaceToView(self.contentView,60)
    .centerYIs(self.contentView.frame.size.height / 2)
    .heightIs(50)
    .widthIs(50);

    self.name.sd_layout
    .leftSpaceToView(self.avatar,10)
    .topSpaceToView(self.contentView,15)
    .heightIs(25);
    
    self.title.sd_layout
    .leftSpaceToView(self.name,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,15)
    .heightIs(25);

    //    self.title.sd_layout
//    .leftSpaceToView(self.avatar,10)
//    .topSpaceToView(self.contentView,5)
//    .rightSpaceToView(self.contentView,10)
//    .heightIs(20);
//    
//    self.msgContent.sd_layout
//    .leftSpaceToView(self.avatar,10)
//    .rightSpaceToView(self.contentView,10)
//    .topSpaceToView(self.title,5)
//    .autoHeightRatio(0);
    
    self.date.sd_layout
    .leftSpaceToView(self.avatar,10)
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(self.name,0)
    .heightIs(25);

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

    [self setupAutoHeightWithBottomView:self.msgContent bottomMargin:32];
}

- (void)setModel:(MessageModel *)model{
    
    if(!model)return;
    
    [self.name setText: model.name];
    [self.title setText:model.title];
    //[self.msgContent setText:model.content];
    [self.date setText:model.date];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"default-avatar.png"]];
    self.avatar.sd_layout.centerYIs(self.contentView.frame.size.height / 2);
    self.name.sd_layout.widthIs([self getWidthWithTitle:model.name font:FontBold(14)]);
    if(model.edit){
        [self.icon setHidden:NO];
        self.avatar.sd_layout.leftSpaceToView(self.contentView,60);
//        self.title.sd_layout.leftSpaceToView(self.contentView,50);
//        self.msgContent.sd_layout.leftSpaceToView(self.contentView,50);
//        self.date.sd_layout.leftSpaceToView(self.contentView,50);
        [self.avatar updateLayout];
        [self.title updateLayout];
        [self.msgContent updateLayout];
        [self.date updateLayout];
    }else{
        [self.icon setHidden:YES];
//        self.title.sd_layout.leftSpaceToView(self.contentView,10);
//        self.msgContent.sd_layout.leftSpaceToView(self.contentView,10);
//        self.date.sd_layout.leftSpaceToView(self.contentView,10);
        self.avatar.sd_layout.leftSpaceToView(self.contentView,15);
        [self.avatar updateLayout];
        [self.title updateLayout];
        [self.msgContent updateLayout];
        [self.date updateLayout];
    }
    
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
