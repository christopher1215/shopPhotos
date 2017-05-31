//
//  SplashViewController.m
//  ShopPhotos
//
//  Created by Macbook on 13/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "SplashViewController.h"
#import "UserModel.h"
#import "LoginCtr.h"
#import "TabBarCtr.h"
#import "SBSliderView.h"
#import "AppDelegate.h"
#import "DDKit.h"
#import "BaseNavigationCtr.h"
#import "LoginLoadModel.h"
#import <RongIMKit/RongIMKit.h>
#import "ChatLoginRequset.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserModel * userModel = [self getValueWithKey:CacheUserModel];
    if(userModel){
        // 已登入
        NSString *pass = [self getValueWithKey:@"password"];
        NSDictionary *QQLoginData = [self getValueWithKey:@"QQLoginData"];
        NSDictionary *WechatLoginData = [self getValueWithKey:@"WechatLoginData"];
        if (pass) {
            NSDictionary *data = @{@"name":userModel.uid, @"password":pass};
            [self showLoad];
            __weak __typeof(self)weakSelef = self;
            [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.login,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
                LoginLoadModel * model = [[LoginLoadModel alloc] init];
                [model analyticInterface:responseObject];
                if(model.status == 0 || model.status == 200){
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
                            [self.appd setStartViewController:tabbar];


                        });
                    } error:^(RCConnectErrorCode status) {
//                        [weakSelef showToast:@"token错误"];
                        NSLog(@"登陆的错误码为:%d", status);
                        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
                        [self.appd setStartViewController:login];
                        [weakSelef showToast:model.message];

                    } tokenIncorrect:^{
                        //token过期或者不正确。
                        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//                        [weakSelef showToast:@"token错误"];
                        NSLog(@"token错误");
                        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
                        [self.appd setStartViewController:login];
                        [weakSelef showToast:model.message];

                    }];
                }else{
                    
                    LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
                    [self.appd setStartViewController:login];
                    [weakSelef showToast:model.message];
                }
            } failure:^(NSError * error){
                [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
                [weakSelef closeLoad];
                LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
                [self.appd setStartViewController:login];

            }];
            
        } else if(WechatLoginData){
            [self showLoad];
            __weak __typeof(self)weakSelef = self;
            [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.useWXLogin,[self.appd getParameterString]] parametric:WechatLoginData  succed:^(id responseObject){
                NSLog(@"%@",responseObject);
                ChatLoginRequset * requset = [[ChatLoginRequset alloc] init];
                [requset analyticInterface:responseObject];
                if(requset.status == 0){
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
                            [self.appd setStartViewController:tabbar];
                            
                            
                        });
                    } error:^(RCConnectErrorCode status) {
                        [weakSelef showToast:@"token错误"];
                        NSLog(@"登陆的错误码为:%d", status);
                        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
                        [self.appd setStartViewController:login];
                    } tokenIncorrect:^{
                        //token过期或者不正确。
                        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                        [weakSelef showToast:@"token错误"];
                        NSLog(@"token错误");
                        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
                        [self.appd setStartViewController:login];
                    }];
                    
                }else{
                    
                    LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
                    [self.appd setStartViewController:login];
                    [weakSelef showToast:requset.message];
                }
            } failure:^(NSError * error){
                [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
                [weakSelef closeLoad];
                LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
                [self.appd setStartViewController:login];
            }];
            
        } else if(QQLoginData){
            [self showLoad];
            __weak __typeof(self)weakSelef = self;
            [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.useQQLogin,[self.appd getParameterString]] parametric:QQLoginData  succed:^(id responseObject){
                NSLog(@"%@",responseObject);
                ChatLoginRequset * requset = [[ChatLoginRequset alloc] init];
                [requset analyticInterface:responseObject];
                if(requset.status == 0){
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
                            [self.appd setStartViewController:tabbar];
                            
                            
                        });
                    } error:^(RCConnectErrorCode status) {
                        [weakSelef showToast:@"token错误"];
                        NSLog(@"登陆的错误码为:%d", status);
                        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
                        [self.appd setStartViewController:login];
                    } tokenIncorrect:^{
                        //token过期或者不正确。
                        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                        [weakSelef showToast:@"token错误"];
                        NSLog(@"token错误");
                        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
                        [self.appd setStartViewController:login];
                    }];

                }else{
                    
                    LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
                    [self.appd setStartViewController:login];
                    [weakSelef showToast:requset.message];
                }
            } failure:^(NSError * error){
                [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
                [weakSelef closeLoad];
                LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
                [self.appd setStartViewController:login];
            }];
        }
        
    }else{
        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
        [self.appd setStartViewController:login];
    }
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
