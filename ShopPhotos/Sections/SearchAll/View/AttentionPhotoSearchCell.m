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
@property (strong, nonatomic) UILabel * share;

@end

@implementation AttentionPhotoSearchCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creteAutoLayout];
        [self setBackgroundColor:ColorHex(0Xffffff)];
        [self.contentView setBackgroundColor:ColorHex(0Xffffff)];
        [self.content setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
- (void)creteAutoLayout{
/*
    self.shadowb = [[UIView alloc] init];
    [self.shadowb setBackgroundColor:ColorHexA(0XCCCCCC,0.7)];
    [self.contentView addSubview:self.shadowb];
    
    self.shadowt = [[UIView alloc] init];
    [self.shadowt setBackgroundColor:ColorHexA(0XBBBBBB,1)];
    [self.contentView addSubview:self.shadowt];
*/
    for (UIView *sv in self.content.subviews) {
        [sv removeFromSuperview];
    }
    self.content = [[UIView alloc] init];
    [self.contentView addSubview:self.content];
    
    
    self.icon = [[UIImageView alloc] init];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.icon setBackgroundColor:ColorHex(0XF5F5F5)];
    [self.content addSubview:self.icon];
    
    self.title = [[UILabel alloc] init];
    self.title.numberOfLines = 1;
    [self.title setFont:Font(13)];
    [self.title setBackgroundColor:[UIColor whiteColor]];
    [self.title setTextColor:[UIColor darkGrayColor]];
    [self.content addSubview:self.title];
    
//    self.prize = [[UILabel alloc] init];
//    [self.prize setTextColor:ThemeColor];
//    [self.prize setBackgroundColor:[UIColor clearColor]];
//    [self.prize setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
//    [self.content addSubview:self.prize];
//    
    
//    self.shadowb.sd_layout
//    .leftEqualToView(self.contentView)
//    .rightEqualToView(self.contentView)
//    .topSpaceToView(self.contentView,6)
//    .bottomSpaceToView(self.contentView,6);
//    
//    self.shadowt.sd_layout
//    .leftEqualToView(self.contentView)
//    .rightSpaceToView(self.contentView,2)
//    .topSpaceToView(self.contentView,3)
//    .bottomSpaceToView(self.contentView,3);
    
    self.content.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
    self.icon.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topEqualToView(self.content)
    .heightIs((WindowWidth - 15)/2);
    self.icon.cornerRadius = 5;
    
    self.title.sd_layout
    .leftSpaceToView(self.content,5)
    .rightSpaceToView(self.content,5)
    .topSpaceToView(self.icon,10)
    .heightIs(20);
    
//    self.prize.sd_layout
//    .leftSpaceToView(self.content,5)
//    .rightSpaceToView(self.content,5)
//    .topSpaceToView(self.title,0)
//    .heightIs(25);

    self.userIcon = [[UIImageView alloc] init];
    [self.userIcon setContentMode:UIViewContentModeScaleAspectFit];
    [self.content addSubview:self.userIcon];
    [self.userIcon addTarget:self action:@selector(userSelected)];
    self.userIcon.sd_layout
    .leftSpaceToView(self.content,5)
    .topSpaceToView(self.title,5)
    .widthIs(25)
    .heightIs(25);
    self.userIcon.cornerRadius = 12.5f;
    
    self.userName = [[UILabel alloc] init];
    [self.userName setFont:Font(14)];
    [self.userName addTarget:self action:@selector(userSelected)];
    [self.userName setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview:self.userName];
    self.userName.sd_layout
    .leftSpaceToView(self.userIcon,5)
    .topSpaceToView(self.title,5)
    .rightSpaceToView(self.content,30)
    .heightIs(25);

    self.share = [[UILabel alloc] init];
    [self.share setFont:Font(22)];
    [self.share setText:@"..."];
    [self.share setTextColor:ColorHex(0x4c5364)];
    [self.share addTarget:self action:@selector(shareClicked)];
    self.share.textAlignment = NSTextAlignmentCenter;
    [self.content addSubview:self.share];
    self.share.sd_layout
    .rightSpaceToView(self.content,5)
    .topSpaceToView(self.title,0)
    .widthIs(20)
    .heightIs(22);

}

- (void)setModel:(AlbumPhotosModel *)model{
    
    if(!model)return;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    [self.title setText:model.title];
    [self.prize setHidden:YES];
    
    NSDictionary * user = model.user;
    if(user && user.count > 0){
        NSString * name = [user objectForKey:@"name"];
        NSString * icon = [user objectForKey:@"avatar"];
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

- (void)shareClicked{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareClicked:)]){
        [self.delegate shareClicked:self.indexPath];
    }
}

@end
