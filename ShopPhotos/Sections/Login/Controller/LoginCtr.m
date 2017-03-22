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

@interface LoginCtr ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UILabel *setPassword;
@property (weak, nonatomic) IBOutlet UILabel *registered;
@property (weak, nonatomic) IBOutlet UIImageView *qqLogin;
@property (weak, nonatomic) IBOutlet UIImageView *wechatLogin;
@property (weak, nonatomic) IBOutlet UIView *lineView;

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

}

#pragma mark - 登入
- (void)loginSelected{
    
    if(![self getValueWithKey:ShopPhotosApi]){
        __weak __typeof(self)weakSelef = self;
        [HTTPRequest requestGetUrl:UOOTUURL parametric:nil succed:^(id responseObject){
            NSLog(@"%@",responseObject);
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
    [self loginLoadNetworkData:@{@"name":self.account.text,
                                 @"password":self.password.text}];
    
}

#pragma mark - 忘记密码
- (void)setPasswordSelected{
    ResetPasswordCtr * resetPassword = GETALONESTORYBOARDPAGE(@"ResetPasswordCtr");
    [self.navigationController pushViewController:resetPassword animated:YES];
}

#pragma mark - 注册
- (void)registeredSelected{
    RegisteredCtr * registered = GETALONESTORYBOARDPAGE(@"RegisteredCtr");
    [self.navigationController pushViewController:registered animated:YES];
    
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
            [weakSelef appWithWeChatLogin:@{@"user":user.rawData,@"isIos":@"true"}];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma makr - AFNetworking网络加载
- (void)loginLoadNetworkData:(NSDictionary *)data{

    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.appLogin parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        LoginLoadModel * model = [[LoginLoadModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0 || model.status == 200){
            TabBarCtr * tabbar = [[TabBarCtr alloc] init];
            [weakSelef.navigationController pushViewController:tabbar animated:YES];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
}
- (void)appWithWeChatLogin:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.appWithWeChatLogin parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        WeChatLoginRequset * requset = [[WeChatLoginRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            if(requset.userID){
                TabBarCtr * tabbar = [[TabBarCtr alloc] init];
                [weakSelef.navigationController pushViewController:tabbar animated:YES];
            }else{
                [weakSelef showToast:@"登入失败"];
            }
        }else if(requset.status == 211){
            ChatLoginCtr * chat = GETALONESTORYBOARDPAGE(@"ChatLoginCtr");
            chat.userData = [[NSMutableDictionary alloc] initWithDictionary:requset.userData];
            chat.type = TypeWechatSession;
            [self.navigationController pushViewController:chat animated:YES];
            
        }else{
            [weakSelef showToast:requset.message];
        }
        
        
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];

}

- (void)appWithWeQQLogin:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.appWithQQLogin parametric:data  succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        WeChatLoginRequset * requset = [[WeChatLoginRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            if(requset.userID){
                TabBarCtr * tabbar = [[TabBarCtr alloc] init];
                [weakSelef.navigationController pushViewController:tabbar animated:YES];
            }else{
                [weakSelef showToast:@"登入失败"];
            }
        }else if(requset.status == 211){
            
            ChatLoginCtr * chat = GETALONESTORYBOARDPAGE(@"ChatLoginCtr");
            chat.userData = [[NSMutableDictionary alloc] initWithDictionary:requset.userData];
            chat.type = TypeQQSession;
            [self.navigationController pushViewController:chat animated:YES];
            
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
}
@end
