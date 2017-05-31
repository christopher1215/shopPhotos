//
//  AlbumClassTableHead.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AlbumClassTableHead.h"

@implementation AlbumClassTableHead

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self creteAutoLayout];
    }
    return self;
}

- (void)creteAutoLayout:(BOOL) isCheckBox selected:(BOOL) isChecked {
    [self setBackgroundColor:[UIColor whiteColor]];
    _isChecked = isChecked;
    
    if (isCheckBox == YES) {
        self.checkBox = [[UIImageView alloc] init];
        if (isChecked ==YES) {
            [self.checkBox setImage:[UIImage imageNamed:@"btn_circle_selected"]];
        }
        else {
            [self.checkBox setImage:[UIImage imageNamed:@"btn_circle_default"]];
        }
        [self.checkBox setContentMode:UIViewContentModeScaleAspectFit];
        [self.checkBox addTarget:self action:@selector(checkBoxSelected)];
        [self addSubview:self.checkBox];
    }
    
    self.folder = [[UIImageView alloc] init];
    [self.folder setImage:[UIImage imageNamed:@"ico_photo_folder"]];
    [self.folder setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.folder];

    self.iconView = [[UIView alloc] init];
    [self addSubview:self.iconView];
    [self.iconView addTarget:self action:@selector(toolSelected)];
    
    self.icon = [[UIImageView alloc] init];
    [self.icon setImage:[UIImage imageNamed:@"ico_edit"]];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.icon addTarget:self action:@selector(toolSelected)];
    [self.iconView addSubview:self.icon];
    
    self.title = [[UILabel alloc] init];
    [self.title setTextColor:ColorHex(0x333333)];
    [self.title setFont:Font(16)];
    [self addSubview:self.title];

    self.subNums = [[UILabel alloc] init];
    [self.subNums setTextColor:ColorHex(0x333333)];
    [self.subNums setFont:Font(16)];
    [self.subNums setTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.subNums];

    UIView * line = [[UIView alloc] init];
    [line setBackgroundColor:ColorHex(0Xeeeeee)];
    [self addSubview:line];

    if (isCheckBox == YES) {
        self.checkBox.sd_layout
        .leftSpaceToView(self,15)
        .centerYEqualToView(self)
        .widthIs(20)
        .heightIs(20);
        
        self.folder.sd_layout
        .leftSpaceToView(_checkBox,15)
        .topSpaceToView(self,18)
        .bottomSpaceToView(self,18)
        .widthIs(26)
        .heightIs(22);
    }
    else {
        self.folder.sd_layout
        .leftSpaceToView(self,15)
        .topSpaceToView(self,18)
        .bottomSpaceToView(self,18)
        .widthIs(26)
        .heightIs(22);
        
    }

    self.title.sd_layout
    .leftSpaceToView(self.folder,10)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .rightSpaceToView(self,40);

    self.iconView.sd_layout
    .rightSpaceToView(self,5)
    .topSpaceToView(self,8)
    .bottomSpaceToView(self,8)
    .widthIs(34);

    self.icon.sd_layout
    .rightSpaceToView(self.iconView,10)
    .topSpaceToView(self.iconView,10)
    .bottomSpaceToView(self.iconView,10)
    .widthIs(14);
    
    self.subNums.sd_layout
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .rightSpaceToView(self.iconView,4)
    .widthIs(40);

    line.sd_layout
    .leftEqualToView(self)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .heightIs(1);
}

- (void)toolSelected {
    if(self.delegate && [self.delegate respondsToSelector:@selector(albumClassTableHeadShowRow:)]){
        [self.delegate albumClassTableHeadShowRow:self.section];
    }
}

- (void)checkBoxSelected {
    _isChecked = !_isChecked;
    
    if (_isChecked) {
        [self.checkBox setImage:[UIImage imageNamed:@"btn_circle_selected"]];
    }
    else {
        [self.checkBox setImage:[UIImage imageNamed:@"btn_circle_default"]];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(albumClassTableHeadSelectCheck:selectedPath:)]){
        [self.delegate albumClassTableHeadSelectCheck:_isChecked selectedPath:self.section];
    }
}

- (void)openOption {
    [self.icon setImage:[UIImage imageNamed:@"ico_edit"]];
    [self.folder setImage:[UIImage imageNamed:@"ico_photo_folder"]];
}

- (void)closeOption {
    [self.icon setImage:[UIImage imageNamed:@"ico_edit"]];
    [self.folder setImage:[UIImage imageNamed:@"ico_photo_folder"]];
}

- (void)videoFolder {
    [self.folder setImage:[UIImage imageNamed:@"ico_movie_folder"]];
    [self.iconView setHidden:YES];
}

@end
