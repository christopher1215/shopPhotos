//
//  BaseViewCtr.m
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseViewCtr.h"
#import "AppDelegate.h"
#import "UserModel.h"

@interface BaseViewCtr ()

@property (strong, nonatomic) MBProgressHUD * progress;

@end

@implementation BaseViewCtr
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appd = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    self.popupErrVC = [[ErrMsgViewController alloc] initWithNibName:@"ErrMsgViewController" bundle:nil];
    
    
    [self.navigationController.navigationBar setHidden:YES];
    //self.congfing = [self getValueWithKey:ShopPhotosApi];
    UserModel * userModel = [self getValueWithKey:CacheUserModel];
    if(userModel){
        self.photosUserID = userModel.uid;
        self.photosUserName = userModel.name;
    }
    if(!self.photosUserID || self.photosUserID.length == 0){
        self.photosUserID = [[NSString alloc] init];
        self.photosUserName = [[NSString alloc] init];
    }
}

- (CongfingURL *)congfing{
    return [self getValueWithKey:ShopPhotosApi];
}

- (void)showLoad{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)closeLoad{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)showToast:(NSString *)title{
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    [hud.bezelView setBackgroundColor:ColorHexA(0X000000, 0.5)];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.font = Font(13);
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.offset = CGPointMake(0.f, -100);
    [hud hideAnimated:YES afterDelay:1.5f];
}

@end
