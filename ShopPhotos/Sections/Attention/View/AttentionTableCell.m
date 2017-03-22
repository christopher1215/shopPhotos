//
//  AttentionTableCell.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/19.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AttentionTableCell.h"
#import <UIImageView+WebCache.h>

@interface AttentionTableCell ()

@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * name;
@property (strong, nonatomic) UIView * attention;
@property (strong, nonatomic) UIView * line;
@property (strong, nonatomic) UIImageView * attenIcon;

@end

@implementation AttentionTableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createAutoLayout];
    }
    
    return self;
}


- (void)createAutoLayout{

    self.icon = [[UIImageView alloc] init];
    [self.icon setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.icon];
    
    self.name = [[UILabel alloc] init];
    [self.name setFont:Font(13)];
    [self.contentView addSubview:self.name];
    
    self.attention = [[UIView alloc] init];
    [self.attention setBackgroundColor:[UIColor clearColor]];
    [self.attention addTarget:self action:@selector(attentionSelected)];
    [self.contentView addSubview:self.attention];
    if(self.attentionStatu){
        [self.attention setHidden:YES];
    }else{
        [self.attention setHidden:NO];
    }
    
    self.attenIcon = [[UIImageView alloc] init];
    [self.attenIcon  setImage:[UIImage imageNamed:@"btn_star_default"]];
    [self.attenIcon  setContentMode:UIViewContentModeScaleAspectFit];
    [self.attention addSubview:self.attenIcon ];
    
    self.line = [[UIView alloc] init];
    [self.line setBackgroundColor:ColorHex(0Xeeeeee)];
    [self.contentView addSubview:self.line];
    
    self.icon.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .widthIs(40)
    .heightIs(40);
    
    self.attention.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,5)
    .widthIs(50)
    .heightIs(50);
    
    self.attenIcon .sd_layout
    .leftSpaceToView(self.attention,10)
    .rightSpaceToView(self.attention,5)
    .topSpaceToView(self.attention,10)
    .bottomSpaceToView(self.attention,10);
    
    self.name.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(self.contentView,5)
    .rightSpaceToView(self.attention,10)
    .heightIs(50);
    
    self.line.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,59)
    .heightIs(1);
    
}


- (void)setModel:(AttentionModel *)model{
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.name setText:model.name];
    if(model.star){
       [self.attenIcon  setImage:[UIImage imageNamed:@"btn_star_selected"]];
    }else{
        [self.attenIcon  setImage:[UIImage imageNamed:@"btn_star_default"]];
    }
    
    if(self.attentionStatu){
        [self.attention setHidden:YES];
    }else{
        [self.attention setHidden:NO];
    }
}

- (void)attentionSelected{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(attentionSelected:)]){
        [self.delegate attentionSelected:self.indexPath];
    }
    
}

@end
