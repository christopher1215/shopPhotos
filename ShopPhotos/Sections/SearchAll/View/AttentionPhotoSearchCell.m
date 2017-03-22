//
//  AttentionPhotoSearchCell.m
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "AttentionPhotoSearchCell.h"
#import <UIView+SDAutoLayout.h>
#import <UIImageView+WebCache.h>
#import "CommonDefine.h"
#import "UIView+Extension.h"


@interface AttentionPhotoSearchCell ()

@property (strong, nonatomic) UIView * shadowb;
@property (strong, nonatomic) UIView * shadowt;
@property (strong, nonatomic) UIView * content;
@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UILabel * prize;
@property (strong, nonatomic) UIImageView * userIcon;
@property (strong, nonatomic) UILabel * userName;

@end

@implementation AttentionPhotoSearchCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creteAutoLayout];
        [self setBackgroundColor:ColorHex(0Xeeeeee)];
        [self.contentView setBackgroundColor:ColorHex(0Xeeeeee)];
        [self.content setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
- (void)creteAutoLayout{
    
    self.shadowb = [[UIView alloc] init];
    [self.shadowb setBackgroundColor:ColorHexA(0XCCCCCC,0.7)];
    [self.contentView addSubview:self.shadowb];
    
    self.shadowt = [[UIView alloc] init];
    [self.shadowt setBackgroundColor:ColorHexA(0XBBBBBB,1)];
    [self.contentView addSubview:self.shadowt];
    
    self.content = [[UIView alloc] init];
    [self.contentView addSubview:self.content];
    
    
    self.icon = [[UIImageView alloc] init];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.icon setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.content addSubview:self.icon];
    
    self.title = [[UILabel alloc] init];
    self.title.numberOfLines = 2;
    [self.title setFont:Font(13)];
    [self.title setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview:self.title];
    
    self.prize = [[UILabel alloc] init];
    [self.prize setTextColor:ThemeColor];
    [self.prize setBackgroundColor:[UIColor clearColor]];
    [self.prize setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.content addSubview:self.prize];
    
    
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
    
    self.icon.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topEqualToView(self.content)
    .heightIs(160);
    
    self.title.sd_layout
    .leftSpaceToView(self.content,5)
    .rightSpaceToView(self.content,5)
    .topSpaceToView(self.icon,0)
    .heightIs(35);
    
    self.prize.sd_layout
    .leftSpaceToView(self.content,5)
    .rightSpaceToView(self.content,5)
    .topSpaceToView(self.title,0)
    .heightIs(25);

    self.userIcon = [[UIImageView alloc] init];
    [self.userIcon setContentMode:UIViewContentModeScaleAspectFit];
    [self.content addSubview:self.userIcon];
    [self.userIcon addTarget:self action:@selector(userSelected)];
    self.userIcon.sd_layout
    .leftSpaceToView(self.content,5)
    .topSpaceToView(self.prize,0)
    .widthIs(25)
    .heightIs(25);
    
    self.userName = [[UILabel alloc] init];
    [self.userName setFont:Font(13)];
    [self.userName addTarget:self action:@selector(userSelected)];
    [self.userName setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview:self.userName];
    self.userName.sd_layout
    .leftSpaceToView(self.userIcon,5)
    .topSpaceToView(self.prize,0)
    .rightSpaceToView(self.content,5)
    .heightIs(25);
}

- (void)setModel:(AlbumPhotosMdel *)model{
    
    if(!model)return;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.big]];
    [self.title setText:model.name];
    [self.prize setText:[NSString stringWithFormat:@"￥%@",model.price]];
    if(!model.showPrice){
        [self.prize setHidden:YES];
    }else{
        [self.prize setHidden:NO];
    }
    
    NSDictionary * user = model.user;
    if(user && user.count > 0){
        NSString * name = [user objectForKey:@"name"];
        NSString * icon = [user objectForKey:@"icon"];
        if(name && name.length > 0){
            [self.userName setText:name];
        }
        if(icon && icon.length > 0){
            [self.userIcon sd_setImageWithURL:[NSURL URLWithString:icon]];
        }
    }
}

- (void)userSelected{
    if(self.delegate && [self.delegate respondsToSelector:@selector(userContenSelected:)]){
        [self.delegate userContenSelected:self.indexPath];
    }
}


@end
