//
//  FeedbackOptionAlert.m
//  ShopPhotos
//
//  Created by addcn on 16/12/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "FeedbackOptionAlert.h"

@interface FeedbackOptionAlert ()

@property (strong, nonatomic)UIView * alert;

@end

@implementation FeedbackOptionAlert

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createAutoLayout];
    }
    return self;
}

- (void)createAutoLayout{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self addTarget:self action:@selector(closeAlert)];
    
    self.alert = [[UIView alloc] init];
    [self.alert addTarget:self action:nil];
    [self.alert setBackgroundColor:[UIColor whiteColor]];
    self.alert.layer.cornerRadius = 3;
    [self addSubview:self.alert];
    
    self.alert.sd_layout
    .centerXIs(WindowWidth/2)
    .centerYIs(WindowHeight/2)
    .widthIs(300)
    .heightIs(135);
    
    NSArray * titleArray = @[@"功能反馈",@"发现BUG",@"投诉"];
    for(NSInteger index = 0; index < titleArray.count; index++){
        
        UILabel * label = [[UILabel alloc] init];
        [label setText:titleArray[index]];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.tag = index;
        [label addTarget:self action:@selector(labelSelected:)];
        [self.alert addSubview:label];
        
        label.sd_layout
        .leftEqualToView(self.alert)
        .rightEqualToView(self.alert)
        .topSpaceToView(self.alert,45*index)
        .heightIs(45);
    }
}

- (void)labelSelected:(UITapGestureRecognizer *)tap{
    
    UILabel * label = (UILabel *)tap.view;
    NSString * title = label.text;
    NSInteger tag = label.tag;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(feedbackOption:selectedType:)]){
        [self.delegate feedbackOption:title selectedType:tag];
    }
    [self closeAlert];
}

- (void)showAlert{

    [self setHidden:NO];
    [self setAlpha:0];
    [UIView animateWithDuration:0.5 animations:^{
         [self setAlpha:1];
    }];
    
}

- (void)closeAlert{

    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished){
        [self setHidden:YES];
    }];
    
}
@end
