//
//  UserInfoDrawerCtr.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/20.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseViewCtr.h"
#import "UserInfoModel.h"

@protocol UserInfoDrawerDelegate <NSObject>

- (void)userInfoDrawerHeadSelected:(NSInteger)type;
- (void)userInfoDrawerCellSelected:(UserInfoModel *)model WithType:(NSInteger)type;

@end

@interface UserInfoDrawerCtr : BaseViewCtr

@property (weak, nonatomic)id<UserInfoDrawerDelegate>delegate;

- (void)setStyle:(UserInfoModel *)model;

- (void)showDrawe;
- (void)closeDrawe;

@end
