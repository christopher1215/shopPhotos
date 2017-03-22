//
//  DynamicQRAlert.h
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/4.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseView.h"

@interface DynamicQRAlert : BaseView
- (void)showAlert;
- (void)closeAlert;

@property (strong, nonatomic) NSString * contentText;
@property (retain, nonatomic) NSString * titleText;

@end
