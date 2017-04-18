//
//  ErrMsgViewController.h
//  ShopPhotos
//
//  Created by Macbook on 11/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseViewCtr.h"
#import <QuartzCore/QuartzCore.h>

@interface ErrMsgViewController :BaseViewCtr
@property (strong, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UIView *viewPopup;
@property (weak, nonatomic) IBOutlet UIView *viewMsg;
- (void)showInView:(UIViewController *)aView animated:(BOOL)animated type:(NSString*)type message:(NSString*)message;
- (void)removeAnimate;
@end
