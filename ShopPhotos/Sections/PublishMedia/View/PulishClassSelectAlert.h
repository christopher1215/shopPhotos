//
//  PulishClassSelectAlert.h
//  ShopPhotos
//
//  Created by addcn on 17/1/2.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseView.h"
#import "AlbumClassTableModel.h"
#import "AlbumClassTableSubModel.h"
@protocol PulishClassSelectAlertDelegate  <NSObject>

- (void)ftherClassSelected:(NSInteger)indexPath;
- (void)subClassSelected:(NSInteger)indexPath;

@end

@interface PulishClassSelectAlert : BaseView

@property (weak, nonatomic) id<PulishClassSelectAlertDelegate>delegate;
- (void)showFtherAlert:(NSArray *)classArray;
- (void)showSubAlert:(NSArray *)classArray;
- (void)closeAlert;
@end
