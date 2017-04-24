//
//  BindEmailViewController.h
//  ShopPhotos
//
//  Created by Macbook on 18/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseViewCtr.h"

@interface BindEmailViewController : BaseViewCtr
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *btnSMS;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtSms;
@property (assign, nonatomic) NSInteger countdown;
@property (strong, nonatomic) NSTimer * timer;
@property (strong, nonatomic) NSString * timestamp;
@property (weak, nonatomic) IBOutlet UIImageView *imgCaptcha;
@property (weak, nonatomic) IBOutlet UITextField *txtCaptcha;
@end
