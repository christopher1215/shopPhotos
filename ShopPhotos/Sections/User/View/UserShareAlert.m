//
//  UserShareAlert.m
//  ShopPhotos
//
//  Created by addcn on 17/1/5.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "UserShareAlert.h"

@interface UserShareAlert ()

@property (strong, nonatomic) UIView * alert;
@property (strong, nonatomic) UILabel * title;

@end

@implementation UserShareAlert

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self creteAutoLayout];
    }
    return self;
}

- (void)creteAutoLayout{
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self addTarget:self action:@selector(closeAlert)];
    
    self.alert = [[UIView alloc] init];
    [self.alert setBackgroundColor:[UIColor whiteColor]];
    [self.alert addTarget:self action:nil];
    [self.alert setCornerRadius:5];
    [self addSubview:self.alert];
    
    self.title = [[UILabel alloc] init];
    [self.title setFont:Font(13)];
    [self.title setTextAlignment:NSTextAlignmentCenter];
    [self.title setText:@"分享/Share"];
    [self.alert addSubview:self.title];
    
    self.alert.sd_layout
    .centerXIs(WindowWidth/2)
    .centerYIs(WindowHeight/2)
    .widthIs(300)
    .heightIs(130);
    
    self.title.sd_layout
    .leftEqualToView(self.alert)
    .rightEqualToView(self.alert)
    .topSpaceToView(self.alert,10)
    .heightIs(30);
    
    NSArray * textArray = @[@"微信好友",@"QQ好友",@"复制链接"];
    NSArray * imageArray = @[@"btn_wechat_share",@"btn_qq_share",@"btn_link"];

    for(NSInteger index = 0; index < 3; index ++){
        
        UIView * option = [[UIView alloc] init];
        option.tag = index;
        [option addTarget:self action:@selector(optionSelected:)];
        [self.alert addSubview:option];
        
        UIImageView * icon = [[UIImageView alloc] init];
        [icon setContentMode:UIViewContentModeScaleAspectFit];
        [icon setImage:[UIImage imageNamed:imageArray[index]]];
        [option addSubview:icon];
        
        UILabel * text = [[UILabel alloc] init];
        [text setText:textArray[index]];
        [text setFont:Font(13)];
        [text setTextAlignment:NSTextAlignmentCenter];
        [option addSubview:text];
        
        option.sd_layout
        .leftSpaceToView(self.alert,index*100)
        .topSpaceToView(self.title,10)
        .bottomSpaceToView(self.alert,10)
        .widthIs(100);
        
        text.sd_layout
        .leftEqualToView(option)
        .bottomEqualToView(option)
        .rightEqualToView(option)
        .heightIs(30);
        
        icon.sd_layout
        .leftSpaceToView(option,0)
        .rightSpaceToView(option,0)
        .topSpaceToView(option,0)
        .bottomSpaceToView(text,0);
        
    }
    
}

- (void)showAlert{
    [self setHidden:NO];
    [self setAlpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:1];
    }];
    
}
- (void)closeAlert{
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished){
        [self setHidden:YES];
    }];
    
}

- (void)optionSelected:(UITapGestureRecognizer *)tap{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(userShareOption:)]){
        [self.delegate userShareOption:tap.view.tag];
    }
    [self closeAlert];
}

@end
