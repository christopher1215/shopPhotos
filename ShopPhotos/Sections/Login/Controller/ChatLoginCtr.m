//
//
;
//  ShopPhotos
//
//  Created by addcn on 17/1/6.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "ChatLoginCtr.h"
#import "ResetEnterView.h"
#import "ChatLoginRequset.h"
#import "TabBarCtr.h"
#import "ErrMsgViewController.h"
#import "ProvisionCtr.h"

@interface ChatLoginCtr ()<UIScrollViewDelegate>{
    ErrMsgViewController *popupErrVC;

}

@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UILabel *regOption;
@property (weak, nonatomic) IBOutlet UILabel *uootuOtion;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOffset;
@property (weak, nonatomic) IBOutlet UIScrollView *content;

@property (strong, nonatomic) ResetEnterView * phone;
@property (strong, nonatomic) UIImageView * imgviewCaptcha;
@property (strong, nonatomic) UITextField * captcha;
@property (strong, nonatomic) ResetEnterView * phoneCode;
@property (strong, nonatomic) ResetEnterView * password;
@property (strong, nonatomic) ResetEnterView * againPassword;
@property (strong, nonatomic) ResetEnterView * email;
@property (strong, nonatomic) UIButton * regSure;
@property (strong, nonatomic) UIButton * btnLic;

@property (strong, nonatomic) ResetEnterView * uAccount;
@property (strong, nonatomic) ResetEnterView * uPassword;
@property (strong, nonatomic) UIButton * uSure;
@property (assign, nonatomic) NSInteger countdown;
@property (strong, nonatomic) NSTimer * timer;
@property (strong, nonatomic) NSString * timestamp;

@property (assign, nonatomic) NSInteger selectType;


@end

@implementation ChatLoginCtr

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    popupErrVC = [[ErrMsgViewController alloc] initWithNibName:@"ErrMsgViewController" bundle:nil];
    [self setup];
    
    [self createAutoLayout];
    [self changeCaptcha:nil];
}

- (void)setup{
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.regOption addTarget:self action:@selector(regOptionSelected)];
    [self.uootuOtion addTarget:self action:@selector(uootuOtionSelected)];
    
    self.content.delegate = self;
    self.content.pagingEnabled = YES;
    self.content.showsVerticalScrollIndicator = NO;
    self.content.showsHorizontalScrollIndicator = NO;

}

