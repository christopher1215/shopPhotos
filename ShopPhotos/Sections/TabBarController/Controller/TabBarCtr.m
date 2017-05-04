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
#import "PublishPhotoCtr.h"
#import "PublishVideoCtr.h"
#import "PublishSelect.h"

@interface TabBarCtr ()<TabBarViewDelegate>
{
    TabBarView * tabbarView;
}
@end

@implementation TabBarCtr

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if (tabbarView) {
        [tabbarView setUnreadCountBadge:nil];
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
    
    tabbarView = [[TabBarView alloc] init];
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
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                // Cancel button tappped.
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }]];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"上传图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // Distructive button tapped.
                PublishPhotoCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
                [self.navigationController pushViewController:pulish animated:YES];

                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }]];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"录制短视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // OK button tapped.
                PublishVideoCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishVideoCtr");
                [self.navigationController pushViewController:pulish animated:YES];
                
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }]];
            // Present action sheet.
            [self presentViewController:actionSheet animated:YES completion:nil];
        }
            break;
        case 3:
        {
            //self.selectedIndex = 2;
            AttentionCtr * attention = GETALONESTORYBOARDPAGE(@"AttentionCtr");
            [self.navigationController pushViewController:attention animated:YES];
            break;
        }
        case 4:
            self.selectedIndex = 3;
            break;
    }
}


@end
