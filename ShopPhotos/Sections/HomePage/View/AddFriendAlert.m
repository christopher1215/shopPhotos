//
//  AddFriendAlert.m
//  ShopPhotos
//
//  Created by addcn on 16/12/27.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AddFriendAlert.h"
#import "ReadQRCode.h"

@interface AddFriendAlert ()

@property (strong, nonatomic) UIView * alert;
@property (strong, nonatomic) UILabel * titleText;
@property (strong, nonatomic) UITextField * enter;
@property (strong, nonatomic) UIButton * sure;
@property (strong, nonatomic) UIView * qrCodeView;
@property (strong, nonatomic) UIImageView * qrCodeIcon;
@property (strong, nonatomic) UILabel * qrCodeText;

@end

@implementation AddFriendAlert

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createAutoLayout];
    }
    return self;
}
- (void)createAutoLayout{
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self addTarget:self action:@selector(closeAlert)];
    
    self.alert = [[UIView alloc] init];
    [self.alert addTarget:self action:nil];
    self.alert.layer.cornerRadius = 5;
    [self.alert setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.alert];
    
    self.titleText = [[UILabel alloc] init];
    [self.titleText setText:@"添加用户"];
    [self.titleText setTextAlignment:NSTextAlignmentCenter];
    [self.titleText setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    [self.alert addSubview:self.titleText];
    
    self.enter = [[UITextField alloc] init];
    [self.enter setPlaceholder:@" 请输入有图号"];
    self.enter.textAlignment = NSTextAlignmentCenter;
    [self.enter setFont:Font(13)];
    self.enter.layer.cornerRadius = 5;
    self.enter.layer.borderWidth = 1;
    self.enter.layer.borderColor = ColorHex(0XEEEEEE).CGColor;
    [self.alert addSubview:self.enter];
    
    self.sure = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sure setTitle:@"确定" forState:UIControlStateNormal];
    [self.sure setBackgroundColor:ThemeColor];
    self.sure.layer.cornerRadius = 5;
    [self.sure addTarget:self action:@selector(sureSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.alert addSubview:self.sure];
    
    self.qrCodeView = [[UIView alloc] init];
    [self.qrCodeView addTarget:self action:@selector(qrCodeSelected)];
    [self.alert addSubview:self.qrCodeView];
    
    self.qrCodeIcon = [[UIImageView alloc] init];
    [self.qrCodeIcon setImage:[UIImage imageNamed:@"cord"]];
    [self.qrCodeIcon setContentMode:UIViewContentModeScaleAspectFit];
    [self.qrCodeIcon setBackgroundColor:[UIColor clearColor]];
    [self.qrCodeView addSubview:self.qrCodeIcon];
    
    self.qrCodeText = [[UILabel alloc] init];
    [self.qrCodeText setText:@"使用扫一扫添加有图号"];
    [self.qrCodeText setTextColor:ColorHex(0X4D4D4D)];
    [self.qrCodeText setFont:Font(13)];
    [self.qrCodeView addSubview:self.qrCodeText];
    
    
    self.alert.sd_layout
    .leftSpaceToView(self,30)
    .rightSpaceToView(self,30)
    .topSpaceToView(self,(WindowHeight-250)/2)
    .heightIs(250);
    
    
    self.titleText.sd_layout
    .leftEqualToView(self.alert)
    .rightEqualToView(self.alert)
    .topSpaceToView(self.alert,10)
    .heightIs(45);
    
    self.enter.sd_layout
    .leftSpaceToView(self.alert,30)
    .rightSpaceToView(self.alert,30)
    .topSpaceToView(self.titleText,10)
    .heightIs(40);
    
    self.sure.sd_layout
    .leftSpaceToView(self.alert,30)
    .rightSpaceToView(self.alert,30)
    .topSpaceToView(self.enter,20)
    .heightIs(40);
    
    self.qrCodeView.sd_layout
    .leftSpaceToView(self.alert,30)
    .rightSpaceToView(self.alert,30)
    .topSpaceToView(self.sure,20)
    .heightIs(30);
    
    self.qrCodeIcon.sd_layout
    .leftSpaceToView(self.qrCodeView,0)
    .topSpaceToView(self.qrCodeView,0)
    .widthIs(30)
    .heightIs(30);
    
    self.qrCodeText.sd_layout
    .leftSpaceToView(self.qrCodeIcon,0)
    .rightSpaceToView(self.qrCodeView,0)
    .topSpaceToView(self.qrCodeView,0)
    .bottomSpaceToView(self.qrCodeView,0);
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

- (void)sureSelected{
    
    if (self.enter.text.length == 0 || [self isEmpty:self.enter.text]) {
        self.enter.text = @"";
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(addFriendSure:)]){
        [self.delegate addFriendSure:self.enter.text];
    }
    
    if(self.enter.text && self.enter.text.length > 0){
        [self closeAlert];
    }
}

- (void)qrCodeSelected{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(useQRCodeScan)]){
        [self.delegate useQRCodeScan];
    }
    [self closeAlert];
}

- (void)showAlert{
    [self setHidden:NO];
    [self setAlpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:1];
    }];
}

- (void)closeAlert{
    
    [self.enter resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished){
        [self setHidden:YES];
    }];
    
}

@end
