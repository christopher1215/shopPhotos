//
//  ChangeClassAlert.m
//  ShopPhotos
//
//  Created by addcn on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "ChangeClassAlert.h"

@interface ChangeClassAlert () <UITextFieldDelegate>
@property (strong, nonatomic) UIView * alert;
@property (strong, nonatomic) UIButton * sure;
@property (strong, nonatomic) UIButton * cancel;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UITextField * enter;
@property (strong, nonatomic) UIView * enterView;

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
    self.alert.layer.cornerRadius = 3;
    self.alert.clipsToBounds = YES;
    [self.alert setBackgroundColor:ColorHex(0xefefef)];
    [self addSubview:self.alert];
    
    self.title = [[UILabel alloc] init];
    [self.title setTextAlignment:NSTextAlignmentCenter];
//    [self.title setText:@"修改父分类"];
    [self.title setFont:Font(18)];
    [self.title setTextColor:ColorHex(0x333333)];
    [self.alert addSubview:self.title];
    

    _enterView = [[UIView alloc] init];
    [_enterView setBackgroundColor:[UIColor whiteColor]];
    _enterView.layer.cornerRadius = 2;
    [self.alert addSubview:_enterView];

    _enter = [[UITextField alloc] init];
    [_enter setBackgroundColor:[UIColor whiteColor]];
    
    _enter.layer.borderWidth = 0;
    _enter.delegate = self;
//    self.enter.layer.borderColor = [UIColor whiteColor].CGColor;
    _enter.placeholder = @"请输入分类名";
    [_enter setFont:Font(14)];
    [self.enterView addSubview:_enter];
    
    UIView * line1 = [[UIView alloc] init];
    line1.backgroundColor = ColorHex(0xd2d2d2);
    [self.alert addSubview:line1];
    
    UIView * line2 = [[UIView alloc] init];
    line2.backgroundColor = ColorHex(0xd2d2d2);
    [self.alert addSubview:line2];
    
    self.sure = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sure setTitle:@"确认" forState:UIControlStateNormal];
    [self.sure.titleLabel setFont:Font(18)];
    [self.sure setTitleColor:ColorHex(0x333333) forState:UIControlStateNormal];
    [self.sure setBackgroundColor:ColorHex(0xefefef)];
    [self.sure addTarget:self action:@selector(sureSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.alert addSubview:self.sure];
    
    self.cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancel.titleLabel setFont:Font(18)];
    [self.cancel setTitleColor:ColorHex(0x333333) forState:UIControlStateNormal];
    [self.cancel setBackgroundColor:ColorHex(0xefefef)];
    [self.cancel addTarget:self action:@selector(closeAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.alert addSubview:self.cancel];
    
    
    self.alert.sd_layout
    .centerXIs(WindowWidth/2)
    .bottomSpaceToView(self,(WindowHeight-220)/2)
    .widthIs(WindowWidth - 50)
    .heightIs(220);
    
    self.title.sd_layout
    .leftEqualToView(self.alert)
    .topSpaceToView(self.alert,40)
    .rightEqualToView(self.alert)
    .heightIs(20);
    
    self.enterView.sd_layout
    .leftSpaceToView(self.alert,20)
    .rightSpaceToView(self.alert,20)
    .topSpaceToView(self.title,35)
    .heightIs(40);

    self.enter.sd_layout
    .leftSpaceToView(self.enterView,8)
    .rightSpaceToView(self.enterView,8)
    .topSpaceToView(self.enterView,0)
    .heightIs(40);
    
    line1.sd_layout
    .leftEqualToView(self.alert)
    .rightEqualToView(self.alert)
    .topSpaceToView(self.enterView,30)
    .heightIs(1);
    
    line2.sd_layout
    .leftSpaceToView(self.alert,(300-2)/2)
    .topSpaceToView(line1,5)
    .heightIs(55)
    .widthIs(1);
    
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
    if (self.addClass) {
        self.enter.text = @"";
    }
    
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

- (void)setIsVideoUpdate:(BOOL)isVideoUpdate{
    _isVideoUpdate = isVideoUpdate;
    if(_isVideoUpdate){
        
        [_title setText:@"修改视频名称"];
        _enter.placeholder = @"请输入视频名称";
    }
}

- (void)setSubClass:(BOOL)subClass{
    _subClass = subClass;
    if(_subClass){
        if (_addClass) {
            [_title setText:@"新建子分类"];
            //_enter.text = @"子_";
        }
        else {
            [_title setText:@"修改子分类"];
        }
        _enter.placeholder = @"请输入子分类名称";
    } else {
        if (_addClass) {
            [_title setText:@"新建父分类"];
            //_enter.text = @"父亲_";
        }
        else {
            [_title setText:@"修改父分类"];
        }
        _enter.placeholder = @"请输入父分类名称";
    }
}

- (void)sureSelected{
    [self closeAlert];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(editClassName:indexClass:)]){
        [self.delegate editClassName:self.enter.text indexClass:self.index];
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
