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
        [self creteAutoLayout];
    }
    return self;
}

- (void)creteAutoLayout{
    [self setBackgroundColor:[UIColor whiteColor]];
    self.icon = [[UIImageView alloc] init];
    [self.icon setImage:[UIImage imageNamed:@"ico_triangle"]];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.icon setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.icon];
    
    self.title = [[UILabel alloc] init];
    [self.title setTextColor:ThemeColor];
    [self.title setFont:Font(13)];
    [self addSubview:self.title];
    
    self.change = [[UIView alloc] init];
    [self.change addTarget:self action:@selector(changSelected)];
    [self addSubview:self.change];
    
    UIImageView * changIcon = [[UIImageView alloc] init];
    [changIcon setContentMode:UIViewContentModeScaleAspectFit];
    [changIcon setImage:[UIImage imageNamed:@"btn_edit_black"]];
    [self.change addSubview:changIcon];
    
    self.deleteBtn = [[UIView alloc] init];
    [self.deleteBtn addTarget:self action:@selector(deleteSelected)];
    [self addSubview:self.deleteBtn];
    
    UIImageView * deleteIcon = [[UIImageView alloc] init];
    [deleteIcon setContentMode:UIViewContentModeScaleAspectFit];
    [deleteIcon setImage:[UIImage imageNamed:@"btn_delete"]];
    [self.deleteBtn addSubview:deleteIcon];
    
    
    UIView * line = [[UIView alloc] init];
    [line setBackgroundColor:ColorHex(0Xeeeeee)];
    [self addSubview:line];
    
    self.icon.sd_layout
    .leftSpaceToView(self,10)
    .topSpaceToView(self,18)
    .bottomSpaceToView(self,18)
    .widthIs(14);
    
    self.deleteBtn.sd_layout
    .rightSpaceToView(self,10)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(50);
    
    deleteIcon.sd_layout
    .leftSpaceToView(self.deleteBtn,15)
    .rightSpaceToView(self.deleteBtn,15)
    .topSpaceToView(self.deleteBtn,15)
    .bottomSpaceToView(self.deleteBtn,15);
    
    self.change.sd_layout
    .rightSpaceToView(self.deleteBtn,10)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(50);

    changIcon.sd_layout
    .leftSpaceToView(self.change,15)
    .rightSpaceToView(self.change,15)
    .bottomSpaceToView(self.change,15)
    .topSpaceToView(self.change,15);
    
    self.title.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .rightSpaceToView(self,120);
    
    line.sd_layout
    .leftEqualToView(self)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .heightIs(1);
}

- (void)changSelected{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(albmClassTableHeadSelectType:slectedPath:)]){
        [self.delegate albmClassTableHeadSelectType:1 slectedPath:self.indexPath];
    }
    
}

- (void)deleteSelected{
    if(self.delegate && [self.delegate respondsToSelector:@selector(albmClassTableHeadSelectType:slectedPath:)]){
        [self.delegate albmClassTableHeadSelectType:2 slectedPath:self.indexPath];
    }
}

- (void)openOption{
    [self.icon setImage:[UIImage imageNamed:@"ico_triangle_top"]];
}

- (void)closeOption{
    [self.icon setImage:[UIImage imageNamed:@"ico_triangle"]];
}
@end
