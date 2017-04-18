//
//  StaticCollectionViewCell.m
//  ShopPhotos
//
//  Created by Park Jin Hyok on 4/8/17.
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
    self.content = [[UIView alloc] init];
    [self.contentView addSubview:self.content];
    
    self.photo = [[UIImageView alloc] init];
    [self.photo setContentMode:UIViewContentModeScaleAspectFit];
    [self.photo setBackgroundColor:ColorHex(0XF5F5F5)];
    [self.content addSubview:self.photo];
    
    if (isVideo == TRUE) {
        self.video = [[UIImageView alloc] init];
        [self.video setImage:[UIImage imageNamed:@"btn_movie"]];
        [self.video setContentMode:UIViewContentModeScaleAspectFit];
        [self.content addSubview:self.video];
    }
    
    self.title = [[UILabel alloc] init];
    self.title.numberOfLines = 1;
    [self.title setFont:Font(15)];
    [self.title setTextColor:ColorHex(0X222222)];
    [self.title setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview:self.title];

    if (type == 2) {
        self.userIcon = [[UIImageView  alloc] init];
        [self.userIcon setBackgroundColor:[UIColor clearColor]];
        [self.userIcon addTarget:self action:@selector(userSelected)];
        self.userIcon.layer.borderColor = [UIColor.whiteColor CGColor];
        self.userIcon.layer.cornerRadius = self.userIcon.width/2;
        self.userIcon.layer.masksToBounds = YES;
        [self.content addSubview:self.userIcon];
        
        self.userName = [[UILabel alloc] init];
        [self.userName setFont:Font(15)];
        [self.userName addTarget:self action:@selector(userSelected)];
        [self.userName setBackgroundColor:[UIColor clearColor]];
        [self.content addSubview:self.userName];
    }
    else {
        self.btn_pyq = [[UIButton alloc] init];
        [self.btn_pyq setBackgroundImage:[UIImage imageNamed:@"btn_pyq_b"] forState:UIControlStateNormal];
        [self.btn_pyq addTarget:self action:@selector(pyqSelected)];
        [self.content addSubview:_btn_pyq];
        
        self.btn_favorite = [[UIButton alloc] init];
        [self.btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_favorite_b"] forState:UIControlStateNormal];
        [self.userName addTarget:self action:@selector(favoriteSelected)];
        [self.content addSubview:_btn_favorite];
    }
    
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
    
    self.content.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightSpaceToView(self.contentView,6);
    
    self.photo.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topEqualToView(self.content)
    .heightIs(140);
    
    if (isVideo == TRUE) {
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
    .heightIs(17);
    
    self.share.sd_layout
    .rightSpaceToView(self.content,2)
    .bottomSpaceToView(self.content,10)
    .widthIs(20)
    .heightIs(20);
    
    if (type == 2) {
        self.userIcon.sd_layout
        .leftSpaceToView(self.content,3)
        .topSpaceToView(self.title,10)
        .bottomSpaceToView(self.content,3)
        .widthEqualToHeight();
        
        self.userName.sd_layout
        .leftSpaceToView(self.userIcon,0)
        .rightSpaceToView(self.share,10)
        .topSpaceToView(self.title,10)
        .bottomSpaceToView(self.content,3);
//        .heightIs(30);
    }
    else {
        self.btn_pyq.sd_layout
        .leftSpaceToView(self.content,3)
        .topSpaceToView(self.title,10)
        .bottomSpaceToView(self.content,3)
        .widthEqualToHeight();
        
        self.btn_favorite.sd_layout
        .leftSpaceToView(self.btn_pyq,15)
        .topSpaceToView(self.title,10)
        .bottomSpaceToView(self.content,3)
        .widthEqualToHeight();
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
    
    if (type == 1) {
        [self.btn_favorite setHidden:YES];
    }
    [self.selectView setHidden:YES];
}

-(void) userSelected {
    if(self.delegate && [self.delegate respondsToSelector:@selector(collectionUserSelecte:)]){
        [self.delegate collectionUserSelecte:self.indexPath];
    }
}

-(void) pyqSelected {}
-(void) favoriteSelected {}

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

- (void)setModel:(AlbumPhotosMdel *)model{
    
    if(!model)return;
    
    [self.photo sd_setImageWithURL:[NSURL URLWithString:model.big]];
    [self.title setText:model.name];
    
    if(model.user && model.user.count > 0){
        NSString * userIcon = [model.user objectForKey:@"icon"];
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
}

@end
