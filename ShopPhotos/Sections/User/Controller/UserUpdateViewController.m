//
//  UserUpdateViewController.m
//  ShopPhotos
//
//  Created by Macbook on 12/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "UserUpdateViewController.h"
#import <UITextView+Placeholder.h>

@interface UserUpdateViewController ()<UITextViewDelegate>

@end

@implementation UserUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _txtValue.textContainerInset = UIEdgeInsetsMake(16, 10, 16, 10);
    [self.txtValue.placeholderLabel setFont:Font(14)];

    [self.back addTarget:self action:@selector(backSelected)];
    self.txtValue.text = _value;
    switch (_type) {
        case 0:
            self.lblTitle.text = @"用户名";
            self.txtValue.placeholder = @"请输入用户名";
            self.txtValue.keyboardType = UIKeyboardTypeDefault;
            break;
        case 1:
            self.lblTitle.text = @"个性签名";
            self.txtValue.placeholder = @"请输入个性签名";
            self.txtValue.keyboardType = UIKeyboardTypeDefault;
            break;
        case 2:
            self.lblTitle.text = @"QQ号";
            self.txtValue.placeholder = @"请输入QQ号";
            self.txtValue.keyboardType = UIKeyboardTypeDefault;
            break;
        case 3:
            self.lblTitle.text = @"微信号";
            self.txtValue.placeholder = @"请输入微信号";
            self.txtValue.keyboardType = UIKeyboardTypeDefault;
            break;
        case 4:
            self.lblTitle.text = @"电话号";
            self.txtValue.placeholder = @"请输入电话号";
            self.txtValue.keyboardType = UIKeyboardTypePhonePad;
            break;
        case 5:
            self.lblTitle.text = @"地址";
            self.txtValue.placeholder = @"请输入地址";
            self.txtValue.keyboardType = UIKeyboardTypeDefault;
            break;
            
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    self.txtValue.sd_layout.heightIs([self heightForString:self.txtValue andWidth:self.txtValue.width]);
//    [self.txtValue updateLayout];

}
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onComplete:(id)sender {
    switch (_type) {
        case 0:
            if (_txtValue.text.length > 32) {
                [self showToast:@"用户名最多含32个字符。请重新输入"];
                return;
            } else {
                _parentVC.nameText.text = _txtValue.text;
                _parentVC.lblNameHead.text = _txtValue.text;
            }
            break;
        case 1:
            if (_txtValue.text.length > 45) {
                [self showToast:@"个性签名最多含45个字符。请重新输入"];
                return;
            } else {
                _parentVC.signatureText.text = _txtValue.text;
            }
            break;
        case 2:
            if (_txtValue.text.length > 12 || (_txtValue.text.length < 6 && _txtValue.text.length > 0)) {
                [self showToast:@"QQ号长度为6-12个字符。请重新输入"];
                return;
            } else {
                _parentVC.qqText.text = _txtValue.text;
            }
            break;
        case 3:
            if (_txtValue.text.length > 64) {
                [self showToast:@"微信最多含64个字符。请重新输入"];
                return;
            } else {
                _parentVC.chatText.text = _txtValue.text;
            }
            break;
        case 4:
            if (_txtValue.text.length != 11) {
                [self showToast:@"请输入正确手机号"];
                return;
            } else {
                _parentVC.phone.text = _txtValue.text;
            }
            break;
        case 5:
            if (_txtValue.text.length > 45) {
                [self showToast:@"地址最多含45个字符。请重新输入"];
                return;
            } else {
                _parentVC.locationText.text = _txtValue.text;
            }
            break;
            
        default:
            break;
    }
    _parentVC.firstFlag = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
//    self.txtValue.sd_layout.heightIs([self heightForString:self.txtValue andWidth:self.txtValue.width]);
//    [self.txtValue updateLayout];
    switch (_type) {
        case 0:
            if(text.length > 0 && textView.text.length >= 64){
                [self showToast:@"用户名不能超过32个字"];
                return NO;
            }
            
            break;
        case 1:
            if(text.length > 0 && textView.text.length >= 45){
                [self showToast:@"个性签名不能超过45个字"];
                return NO;
            }
            
            break;
        case 2:
            if(text.length > 0 && textView.text.length >= 12){
                [self showToast:@"QQ不能超过12个字"];
                return NO;
            }
            
            break;
        case 3:
            if(text.length > 0 && textView.text.length >= 64){
                [self showToast:@"微信不能超过64个字"];
                return NO;
            }
            
            break;
        case 4:
            if(text.length > 0 && textView.text.length >= 11){
                [self showToast:@"电话不能超过11个字"];
                return NO;
            }
            
            break;
        case 5:
            if(text.length > 0 && textView.text.length >= 45){
                [self showToast:@"地址不能超过45个字"];
                return NO;
            }
            
            break;
            
        default:
            break;
    }
    return YES;
}

- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
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
