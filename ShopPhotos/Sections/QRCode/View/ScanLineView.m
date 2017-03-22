//
//  ScanLineView.m
//  platform
//
//  Created by addcn on 16/11/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "ScanLineView.h"

@interface ScanLineView ()

@property (strong, nonatomic) UIImageView * line;
@property (assign, nonatomic) BOOL stop;

@end

@implementation ScanLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        self.line = [[UIImageView alloc] initWithFrame:CGRectMake(0,-250, self.frame.size.width,self.frame.size.height)];
        self.line.alpha = 0.7;
        [self.line setContentMode:UIViewContentModeScaleAspectFill];
        [self.line setImage:[UIImage imageNamed:@"qrcode_default_grid_scan_line"]];
        [self addSubview:self.line];
        [self startScan];
    }
    return self;
}


- (void)startScan{
    
    [UIView animateWithDuration:4 animations:^{
        self.line.frame = CGRectMake(0,self.frame.size.height,self.frame.size.width,self.frame.size.height);
    } completion:^(BOOL finished){
        self.line.frame = CGRectMake(0,-250, self.frame.size.width,self.frame.size.height);
        if(!self.stop){
            [self startScan];
        }
        
    }];
}

- (void)stopScan{
    self.stop = YES;
}


@end
