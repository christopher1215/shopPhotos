//
//  ChangeClassAlert.m
//  ShopPhotos
//
//  Created by addcn on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "ChangeClassAlert.h"

@interface ChangeClassAlert ()
@property (strong, nonatomic) UIView * alert;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UITextField * enter;
@property (strong, nonatomic) UIButton * sure;
@property (strong, nonatomic) UIButton * cancel;

@end

@implementation ChangeClassAlert

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createAutoLayout];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)createAutoLayout{
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self addTarget:self action:@selector(closeAlert)];
    
    self.alert = [[UIView alloc] init];
    [self.alert addTarget:self action:nil];
    self.alert.layer.cornerRadius = 5;
    self.alert.clipsToBounds = YES;
    [self.alert setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.alert];
    
    self.title = [[UILabel alloc] init];
    [self.title setTextAlignment:NSTextAlignmentCenter];
    [self.title setText:@"修改父分类"];
    [self.title setFont:Font(19)];
    [self.alert addSubview:self.title];
    
    self.enter = [[UITextField alloc] init];
    self.enter.layer.cornerRadius = 5;
    self.enter.layer.borderColor = ThemeColor.CGColor;
    self.enter.layer.borderWidth = 1;
    self.enter.placeholder = @"请输入分类名";
    [self.alert addSubview:self.enter];
    
    UIView * line1 = [[UIView alloc] init];
    line1.backgroundColor = ColorHex(0Xeeeeee);
    [self.alert addSubview:line1];
    
    UIView * line2 = [[UIView alloc] init];
    line2.backgroundColor = ColorHex(0Xeeeeee);
    [self.alert addSubview:line2];
    
    self.sure = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sure setTitle:@"确定" forState:UIControlStateNormal];
    [self.sure setTitleColor:ThemeColor forState:UIControlStateNormal];
    [self.sure setBackgroundColor:[UIColor whiteColor]];
    [self.sure addTarget:self action:@selector(sureSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.alert addSubview:self.sure];
    
    self.cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancel setTitleColor:ThemeColor forState:UIControlStateNormal];
    [self.cancel setBackgroundColor:[UIColor whiteColor]];
    [self.cancel addTarget:self action:@selector(closeAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.alert addSubview:self.cancel];
    
    
    self.alert.sd_layout
    .centerXIs(WindowWidth/2)
    .bottomSpaceToView(self,(WindowHeight-161)/2)
    .widthIs(300)
    .heightIs(161);
    
    self.title.sd_layout
    .leftEqualToView(self.alert)
    .topSpaceToView(self.alert,10)
    .rightEqualToView(self.alert)
    .heightIs(45);
    
    self.enter.sd_layout
    .leftSpaceToView(self.alert,20)
    .rightSpaceToView(self.alert,20)
    .topSpaceToView(self.title,10)
    .heightIs(35);
    
    line1.sd_layout
    .leftEqualToView(self.alert)
    .rightEqualToView(self.alert)
    .topSpaceToView(self.enter,10)
    .heightIs(1);
    
    line2.sd_layout
    .leftSpaceToView(self.alert,(300-2)/2)
    .topSpaceToView(line1,5)
    .heightIs(40)
    .widthIs(2);
    
    self.sure.sd_layout
    .rightSpaceToView(self.alert,0)
    .topSpaceToView(line1,0)
    .bottomEqualToView(self.alert)
    .leftSpaceToView(line2,0);
    
    self.cancel.sd_layout
    .leftSpaceToView(self.alert,0)
    .topSpaceToView(line1,0)
    .rightSpaceToView(line2,0)
    .bottomEqualToView(self.alert);
    
}

- (void)showAlert{
    
    [self setHidden:NO];
    [self setAlpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:1];
    }];
}
- (void)closeAlert{
    [self.enter resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished){
        [self setHidden:YES];
    }];
}

- (void)setDName:(NSString *)dName{
    self.enter.text = dName;
}

- (void)setSubClass:(BOOL)subClass{
    _subClass = subClass;
    if(subClass){
        [self.title setText:@"修改子分类"];
    }else{
        [self.title setText:@"修改父分类"];
    }
}

- (void)sureSelected{
    [self closeAlert];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(editClassName:)]){
        [self.delegate editClassName:self.enter.text];
    }
   
}


#pragma mark - 键盘监听
- (void)keyboardWillShow:(NSNotification *)notification{
    
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if(keyboardHeight > ((WindowHeight-161)/2)){
        [UIView animateWithDuration:duration animations:^{
            self.alert.sd_layout.bottomSpaceToView(self,keyboardHeight);
            [self.alert updateLayout];
        }];
        
    }
}
- (void)keyboardWillHide:(NSNotification *)notification{
    
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.alert.sd_layout.bottomSpaceToView(self,(WindowHeight-161)/2);
        [self.alert updateLayout];;
    }];
}
@end
