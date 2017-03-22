//
//  FeedbackCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "FeedbackCtr.h"
#import "FeedbackOptionAlert.h"
#import "AppDelegate.h"

@interface FeedbackCtr ()<UITextViewDelegate,UITextFieldDelegate,FeedbackOptionAlertDelegate>
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIView *option;
@property (weak, nonatomic) IBOutlet UILabel *optionText;
@property (strong, nonatomic) FeedbackOptionAlert * alert;
@property (weak, nonatomic) IBOutlet UILabel *contentPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *submit;
@property (assign, nonatomic) NSInteger selectType;

@end

@implementation FeedbackCtr

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup{
    
    self.selectType = 1;
    [self.back addTarget:self action:@selector(backSelected)];
    [self.submit addTarget:self action:@selector(submitSelected)];
    [self.option addTarget:self action:@selector(optionSelected)];
    
    self.content.delegate = self;
    self.email.delegate = self;
    
    self.alert = [[FeedbackOptionAlert alloc] init];
    self.alert.delegate = self;
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self.alert];
    self.alert.sd_layout
    .leftEqualToView(appDelegate.window)
    .rightEqualToView(appDelegate.window)
    .rightEqualToView(appDelegate.window)
    .bottomEqualToView(appDelegate.window);
    [self.alert setHidden:YES];
}

- (BOOL)feedbackValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        
        return true;
        
    } else {
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            
            return true;
            
        } else {
            
            return false;
            
        }
        
    }
    
}

#pragma mark - OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitSelected{
    
    if(self.content.text.length == 0){
        [self showToast:@"请输入反馈内容"];
        return;
    }
    if([self isEmpty:self.content.text]){
        [self showToast:@"请输入反馈内容"];
        return;
    }
    
    if(self.email.text.length == 0){
        [self showToast:@"请输入邮箱"];
        return;
    }
    
    NSString * text = self.email.text;
    [self.email setText:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    if(![self feedbackValidateEmail:self.email.text]){
        [self showToast:@"请输入正确的邮箱"];
        return;
    }
    
    [self submitFeedbackData:@{@"email":self.email.text,
                               @"content":self.content.text,
                               @"type":[NSString stringWithFormat:@"%ld",self.selectType]}];
}

- (void)optionSelected{
    [self.alert showAlert];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - FeedbackOptionAlertDelegate
- (void)feedbackOption:(NSString *)titiel selectedType:(NSInteger)type{
    
    [self.optionText setText:titiel];
    self.selectType = type+1;
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    
    if(text.length == 0 && textView.text.length <2){
        [self.contentPlaceholder setHidden:NO];
    }else{
        [self.contentPlaceholder setHidden:YES];
    }
    return YES;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma makr - AFNetworking网络加载
- (void)submitFeedbackData:(NSDictionary *)data{
    NSLog(@"%@",data);
    NSLog(@"%@",self.congfing.getUserInfo);
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.publishedFeedback parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"提交成功"];
            [weakSelef.navigationController popViewControllerAnimated:YES];
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        NSLog(@"%@",error.userInfo);
        [weakSelef showToast:NETWORKTIPS];
    }];
}

@end