- (void)createAutoLayout{
    
    UIView * regView = [[UIView alloc] init];
    [self.content addSubview:regView];
    regView.sd_layout
    .leftSpaceToView(self.content,20)
    .rightSpaceToView(self.content,20)
    .bottomEqualToView(self.content)
    .widthIs(WindowWidth-40);
    
    self.phone = [[ResetEnterView alloc] init];
    [self.phone setStyle:GeneralEnter];
//    self.phone.iconName = @"ico_phone";
    self.phone.enter.placeholder = @"请输入手机号";
    [regView addSubview:self.phone];
    self.phone.sd_layout
    .leftSpaceToView(regView,0)
    .rightSpaceToView(regView,0)
    .topSpaceToView(regView,20)
    .heightIs(45);
    
    self.imgviewCaptcha = [[UIImageView alloc] init];
    self.imgviewCaptcha.userInteractionEnabled = YES;
    [self.imgviewCaptcha addTarget:self action:@selector(changeCaptcha:)];
    [regView addSubview:self.imgviewCaptcha];
    self.imgviewCaptcha.sd_layout
    .leftSpaceToView(regView,30)
    .topSpaceToView(self.phone,10)
    .widthIs(150)
    .heightIs(45);

    self.captcha = [[UITextField alloc] init];
    self.captcha.placeholder = @"图片验证吗";
    self.captcha.textAlignment = NSTextAlignmentCenter;
    [self.captcha setFont:[UIFont systemFontOfSize:15]];
    [regView addSubview:self.captcha];
    self.captcha.sd_layout
    .leftSpaceToView(self.imgviewCaptcha,8)
    .rightSpaceToView(regView,0)
    .topSpaceToView(self.phone,10)
    .heightIs(45);

    self.phoneCode = [[ResetEnterView alloc] init];
    [self.phoneCode setStyle:SendEnter];
    [self.phoneCode.send addTarget:self action:@selector(sendPhoneCode) forControlEvents:UIControlEventTouchUpInside];
//    self.phoneCode.iconName = @"ico_message";
    self.phoneCode.enter.placeholder = @"请输入验证码";
    [regView addSubview:self.phoneCode];
    self.phoneCode.sd_layout
    .leftSpaceToView(regView,0)
    .rightSpaceToView(regView,0)
    .topSpaceToView(self.imgviewCaptcha,10)
    .heightIs(45);
    
    self.password = [[ResetEnterView alloc] init];
    [self.password setStyle:GeneralEnter];
//    self.password.iconName = @"ico_password";
    self.password.enter.secureTextEntry = YES;
    self.password.enter.placeholder = @"请输入密码";
    [regView addSubview:self.password];
    self.password.sd_layout
    .leftSpaceToView(regView,0)
    .rightSpaceToView(regView,0)
    .topSpaceToView(self.phoneCode,10)
    .heightIs(45);
    
    self.againPassword = [[ResetEnterView alloc] init];
    [regView addSubview:self.againPassword];
//    self.againPassword.iconName = @"ico_password";
    self.againPassword.enter.placeholder = @"请再次确认没密码";
    self.againPassword.enter.secureTextEntry = YES;
    [self.againPassword setStyle:GeneralEnter];
    self.againPassword.sd_layout
    .leftSpaceToView(regView,0)
    .rightSpaceToView(regView,0)
    .topSpaceToView(self.password,10)
    .heightIs(45);
    
    
    self.regSure = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.regSure setTitle:@"绑定" forState:UIControlStateNormal];
    [self.regSure setBackgroundColor:ThemeColor];
    [self.regSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.regSure.cornerRadius = 5;
    [self.regSure addTarget:self action:@selector(regSelected) forControlEvents:UIControlEventTouchUpInside];
    [regView addSubview:self.regSure];
    
    self.regSure.sd_layout
    .leftSpaceToView(regView,0)
    .rightSpaceToView(regView,0)
    .topSpaceToView(self.againPassword,20)
    .heightIs(50);
    
    UIView *licView = [[UIView alloc] init];
    
    UILabel *lblLicExp = [[UILabel alloc] init];
    lblLicExp.text = @"点击确定表示同意";
    [lblLicExp  setFont:[UIFont systemFontOfSize:15]];
    [licView addSubview:lblLicExp];
    lblLicExp.sd_layout
    .topSpaceToView(licView,0)
    .bottomSpaceToView(licView,0)
    .leftSpaceToView(licView,0);
    
    self.btnLic = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btnLic setTitle:@"用户协议" forState:UIControlStateNormal];
    [self.btnLic addTarget:self action:@selector(onViewLic) forControlEvents:UIControlEventTouchUpInside];
    [licView addSubview:self.btnLic];
    self.btnLic.sd_layout
    .topSpaceToView(licView,0)
    .bottomSpaceToView(licView,0)
    .rightSpaceToView(licView,0)
    .leftSpaceToView(lblLicExp,0);

    [regView addSubview:licView];
    licView.sd_layout
    .topSpaceToView(self.regSure,20)
    .heightIs(30)
    .widthIs(250)
    .centerXIs(0);

    UIView * uootuView = [[UIView alloc] init];
    [uootuView setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:uootuView];
    uootuView.sd_layout
    .leftSpaceToView(self.content,WindowWidth+20)
    .topEqualToView(self.content)
    .bottomEqualToView(self.content)
    .widthIs(WindowWidth-40);
    
    self.uAccount = [[ResetEnterView alloc] init];
    [self.uAccount setStyle:GeneralEnter];
//    self.uAccount.iconName = @"ico_user";
    self.uAccount.enter.placeholder = @"请输入有图账号";
    [uootuView addSubview:self.uAccount];
    self.uAccount.sd_layout
    .leftSpaceToView(uootuView,0)
    .rightSpaceToView(uootuView,0)
    .topSpaceToView(uootuView,20)
    .heightIs(45);
    
    self.uPassword = [[ResetEnterView alloc] init];
    [uootuView addSubview:self.uPassword];
    [self.uPassword setStyle:GeneralEnter];
//    self.uPassword.iconName = @"ico_password";
    self.uPassword.enter.placeholder = @"请输入有图密码";
    self.uPassword.enter.secureTextEntry = YES;
    self.uPassword.sd_layout
    .leftSpaceToView(uootuView,0)
    .rightSpaceToView(uootuView,0)
    .topSpaceToView(self.uAccount,10)
    .heightIs(45);
    
    self.uSure = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.uSure setTitle:@"绑定" forState:UIControlStateNormal];
    [self.uSure setBackgroundColor:ThemeColor];
    [self.uSure addTarget:self action:@selector(uSureSlected) forControlEvents:UIControlEventTouchUpInside];
    [self.uSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.uSure.cornerRadius = 5;
    [uootuView addSubview:self.uSure];
    self.uSure.sd_layout
    .leftSpaceToView(uootuView,0)
    .rightSpaceToView(uootuView,0)
    .topSpaceToView(self.uPassword,10)
    .heightIs(50);
    
    if(self.type == TypeWechatSession){
        [self.pageTitle setText:@"绑定微信"];
    }else {
        [self.pageTitle setText:@"绑定QQ"];
    }
    
    [self.content setContentSize:CGSizeMake(WindowWidth*2, 0)];
}
- (void)onViewLic {
    ProvisionCtr * pro = GETALONESTORYBOARDPAGE(@"ProvisionCtr");
    [self.navigationController pushViewController:pro animated:YES];
}

- (void)getCaptcha{
    NSString *urlStr = [NSString stringWithFormat:@"%@?timestamps=%@", self.congfing.getCaptcha, self.timestamp];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *ret = [UIImage imageWithData:imageData];
    [self.imgviewCaptcha setImage:ret];
    
}
- (IBAction)changeCaptcha:(id)sender {
    self.timestamp = TimeStamp;
    [self getCaptcha];
    
}

