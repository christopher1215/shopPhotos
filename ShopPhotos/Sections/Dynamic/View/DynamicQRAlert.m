//
//  DynamicQRAlert.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/4.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "DynamicQRAlert.h"
#import "ReadQRCode.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@interface DynamicQRAlert ()
@property (strong, nonatomic) UIView * alert;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UIImageView * content;
@property (strong, nonatomic) UILabel * tip;
@property (assign, nonatomic) BOOL bcStatu;
@end

@implementation DynamicQRAlert

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [self addTarget:self action:@selector(closeAlert)];
        
        self.alert = [[UIView alloc] init];
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableLongPressSelected)];
        [self.alert addGestureRecognizer:longPressGr];
        [self.alert setBackgroundColor:[UIColor whiteColor]];
        [self.alert addTarget:self action:nil];
        self.alert.cornerRadius = 5;
        [self addSubview:self.alert];

        self.title = [[UILabel alloc] init];
        [self.title setNumberOfLines:2];
        [self.title setTextAlignment:NSTextAlignmentCenter];
        [self.title setTextColor:ColorHex(0X333333)];
        [self.title setFont:Font(18)];
        [self.alert addSubview:self.title];
        
        self.content = [[UIImageView alloc] init];
        [self.content setContentMode:UIViewContentModeScaleAspectFit];
        [self.alert addSubview:self.content];
        
        self.tip = [[UILabel alloc] init];
        [self.tip setNumberOfLines:3];
        [self.tip setTextAlignment:NSTextAlignmentCenter];
        [self.tip setFont:Font(12)];
        [self.tip setTextColor:ColorHex(0X7e8599)];
        [self.tip setText:@"长按保存二维码\n\n扫一扫上面的二维码图案，查看相册详情"];
        [self.alert addSubview:self.tip];
        
        self.alert.sd_layout
        .widthIs(300)
        .heightIs(360)
        .centerYIs(WindowHeight/2)
        .centerXIs(WindowWidth/2);
        
        self.title.sd_layout
        .leftSpaceToView(self.alert,20)
        .rightSpaceToView(self.alert,20)
        .topSpaceToView(self.alert,20)
        .heightIs(45);
        
        self.content.sd_layout
        .leftSpaceToView(self.alert,20)
        .rightSpaceToView(self.alert,20)
        .topSpaceToView(self.title,30)
        .heightIs(160);
        
        self.tip.sd_layout
        .leftSpaceToView(self.alert,20)
        .rightSpaceToView(self.alert,20)
        .topSpaceToView(self.content,20)
        .heightIs(50);
    }
    return self;
}

- (void)setAlertContent{
    
    [self.title setText:[NSString stringWithFormat:@"有图相册二维码\n%@",self.titleText]];
    [self.content setImage:[ReadQRCode creatCIQRCodeContent:self.contentText ImageSize:260]];
}


- (void)showAlert{
    self.bcStatu = NO;
    [self setAlertContent];
    
    [self setHidden:NO];
    [self setAlpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:1];
    }];
}


- (void)closeAlert{
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished){
//        [self setHidden:YES];
        [self removeFromSuperview];
    }];
    
}

- (void)tableLongPressSelected{
    if(_bcStatu) return;
    self.bcStatu = YES;
    
    UIGraphicsBeginImageContext(self.alert.bounds.size);
    [self.alert.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();     UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image,self, nil, nil);
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    [hud.bezelView setBackgroundColor:ColorHexA(0X000000, 0.5)];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"保存成功";
    hud.label.textColor = [UIColor whiteColor];
    hud.offset = CGPointMake(0.f, -100);
    [hud hideAnimated:YES afterDelay:1.5f];
    
}
@end
