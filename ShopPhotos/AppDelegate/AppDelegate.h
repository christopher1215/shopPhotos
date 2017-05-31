//
//  AppDelegate.h
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumPhotosModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setStartViewController:(UIViewController*)vc;
- (NSString *)getParameterString;

@property (strong, nonatomic) UIViewController *fromCtr;
- (UIView *) showShareview:(NSString *)type collected:(BOOL)isCollected model:(AlbumPhotosModel *)photoModel from:(UIViewController *)ctr;
- (UIView *) showShare2view:(UIViewController *)ctr;

@end


