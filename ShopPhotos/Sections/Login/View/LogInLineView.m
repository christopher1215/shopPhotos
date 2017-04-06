//
//  LogInLineView.m
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "LogInLineView.h"

@implementation LogInLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel * title = [[UILabel alloc] init];
        [title setText:@"第三方登录"];
        [title setTextColor:ColorHex(0X888888)];
        [title setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:title];
        
        UIView * leftView = [[UIView alloc] init];
        //[leftView setBackgroundColor:[UIColor greenColor]];
        [self addSubview:leftView];
        
        UIView * rightView = [[UIView alloc] init];
        //[rightView setBackgroundColor:[UIColor greenColor]];
        [self addSubview:rightView];
        
        title.sd_layout
        .leftSpaceToView(self,(frame.size.width-95)/2)
        .topEqualToView(self)
        .widthIs(95)
        .heightIs(30);
        
        leftView.sd_layout
        .leftEqualToView(self)
        .rightSpaceToView(title,-5)
        .topSpaceToView(self,(frame.size.height-1)/2)
        .heightIs(1);
        
        
        rightView.sd_layout
        .rightEqualToView(self)
        .leftSpaceToView(title,5)
        .topSpaceToView(self,(frame.size.height-1)/2)
        .heightIs(1);
        
        
//        CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
//        NSArray * colors = [NSArray arrayWithObjects:
//                            (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor,
//                            (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor,
//                            (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor,
//                            nil];
//        newShadow.colors = colors;
//        [newShadow setBackgroundColor:[UIColor whiteColor].CGColor];
//        newShadow.startPoint = CGPointMake(1, 0);
//        newShadow.endPoint   = CGPointMake(0, 0);
//        CGRect newShadowFrame = CGRectMake(0, 0,(WindowWidth-60-30-10)/2, 1);
//        newShadow.frame = newShadowFrame;
//        [leftView.layer addSublayer:newShadow];
//        
//        
//        CAGradientLayer *newShadow1 = [[CAGradientLayer alloc] init];
//        NSArray * colors1 = [NSArray arrayWithObjects:
//                            (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor,
//                            (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor,
//                            (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor,
//                            nil];
//        newShadow1.colors = colors1;
//        [newShadow1 setBackgroundColor:[UIColor whiteColor].CGColor];
//        newShadow1.startPoint = CGPointMake(0, 0);
//        newShadow1.endPoint   = CGPointMake(1, 0);
//        CGRect newShadowFrame1 = CGRectMake(0, 0,(WindowWidth-60-30-10)/2, 1);
//        newShadow1.frame = newShadowFrame1;
//        [rightView.layer addSublayer:newShadow1];
        
        
        
        [leftView.layer addSublayer:[self shadowAsInverse:CGRectMake(0, 0,(WindowWidth-60-95-10)/2, 1) winth:NO]];
        [rightView.layer addSublayer:[self shadowAsInverse:CGRectMake(0, 0, (WindowWidth-60-95-10)/2, 1) winth:YES]];
    }
    return self;
}


- (CAGradientLayer *)shadowAsInverse:(CGRect)rect winth:(BOOL)point{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = rect;
    newShadow.frame = newShadowFrame;
    
    NSArray * colors = [NSArray arrayWithObjects:
                        (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor,
                        (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor,
                        (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor,
                        nil];
    newShadow.colors = colors;
    if(point){
        newShadow.startPoint = CGPointMake(0, 0);
        newShadow.endPoint   = CGPointMake(1, 0);
    }else{
        newShadow.startPoint = CGPointMake(1, 0);
        newShadow.endPoint   = CGPointMake(0, 0);
    }
    [newShadow setBackgroundColor:[UIColor whiteColor].CGColor];
    return newShadow;
}

@end
