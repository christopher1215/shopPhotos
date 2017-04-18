//
//  TabBarCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "TabBarCtr.h"
#import "HomePageCtr.h"
#import "DynamicCtr.h"
#import "AttentionCtr.h"
#import "UserCtr.h"
#import "CommonDefine.h"
#import "TabBarView.h"
#import "PublishPhotosCtr.h"
#import "PublishPhotoCtr.h"
#import "PublishSelect.h"

@interface TabBarCtr ()<TabBarViewDelegate>

@end

@implementation TabBarCtr

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBar setHidden:YES];
    for(UIView * tabbar in self.tabBar.subviews){
        if([tabbar isKindOfClass:[TabBarView class]]){
            [tabbar removeFromSuperview];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundColor = [UIColor clearColor];
    [self createPage];
}

- (void)createPage{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    HomePageCtr * home = GETALONESTORYBOARDPAGE(@"HomePageCtr");
    DynamicCtr * dynamic = GETALONESTORYBOARDPAGE(@"DynamicCtr");
    AttentionCtr * attention = GETALONESTORYBOARDPAGE(@"AttentionCtr");
    UserCtr * user = GETALONESTORYBOARDPAGE(@"UserCtr");
    
    [self setViewControllers:@[home,dynamic,attention,user]];
    
    TabBarView * tabbarView = [[TabBarView alloc] init];
    tabbarView.delegate = self;
    [self.view addSubview:tabbarView];
    
    tabbarView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(60);
}

#pragma mark - TabBarViewDelegate
- (void)tabbarSelect:(NSInteger)index{
    switch (index) {
        case 0:
            self.selectedIndex = index;
            break;
        case 1:
            self.selectedIndex = index;
            break;
        case 2:
        {
            PublishSelect * pubSelect = GETALONESTORYBOARDPAGE(@"PublishSelect");
            [self presentViewController:pubSelect animated:YES completion:nil];
//            [self.navigationController pushViewController:pulish animated:YES];
        }
            break;
        case 3:
            self.selectedIndex = 2;
            break;
        case 4:
            self.selectedIndex = 3;
            break;
    }
}


@end
