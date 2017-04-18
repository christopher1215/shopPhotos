//
//  CollectionTableCell.m
//  ShopPhotos
//
//  Created by addcn on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "CollectionTableCell.h"
#import <UIView+SDAutoLayout.h>
#import <UIImageView+WebCache.h>
#import "CommonDefine.h"
#import "UIView+Extension.h"

@interface CollectionTableCell ()

@property (strong, nonatomic) UIView * shadowb;
@property (strong, nonatomic) UIView * shadowt;
@property (strong, nonatomic) UIView * content;
@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UILabel * prize;
@property (strong, nonatomic) UIView * collection;
@property (strong, nonatomic) UIView * userIcon;
@property (strong, nonatomic) UIImageView * userIconImage;
@property (strong, nonatomic) UILabel * userName;
@property (strong, nonatomic) UILabel * share;
@property (strong, nonatomic) UIView * selectView;
@property (strong, nonatomic) UIImageView * select;

@end

@implementation CollectionTableCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creteAutoLayout];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self.content setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


- (void)creteAutoLayout{
/*
    self.shadowb = [[UIView alloc] init];
    [self.shadowb setBackgroundColor:ColorHexA(0XDDDDDD,1)];
    [self.contentView addSubview:self.shadowb];
    
    self.shadowt = [[UIView alloc] init];
    [self.shadowt setBackgroundColor:ColorHexA(0XCCCCCC,1)];
    [self.contentView addSubview:self.shadowt];
  */
    self.content = [[UIView alloc] init];
    self.content.layer.cornerRadius = 5.0f;
    self.content.clipsToBounds = TRUE;
    [self.contentView addSubview:self.content];

    self.icon = [[UIImageView alloc] init];
    [self.icon setBackgroundColor:ColorHex(0XF5F5F5)];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.content addSubview:self.icon];
    
    self.title = [[UILabel alloc] init];
    self.title.numberOfLines = 1;
    [self.title setFont:Font(15)];
    [self.title setTextColor:ColorHex(0X222222)];
    [self.title setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview:self.title];
    /*
    self.prize = [[UILabel alloc] init];
    [self.prize setTextColor:ThemeColor];
    [self.prize setBackgroundColor:[UIColor clearColor]];
    [self.prize setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.content addSubview:self.prize];
    
    self.collection = [[UIView alloc] init];
    [self.collection setBackgroundColor:[UIColor clearColor]];
    [self.collection addTarget:self action:@selector(collectionSelected)];
//    [self.content addSubview:self.collection];
    
    UIImageView * collectionIcon = [[UIImageView alloc] init];
    [collectionIcon setContentMode:UIViewContentModeScaleAspectFit];
    [collectionIcon setImage:[UIImage imageNamed:@"btn_star_selected"]];
    [self.collection addSubview:collectionIcon];
    */
    self.userIcon = [[UIView  alloc] init];
    [self.userIcon setBackgroundColor:[UIColor clearColor]];
    [self.userIcon addTarget:self action:@selector(userSelected)];
    [self.content addSubview:self.userIcon];
    
    self.userIconImage = [[UIImageView alloc] init];
    [self.userIconImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.userIcon addSubview:self.userIconImage];
    self.userIconImage.layer.cornerRadius = self.userIconImage.frame.size.width/2;
    self.userIconImage.layer.masksToBounds = TRUE;
    
    self.userName = [[UILabel alloc] init];
    [self.userName setFont:Font(15)];
    [self.userName addTarget:self action:@selector(userSelected)];
    [self.userName setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview:self.userName];

    self.share = [[UILabel alloc] init];
    [self.share setFont:Font(19)];
    [self.share setText:@"..."];
    [self.share addTarget:self action:@selector(shareClicked)];
    self.share.textAlignment = NSTextAlignmentLeft;
    [self.content addSubview:self.share];
    
    self.selectView = [[UIView alloc] init];
    [self.selectView addTarget:self action:@selector(selectedClick)];
    [self.contentView addSubview:self.selectView];
    
    self.select = [[UIImageView alloc] init];
    [self.select setImage:[UIImage imageNamed:@"btn_circle_default"]];
    [self.selectView addSubview:self.select];
    
    /*
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
    */
    self.content.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightSpaceToView(self.contentView,0);
    
    self.icon.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topEqualToView(self.content)
    .heightIs(140);
    
    self.title.sd_layout
    .leftSpaceToView(self.content,5)
    .rightSpaceToView(self.content,5)
    .topSpaceToView(self.icon,10)
    .heightIs(17);
    /*
    self.collection.sd_layout
    .rightSpaceToView(self.content,5)
    .topSpaceToView(self.title,0)
    .widthIs(30)
    .heightIs(30);
    
    collectionIcon.sd_layout
    .leftSpaceToView(self.collection,5)
    .rightSpaceToView(self.collection,5)
    .topSpaceToView(self.collection,5)
    .bottomSpaceToView(self.collection,5);
    
    self.prize.sd_layout
    .leftSpaceToView(self.content,5)
    .rightSpaceToView(self.collection,5)
    .topSpaceToView(self.title,0)
    .heightIs(10);
    */
    
    self.userIcon.sd_layout
    .leftSpaceToView(self.content,5)
    .topSpaceToView(self.title,0)
    .widthIs(30)
    .heightIs(30);
    
    self.userIconImage.sd_layout
    .leftSpaceToView(self.userIcon,5)
    .rightSpaceToView(self.userIcon,5)
    .topSpaceToView(self.userIcon,5)
    .bottomSpaceToView(self.userIcon,5);

    self.userName.sd_layout
    .leftSpaceToView(self.userIcon,0)
    .topSpaceToView(self.title,0)
    .rightSpaceToView(self.content,5)
    .heightIs(30);
    
    self.share.sd_layout
    .rightSpaceToView(self.content,2)
    .leftSpaceToView(self.userName,10)
    .bottomSpaceToView(self.content,15)
