//
//  LoginCtr.m
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "LoginCtr.h"
#import "RegisteredCtr.h"
#import "ResetPasswordCtr.h"
#import "LogInLineView.h"
#import "TabBarCtr.h"
#import "LoginLoadModel.h"
#import "UserModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "PublicDataAnalytic.h"
#import "ChatLoginCtr.h"
#import "RequestUtil.h"
#import "HTTPUserAgent.h"
#import "WeChatLoginRequset.h"
#import "AppDelegate.h"
#import "ErrMsgViewController.h"
#import "ChatLoginRequset.h"
#import <RongIMKit/RongIMKit.h>

@interface LoginCtr ()<UITextFieldDelegate>{
    //    AppDelegate *appd;
    ErrMsgViewController *popupErrVC;
}
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UILabel *setPassword;
@property (weak, nonatomic) IBOutlet UILabel *registered;
@property (weak, nonatomic) IBOutlet UIImageView *qqLogin;
@property (weak, nonatomic) IBOutlet UIImageView *wechatLogin;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *btnPassSec;

@end

@implementation LoginCtr

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //    appd = (AppDelegate*)[UIApplication sharedApplication].delegate;
    popupErrVC = [[ErrMsgViewController alloc] initWithNibName:@"ErrMsgViewController" bundle:nil];
    [self setup];
}

