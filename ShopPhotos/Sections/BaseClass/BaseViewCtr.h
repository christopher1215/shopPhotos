//
//  BaseViewCtr.h
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <UIView+SDAutoLayout.h>
#import "CommonDefine.h"
#import "UIView+Extension.h"
#import <MBProgressHUD.h>
#import "CongfingURL.h"
#import "HTTPRequest.h"
#import "BaseModel.h"
#import "NSObject+StoreValue.h"
#import "StringCheck.h"
#import "AppDelegate.h"

static NSString * const URLHead = @"http://www.uootu.com/";
//static NSString * const ShareURLHead = @"http://uootu.com";

@interface BaseViewCtr : UIViewController

@property (strong, nonatomic)CongfingURL * congfing;
@property (strong, nonatomic)NSDictionary * tokenData;
@property (strong, nonatomic)NSString * photosUserID;
@property (strong, nonatomic)NSString * photosUserName;
@property (strong, nonatomic)AppDelegate *appd;
//@property (strong, nonatomic)ErrMsgViewController *popupErrVC;

- (void)showLoad;
- (void)closeLoad;
- (void)showToast:(NSString *)title;

@end
