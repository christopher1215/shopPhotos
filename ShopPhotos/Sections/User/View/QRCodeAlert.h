//
//  QRCodeAlert.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"
#import "UserModel.h"

@interface QRCodeAlert : BaseView
@property (strong, nonatomic) UserModel * model;
- (void)showAlert;
- (void)closeAlert;

@end
