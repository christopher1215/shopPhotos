//
//  QRCodeAlert.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"
#import "UserInfoModel.h"

@interface QRCodeAlert : BaseView
@property (strong, nonatomic) UserInfoModel * model;
- (void)showAlert;
- (void)closeAlert;

@end
