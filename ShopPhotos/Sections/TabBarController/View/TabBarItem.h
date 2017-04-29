//
//  TabBarItem.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/19.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"
#import "TabBarModel.h"

@interface TabBarItem : BaseView

- (instancetype)initWithModel:(TabBarModel *)model;

- (void)setStyleSelected;
- (void)setStyleDefault;
- (void)setUnreadCountBadge:(int)unreadCount;
@end
