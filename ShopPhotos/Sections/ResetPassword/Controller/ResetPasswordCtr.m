//
//  ResetPasswordCtr.m
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "ResetPasswordCtr.h"
#import "ResetCheckView.h"
#import "SetPasswordViewController.h"
#import "ProvisionCtr.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "ErrMsgViewController.h"

@interface ResetPasswordCtr ()<UITextFieldDelegate>{
//    AppDelegate *appd;
    ErrMsgViewController *popupErrVC;

}

@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *btnSMS;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtSms;
@property (assign, nonatomic) NSInteger countdown;
@property (strong, nonatomic) NSTimer * timer;
@property (strong, nonatomic) NSString * timestamp;
@property (weak, nonatomic) IBOutlet UIImageView *imgCaptcha;
@property (weak, nonatomic) IBOutlet UITextField *txtCaptcha;
@property (weak, nonatomic) IBOutlet UIView *viewLic;

@end

@implementation ResetPasswordCtr

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    appd = (AppDelegate*)[UIApplication sharedApplication].delegate;
    popupErrVC = [[ErrMsgViewController alloc] initWithNibName:@"ErrMsgViewController" bundle:nil];
    
    [self setup];
    [self changeCaptcha:nil];
}


- (void)setup{

    
    [self.back addTarget:self action:@selector(backSelected)];
    
    [_txtPhone addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [_txtSms addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [_txtCaptcha addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    _btnNext.cornerRadius = 3;
    _btnSMS.cornerRadius = 3;
    if ([_fromType isEqualToString:@"register"]) {
        [_viewLic setHidden:NO];
    } else if ([_fromType isEqualToString:@"resetPassword"]){
        [_viewLic setHidden:YES];
    }
}
- (void)getCaptcha{
    NSString *urlStr = [NSString stringWithFormat:@"%@?timestamps=%@", self.congfing.getCaptcha, self.timestamp];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *ret = [UIImage imageWithData:imageData];
    [_imgCaptcha setImage:ret];
    
}
-(void)textChanged:(UITextField *)textField
{
    if ([_txtPhone.text isEqualToString:@""] || [_txtCaptcha.text isEqualToString:@""]) {
        [_btnSMS setEnabled:NO];
        [_btnSMS setBackgroundColor:RGBACOLOR(212, 217, 226, 1)];
    } else {
        if (self.countdown <= 0) {
            [_btnSMS setEnabled:YES];
            [_btnSMS setBackgroundColor:RGBACOLOR(68, 148, 210, 1)];
        }
        
    }
    if ([_txtPhone.text isEqualToString:@""] || [_txtSms.text isEqualToString:@""]) {
        [_btnNext setBackgroundColor:RGBACOLOR(212, 217, 226, 1)];
        [_btnNext setEnabled:NO];
    } else {
        [_btnNext setEnabled:YES];
        [_btnNext setBackgroundColor:RGBACOLOR(68, 148, 210, 1)];
    }
}

#pragma mark - 返回
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendSms:(id)sender {
    NSString * text = self.txtPhone.text;
    
    [self.txtPhone setText:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    // 发送手机验证码
    if(self.txtPhone.text.length == 0){
        [self showToast:@"请填写手机号码"];
    }else{
        [self sendCheckCode:@{
                              @"target":self.txtPhone.text,
                              @"captcha":self.txtCaptcha.text
                              }];
    }
}
- (IBAction)changeCaptcha:(id)sender {
    self.timestamp = TimeStamp;
    [self getCaptcha];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma makr - AFNetworking网络加载
- (void)sendCheckCode:(NSDictionary *)data{
    if ([_fromType isEqualToString:@"register"]) {
        [self sendCodeRegister:data];
    } else {
        [self sendCodeForgotPassword:data];
    }

}
-(void)sendCodeRegister:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@", self.congfing.register1,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"发送验证码成功"];
            [weakSelef startCountdown];
        }else{
            [popupErrVC showInView:self animated:YES type:@"error" message:model.message];
            
//            [weakSelef showToast:model.message];
            [self changeCaptcha:nil];
        }
        
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
    
}
-(void)sendCodeForgotPassword:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPUTUrl:[NSString stringWithFormat:@"%@%@", self.congfing.forgotPassword1,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"发送验证码成功"];
            [weakSelef startCountdown];
        }else{
            [popupErrVC showInView:self animated:YES type:@"error" message:model.message];
            //[weakSelef showToast:model.message];
            [self changeCaptcha:nil];
        }
        
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
    
}
- (void)startCountdown{
    [self.btnSMS setUserInteractionEnabled:NO];
    self.countdown = 60;
    [_btnSMS setEnabled:NO];
    [_btnSMS setBackgroundColor:RGBACOLOR(212, 217, 226, 1)];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendCodeCountdown) userInfo:nil repeats:YES];
    
}

- (void)sendCodeCountdown{
    NSLog(@"123213");
    self.countdown -- ;
    if(self.countdown > 0){
        NSString * title = [NSString stringWithFormat:@"%ld",self.countdown];
        [self.btnSMS setTitle:title forState:UIControlStateNormal];
    }else{
        [self.btnSMS setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.btnSMS setUserInteractionEnabled:YES];
        [self.timer invalidate];
        self.timer = nil;
        [_btnSMS setEnabled:YES];
        [_btnSMS setBackgroundColor:RGBACOLOR(68, 148, 210, 1)];

    }
}
- (IBAction)onNext:(id)sender {
    if ([_fromType isEqualToString:@"register"]) {
        [self nextRegister];
    } else {
        [self nextForgotPassword];
    }
}
- (void) nextForgotPassword{
    NSDictionary * data = @{
                            @"authCode":self.txtSms.text
                            };
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPUTUrl:[NSString stringWithFormat:@"%@%@", self.congfing.forgotPassword2,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            SetPasswordViewController *vc=[[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
            vc.strPhone = _txtPhone.text;
            vc.strAuthCode = _txtSms.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [popupErrVC showInView:self animated:YES type:@"error" message:model.message];

//            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
    
}
- (void) nextRegister{
    NSDictionary * data = @{
                            @"authCode":self.txtSms.text
                            };
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.register2,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            RegisterViewController *vc=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
            vc.strPhone = _txtPhone.text;
            vc.strAuthCode = _txtSms.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [popupErrVC showInView:self animated:YES type:@"error" message:model.message];
            
//            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
    
}
- (IBAction)onViewLic:(id)sender {
    ProvisionCtr * pro = GETALONESTORYBOARDPAGE(@"ProvisionCtr");
    [self.navigationController pushViewController:pro animated:YES];
}
@end
