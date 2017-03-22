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
@property (strong, nonatomic) UIView * changView;
@property (strong, nonatomic) UIView * deleteView;

@end

@implementation AlbumClassTableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createAutoLayout];
    }
    
    return self;
}

- (void)createAutoLayout{
    
    [self setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.contentView setBackgroundColor:ColorHex(0Xeeeeee)];
    
    self.title = [[UILabel alloc] init];
    [self.title setFont:Font(13)];
    [self.title setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.title];
    
    self.changView = [[UIView alloc] init];
    [self.changView addTarget:self action:@selector(changSelected)];
    [self.contentView addSubview:self.changView];
    
    UIImageView * change = [[UIImageView alloc] init];
    [change setContentMode:UIViewContentModeScaleAspectFit];
    [change setImage:[UIImage imageNamed:@"btn_edit_black"]];
    [self.changView addSubview:change];
    
    self.deleteView = [[UIView alloc] init];
    [self.deleteView addTarget:self action:@selector(deleteSelected)];
    [self.contentView addSubview:self.deleteView];
    
    UIImageView *deleteBtn = [[UIImageView alloc] init];
    [deleteBtn setContentMode:UIViewContentModeScaleAspectFit];
    [deleteBtn setImage:[UIImage imageNamed:@"btn_delete"]];
    [self.deleteView addSubview:deleteBtn];
    
    self.line = [[UIView alloc] init];
    [self.contentView addSubview:self.line];
    [self.line setBackgroundColor:ColorHex(0Xdedede)];
    
    self.title.sd_layout
    .leftSpaceToView(self.contentView,40)
    .rightSpaceToView(self.contentView,120)
    .topSpaceToView(self.contentView,0)
    .bottomSpaceToView(self.contentView,0);

    self.deleteView.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .widthIs(50);
    
    deleteBtn.sd_layout
    .leftSpaceToView(self.deleteView,15)
    .rightSpaceToView(self.deleteView,15)
    .topSpaceToView(self.deleteView,15)
    .bottomSpaceToView(self.deleteView,15);
    
    self.changView.sd_layout
    .rightSpaceToView(self.deleteView,10)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .widthIs(50);
    
    change.sd_layout
    .leftSpaceToView(self.changView,15)
    .rightSpaceToView(self.changView,15)
    .topSpaceToView(self.changView,15)
    .bottomSpaceToView(self.changView,15);
    
    self.line.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(1);
    
}

- (void)setModel:(AlbumClassTableSubModel *)model{
    
    [self.title setText:model.name];
    
    if(model.edit){
    
        [self.changView setHidden:NO];
        [self.deleteView setHidden:NO];
        
    }else{
        [self.changView setHidden:YES];
        [self.deleteView setHidden:YES];
    }
}

- (void)changSelected{

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