- (void)regOptionSelected{

      [self.content setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)uootuOtionSelected{
    [self.content setContentOffset:CGPointMake(WindowWidth, 0) animated:YES];
}

- (void)sendPhoneCode{
    
    if(self.phone.enter.text.length > 0){
        if(self.captcha.text.length > 0){
            [self sendCheckCode:@{
                                  @"target":self.phone.enter.text,
                                  @"captcha":self.captcha.text
                                  }];
        }else{
            [self showToast:@"请输入图片验证码"];
        }
    }else{
        [self showToast:@"请输入手机号码"];
    }
}


- (void)regSelected{
    
    if(self.phone.enter.text.length == 0){
        SPAlert(@"请输入手机号码",self);
        return;
    }
    if(self.phoneCode.enter.text.length == 0){
        SPAlert(@"请输入手机验证码",self);
        return;
    }
    
    if(self.password.enter.text.length == 0){
        SPAlert(@"请输入密码",self);
        return;
    }
    if(![self.password.enter.text isEqualToString:self.againPassword.enter.text]){
        SPAlert(@"两次密码输入不一致",self);
        return;
    }
    
    [self regChatAccount];
}

- (void)uSureSlected{

    if(self.uAccount.enter.text.length == 0){
        SPAlert(@"请输入账号",self);
        return;
    }
    if(self.uPassword.enter.text.length == 0){
        SPAlert(@"请输入密码",self);
        return;
    }
    
    
    [self bindingAccount:@{
                           @"uid":self.uAccount.enter.text,
                           @"password":self.uPassword.enter.text}];
}


- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if(offsetX == 0){
        [self.regOption setTextColor:ColorHex(0X3E99CB)];
        [self.uootuOtion setTextColor:ColorHex(0X000000)];
        self.selectType = 0;
        
    }else if(offsetX == WindowWidth){
        [self.regOption setTextColor:ColorHex(0X000000)];
        [self.uootuOtion setTextColor:ColorHex(0X3E99CB)];
        self.selectType = 1;
    }
    self.lineOffset.constant = (WindowWidth - 190) * (offsetX/WindowWidth);
}

#pragma makr - AFNetworking网络加载
- (void)sendCheckCode:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.register1,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"发送验证码成功"];
            [weakSelef startCountdown];
            
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
}

- (void)startCountdown{
    
  [self.phone.send setUserInteractionEnabled:NO];
    self.countdown = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendCodeCountdown) userInfo:nil repeats:YES];
    
}

- (void)sendCodeCountdown{
    self.countdown -- ;
    if(self.countdown > 0){
        NSString * title = [NSString stringWithFormat:@"%ldS",self.countdown];
        [self.phone.send setTitle:title forState:UIControlStateNormal];
    }else{
        [self.phone.send setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.phone.send setUserInteractionEnabled:YES];
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)regChatAccount{
    
    NSDictionary *data = @{
                           @"authCode":self.phoneCode.enter.text
                           };
    NSLog(@"%@",data);
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.register2,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            NSDictionary *data=@{@"password":self.password.enter.text, @"password_confirmation":self.password.enter.text};
            __weak __typeof(self)weakSeleff = weakSelef;
            [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.register3,[self.appd getParameterString]]  parametric:data succed:^(id responseObject){
                [weakSeleff closeLoad];
                NSLog(@"%@",responseObject);
                ChatLoginRequset * model = [[ChatLoginRequset alloc] init];
                [model analyticInterface:responseObject];
                if(model.status == 0 || model.status == 200){
                    [popupErrVC showInView:self animated:YES type:@"success" message:@"注册成功"];
                    
                    TabBarCtr * tabbar = [[TabBarCtr alloc] init];
                    [weakSelef.navigationController pushViewController:tabbar animated:YES];
                    
                }else{
                    [popupErrVC showInView:self animated:YES type:@"error" message:model.message];
                    
                    //            [weakSeleff showToast:model.message];
                }
                
            } failure:^(NSError * error){
                [weakSeleff showToast:NETWORKTIPS];
                [weakSeleff closeLoad];
            }];
            
        }else{
            [popupErrVC showInView:self animated:YES type:@"error" message:model.message];
            
            //            [weakSelef showToast:model.message];
        }
    } failure:^(NSError * error){
        NSLog(@"%@",error.userInfo);
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
}


- (void)bindingAccount:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.bindAccount,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        ChatLoginRequset * model = [[ChatLoginRequset alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0 && model.status == 200){
            
            TabBarCtr * tabbar = [[TabBarCtr alloc] init];
            [weakSelef.navigationController pushViewController:tabbar animated:YES];
        }else{
            [popupErrVC showInView:self animated:YES type:@"error" message:model.message];
            //[weakSelef showToast:model.message];
        }
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
    
}
- (void)closePopupErr {
    [popupErrVC removeAnimate];
}
@end
