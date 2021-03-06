//
//  RegisterViewController.m
//  ShopPhotos
//
//  Created by Macbook on 07/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginLoadModel.h"
#import "TabBarCtr.h"
#import "NSObject+StoreValue.h"
#import "AppDelegate.h"
#import "ErrMsgViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface RegisterViewController (){
//    AppDelegate *appd;
    ErrMsgViewController *popupErrVC;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    appd = (AppDelegate*)[UIApplication sharedApplication].delegate;
    popupErrVC = [[ErrMsgViewController alloc] initWithNibName:@"ErrMsgViewController" bundle:nil];
    [self setup];
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
    NSDictionary *data=@{@"password":_txtPass.text, @"password_confirmation":_txtPass.text};
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.register3,[self.appd getParameterString]]  parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        LoginLoadModel * model = [[LoginLoadModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0 || model.status == 200){
//            [self setValue:model.authToken WithKey:ShopPhotosToken];
            [self setValue:self.txtPass.text WithKey:@"password"];
            [popupErrVC showInView:self animated:YES type:@"success" message:@"注册成功"];
            [[RCIM sharedRCIM] connectWithToken:model.imToken     success:^(NSString *userId) {
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelef closeLoad];
                    //更新UI操作
                    int totalUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
                    NSLog(@"当前所有会话的未读消息数为：%d", totalUnreadCount);
                    NSDictionary * userInfo = @{ @"totalUnreadCount": [NSString stringWithFormat:@"%d", totalUnreadCount]};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getTotalUnreadCount" object:nil userInfo:userInfo];
                    TabBarCtr * tabbar = [[TabBarCtr alloc] init];
                    [weakSelef.navigationController pushViewController:tabbar animated:YES];
                });
                
            } error:^(RCConnectErrorCode status) {
                NSLog(@"登陆的错误码为:%d", status);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelef closeLoad];
                    TabBarCtr * tabbar = [[TabBarCtr alloc] init];
                    [weakSelef.navigationController pushViewController:tabbar animated:YES];
                });
                
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelef closeLoad];
                    TabBarCtr * tabbar = [[TabBarCtr alloc] init];
                    [weakSelef.navigationController pushViewController:tabbar animated:YES];
                });
                
            }];
            
            
        }else{
            [weakSelef closeLoad];
            [popupErrVC showInView:self animated:YES type:@"error" message:model.message];
            
//            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError * error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
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
        NSUInteger maxLength = 32;
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

@end
