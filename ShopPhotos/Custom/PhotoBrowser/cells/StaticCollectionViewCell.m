//
//  StaticCollectionViewCell.m
//  ShopPhotos
//
//  Created by  on 4/8/17.
//  Copyright © 2017 addcn. All rights reserved.
//

//
//  AlbumPhotoTableCell.m
//  ShopPhotos
//
//  Created by addcn on 16/12/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "StaticCollectionViewCell.h"
#import <UIView+SDAutoLayout.h>
#import <UIImageView+WebCache.h>
#import "CommonDefine.h"
#import "UIView+Extension.h"

@interface StaticCollectionViewCell ()

@property (strong, nonatomic) UIView * content;
@property (strong, nonatomic) UIImageView * photo;
@property (strong, nonatomic) UIImageView * video;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UIView * selectView;
@property (strong, nonatomic) UIImageView * select;
@property (strong, nonatomic) UIButton * btn_pyq;
@property (strong, nonatomic) UIButton * btn_favorite;
@property (strong, nonatomic) UIButton * btn_edit;
@property (strong, nonatomic) UIImageView * userIcon;
@property (strong, nonatomic) UILabel * userName;
@property (strong, nonatomic) UILabel * share;

@end

@implementation StaticCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self.content setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)createAutoLayout:(BOOL)isVideo cellType:(int) type {
    // 1: 自己的相册列表样式
    // 2: 收藏的相册样式
    // 3: 在他人个人中心查看他人相册
    for (UIView *sv in self.content.subviews) {
        [sv removeFromSuperview];
    }
    self.content = [[UIView alloc] init];
    [self.contentView addSubview:self.content];
    
    self.photo = [[UIImageView alloc] init];
    [self.photo setContentMode:UIViewContentModeScaleAspectFit];
    [self.photo setBackgroundColor:ColorHex(0XF5F5F5)];
    [self.content addSubview:self.photo];
    
    if (isVideo == YES) {
        self.video = [[UIImageView alloc] init];
        [self.video setImage:[UIImage imageNamed:@"btn_movie"]];
        [self.video setContentMode:UIViewContentModeScaleAspectFit];
        [self.content addSubview:self.video];
    }
    
    self.title = [[UILabel alloc] init];
    self.title.numberOfLines = 1;
    [self.title setFont:Font(13)];
    [self.title setTextColor:ColorHex(0x333333)];
    [self.title setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:self.title];
    
    if (type == 2) {
        self.userIcon = [[UIImageView  alloc] init];
        [self.userIcon setBackgroundColor:[UIColor clearColor]];
        [self.userIcon addTarget:self action:@selector(userSelected)];
        self.userIcon.cornerRadius = self.userIcon.width/2;
        [self.content addSubview:self.userIcon];
        
        self.userName = [[UILabel alloc] init];
        [self.userName setFont:Font(14)];
        [self.userName setTextColor:ColorHex(0x4c5364)];
        [self.userName addTarget:self action:@selector(userSelected)];
        [self.userName setBackgroundColor:[UIColor clearColor]];
        [self.content addSubview:self.userName];
    }
    else {
        self.btn_pyq = [[UIButton alloc] init];
        [self.btn_pyq setImage:[UIImage imageNamed:@"btn_pyq_b"] forState:UIControlStateNormal];
        [self.btn_pyq addTarget:self action:@selector(pyqSelected)];
        [self.content addSubview:_btn_pyq];
        
        self.btn_favorite = [[UIButton alloc] init];
        [self.btn_favorite setImage:[UIImage imageNamed:@"btn_favorite"] forState:UIControlStateNormal];
        [self.btn_favorite addTarget:self action:@selector(favoriteSelected)];
        [self.content addSubview:_btn_favorite];
        
        if (isVideo == YES) {
            self.btn_edit = [[UIButton alloc] init];
            [self.btn_edit setImage:[UIImage imageNamed:@"ico_edit"] forState:UIControlStateNormal];
            [self.btn_edit setContentMode:UIViewContentModeScaleAspectFit];
            [self.btn_edit addTarget:self action:@selector(editSelected)];
            [self.content addSubview:_btn_edit];
        }
    }
    
    self.share = [[UILabel alloc] init];
    [self.share setFont:Font(22)];
    [self.share setText:@"..."];
    [self.share setTextColor:ColorHex(0x4c5364)];
    [self.share addTarget:self action:@selector(shareClicked)];
    self.share.textAlignment = NSTextAlignmentCenter;
    [self.content addSubview:self.share];
    
    self.selectView = [[UIView alloc] init];
    [self.selectView addTarget:self action:@selector(selectedClick)];
    [self.contentView addSubview:self.selectView];
    
    self.select = [[UIImageView alloc] init];
    [self.select setImage:[UIImage imageNamed:@"btn_circle_default"]];
    [self.selectView addSubview:self.select];
    
    self.content.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
    self.photo.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topEqualToView(self.content)
    .heightIs((WindowWidth - 15)/2);
    self.photo.cornerRadius = 5;
    
    if (isVideo == YES) {
        self.video.sd_layout
        .centerXEqualToView(self.photo)
        .centerYEqualToView(self.photo)
        .widthRatioToView(self.photo,0.25)
        .autoHeightRatio(1);
    }
    
    self.title.sd_layout
    .leftSpaceToView(self.content,5)
    .rightSpaceToView(self.content,5)
    .topSpaceToView(self.photo,10)
    .heightIs(20);
    
    self.share.sd_layout
    .rightSpaceToView(self.content,0)
    .topSpaceToView(self.title,0)
    .widthIs(30)
    .heightIs(22);
    
    if (type == 2) {
        self.userIcon.sd_layout
        .leftSpaceToView(self.content,5)
        .topSpaceToView(self.title,5)
        .widthIs(25)
        .heightIs(25);
        self.userIcon.cornerRadius = 12.5f;
        
        self.userName.sd_layout
        .leftSpaceToView(self.userIcon,5)
        .topSpaceToView(self.title,5)
        .rightSpaceToView(self.content,30)
        .heightIs(25);
    }
    else {
        self.btn_pyq.sd_layout
        .leftSpaceToView(self.content,5)
        .topSpaceToView(self.title,5)
        .widthIs(25)
        .heightIs(25);
        [self.btn_pyq setImageEdgeInsets: UIEdgeInsetsMake(2, 2, 2, 2)];
        
        self.btn_favorite.sd_layout
        .leftSpaceToView(self.btn_pyq,15)
        .topSpaceToView(self.title,5)
        .widthIs(25)
        .heightIs(25);
        [self.btn_favorite setImageEdgeInsets: UIEdgeInsetsMake(2, 2, 2, 2)];
        
        if (isVideo == YES) {
            self.btn_edit.sd_layout
            .leftSpaceToView(self.btn_pyq,15)
            .topSpaceToView(self.title,5)
            .widthIs(25)
            .heightIs(25);
            [self.btn_edit setImageEdgeInsets: UIEdgeInsetsMake(4.5, 4.5, 4.5, 4.5)];
        }

    }
    
    
    self.selectView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .topEqualToView(self.contentView);
    
    self.select.sd_layout
    .rightSpaceToView(self.selectView,10)
    .topSpaceToView(self.selectView,10)
    .widthIs(30)
    .heightIs(30);
    
    if (type != 3) {
        [self.btn_favorite setHidden:YES];
    }
    
    [self.selectView setHidden:YES];
}

