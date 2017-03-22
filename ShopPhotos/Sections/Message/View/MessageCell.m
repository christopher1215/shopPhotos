//
//  MessageCell.m
//  ShopPhotos
//
//  Created by addcn on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UILabel * msgContent;
@property (strong, nonatomic) UILabel * date;
@property (strong, nonatomic) UIView * line;


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
    
    self.icon = [[UIImageView alloc] init];
    [self.icon setImage:[UIImage imageNamed:@"btn_circle_default"]];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.icon setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.icon];
    
    self.title = [[UILabel alloc] init];
    [self.title setText:@""];
    [self.title setFont:Font(13)];
    [self.title setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.title];
    
    self.msgContent = [[UILabel alloc] init];
    self.msgContent.numberOfLines = 0;
    [self.msgContent setText:@""];
    [self.msgContent setFont:Font(13)];
    [self.msgContent setTextColor:ColorHex(0X808080)];
    [self.msgContent setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.msgContent];
    
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
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,10)
    .widthIs(30);

    self.title.sd_layout
    .leftSpaceToView(self.contentView,50)
    .topSpaceToView(self.contentView,5)
    .rightSpaceToView(self.contentView,10)
    .heightIs(20);
    
    self.msgContent.sd_layout
    .leftSpaceToView(self.contentView,50)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.title,5)
    .autoHeightRatio(0);
    
    self.date.sd_layout
    .leftSpaceToView(self.contentView,50)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.msgContent,5)
    .heightIs(20);

    self.line.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:self.msgContent bottomMargin:32];
}

- (void)setModel:(MessageModel *)model{
    
    if(!model)return;
    
    [self.title setText:model.title];
    [self.msgContent setText:model.content];
    [self.date setText:model.date];
    
    if(model.edit){
        [self.icon setHidden:NO];
        self.title.sd_layout.leftSpaceToView(self.contentView,50);
        self.msgContent.sd_layout.leftSpaceToView(self.contentView,50);
        self.date.sd_layout.leftSpaceToView(self.contentView,50);
        [self.title updateLayout];
        [self.msgContent updateLayout];
        [self.date updateLayout];
    }else{
        [self.icon setHidden:YES];
        self.title.sd_layout.leftSpaceToView(self.contentView,10);
        self.msgContent.sd_layout.leftSpaceToView(self.contentView,10);
        self.date.sd_layout.leftSpaceToView(self.contentView,10);
        [self.title updateLayout];
        [self.msgContent updateLayout];
        [self.date updateLayout];
    }
    
    if(model.editSelect){
        [self.icon setImage:[UIImage imageNamed:@"btn_circle_selected"]];
    }else{
       [self.icon setImage:[UIImage imageNamed:@"btn_circle_default"]];
    }
}


@end
