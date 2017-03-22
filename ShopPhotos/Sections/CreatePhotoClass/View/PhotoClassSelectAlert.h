//
//  PhotoClassSelectAlert.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol PhotoClassSelectAlertDelegate <NSObject>

- (void)photoClassSelectAlert:(NSIndexPath *)indexPath;

@end

@interface PhotoClassSelectAlert : BaseView

@property (assign, nonatomic) id<PhotoClassSelectAlertDelegate>delegate;
@property (strong, nonatomic)NSMutableArray * dataArray;

@end

