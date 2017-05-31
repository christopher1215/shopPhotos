
//
//  ChangeClassAlert.h
//  ShopPhotos
//
//  Created by addcn on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol ChangeClassAlertDelegate <NSObject>

- (void)editClassName:(NSString *)name indexClass:(NSInteger)index;

@end

@interface ChangeClassAlert : BaseView

@property (weak, nonatomic) id<ChangeClassAlertDelegate>delegate;
@property (assign, nonatomic) BOOL subClass;
@property (assign, nonatomic) BOOL isVideoUpdate;
@property (assign, nonatomic) BOOL addClass;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString * dName;

- (void)showAlert;
- (void)closeAlert;

@end
