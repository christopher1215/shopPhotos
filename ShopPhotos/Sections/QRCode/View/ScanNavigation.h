//
//  ScanNavigation.h
//  platform
//
//  Created by addcn on 16/11/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol ScanNavigationDelegate <NSObject>

- (void)navigationComeBack;

@end

@interface ScanNavigation : BaseView

@property (weak, nonatomic) id<ScanNavigationDelegate>delegate;

@end
