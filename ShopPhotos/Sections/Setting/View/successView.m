//
//  successView.m
//  ShopPhotos
//
//  Created by Macbook on 27/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "successView.h"

@implementation successView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews{
    self.msgView.cornerRadius = 5;
}
- (IBAction)onClose:(id)sender {
    [self removeAnimate];
}
- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformMakeScale(1, 1);
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
@end
