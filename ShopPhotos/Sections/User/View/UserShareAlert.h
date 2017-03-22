//
//  UserShareAlert.h
//  ShopPhotos
//
//  Created by addcn on 17/1/5.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol UserShareAlertDelegate <NSObject>

- (void)userShareOption:(NSInteger)indexPath;

@end

@interface UserShareAlert : BaseView
@property (weak, nonatomic) id<UserShareAlertDelegate>delegate;

- (void)showAlert;
- (void)closeAlert;
@end
