//
//  UserUpdateViewController.m
//  ShopPhotos
//
//  Created by Macbook on 12/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "UserUpdateViewController.h"

@interface UserUpdateViewController ()<UITextFieldDelegate>

@end

@implementation UserUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.back addTarget:self action:@selector(backSelected)];
    switch (_type) {
        case 0:
            self.lblTitle.text = @"用户名";
            self.txtValue.placeholder = @"请输入用户名";
            break;
        case 1:
            self.lblTitle.text = @"个性签名";
            self.txtValue.placeholder = @"请输入个性签名";
            break;
        case 2:
            self.lblTitle.text = @"QQ号";
            self.txtValue.placeholder = @"请输入QQ号";
            break;
        case 3:
            self.lblTitle.text = @"微信号";
            self.txtValue.placeholder = @"请输入微信号";
            break;
        case 4:
            self.lblTitle.text = @"电话号";
            self.txtValue.placeholder = @"请输入电话号";
            break;
        case 5:
            self.lblTitle.text = @"地址";
            self.txtValue.placeholder = @"请输入地址";
            break;
            
        default:
            break;
    }
}
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onComplete:(id)sender {
    switch (_type) {
        case 0:
            _parentVC.nameText.text = _txtValue.text;
            _parentVC.lblNameHead.text = _txtValue.text;
            break;
        case 1:
            _parentVC.signatureText.text = _txtValue.text;
            break;
        case 2:
            _parentVC.qqText.text = _txtValue.text;
            break;
        case 3:
            _parentVC.chatText.text = _txtValue.text;
            break;
        case 4:
            _parentVC.phone.text = _txtValue.text;
            break;
        case 5:
            _parentVC.locationText.text = _txtValue.text;
            break;
            
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    switch (_type) {
        case 0:
            if(string.length > 0 && textField.text.length == 64){
                [self showToast:@"用户名不能超过64个字"];
                return NO;
            }

            break;
        case 1:
            if(string.length > 0 && textField.text.length == 128){
                [self showToast:@"个性签名不能超过128个字"];
                return NO;
            }
            
            break;
        case 2:
            if(string.length > 0 && textField.text.length == 40){
                [self showToast:@"QQ不能超过12个字"];
                return NO;
            }
            
            break;
        case 3:
            if(string.length > 0 && textField.text.length == 40){
                [self showToast:@"微信不能超过64个字"];
                return NO;
            }
            
            break;
        case 4:
            if(string.length > 0 && textField.text.length == 40){
                [self showToast:@"电话不能超过11个字"];
                return NO;
            }
            
            break;
        case 5:
            if(string.length > 0 && textField.text.length == 40){
                [self showToast:@"地址不能超过255个字"];
                return NO;
            }
            
            break;
            
        default:
            break;
    }
    return YES;
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
