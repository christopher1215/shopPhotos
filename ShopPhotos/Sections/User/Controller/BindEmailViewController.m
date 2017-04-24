//
//  BindEmailViewController.m
//  ShopPhotos
//
//  Created by Macbook on 18/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BindEmailViewController.h"
#import "ErrMsgViewController.h"

@interface BindEmailViewController (){
    ErrMsgViewController *popupErrVC;

}

@end

@implementation BindEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    popupErrVC = [[ErrMsgViewController alloc] initWithNibName:@"ErrMsgViewController" bundle:nil];
    [self setup];
    [self changeCaptcha:nil];
}
- (void)setup{
    
    
    [self.back addTarget:self action:@selector(backSelected)];
    
    [_txtEmail addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [_txtCaptcha addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [_txtSms addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    _btnNext.cornerRadius = 3;
    _btnSMS.cornerRadius = 3;
}
- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)getCaptcha{
    NSString *urlStr = [NSString stringWithFormat:@"%@?timestamps=%@", self.congfing.getCaptcha, self.timestamp];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *ret = [UIImage imageWithData:imageData];
    [_imgCaptcha setImage:ret];
    
}
- (IBAction)changeCaptcha:(id)sender {
    self.timestamp = TimeStamp;
    [self getCaptcha];
    
}

-(void)textChanged:(UITextField *)textField
{
    if ([_txtEmail.text isEqualToString:@""] || [_txtCaptcha.text isEqualToString:@""] || _txtCaptcha.text.length != 6) {
        [_btnSMS setEnabled:NO];
        [_btnSMS setBackgroundColor:RGBACOLOR(212, 217, 226, 1)];
    } else {
        if (self.countdown <= 0) {
            [_btnSMS setEnabled:YES];
            [_btnSMS setBackgroundColor:RGBACOLOR(68, 148, 210, 1)];
        }
        
    }
    if ([_txtEmail.text isEqualToString:@""] || [_txtSms.text isEqualToString:@""] || _txtSms.text.length != 6) {
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
    NSString * text = self.txtEmail.text;
    
    [self.txtEmail setText:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    // 发送手机验证码
    if(self.txtEmail.text.length == 0){
        [self showToast:@"请填写手机号码"];
    }else{
        [self sendCheckCode:@{
                              @"email":self.txtEmail.text,
                              @"captcha":self.txtCaptcha.text
                              }];
    }
}
- (void)sendCheckCode:(NSDictionary *)data{
    if(![self validateEmail:self.txtEmail.text]){
        [self showToast:@"请输入正确的邮箱"];
        return;
    }
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPUTUrl:[NSString stringWithFormat:@"%@%@", self.congfing.bindEmail1,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
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
- (void)closePopupErr {
    [popupErrVC removeAnimate];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)onNext:(id)sender {
    NSDictionary * data = @{
                            @"authCode":self.txtSms.text
                            };
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPUTUrl:[NSString stringWithFormat:@"%@%@", self.congfing.bindEmail2,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [popupErrVC showInView:self animated:YES type:@"error" message:model.message];
        }
        
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