//    .topSpaceToView(self.prize,0)
    .widthIs(20)
    .heightIs(25);
    
    
    self.selectView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .topEqualToView(self.contentView);
    
    self.select.sd_layout
    .leftEqualToView(self.selectView)
    .topEqualToView(self.selectView)
    .widthIs(40)
    .heightIs(40);
    
    [self.selectView setHidden:YES];
}

- (void)selectedClick{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(editSelected:)]){
        [self.delegate editSelected:self.indexPath];
    }
}

- (void)collectionSelected{
    if(self.delegate && [self.delegate respondsToSelector:@selector(collctionSelected:)]){
        [self.delegate collctionSelected:self.indexPath];
    }
}

- (void)userSelected{
    if(self.delegate && [self.delegate respondsToSelector:@selector(collctionUserSelecte:)]){
        [self.delegate collctionUserSelecte:self.indexPath];
    }
}

- (void)shareClicked{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareClicked:)]){
        [self.delegate shareClicked:self.indexPath];
    }
}

- (void)setModel:(AlbumPhotosMdel *)model{
    
    if(!model)return;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.big]];
    [self.title setText:model.name];
    [self.prize setText:[NSString stringWithFormat:@"￥%@",model.price]];
    
    if(model.showPrice == 1){
        [self.prize setHidden:NO];
    }else{
        [self.prize setHidden:YES];
    }
    if(model.user && model.user.count > 0){
        NSString * userIcon = [model.user objectForKey:@"icon"];
        NSString * userName = [model.user objectForKey:@"name"];
        
        if(userIcon) [self.userIconImage sd_setImageWithURL:[NSURL URLWithString:userIcon]];
        if(userName) [self.userName setText:userName];
    }
    
    if(model.openEdit){
        [self.selectView setHidden:NO];
    }else{
        [self.selectView setHidden:YES];
    }
    
    if(model.selected){
        [self.select setImage:[UIImage imageNamed:@"btn_circle_selected"]];
    }else{
        [self.select setImage:[UIImage imageNamed:@"btn_circle_default"]];
    }
}

@end
