//
//  QRCodeAlert.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "QRCodeAlert.h"
#import <UIImageView+WebCache.h>
#import "ReadQRCode.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@interface QRCodeAlert ()

@property (strong, nonatomic) UIView * alert;
@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * name;
@property (strong, nonatomic) UILabel * uid;
@property (strong, nonatomic) UIView * qrView;
@property (strong, nonatomic) UIImageView  * qrImage;
@property (strong, nonatomic) UILabel * tip;
@property (assign, nonatomic) BOOL bcStatu;

@end

@implementation QRCodeAlert

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
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableLongPressSelected)];
    [self.alert addGestureRecognizer:longPressGr];
    [self.alert setBackgroundColor:[UIColor whiteColor]];
    self.alert.cornerRadius = 5;
    [self addSubview:self.alert];
    
    self.icon = [[UIImageView alloc] init];
    [self.alert addSubview:self.icon];
    
    self.name = [[UILabel alloc] init];
    [self.alert addSubview:self.name];
    
    self.uid = [[UILabel alloc] init];
    [self.alert addSubview:self.uid];
    
    self.qrView = [[UIView alloc] init];
    [self.qrView setBackgroundColor:[UIColor whiteColor]];
    [self.alert addSubview:self.qrView];
    
    self.qrImage = [[UIImageView alloc] init];
    [self.qrImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.qrView addSubview:self.qrImage];
    
    self.tip = [[UILabel alloc] init];
    [self.tip setNumberOfLines:2];
    [self.tip setTextAlignment:NSTextAlignmentCenter];
    [self.tip setFont:Font(14)];
    [self.tip setTextColor:ColorHex(0X888888)];
    [self.tip setText:@"长按保存二维码\n扫一扫上面的二维码图案，加我有图号"];
    [self.alert addSubview:self.tip];


    self.alert.sd_layout
    .widthIs(300)
    .heightIs(400)
    .centerYIs(WindowHeight/2)
    .centerXIs(WindowWidth/2);
    
    self.icon.sd_layout
    .leftSpaceToView(self.alert,20)
    .topSpaceToView(self.alert,20)
    .widthIs(80)
    .heightIs(80);
    
    self.name.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(self.alert,20)
    .rightSpaceToView(self.alert,20)
    .heightIs(40);
    
    self.uid.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(self.name,0)
    .rightSpaceToView(self.alert,20)
    .heightIs(40);
    
    self.tip.sd_layout
    .leftSpaceToView(self.alert,20)
    .rightSpaceToView(self.alert,20)
    .bottomSpaceToView(self.alert,20)
    .heightIs(50);
    
    self.qrView.sd_layout
    .leftSpaceToView(self.alert,25)
    .topSpaceToView(self.icon,20)
    .bottomSpaceToView(self.tip,20)
    .rightSpaceToView(self.alert,25);
    
    self.qrImage.sd_layout
    .leftEqualToView(self.qrView)
    .rightEqualToView(self.qrView)
    .topEqualToView(self.qrView)
    .bottomEqualToView(self.qrView);
    

}

- (void)setModel:(UserInfoModel *)model{
    
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.name setText:model.name];
    [self.uid setText:[NSString stringWithFormat:@"有图号:%@",model.uid]];
    [self.qrImage setImage:[ReadQRCode creatCIQRCodeContent:[NSString stringWithFormat:@"https://www.uootu.com/%@",model.uid] ImageSize:280]];
}

- (void)showAlert{
    self.bcStatu = NO;
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
        [self setHidden:YES];
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
