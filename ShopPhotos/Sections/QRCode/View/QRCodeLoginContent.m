//
//  QRCodeLoginContent.m
//  platform
//
//  Created by addcn on 16/11/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "QRCodeLoginContent.h"

@interface QRCodeLoginContent ()

@property (strong, nonatomic) NSDictionary * data;

@end

@implementation QRCodeLoginContent

- (instancetype)initWithData:(NSDictionary *)data;
{
    self = [super init];
    if (self) {
        if(data) _data = data;
        
        [self stCreateLayoutView];
        
    }
    return self;
}

- (void)stCreateLayoutView{
    
    [self setBackgroundColor:ColorHex(0XEEEEEE)];
    
    UIImageView * icon = [[UIImageView alloc] init];
    [icon setContentMode:UIViewContentModeCenter];
    [icon setImage:[UIImage imageNamed:@"qr_login_computer_icon"]];
    [self addSubview:icon];
    
    UILabel * title = [[UILabel alloc] init];
    [title setTextColor:ColorHex(0X333333)];
    [title setText:[self.data objectForKey:@"content"]];
    [title setFont:Font(18)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:title];
    
    UILabel * tip = [[UILabel alloc] init];
    [tip setText:@"為保安全，請勿掃描他人給予的登入QR碼"];
    [tip setTextColor:ColorHex(0X666666)];
    [tip setFont:Font(15)];
    [tip setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:tip];
    
    UIButton * sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure setCornerRadius:5];
    [sure setBackgroundColor:ThemeColor];
    [sure setTitle:[self.data objectForKey:@"buttonTitle"] forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sureSelect) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sure];
    
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitleColor:ColorHex(0x4D4D4D) forState:UIControlStateNormal];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancel];
    
    
    icon.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self,100)
    .heightIs(80);
    
    title.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(icon,35)
    .heightIs(30);
    
    tip.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(title,15)
    .heightIs(30);
    
    cancel.sd_layout
    .leftSpaceToView(self,30)
    .rightSpaceToView(self,30)
    .bottomSpaceToView(self,40)
    .heightIs(45);
    
    sure.sd_layout
    .leftSpaceToView(self,30)
    .rightSpaceToView(self,30)
    .bottomSpaceToView(cancel,20)
    .heightIs(45);
}

- (void)sureSelect{

    if(self.delegate && [self.delegate respondsToSelector:@selector(sureLoginSelect)]){
        [self.delegate sureLoginSelect];
    }
}

- (void)cancelSelect{

    if(self.delegate && [self.delegate respondsToSelector:@selector(cancelLoginSelect)]){
        [self.delegate cancelLoginSelect];
    }
}


@end
