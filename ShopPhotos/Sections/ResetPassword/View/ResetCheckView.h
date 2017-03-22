//
//  ResetCheckView.h
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"
#import "ResetEnterView.h"

typedef NS_ENUM(NSInteger, CheckStyle) {
    
    PhoneCheck,
    MailCheck,
    
};

@protocol ResetCheckViewDelegate <NSObject>

- (void)resetSendCode;
- (void)completeRetrievePassword;
@end



@interface ResetCheckView : BaseView
@property (strong, nonatomic) ResetEnterView * phone;
@property (strong, nonatomic) ResetEnterView * phoneCode;
@property (strong, nonatomic) ResetEnterView * password;
@property (strong, nonatomic) ResetEnterView * againPassword;
@property (assign, nonatomic) CheckStyle style;
@property (weak, nonatomic) id<ResetCheckViewDelegate>delegate;

- (void)startCountdown;

@end