- (void)setup{
    
    self.account.delegate = self;
    self.account.returnKeyType = UIReturnKeyJoin;
    self.account.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.password.delegate = self;
    self.password.secureTextEntry = YES;
    self.password.returnKeyType = UIReturnKeyJoin;
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.login.cornerRadius = 3;
    [self.login addTarget:self action:@selector(loginSelected)];
    
    [self.setPassword addTarget:self action:@selector(setPasswordSelected)];
    
    [self.registered addTarget:self action:@selector(registeredSelected)];
    
    self.qqLogin.borderColor = ColorHex(0X60D0FF);
    self.qqLogin.borderWidth = 1;
    self.qqLogin.cornerRadius = 25;
    [self.qqLogin addTarget:self action:@selector(qqLoginSelected)];
    
    self.wechatLogin.borderColor = ColorHex(0X8DC81C);
    self.wechatLogin.borderWidth = 1;
    self.wechatLogin.cornerRadius = 25;
    [self.wechatLogin addTarget:self action:@selector(wechatLoginSelected)];
    LogInLineView * line = [[LogInLineView alloc] initWithFrame:CGRectMake(0, 0, WindowWidth-60, 30)];
    [self.lineView addSubview:line];
    [_password addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [_account addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)setPasswordSecret:(id)sender {
    if (self.password.secureTextEntry == YES) {
        self.password.secureTextEntry = NO;
        [_btnPassSec setBackgroundImage:[UIImage imageNamed:@"showPass.png"] forState:UIControlStateNormal];
    } else {
        self.password.secureTextEntry = YES;
        [_btnPassSec setBackgroundImage:[UIImage imageNamed:@"hidPass.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - 登入
- (void)loginSelected{
    
    if(![self getValueWithKey:ShopPhotosApi]){
        __weak __typeof(self)weakSelef = self;
        [HTTPRequest requestGETUrl:UOOTUURL parametric:nil succed:^(id responseObject){
            NSLog(@"login success: %@",responseObject);
            PublicDataAnalytic * publicData = [[PublicDataAnalytic alloc] init];
            [publicData analyticInterface:responseObject];
        } failure:^(NSError * error){
            [weakSelef showToast:@"抱歉网络故障，请检测网络设置是否正常"];
        }];
        return;
    }
    
    [self.account resignFirstResponder];
    [self.password resignFirstResponder];
    
    if(self.account.text.length == 0 ||
       self.password.text.length == 0){
        
        [self showToast:@"账号密码填写不正确"];
        return;
    }
    
    // 登入
    [self loginLoadNetworkData:@{@"name":self.account.text, @"password":self.password.text}];
}

#pragma mark - 忘记密码
- (void)setPasswordSelected{
    ResetPasswordCtr * resetPassword = GETALONESTORYBOARDPAGE(@"ResetPasswordCtr");
    resetPassword.fromType = @"resetPassword";
    [self.navigationController pushViewController:resetPassword animated:YES];
}

#pragma mark - 注册
- (void)registeredSelected{
    //    RegisteredCtr * registered = GETALONESTORYBOARDPAGE(@"RegisteredCtr");
    //    [self.navigationController pushViewController:registered animated:YES];
    ResetPasswordCtr * resetPassword = GETALONESTORYBOARDPAGE(@"ResetPasswordCtr");
    resetPassword.fromType = @"register";
    [self.navigationController pushViewController:resetPassword animated:YES];
    
}

#pragma mark - QQ登入
- (void)qqLoginSelected{
    NSLog(@"QQ登入");
    [self showLoad];
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error){
        if(state == SSDKResponseStateSuccess){
            [self closeLoad];
            NSString * nickname = user.nickname;
            NSString * authId = [user.credential.rawData objectForKey:@"openid"];
            NSString * avatar = user.icon;
            if(nickname && authId && avatar){
                NSDictionary * data = @{@"nickname":nickname,
                                        @"authId":authId,
                                        @"avatar":avatar};
                [self appWithWeQQLogin:data];
            }else{
                [self showToast:@"QQ登录失败"];
            }
        }else{
            [self closeLoad];
            [self showToast:@"QQ登录失败"];
        }
    }];
}

#pragma mark - 微信登入
- (void)wechatLoginSelected{
    
    NSLog(@"微信登入");
    __weak __typeof(self)weakSelef = self;
    [self showLoad];
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error){
        if(state == SSDKResponseStateSuccess){
            [weakSelef appWithWeChatLogin:@{@"nickname":user.nickname,@"avatar":[user.rawData objectForKey:@"headimgurl"], @"authId":[user.rawData objectForKey:@"openid"]}];
        }else{
            [weakSelef showToast:@"微信登录失败"];
        }
        [weakSelef closeLoad];
    }];
}

#pragma 屏幕点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL bFlag = YES;
    if (textField == self.password) {
        NSUInteger maxLength = 32;
        bFlag = [textField.text stringByReplacingCharactersInRange:range withString:string].length <= maxLength;
        return bFlag;
    }
    return bFlag;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textChanged:(UITextField *)textField
{
    if (_password == textField) {
        if ([textField.text isEqualToString:@""]) {
            [_btnPassSec setHidden:YES];
        } else {
            [_btnPassSec setHidden:NO];
        }
    }
    if ([_password.text isEqualToString:@""] || [_account.text isEqualToString:@""]) {
        [_login setBackgroundColor:RGBACOLOR(212, 217, 226, 1)];
        [_login setEnabled:NO];
    } else {
        [_login setEnabled:YES];
        [_login setBackgroundColor:RGBACOLOR(68, 148, 210, 1)];
    }
}


#pragma makr - AFNetworking网络加载
- (void)loginLoadNetworkData:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.login,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        LoginLoadModel * model = [[LoginLoadModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0 || model.status == 200){
            [self setValue:self.password.text WithKey:@"password"];
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
            
            [popupErrVC showInView:self animated:YES type:@"error" message:model.message];
            [weakSelef closeLoad];
            
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

- (void)appWithWeChatLogin:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.useWXLogin,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        ChatLoginRequset * requset = [[ChatLoginRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [self setValue:data WithKey:@"WechatLoginData"];
            [[RCIM sharedRCIM] connectWithToken:requset.imToken     success:^(NSString *userId) {
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
        }else if(requset.status == 303){
            [weakSelef closeLoad];
            ChatLoginCtr * chat = GETALONESTORYBOARDPAGE(@"ChatLoginCtr");
            //chat.userData = [[NSMutableDictionary alloc] initWithDictionary:requset.userData];
            chat.type = TypeWechatSession;
            [self.navigationController pushViewController:chat animated:YES];
            
        }else{
            [weakSelef showToast:requset.message];
        }
        
        
    } failure:^(NSError * error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef closeLoad];
    }];
    
}

- (void)appWithWeQQLogin:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.useQQLogin,[self.appd getParameterString]] parametric:data  succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        ChatLoginRequset * requset = [[ChatLoginRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [self setValue:data WithKey:@"QQLoginData"];
            [[RCIM sharedRCIM] connectWithToken:requset.imToken     success:^(NSString *userId) {
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
        }else if(requset.status == 303){
            [weakSelef closeLoad];
            
            ChatLoginCtr * chat = GETALONESTORYBOARDPAGE(@"ChatLoginCtr");
            //            chat.userData = [[NSMutableDictionary alloc] initWithDictionary:requset.userData];
            chat.type = TypeQQSession;
            [self.navigationController pushViewController:chat animated:YES];
            
        }else{
            [weakSelef closeLoad];
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError * error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef closeLoad];
    }];
}

@end
