//
//  ChargeViewController.m
//  ShopPhotos
//
//  Created by Macbook on 08/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "ChargeViewController.h"

@interface ChargeViewController ()
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *wechatPay;
@property (weak, nonatomic) IBOutlet UIView *alipay;
@property (weak, nonatomic) IBOutlet UIImageView *ico_wechat;
@property (weak, nonatomic) IBOutlet UIImageView *ico_alipay;
@property (strong, nonatomic) NSString *payMethod;

@end

@implementation ChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.back addTarget:self action:@selector(backSelected)];
    [self.wechatPay addTarget:self action:@selector(wechatSelected)];
    [self.alipay addTarget:self action:@selector(aliSelected)];
}
- (void)backSelected{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)wechatSelected{
    
    [self.ico_alipay setImage:[UIImage imageNamed:@"icon_unchecked.png"]];
    [self.ico_wechat setImage:[UIImage imageNamed:@"icon_checked.png"]];
    _payMethod = @"wechat";
    
}
- (void)aliSelected{
    
    [self.ico_alipay setImage:[UIImage imageNamed:@"icon_checked.png"]];
    [self.ico_wechat setImage:[UIImage imageNamed:@"icon_unchecked.png"]];
    _payMethod = @"alipay";
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
