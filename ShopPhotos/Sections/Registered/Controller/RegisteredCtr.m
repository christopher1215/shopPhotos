//
//  RegisteredCtr.m
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "RegisteredCtr.h"
#import "LoginLoadModel.h"
#import "TabBarCtr.h"
#import "ProvisionCtr.h"

#define countdownTimeKey @"countdownKey"

@interface RegisteredCtr ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIButton *sendMessage;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *phoneCode;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;
@property (weak, nonatomic) IBOutlet UITextField *mail;
@property (weak, nonatomic) IBOutlet UIButton *complete;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromTop;
@property (strong, nonatomic) UITextField * tempTextField;
//@property (strong, nonatomic) NSTimer * timer;
//@property (assign, nonatomic) NSInteger countdown;
@property (weak, nonatomic) IBOutlet UILabel *provisionText;
@property (weak, nonatomic) IBOutlet UILabel *provision;
@property (weak, nonatomic) IBOutlet UIView *provisionIcon;
@property (weak, nonatomic) IBOutlet UIImageView *provisonSeelcte;
@property (assign, nonatomic) BOOL provisionStatu;
@end

@implementation RegisteredCtr

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

- (void)setup{
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.sendMessage addTarget:self action:@selector(sendMessageSelected)];
    self.sendMessage.cornerRadius = 3;
    [self.provisionIcon addTarget:self action:@selector(provisionIconSelected)];
    [self.provisionText addTarget:self action:@selector(provisionIconSelected)];
    [self.provision addTarget:self action:@selector(provisionSelected)];
    
    
    self.phone.delegate = self;
    self.phone.keyboardType = UIKeyboardTypePhonePad;
    self.phoneCode.delegate = self;
    self.phoneCode.keyboardType = UIKeyboardTypePhonePad;
    self.account.delegate = self;
    self.password.delegate = self;
    self.password.secureTextEntry = YES;
    self.passwordAgain.delegate = self;
    self.passwordAgain.secureTextEntry = YES;
    self.mail.delegate = self;
    
    self.complete.cornerRadius = 3;
    [self.complete addTarget:self action:@selector(completeSelected) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - 返回
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)provisionIconSelected{
    
    self.provisionStatu = !self.provisionStatu;
    
    if(self.provisionStatu){
        [self.provisonSeelcte setImage:[UIImage imageNamed:@"icon_agree"]];
    }else{
        [self.provisonSeelcte setImage:[UIImage imageNamed:@"icon_refuse"]];
    }
}

- (void)provisionSelected{
    ProvisionCtr * pro = GETALONESTORYBOARDPAGE(@"ProvisionCtr");
    [self.navigationController pushViewController:pro animated:YES];
}

#pragma mark - 发送验证码
- (void)sendMessageSelected{
    if(self.phone.text.length == 0 || ![StringCheck isValidateMobile:self.phone.text]){
        [self showToast:@"请填写正确的手机号码"];
        return;
    }
    [self.phone resignFirstResponder];
    // 发送验证码
    [self sendCheckCode:@{@"tel":self.phone.text}];
}

#pragma mark - 完成注册
- (void)completeSelected{
    
    if(self.phone.text.length == 0 || ![StringCheck isValidateMobile:self.phone.text]){
        [self showToast:@"请填写正确的手机号码"];
        return;
    }
    
    if(self.phoneCode.text.length == 0){
        [self showToast:@"请填写手机验证码"];
        return;
    }
    
    if(self.account.text.length == 0){
        [self showToast:@"请填写账号"];
        return;
    }
    
    if(self.password.text.length == 0){
        [self showToast:@"请填写密码"];
        return;
    }
    
    if(self.passwordAgain.text.length == 0){
        [self showToast:@"请确认密码"];
        return;
    }
    
    if(![self.passwordAgain.text isEqualToString:self.password.text]){
        [self showToast:@"两次密码填写不一致"];
        return;
    }
    
    if(self.mail.text.length == 0){
        [self showToast:@"请填写常用邮箱"];
        return;
    }

    if(!self.provisionStatu){
        [self showToast:@"请仔细阅读并且同意服务条款"];
        return;
    }
    
    [self checkCode:@{@"authCode":self.phoneCode.text,
                      @"_token":self.congfing.token}];
    
}

#pragma 屏幕点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tempTextField resignFirstResponder];
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

#pragma mark - 键盘监听
- (void)keyboardWillShow:(NSNotification *)notification{
    
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat offset = keyboardHeight -(WindowHeight - (self.tempTextField.superview.frame.size.height + self.tempTextField.superview.frame.origin.y + 114));
    
    if(offset > -60){
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            self.fromTop.constant = -100;
            [self.view layoutIfNeeded];
        }];
    }
}
- (void)keyboardWillHide:(NSNotification *)notification{
    
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.fromTop.constant = 30;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 发送验证码倒计时

- (void)countDownWithTime:(int)time{
    
    
    __block int timeout = time;
    __weak __typeof(self)weakSelef = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(NSInteger index = timeout; index>=0;index--){
            NSLog(@"111");
            // 耗时的操作
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                if(timeout == 0){
                    [weakSelef.sendMessage setUserInteractionEnabled:YES];
                    [weakSelef.sendMessage setTitle:@"获取验证码" forState:UIControlStateNormal];
                }else{
                    [weakSelef.sendMessage setUserInteractionEnabled:YES];
                    NSString * title = [NSString stringWithFormat:@"%ldS",(long)index];
                    [weakSelef.sendMessage setTitle:title forState:UIControlStateNormal];
                }
            });
        }
    });
}

#pragma makr - AFNetworking网络加载
- (void)sendCheckCode:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.authTel parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            
            [weakSelef showToast:@"发送验证码成功"];
            [weakSelef countDownWithTime:60];
            
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError * error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef closeLoad];
    }];
    
}

- (void)checkCode:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.authTel parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef registeredUser:@{@"name":weakSelef.account.text,@"email":weakSelef.mail.text,@"password":weakSelef.password.text}];
            
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError * error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef closeLoad];
    }];
}

- (void)registeredUser:(NSDictionary *)data{
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.registerUser parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        
        LoginLoadModel * model = [[LoginLoadModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"注册成功"];
            TabBarCtr * tabbar = [[TabBarCtr alloc] init];
            [weakSelef.navigationController pushViewController:tabbar animated:YES];
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError * error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef closeLoad];
    }];

}

@end
