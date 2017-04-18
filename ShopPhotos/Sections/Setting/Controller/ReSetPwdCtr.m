//
//  ReSetPwdCtr.m
//  ShopPhotos
//
//  Created by addcn on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "ReSetPwdCtr.h"
#import "AppDelegate.h"

@interface ReSetPwdCtr ()<UITextFieldDelegate>{
//    AppDelegate *appd;

}
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIButton *sure;
@property (weak, nonatomic) IBOutlet UITextField *jPwd;
@property (weak, nonatomic) IBOutlet UITextField *nPwd;
@property (weak, nonatomic) IBOutlet UITextField *anPwd;

@end

@implementation ReSetPwdCtr

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    appd = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self setup];
}

- (void)setup{
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.sure addTarget:self action:@selector(sureSelected) forControlEvents:UIControlEventTouchUpInside];
    self.sure.layer.cornerRadius = 5;
    self.jPwd.delegate = self;
    self.jPwd.secureTextEntry = YES;
    self.nPwd.delegate = self;
    self.nPwd.secureTextEntry = YES;
    self.anPwd.delegate = self;
    self.anPwd.secureTextEntry = YES;
}

#pragma mark - Onclick
- (void)backSelected{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureSelected{
    
    [self.jPwd resignFirstResponder];
    [self.nPwd resignFirstResponder];
    [self.anPwd resignFirstResponder];
    
    
    if(!self.jPwd.text || self.jPwd.text.length == 0){
//        ShowAlert(@"请输入旧密码");
        SPAlert(@"请输入旧密码",self);
        return;
    }
    
    if(!self.nPwd.text || self.nPwd.text.length == 0){
//        ShowAlert(@"请输入新密码");
        SPAlert(@"请输入新密码",self);
        return;
    }
    
    if(![self.nPwd.text isEqualToString:self.anPwd.text]){
        SPAlert(@"两次密码输入不一致",self);
        return;
    }
    
    
    [self changePassword:@{@"oldPassword":self.jPwd.text,
                           @"password":self.nPwd.text,
                           @"password_confirmation":self.nPwd.text}];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma makr - AFNetworking网络加载
- (void)changePassword:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPUTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.updatePassword,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"修改成功"];
            [weakSelef.navigationController popViewControllerAnimated:YES];
        }else{
            SPAlert(model.message,self);
            //[weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
    
}
@end
