//
//  RegisterViewController.h
//  ShopPhotos
//
//  Created by Macbook on 07/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseViewCtr.h"

@interface RegisterViewController : BaseViewCtr
@property (weak, nonatomic) IBOutlet UITextField *txtPass;
@property (weak, nonatomic) IBOutlet UITextField *txtRePass;
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIButton *btnComplete;
@property (weak, nonatomic) IBOutlet UIButton *btnSecPass;
@property (weak, nonatomic) IBOutlet UIButton *btnSecRePass;
@property (strong, nonatomic) NSString * strPhone;
@property (strong, nonatomic) NSString * strAuthCode;

@end
