//
//  UILabel+Extension.m
//  58City
//
//  Created by addcn on 16/9/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView(Extension)


#pragma mark - 设置边框颜色
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}
#pragma mark - 获取边框颜色
- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

#pragma mark - 设置边框大小
- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}
#pragma mark - 获取边框大小
- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

#pragma mark -  设置圆角弧度
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}
#pragma mark -  获取圆角弧度
- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}


#pragma mark - 添加单击手势
- (void)addTarget:(id)target action:(SEL)action{
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:target action:action]];
}
@end
