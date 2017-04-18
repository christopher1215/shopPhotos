//
//  ErrMsgViewController.m
//  ShopPhotos
//
//  Created by Macbook on 11/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "ErrMsgViewController.h"

@interface ErrMsgViewController ()

@end

@implementation ErrMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.viewMsg.cornerRadius = 5;
    self.btnOk.borderColor = RGBACOLOR(86, 160, 215, 1);
    self.btnOk.borderWidth = 1;

}
- (IBAction)close:(id)sender {
    [self removeAnimate];
}

- (void)showInView:(UIViewController *)aView animated:(BOOL)animated type:(NSString*)type message:(NSString*)message
{
    UIImageView *_imgMark = (UIImageView*) [self.view viewWithTag: 200];

    if ([type isEqualToString:@"success"]) {
        _imgMark.image = [UIImage imageNamed:@"mark_success.png"];
    } else if([type isEqualToString:@"error"]){
        _imgMark.image = [UIImage imageNamed:@"mark_err.png"];
    }
    UILabel *msgLbl = (UILabel*) [self.view viewWithTag: 100];
    msgLbl.text = message;
    self.view.frame = [[UIScreen mainScreen] bounds];
    [aView.view addSubview:self.view];
    [self.btnOk addTarget:aView action:@selector(closePopupErr)];

    if (animated) {
        [self showAnimate];
    }
}
- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.view.transform = CGAffineTransformMakeScale(1, 1);
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
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
