//
//  UILabel+Extension.h
//  58City
//
//  Created by addcn on 16/9/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, strong) IBInspectable UIColor * borderColor;
@property (nonatomic, assign) IBInspectable CGFloat  borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

- (void)addTarget:(id)target action:(SEL)action;

@end
