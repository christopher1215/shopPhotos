//
//  SettingCtr.m
//  ShopPhotos
//
//  Created by addcn on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "SettingCtr.h"
#import "CacheFileOption.h"
#import "ReSetPwdCtr.h"
#import "UserInfoModel.h"
#import "LoginCtr.h"
#import "NSObject+StoreValue.h"
#import "RequestUtil.h"
#import "UserModel.h"
#import <ShareSDK/ShareSDK.h>

@interface SettingCtr ()
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwitch *switchCopy;
@property (weak, nonatomic) IBOutlet UISwitch *showPrize;
@property (weak, nonatomic) IBOutlet UIView *resetPasswork;
@property (weak, nonatomic) IBOutlet UIView *checkUpdata;
@property (weak, nonatomic) IBOutlet UIView *removeCache;
@property (weak, nonatomic) IBOutlet UILabel *dataSize;
@property (weak, nonatomic) IBOutlet UIButton *loginOut;

@end

@implementation SettingCtr

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self loadNetworkData:@{@"uid":self.uid}];
}

- (void)setup{

    CacheFileOption * cache = [[CacheFileOption alloc] init];
    [self.dataSize setText:[NSString stringWithFormat:@"%.2fM",[cache getCacheSize]]];
    [self.back addTarget:self action:@selector(backSelected)];
    [self.resetPasswork addTarget:self action:@selector(resetPassworkSelected)];
    [self.checkUpdata addTarget:self action:@selector(checkUpdataSelected)];
    [self.removeCache addTarget:self action:@selector(removeCacheSelected)];
    [self.switchCopy addTarget:self action:@selector(switchSelected:) forControlEvents:UIControlEventValueChanged];
    [self.showPrize addTarget:self action:@selector(showPrizeSelected:) forControlEvents:UIControlEventValueChanged];
    [self.loginOut addTarget:self action:@selector(loginoutSelected) forControlEvents:UIControlEventTouchUpInside];
}

- (NSDictionary *)getPostData{
    
    NSString * allowCoyp = @"0";
    if(self.switchCopy.on){
        allowCoyp = @"1";
    }else{
        allowCoyp = @"0";
    }
    
    NSString * showPrize = @"0";
    if(self.showPrize.on){
        showPrize = @"1";
    }else{
        showPrize = @"0";
    }
    
    return @{@"allowCopy":allowCoyp,
             @"photoStyle":@"10",
             @"showPrice":showPrize,
             @"watermark":@"1"};
    
}

- (void)setStyle:(UserInfoModel *)model{
    if(model.config && model.config.count > 0){
        
        NSNumber * allowCopy = [model.config objectForKey:@"allowCopy"];
        NSNumber * showPrice = [model.config objectForKey:@"showPrice"];
        if([allowCopy integerValue] == 1){
            [self.switchCopy setOn:YES animated:YES];
        }else{
             [self.switchCopy setOn:NO animated:YES];
        }
        
        if([showPrice integerValue] == 1){
            [self.showPrize setOn:YES animated:YES];
        }else{
             [self.showPrize setOn:NO animated:YES];
        }
    }

}

#pragma mark - OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchSelected:(UISwitch *)swt{
    [self changeSetting:[self getPostData]];
}

- (void)showPrizeSelected:(UISwitch *)swt{
    [self changeSetting:[self getPostData]];
}

- (void)resetPassworkSelected{
    ReSetPwdCtr * reSetpwd = GETALONESTORYBOARDPAGE(@"ReSetPwdCtr");
    [self.navigationController pushViewController:reSetpwd animated:YES];
}

- (void)checkUpdataSelected{
    
    [self showToast:@"当前为最新版本"];
}

- (void)removeCacheSelected{
    
    __weak __typeof(self)weakSelef = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否清除缓存" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [weakSelef showLoad];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            CacheFileOption * cache = [[CacheFileOption alloc] init];
            
            sleep(1);
            [cache clearCacheAtPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [weakSelef.dataSize setText:[NSString stringWithFormat:@"%.2fM",[cache getCacheSize]]];
                [weakSelef closeLoad];
            });
        });
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loginoutSelected{
    
    [self loadLoginOutData];
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getUserInfo parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        UserInfoModel * infoModel = [[UserInfoModel alloc] init];
        [infoModel analyticInterface:responseObject];
        if(infoModel.status == 0){
            [weakSelef setStyle:infoModel];
        }else{
            [self showToast:infoModel.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)changeSetting:(NSDictionary *)data{
    NSLog(@"data -- %@",data);
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.handleChangeConfig parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"修改成功"];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)loadLoginOutData{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.appLogout parametric:nil succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        [weakSelef removeValueWithKey:CacheUserModel];
        [weakSelef removeValueWithKey:SESSIONCOOKKEY];
        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
        [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
        [weakSelef.navigationController pushViewController:login animated:YES];
    } failure:^(NSError *error){
        [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
        [weakSelef removeValueWithKey:CacheUserModel];
        [weakSelef removeValueWithKey:SESSIONCOOKKEY];
        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
        [weakSelef.navigationController pushViewController:login animated:YES];
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

@end
