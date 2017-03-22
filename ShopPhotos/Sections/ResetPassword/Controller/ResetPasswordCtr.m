//
//  ResetPasswordCtr.m
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "ResetPasswordCtr.h"
#import "ResetCheckView.h"

@interface ResetPasswordCtr ()<UIScrollViewDelegate,UITextFieldDelegate,ResetCheckViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UILabel *phoneCheck;
@property (weak, nonatomic) IBOutlet UILabel *mailCheck;
@property (weak, nonatomic) IBOutlet UIView * line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOffset;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) ResetCheckView * phone;
@property (strong, nonatomic) ResetCheckView * mail;
@property (strong, nonatomic) UITextField * tempTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrllOffset;
@property (assign, nonatomic) CheckStyle sendType;

@end

@implementation ResetPasswordCtr

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup{

    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.phoneCheck addTarget:self action:@selector(phoneCheckSelected)];
    [self.mailCheck addTarget:self action:@selector(mailCheckSelected)];
    
    [self.scrollView setContentSize:CGSizeMake(WindowWidth*2,0)];
    
    self.scrollView.delegate = self;
    [self.scrollView addTarget:self action:@selector(scrollViewSelected)];
    self.sendType = PhoneCheck;
    
    self.phone = [[ResetCheckView alloc] init];
    self.phone.style = PhoneCheck;
    self.phone.delegate = self;
    self.phone.phone.enter.keyboardType = UIKeyboardTypeNumberPad;
    self.phone.phoneCode.enter.keyboardType = UIKeyboardTypeNumberPad;
    self.phone.phone.enter.delegate = self;
    self.phone.phoneCode.enter.delegate = self;
    self.phone.password.enter.delegate = self;
    self.phone.againPassword.enter.delegate = self;
    [self.scrollView addSubview:self.phone];
    
    self.mail = [[ResetCheckView alloc] init];
    self.mail.style = MailCheck;
    self.mail.phoneCode.enter.keyboardType = UIKeyboardTypeNumberPad;
    self.mail.delegate = self;
    self.mail.phone.enter.delegate = self;
    self.mail.phoneCode.enter.delegate = self;
    self.mail.password.enter.delegate = self;
    self.mail.againPassword.enter.delegate = self;
    [self.scrollView addSubview:self.mail];
    
    self.phone.sd_layout
    .leftEqualToView(self.scrollView)
    .topEqualToView(self.scrollView)
    .bottomEqualToView(self.scrollView)
    .widthIs(WindowWidth);
    
    self.mail.sd_layout
    .leftSpaceToView(self.scrollView,WindowWidth)
    .topEqualToView(self.scrollView)
    .bottomEqualToView(self.scrollView)
    .widthIs(WindowWidth);
}

#pragma mark - 返回
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 手机验证
- (void)phoneCheckSelected{

    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - 邮箱验证
- (void)mailCheckSelected{
    [self.scrollView setContentOffset:CGPointMake(WindowWidth, 0) animated:YES];
}

#pragma 屏幕点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tempTextField resignFirstResponder];
}

- (void)scrollViewSelected{
    [self.tempTextField resignFirstResponder];
}

- (BOOL)feedbackValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


#pragma mark - ResetCheckViewDelegate
- (void)resetSendCode{
    
    NSString * text = self.mail.phone.enter.text;
    
    [self.mail.phone.enter setText:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    if(self.sendType == PhoneCheck){
        // 发送手机验证码
        if(self.phone.phone.enter.text.length == 0){
            [self showToast:@"请填写手机号码"];
        }else{
          [self sendCheckCode:@{@"channel":@"tel",
                                @"tel":self.phone.phone.enter.text,
                                @"email":self.phone.phone.enter.text}];
        }
    }else{
        if(self.mail.phone.enter.text.length == 0 || ![self feedbackValidateEmail:self.mail.phone.enter.text]){
            [self showToast:@"邮箱填写不正确"];
        }else{
            // 发送邮箱验证码
            [self sendCheckCode:@{@"channel":@"email",
                                  @"email":self.mail.phone.enter.text,
                                  @"tel":self.mail.phone.enter.text}];
        }
    }
}

- (void)completeRetrievePassword{
    
    if(self.sendType == PhoneCheck){
    
        if(self.phone.phone.enter.text == 0){
        
            [self showToast:@"请填写手机号码"];
            return;
        }
        
        if(self.phone.phoneCode.enter.text == 0 || ![self feedbackValidateEmail:self.mail.phone.enter.text]){
             [self showToast:@"邮箱填写不正确"];
            return;
        }
        
        if(self.phone.password.enter.text == 0){
            [self showToast:@"请填写新的密码"];
            return;
        }
        
        if(![self.phone.password.enter.text isEqualToString:self.phone.againPassword.enter.text]){
            [self showToast:@"两次密码填写不一致"];
            return;
        }
        
        [self retrievePassword:@{@"channel":@"tel",
                                 @"tel":self.phone.phone.enter.text,
                                 @"email":@"",
                                 @"authCode":self.phone.phoneCode.enter.text,
                                 @"password":self.phone.password.enter.text}];
        
    }else{
    
        if(self.mail.phone.enter.text == 0){
            
            [self showToast:@"请填写注册邮箱"];
            return;
        }
        
        if(self.mail.phoneCode.enter.text == 0){
            [self showToast:@"请填写验证码"];
            return;
        }
        
        if(self.mail.password.enter.text == 0){
            [self showToast:@"请填写新的密码"];
            return;
        }
        
        if(![self.mail.password.enter.text isEqualToString:self.mail.againPassword.enter.text]){
            [self showToast:@"两次密码填写不一致"];
            return;
        }
        
        [self retrievePassword:@{@"channel":@"email",
                                 @"tel":@"",
                                 @"email":self.mail.phone.enter.text,
                                 @"authCode":self.mail.phoneCode.enter.text,
                                 @"password":self.mail.password.enter.text}];
    }
    
    
    
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if(offsetX == 0){
        [self.phoneCheck setTextColor:ColorHex(0XFF500D)];
        [self.mailCheck setTextColor:ColorHex(0X000000)];
        self.sendType = PhoneCheck;
    }else if(offsetX == WindowWidth){
        [self.phoneCheck setTextColor:ColorHex(0X000000)];
        [self.mailCheck setTextColor:ColorHex(0XFF500D)];
        self.sendType = MailCheck;
    }
    self.lineOffset.constant = (WindowWidth - 160) * (offsetX/WindowWidth);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.tempTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma makr - AFNetworking网络加载
- (void)sendCheckCode:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.sendAuthCode parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"发送验证码成功"];
            if(weakSelef.sendType == PhoneCheck){
                [weakSelef.phone startCountdown];
            }else{
                [weakSelef.mail startCountdown];
            }
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
}

- (void)retrievePassword:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.resetPassword2 parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"找回密码成功"];
            [weakSelef.navigationController popViewControllerAnimated:YES];
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
}


@end
