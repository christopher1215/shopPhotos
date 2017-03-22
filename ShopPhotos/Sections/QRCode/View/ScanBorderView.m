//
//  ScanBorderView.m
//  platform
//
//  Created by addcn on 16/11/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "ScanBorderView.h"

@interface ScanBorderView ()

@property (assign, nonatomic) BorderType type;

@end

@implementation ScanBorderView

- (instancetype)initWithType:(BorderType)type
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _type = type;
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext(); //设置上下文
    CGContextSetStrokeColorWithColor(context,[ThemeColor CGColor]);//线条颜色
    CGContextSetLineWidth(context, 5.0);//线条宽度
    switch (self.type) {
        case BorderTopLeft:
            CGContextMoveToPoint(context, 30, 2);
            CGContextAddLineToPoint(context, 2, 2);
            CGContextAddLineToPoint(context, 2, 30);
            break;
        case BorderTopRight:
            CGContextMoveToPoint(context, self.frame.size.width-30,2);
            CGContextAddLineToPoint(context, self.frame.size.width-2, 2);
            CGContextAddLineToPoint(context, self.frame.size.width-2,30);
            break;
        case BorderLowerLeft:
            CGContextMoveToPoint(context, 2, self.frame.size.height-30);
            CGContextAddLineToPoint(context, 2, self.frame.size.height-2);
            CGContextAddLineToPoint(context, 30, self.frame.size.height-2);
            break;
        case BorderLowerRight:
            CGContextMoveToPoint(context, self.frame.size.width-30, self.frame.size.height-2);
            CGContextAddLineToPoint(context, self.frame.size.width-2, self.frame.size.height-2);
            CGContextAddLineToPoint(context, self.frame.size.width-2, self.frame.size.height-30);
            break;
    }
    CGContextStrokePath(context);
}


@end
