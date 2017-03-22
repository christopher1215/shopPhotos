//
//  NavigationView.m
//  platform
//
//  Created by addcn on 16/8/9.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "NavigationView.h"

@interface NavigationView ()

@property (strong, nonatomic) UIImageView * back;
@property (strong, nonatomic) UILabel * titleText;


@end

@implementation NavigationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.back = [UIImageView new];
        [self.back setContentMode:UIViewContentModeCenter];
        [self.back setImage:[UIImage imageNamed:@"back"]];
        [self.back addTarget:self action:@selector(backSelect)];
        [self addSubview:self.back];
        
        self.titleText = [UILabel new];
        [self.titleText setText:@""];
        [self.titleText setTextAlignment:NSTextAlignmentCenter];
        [self.titleText setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
        
        [self.titleText setTextColor:[UIColor whiteColor]];
        [self addSubview:self.titleText];
        
        self.back.sd_layout
        .leftEqualToView(self)
        .bottomEqualToView(self)
        .widthIs(44)
        .heightIs(44);
        
        self.titleText.sd_layout
        .leftSpaceToView(self,50)
        .bottomEqualToView(self)
        .rightSpaceToView(self,50)
        .heightIs(44);
        
        self.backgroundColor = ThemeColor;
        
    }
    return self;
}

- (void)setBackImageName:(NSString *)backImageName{
    [self.back setImage:[UIImage imageNamed:backImageName]];
}

- (void)setTitle:(NSString *)title{
    
    [self.titleText setText:title];
}

- (void)backSelect{
    if(self.delegate && [self.delegate respondsToSelector:@selector(navigationComeBack)]){
        [self.delegate navigationComeBack];
    }
}

@end
