//
//  NavigationView.h
//  platform
//
//  Created by addcn on 16/8/9.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol NavigationDelegate <NSObject>
- (void)navigationComeBack;
@end

#define NAVIGATIONHEIGHT 64

@interface NavigationView :BaseView

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * backImageName;
@property (weak, nonatomic) id<NavigationDelegate>delegate;

@end
