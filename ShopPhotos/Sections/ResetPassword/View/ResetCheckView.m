//
//  ResetCheckView.m
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "ResetCheckView.h"

@interface ResetCheckView ()

@property (strong, nonatomic) UIView * content;
@property (strong, nonatomic) UIButton * complete;
@property (strong, nonatomic) NSTimer * timer;
@property (assign, nonatomic) NSInteger countdown;

@end

@implementation ResetCheckView

- (instancetype)init
{
    self = [super init];
    if (self) {
    
        [self createAutoLayout];
        
    }
    return self;
}

- (void)createAutoLayout{
    
    self.content = [[ResetEnterView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.content];
    
    self.phone = [[ResetEnterView alloc] initWithFrame:CGRectZero];
    [self.phone.send addTarget:self action:@selector(sendCodeSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.content addSubview:self.phone];
    
    self.phoneCode = [[ResetEnterView alloc] initWithFrame:CGRectZero];
    [self.content addSubview:self.phoneCode];
    
    self.password = [[ResetEnterView alloc] initWithFrame:CGRectZero];
    self.password.enter.secureTextEntry = YES;
    [self.content addSubview:self.password];
    
    self.againPassword = [[ResetEnterView alloc] initWithFrame:CGRectZero];
    self.againPassword.enter.secureTextEntry = YES;
    [self.content addSubview:self.againPassword];
    
    self.complete = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.complete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.complete setBackgroundColor:ColorHex(0XFF500D)];
    [self.complete setTitle:@"重置密码" forState:UIControlStateNormal];
    [self.complete setCornerRadius:3];
    [self.complete addTarget:self action:@selector(completeSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.content addSubview:self.complete];
    
    self.content.sd_layout
    .leftSpaceToView(self,30)
    .topEqualToView(self)
    .rightSpaceToView(self,30)
    .bottomEqualToView(self);
    
    
    self.phone.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topEqualToView(self.content)
    .heightIs(45);
    
    self.phoneCode.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.phone,10)
    .heightIs(45);
    
    self.password.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.phoneCode,10)
    .heightIs(45);
    
    self.againPassword.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.password,10)
    .heightIs(45);
    
    self.complete.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.againPassword,30)
    .heightIs(40);
}

- (void)setStyle:(CheckStyle)style{
    
    if(style == PhoneCheck){
        
        self.phone.style = SendEnter;
        self.phone.iconName = @"ico_phone";
        self.phone.text = @"请输入手机号码";
        
        [self.phone.send setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        self.phoneCode.style = GeneralEnter;
        self.phoneCode.iconName = @"ico_message";
        self.phoneCode.text = @"请输入手机验证码";
        
    }else{
        
        
        
        self.phone.style = SendEnter;
        self.phone.iconName = @"ico_mail";
        self.phone.text = @"请输入注册邮箱";
        
        [self.phone.send setTitle:@"发送邮件" forState:UIControlStateNormal];
        
        self.phoneCode.style = GeneralEnter;
        self.phoneCode.iconName = @"ico_message";
        self.phoneCode.text = @"请输入邮箱验证码";
    }
    
    self.password.style = GeneralEnter;
    self.password.iconName = @"ico_password";
    self.password.text = @"请设置账号登入密码";
    
    self.againPassword.style = GeneralEnter;
    self.againPassword.iconName = @"ico_password";
    self.againPassword.text = @"请再次确认密码";
    
}

#pragma mark - 发送验证码
- (void)sendCodeSelected{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(resetSendCode)]){
        [self.delegate resetSendCode];
    }
}

- (void)startCountdown{
    [self.phone.send setUserInteractionEnabled:NO];
    self.countdown = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendCodeCountdown) userInfo:nil repeats:YES];
    
}

- (void)sendCodeCountdown{
    NSLog(@"123213");
    self.countdown -- ;
    if(self.countdown > 0){
        NSString * title = [NSString stringWithFormat:@"%ldS",self.countdown];
        [self.phone.send setTitle:title forState:UIControlStateNormal];
    }else{
        [self.phone.send setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.phone.send setUserInteractionEnabled:YES];
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)completeSelected{
    if(self.delegate && [self.delegate respondsToSelector:@selector(completeRetrievePassword)]){
        [self.delegate completeRetrievePassword];
    }
}

@end
