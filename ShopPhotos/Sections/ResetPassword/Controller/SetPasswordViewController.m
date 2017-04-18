//
//  SetPasswordViewController.m
//  ShopPhotos
//
//  Created by Macbook on 06/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "LoginCtr.h"
#import "AppDelegate.h"
#import "ErrMsgViewController.h"

@interface SetPasswordViewController (){
//    AppDelegate *appd;
    ErrMsgViewController *popupErrVC;
    
}

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    appd = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self setup];
    popupErrVC = [[ErrMsgViewController alloc] initWithNibName:@"ErrMsgViewController" bundle:nil];
}


- (void)setup{
    
    
    [self.back addTarget:self action:@selector(backSelected)];
    
    [_txtPass addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [_txtRePass addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    self.btnComplete.cornerRadius = 3;
}
-(void)textChanged:(UITextField *)textField
{
    if (_txtPass == textField) {
        if ([textField.text isEqualToString:@""]) {
            [_btnSecPass setHidden:YES];
        } else {
            [_btnSecPass setHidden:NO];
        }
    }
    if (_txtRePass == textField) {
        if ([textField.text isEqualToString:@""]) {
            [_btnSecRePass setHidden:YES];
        } else {
            [_btnSecRePass setHidden:NO];
        }
    }
    if (_txtPass.text.length < 6 || [_txtPass.text isEqualToString:@""] || !([_txtPass.text isEqualToString:_txtRePass.text])) {
        [_btnComplete setBackgroundColor:RGBACOLOR(212, 217, 226, 1)];
        [_btnComplete setEnabled:NO];
    } else {
        [_btnComplete setEnabled:YES];
        [_btnComplete setBackgroundColor:RGBACOLOR(68, 148, 210, 1)];
    }
}
- (IBAction)setPasswordSecret:(id)sender {
    if (self.txtPass.secureTextEntry == YES) {
        self.txtPass.secureTextEntry = NO;
        [_btnSecPass setBackgroundImage:[UIImage imageNamed:@"showPass.png"] forState:UIControlStateNormal];
    } else {
        self.txtPass.secureTextEntry = YES;
        [_btnSecPass setBackgroundImage:[UIImage imageNamed:@"hidPass.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)setRePasswordSecret:(id)sender {
    if (self.txtRePass.secureTextEntry == YES) {
        self.txtRePass.secureTextEntry = NO;
        [_btnSecRePass setBackgroundImage:[UIImage imageNamed:@"showPass.png"] forState:UIControlStateNormal];
    } else {
        self.txtRePass.secureTextEntry = YES;
        [_btnSecRePass setBackgroundImage:[UIImage imageNamed:@"hidPass.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)onComplete:(id)sender {
    NSDictionary *data=@{
                      @"password":self.txtPass.text,
                      @"password_confirmation":self.txtPass.text
                };
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPUTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.forgotPassword3,[self.appd getParameterString]]  parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            ErrMsgViewController *vc = [[ErrMsgViewController alloc] initWithNibName:@"ErrMsgViewController" bundle:nil];
            [vc showInView:self.view animated:YES type:@"success" message:@"修改成功！"];
//            [weakSelef showToast:@"修改成功！"];
            NSArray *viewControllers = weakSelef.navigationController.viewControllers;
            for (UIViewController *vc in viewControllers)
            {
                if([vc isKindOfClass:[LoginCtr class]])
                {
                    [self.navigationController popToViewController:vc animated:NO];
                    break;
                }
            }

        }else{
            [popupErrVC showInView:self animated:YES type:@"error" message:model.message];

//            [weakSelef showToast:model.message];
        }

    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
    
}
- (void)closePopupErr {
    [popupErrVC removeAnimate];
}

#pragma mark - 返回
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL bFlag = YES;
    if (textField == self.txtPass) {
        NSUInteger maxLength = 12;
        bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
        return bFlag;
    }
    return bFlag;
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
//- (void)completeRetrievePassword{
//    
//    if(self.sendType == PhoneCheck){
//        
//        if(self.phone.phone.enter.text == 0){
//            
//            [self showToast:@"请填写手机号码"];
//            return;
//        }
//        
//        if(self.phone.phoneCode.enter.text == 0 || ![self feedbackValidateEmail:self.mail.phone.enter.text]){
//            [self showToast:@"邮箱填写不正确"];
//            return;
//        }
//        
//        if(self.phone.password.enter.text == 0){
//            [self showToast:@"请填写新的密码"];
//            return;
//        }
//        
//        if(![self.phone.password.enter.text isEqualToString:self.phone.againPassword.enter.text]){
//            [self showToast:@"两次密码填写不一致"];
//            return;
//        }
//        
//        [self retrievePassword:@{@"channel":@"tel",
//                                 @"tel":self.phone.phone.enter.text,
//                                 @"email":@"",
//                                 @"authCode":self.phone.phoneCode.enter.text,
//                                 @"password":self.phone.password.enter.text}];
//        
//    }
//    
//    
//    
//}
//- (void)retrievePassword:(NSDictionary *)data{
//    [self showLoad];
//    __weak __typeof(self)weakSelef = self;
//    [HTTPRequest requestPOSTUrl:self.congfing.resetPassword2 parametric:data succed:^(id responseObject){
//        [weakSelef closeLoad];
//        NSLog(@"%@",responseObject);
//        BaseModel * model = [[BaseModel alloc] init];
//        [model analyticInterface:responseObject];
//        if(model.status == 0){
//            [weakSelef showToast:@"找回密码成功"];
//            [weakSelef.navigationController popViewControllerAnimated:YES];
//        }else{
//            [weakSelef showToast:model.message];
//        }
//        
//    } failure:^(NSError * error){
//        [weakSelef showToast:NETWORKTIPS];
//        [weakSelef closeLoad];
//    }];
//}


@end
