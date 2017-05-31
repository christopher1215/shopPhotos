//
//  ShareCtr2.m
//  ShopPhotos
//
//  Created by PKJ on 5/10/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "ShareCtr2.h"

@interface ShareCtr2 ()

@end

@implementation ShareCtr2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)weixinShare:(id)sender {
    [self useDelegate:1];
}
- (IBAction)qqShare:(id)sender {
    [self useDelegate:2];
}
- (IBAction)closeShareview:(id)sender {
    [self closeAlert];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)useDelegate:(NSInteger)type{
    [self closeAlert];
    if(self.delegate && [self.delegate respondsToSelector:@selector(share2Selected:)]){
        [self.delegate share2Selected:type];
    }
}

- (void)showAlert{
    [self.view setHidden:NO];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    [UIView animateWithDuration:0.0 animations:^{
        
//        self.alertOffset.constant = 0;
        [self.view layoutIfNeeded];
        [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.45]];
        
    }];
}

- (void)closeAlert{
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
//        self.alertOffset.constant = -360;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished){
        [self.view removeFromSuperview];
        //        [self.view setHidden:YES];
    }];
}


@end
