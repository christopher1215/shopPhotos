//
//  TabBarView.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/19.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol TabBarViewDelegate <NSObject>

- (void)tabbarSelect:(NSInteger)index;
@end

@interface TabBarView : BaseView

@property (weak, nonatomic) id<TabBarViewDelegate>delegate;
-(void)setUnreadCountBadge:(NSNotification *)noti;

@end
