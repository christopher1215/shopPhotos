//
//  ResetEnterView.m
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "ResetEnterView.h"

@interface ResetEnterView ()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UIView * line;

@end

@implementation ResetEnterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createAutoLayout];
        
    }
    return self;
}

- (void)createAutoLayout{
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.icon];
    
    self.enter = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.enter setFont:[UIFont systemFontOfSize:13]];
    //self.enter.delegate = self;
    [self addSubview:self.enter];
    
    self.send = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.send setBackgroundColor:ColorHex(0XEEEEEE)];
    self.send.titleLabel.font = Font(13);
    [self.send setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.send.cornerRadius = 3;
    [self.send setTitleColor:ColorHex(0X888888) forState:UIControlStateNormal];
    [self addSubview:self.send];
    
    self.line = [[UIView alloc] initWithFrame:CGRectZero];
    [self.line setBackgroundColor:ColorHex(0XEEEEEE)];
    [self addSubview:self.line];
    
}

- (void)setStyle:(EnterStyle)style{
    
    _style = style;
    if(_style == GeneralEnter){
        [self.send setHidden:YES];
        
        self.icon.sd_layout
        .leftSpaceToView(self,5)
        .topSpaceToView(self,9)
        .heightIs(20)
        .widthIs(20);
        
        self.enter.sd_layout
        .leftSpaceToView(self.icon,5)
        .topSpaceToView(self,5)
        .rightSpaceToView(self,5)
        .heightIs(30);
        
        self.line.sd_layout
        .leftEqualToView(self)
        .bottomEqualToView(self)
        .rightEqualToView(self)
        .heightIs(1);
    }else{
        
        self.icon.sd_layout
        .leftSpaceToView(self,5)
        .topSpaceToView(self,9)
        .heightIs(20)
        .widthIs(20);
        
        self.send.sd_layout
        .topSpaceToView(self,5)
        .rightSpaceToView(self,5)
        .bottomSpaceToView(self,5)
        .widthIs(80);
        
        self.enter.sd_layout
        .leftSpaceToView(self.icon,5)
        .topSpaceToView(self,5)
        .rightSpaceToView(self.send,5)
        .heightIs(30);
        
        self.line.sd_layout
        .leftEqualToView(self)
        .bottomEqualToView(self)
        .rightEqualToView(self)
        .heightIs(1);
        
    }
}

- (void)setIconName:(NSString *)iconName{
    [self.icon setImage:[UIImage imageNamed:iconName]];
}

- (void)setText:(NSString *)text{
    [self.enter setPlaceholder:text];
}



@end