-(void) userSelected {
    if(self.delegate && [self.delegate respondsToSelector:@selector(collectionUserSelecte:)]){
        [self.delegate collectionUserSelecte:self.indexPath];
    }
}

-(void) pyqSelected {
    if(self.delegate && [self.delegate respondsToSelector:@selector(pyqClicked:)]){
        [self.delegate pyqClicked:self.indexPath];
    }
}
-(void) editSelected {
    if(self.delegate && [self.delegate respondsToSelector:@selector(editClicked:)]){
        [self.delegate editClicked:self.indexPath];
    }
}

-(void) favoriteSelected {
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareClicked:)]){
        [self.delegate favoriteClicked:self.indexPath];
    }
}

-(void) shareClicked {
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareClicked:)]){
        [self.delegate shareClicked:self.indexPath];
    }
}

-(void) selectedClick {
    if(self.delegate && [self.delegate respondsToSelector:@selector(editSelected:)]){
        [self.delegate editSelected:self.indexPath];
    }
}

- (void)setModel:(AlbumPhotosModel *)model{
    
    if(!model) return;
    
    [self.photo sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    [self.title setText:model.title];
    
    if(model.user && model.user.count > 0){
        NSString * userIcon = [model.user objectForKey:@"avatar"];
        NSString * userName = [model.user objectForKey:@"name"];
        
        if(userIcon) [self.userIcon sd_setImageWithURL:[NSURL URLWithString:userIcon]];
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
    
    if (model.collected == NO) {
        [self.btn_favorite setImage:[UIImage imageNamed:@"btn_favorite_b"] forState:UIControlStateNormal];
    }
}

@end

