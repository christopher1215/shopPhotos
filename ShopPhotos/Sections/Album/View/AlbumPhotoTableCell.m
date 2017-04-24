//
//  AlbumPhotoTableCell.m
//  ShopPhotos
//
//  Created by addcn on 16/12/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AlbumPhotoTableCell.h"
#import <UIView+SDAutoLayout.h>
#import <UIImageView+WebCache.h>
#import "CommonDefine.h"
#import "UIView+Extension.h"

@interface AlbumPhotoTableCell ()

//@property (strong, nonatomic) UIView * shadowb;
//@property (strong, nonatomic) UIView * shadowt;
@property (strong, nonatomic) UIView * content;
@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * title;
//@property (strong, nonatomic) UILabel * prize;
@property (strong, nonatomic) UIView * selectView;
@property (strong, nonatomic) UIImageView * select;
@property (strong, nonatomic) UILabel * share;
@property (strong, nonatomic) UIButton * btn_pyq;

@end

@implementation AlbumPhotoTableCell

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
    [self.contentView addSubview:self.content];
    
    self.icon = [[UIImageView alloc] init];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.icon setBackgroundColor:ColorHex(0XF5F5F5)];
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
    [self.prize setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.content addSubview:self.prize];
  */
    self.btn_pyq = [[UIButton alloc] init];
    [self.btn_pyq setBackgroundImage:[UIImage imageNamed:@"btn_pyq_b"] forState:UIControlStateNormal];
//    [self.btn_pyq addTarget:self action:@selector(shareClicked)];
    [self.content addSubview:_btn_pyq];
    
    self.share = [[UILabel alloc] init];
    [self.share setFont:Font(19)];
    [self.share setText:@"..."];
//    [self.share addTarget:self action:@selector(shareClicked)];
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
    .rightSpaceToView(self.contentView,3)
    .topSpaceToView(self.contentView,3)
    .bottomSpaceToView(self.contentView,3);
    */
    self.content.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightSpaceToView(self.contentView,6);
    
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
    self.prize.sd_layout
    .leftSpaceToView(self.content,5)
    .rightSpaceToView(self.content,5)
    .topSpaceToView(self.title,0)
    .bottomSpaceToView(self.content,0);
    */
    self.btn_pyq.sd_layout
    .leftSpaceToView(self.content,3)
    .topSpaceToView(self.title,10)
    .bottomSpaceToView(self.content,3)
    .widthEqualToHeight();
    
    self.share.sd_layout
    .rightSpaceToView(self.content,2)
    .bottomSpaceToView(self.content,10)
    .widthIs(20)
    .heightIs(20);

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

- (void)setModel:(AlbumPhotosModel *)model{
    
    if(!model)return;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    [self.title setText:model.title];
//    [self.prize setText:[NSString stringWithFormat:@"￥%@",model.price]];
    
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
/*
    if(self.showPrice){
        [self.prize setHidden:NO];
    }else{
        if(model.showPrice){
            [self.prize setHidden:NO];
        }else{
            [self.prize setHidden:YES];
        }
    }  */
}

- (void)selectedClick{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(editSelected:)]){
        [self.delegate editSelected:self.indexPath];
    } 
}

- (void)shareClicked{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareClicked:)]){
        [self.delegate shareClicked:self.indexPath];
    }
}


@end
