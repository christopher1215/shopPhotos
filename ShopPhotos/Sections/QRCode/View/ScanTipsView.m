//
//  ScanTipsView.m
//  platform
//
//  Created by addcn on 16/11/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "ScanTipsView.h"

@implementation ScanTipsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel * title = [[UILabel alloc] initWithFrame:self.bounds];
        [title setTextColor:[UIColor whiteColor]];
        [title setBackgroundColor:ColorHexA(0X000000, 0.3)];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setCornerRadius:18];
        [title setText:@"将二维码放入框内，即可自动扫描"];
        [self addSubview:title];
    }
    return self;
}

@end
