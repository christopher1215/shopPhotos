//
//  ClassByCoverTableViewCell.m
//  ShopPhotos
//
//  Created by Macbook on 15/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "ClassByCoverTableViewCell.h"
#import <UIView+SDAutoLayout.h>
#import <UIImageView+WebCache.h>
#import "CommonDefine.h"
#import "UIView+Extension.h"

@interface ClassByCoverTableViewCell ()

@property (strong, nonatomic) UIView * content;
@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * title;

@end

@implementation ClassByCoverTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    [self.title setFont:Font(15)];
    [self.title setTextColor:[UIColor darkGrayColor]];
    [self.title setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:self.title];
    
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

}
- (void)setModel:(AlbumClassTableModel *)model{
    
    if(!model)return;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    [self.title setText:model.name];
}

@end
