//
//  AddFriendAlert.h
//  ShopPhotos
//
//  Created by addcn on 16/12/27.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol AddFriendAlertDelegate  <NSObject>

- (void)addFriendSure:(NSString *)uid;
- (void)useQRCodeScan;

@end

@interface AddFriendAlert : BaseView

@property (weak, nonatomic) id <AddFriendAlertDelegate>delegate;


- (void)showAlert;
- (void)closeAlert;



@end
