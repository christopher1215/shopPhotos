//
//  AlbumClassTableCell.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AlbumClassTableCell.h"

@interface AlbumClassTableCell ()

@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UIView * line;
//@property (strong, nonatomic) UIView * changView;
//@property (strong, nonatomic) UIView * deleteView;

@end

@implementation AlbumClassTableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self createAutoLayout];
    }
    
    return self;
}

- (void)createAutoLayout:(BOOL)isSubClass {
    
    [self setBackgroundColor:ColorHex(0xf5f5f5)];
    [self.contentView setBackgroundColor:ColorHex(0xf5f5f5)];
    
    
    for(UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    int space = 50;
    if (isSubClass == TRUE) {
        space = self.frame.size.width/4;
    }
    
    UIView *editView = [[UIView alloc] init];
    [editView setBackgroundColor:[UIColor clearColor]];
    [editView addTarget:self action:@selector(changSelected)];
    [self addSubview:editView];
    editView.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self,space)
    .widthIs(30)
    .heightIs(35);
    
    UIButton *btn_edit = [[UIButton alloc]init];
    [btn_edit setBackgroundImage:[UIImage imageNamed:@"ico_edit2"] forState:UIControlStateNormal];
    [btn_edit addTarget:self action:@selector(changSelected)];
    [editView addSubview:btn_edit];
    btn_edit.sd_layout
    .centerXEqualToView(editView)
    .topEqualToView(editView)
    .widthIs(16)
    .heightIs(17);
    
    UILabel *lab_edit = [[UILabel alloc] init];
    [lab_edit setText:@"编辑"];
    [lab_edit setTextColor:ColorHex(0x7e8599)];
    [lab_edit setFont:Font(11)];
    [lab_edit setTextAlignment:NSTextAlignmentCenter];
    [lab_edit addTarget:self action:@selector(changSelected)];
    [editView addSubview:lab_edit];
    lab_edit.sd_layout
    .bottomEqualToView(editView)
    .widthIs(30)
    .heightIs(14);

    if (isSubClass == FALSE) {
        UIView *addView = [[UIView alloc] init];
        [addView setBackgroundColor:[UIColor clearColor]];
        [addView addTarget:self action:@selector(addSubSelected)];
        [self addSubview:addView];
        addView.sd_layout
        .centerXEqualToView(self)
        .centerYEqualToView(self)
        .widthIs(70)
        .heightIs(35);
        
        UIButton *btn_add = [[UIButton alloc]init];
        [btn_add setBackgroundImage:[UIImage imageNamed:@"ico_add"] forState:UIControlStateNormal];
        [btn_add addTarget:self action:@selector(addSubSelected)];
        [addView addSubview:btn_add];
        btn_add.sd_layout
        .centerXEqualToView(addView)
        .topEqualToView(addView)
        .widthIs(17)
        .heightIs(17);
        
        UILabel *lab_add = [[UILabel alloc] init];
        [lab_add setText:@"添加子分类"];
        [lab_add setTextColor:ColorHex(0x7e8599)];
        [lab_add setFont:Font(11)];
        [lab_add setTextAlignment:NSTextAlignmentCenter];
        [lab_add addTarget:self action:@selector(addSubSelected)];
        [addView addSubview:lab_add];
        lab_add.sd_layout
        .bottomEqualToView(addView)
        .widthIs(70)
        .heightIs(14);
    }
    else {
    }
    
    UIView *delView = [[UIView alloc] init];
    [delView setBackgroundColor:[UIColor clearColor]];
    [delView addTarget:self action:@selector(deleteSelected)];
    [self addSubview:delView];
    delView.sd_layout
    .centerYEqualToView(self)
    .rightSpaceToView(self,space)
    .widthIs(30)
    .heightIs(35);
    
    UIButton *btn_del = [[UIButton alloc]init];
    [btn_del setBackgroundImage:[UIImage imageNamed:@"ico_delete"] forState:UIControlStateNormal];
    [btn_del addTarget:self action:@selector(deleteSelected)];
    [delView addSubview:btn_del];
    btn_del.sd_layout
    .centerXEqualToView(delView)
    .topEqualToView(delView)
    .widthIs(16)
    .heightIs(17);
    
    UILabel *lab_del = [[UILabel alloc] init];
    [lab_del setText:@"删除"];
    [lab_del setTextColor:ColorHex(0x7e8599)];
    [lab_del setTextAlignment:NSTextAlignmentCenter];
    [lab_del setFont:Font(11)];
    [lab_del addTarget:self action:@selector(deleteSelected)];
    [delView addSubview:lab_del];
    lab_del.sd_layout
    .bottomEqualToView(delView)
    .widthIs(30)
    .heightIs(14);
}

- (void)setModel:(AlbumClassTableSubModel *)model {
    
    [self.title setText:model.name];
}

- (void)addSubSelected {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(albumClassTableSelectType:selectPath:)]){
        [self.delegate albumClassTableSelectType:3 selectPath:self.indexPath];
    }
}

- (void)changSelected {

    if(self.delegate && [self.delegate respondsToSelector:@selector(albumClassTableSelectType:selectPath:)]){
        [self.delegate albumClassTableSelectType:1 selectPath:self.indexPath];
    }
}

- (void)deleteSelected{
    if(self.delegate && [self.delegate respondsToSelector:@selector(albumClassTableSelectType:selectPath:)]){
        [self.delegate albumClassTableSelectType:2 selectPath:self.indexPath];
    }
}

@end
