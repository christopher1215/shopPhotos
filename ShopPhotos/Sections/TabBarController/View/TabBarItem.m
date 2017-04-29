//
//  TabBarItem.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/19.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "TabBarItem.h"

@interface TabBarItem ()

@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * text;
@property (strong, nonatomic) UILabel * badge;
@property (strong, nonatomic) TabBarModel * model;

@end

@implementation TabBarItem

- (instancetype)initWithModel:(TabBarModel *)model;
{
    self = [super init];
    if (self) {
        
        [self createAutoLayout:model];
    }
    return self;
}

- (void)createAutoLayout:(TabBarModel *)model{
    
    _model = model;
    
    self.icon = [[UIImageView alloc] init];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.icon setImage:[UIImage imageNamed:model.defaultImage]];
    
    [self addSubview:self.icon];
    
    self.text = [[UILabel alloc] init];
    [self.text setTextAlignment:NSTextAlignmentCenter];
    [self.text setText:model.text];
    [self.text setTextColor:[UIColor darkGrayColor]];
    [self.text setFont:Font(11)];
    [self addSubview:self.text];
    
    self.badge = [[UILabel alloc] init];
    [self.badge setTextAlignment:NSTextAlignmentCenter];
    [self.badge setTextColor:[UIColor whiteColor]];
    [self.badge setBackgroundColor:[UIColor redColor]];
    [self.badge setFont:Font(8)];
    self.badge.cornerRadius = 6;
    [self addSubview:self.badge];
    [self.badge setHidden:YES];
    
    self.icon.sd_layout
    .leftEqualToView(self)
    .topSpaceToView(self,7.5)
    .rightEqualToView(self)
    .heightIs(20);
    
    self.text.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .topSpaceToView(self.icon,0);
    
    self.badge.sd_layout
    .rightSpaceToView(self,15)
    .widthIs(15)
    .heightIs(12)
    .topSpaceToView(self,5);

    [self setStyleDefault];
}

- (void)setStyleSelected{
    
    [self.icon setImage:[UIImage imageNamed:self.model.selectedImage]];
//    [self.text setTextColor:ThemeColor];
    
}

- (void)setStyleDefault{

    [self.icon setImage:[UIImage imageNamed:self.model.defaultImage]];
//    [self.text setTextColor:ColorHex(0X4d4d4d)];
    
}
- (void)setUnreadCountBadge:(int)unreadCount{
    if (unreadCount <= 0) {
        [self.badge setHidden:YES];
    } else {
        [self.badge setHidden:NO];
        [self.badge setText:unreadCount > 99 ? @"99+" : [NSString stringWithFormat:@"%d", unreadCount]];
    }
}
@end
