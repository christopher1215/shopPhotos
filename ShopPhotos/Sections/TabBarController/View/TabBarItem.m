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
@end
