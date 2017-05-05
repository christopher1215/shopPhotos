//
//  ScanNavigation.m
//  platform
//
//  Created by addcn on 16/11/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "ScanNavigation.h"

@interface ScanNavigation ()

@property (strong, nonatomic) UIImageView * back;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UILabel * lblBack;

@end

@implementation ScanNavigation

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setup];
        [self stCreateView];
        
    }
    return self;
}

- (void)setup{
    
    [self setBackgroundColor:ColorHex(0XFFFFFF)];
    
}

- (void)stCreateView{
    
    UIView * backView = [[UIView alloc] init];
    [backView addTarget:self action:@selector(backSelect)];
    [self addSubview:backView];
    
    self.back = [[UIImageView alloc] init];
    [self.back setContentMode:UIViewContentModeScaleAspectFit];
    [self.back setImage:[UIImage imageNamed:@"btn_back_black"]];
    [backView addSubview:self.back];
    
    self.lblBack = [[UILabel alloc] init];
    [self.lblBack setText:@"返回"];
    [self.lblBack setFont:[UIFont systemFontOfSize:17]];
    [self.lblBack setTextColor:[UIColor blackColor]];
    [backView addSubview:self.lblBack];
    
    self.title = [[UILabel alloc] init];
    [self.title setTextAlignment:NSTextAlignmentCenter];
    [self.title setText:@"扫一扫"];
    [self.title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    [self.title setTextColor:[UIColor blackColor]];
    [self addSubview:self.title];
    
    backView.sd_layout
    .leftEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(75)
    .heightIs(44);
    
    UIView * line = [[UIView alloc] init];
    [self addSubview:line];
    [line setBackgroundColor:ColorHex(0Xeeeeee)];
    line.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(1);
    
    self.lblBack.sd_layout
    .rightSpaceToView(backView,6)
    .topSpaceToView(backView, 12)
    .heightIs(21)
    .widthIs(45);
    
    self.back.sd_layout
    .leftSpaceToView(backView,7)
    .topSpaceToView(backView,7)
    .rightSpaceToView(_lblBack,6)
    .widthIs(11)
    .bottomSpaceToView(backView,7);
    
    
    self.title.sd_layout
    .leftSpaceToView(self,50)
    .bottomEqualToView(self)
    .rightSpaceToView(self,50)
    .heightIs(44);
    
}

- (void)backSelect{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(navigationComeBack)]){
        [self.delegate navigationComeBack];
    }
    
}

@end
