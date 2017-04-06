//
//  MoreAlert.m
//  ShopPhotos
//
//  Created by addcn on 16/12/24.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "MoreAlert.h"

@interface MoreAlert ()<CAAnimationDelegate>
@property (assign, nonatomic) CGPoint tempCenter;
@property (strong, nonatomic) UIView * alert;
@property (assign, nonatomic) CGFloat alertWidth;
@property (assign, nonatomic) CGFloat alertHeight;
@end

@implementation MoreAlert


- (void)setMode:(AlertModeType)mode{
    
    _mode = mode;
    [self createAutoLayout:mode];
    [self setStyle];
}

- (void)createAutoLayout:(AlertModeType)mode{
    
    [self setBackgroundColor:ColorHexA(0XFFFFFF, 0)];
    [self addTarget:self action:@selector(closeAlert)];
    
    
    self.alert = [[UIView alloc] init];
//    [self.alert setBackgroundColor:ColorHex(0X26252a)];
    [self.alert setBackgroundColor:ColorHexA(0Xffffff,0.7)];
    [self.alert addTarget:self action:nil];
    [self addSubview:self.alert];
    
    
    NSArray * titleArray;
    if(mode == OptionModel){
//        titleArray = @[@"上传相册",@"扫一扫",@"添加用户"];
        titleArray = @[@"上传相册",@"添加用户"];
        self.alertWidth = 120;
        self.alertHeight = 90;
        
    }else if(mode == PhotosModel){
        titleArray = @[@"编辑",@"上传相册"];
        self.alertWidth = 120;
        self.alertHeight = 90;
    }else if(mode == PhotosClassModel){
        titleArray = @[@"编辑",@"新建分类"];
        self.alertWidth = 120;
        self.alertHeight = 90;
    }
    
    self.alert.sd_layout
    .rightSpaceToView(self,10)
    .topSpaceToView(self,64)
    .widthIs(self.alertWidth)
    .heightIs(self.alertHeight);
    
    if(!titleArray) return;
    
    for(NSInteger index = 0; index < titleArray.count; index++){
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:[titleArray objectAtIndex:index] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = index;
        [button addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.alert addSubview:button];
        
        button.sd_layout
        .leftEqualToView(self.alert)
        .rightEqualToView(self.alert)
        .topSpaceToView(self.alert,index*40+10)
        .heightIs(39.5);
        if(index != titleArray.count - 1){
            UIView * line = [[UIView alloc] init];
            [line setBackgroundColor:[UIColor blackColor]];
            [self.alert addSubview:line];
            
            line.sd_layout
            .leftEqualToView(self.alert)
            .rightEqualToView(self.alert)
            .topSpaceToView(self.alert,index*40+49.5)
            .heightIs(0.5);
        }   
    }
}

- (void)setStyle{

    CGFloat viewWidth = 120;
    CGFloat viewHeight = 130;
    CGPoint point1 = CGPointMake(0, 10);
    CGPoint point2 = CGPointMake(viewWidth-20, 10);
    CGPoint point3 = CGPointMake(viewWidth-25,0);
    CGPoint point4 = CGPointMake(viewWidth-30, 10);
    CGPoint point5 = CGPointMake(viewWidth, 10);
    CGPoint point6 = CGPointMake(viewWidth, viewHeight);
    CGPoint point7 = CGPointMake(0, viewHeight);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    [path addLineToPoint:point7];
    [path closePath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    self.alert.layer.mask = layer;
    self.alert.layer.cornerRadius = 3;
}


- (void)showAlert{
    
    [self setHidden:NO];
    [self setAlpha:1];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.2; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    animation.autoreverses = NO; // 动画结束时执行逆动画
    animation.fromValue = [NSNumber numberWithFloat:0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1]; // 结束时的倍率
    self.alert.layer.anchorPoint = CGPointMake(1,0);
    self.alert.center = CGPointMake(self.alert.center.x+(self.alertWidth/2),self.alert.center.y-(self.alertHeight/2));
    animation.delegate = self;
    [animation setValue:@"ShowAnimation" forKey:@"AnimationKey"];
    [self.alert.layer addAnimation:animation forKey:@"scale-layer"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if([[anim valueForKey:@"AnimationKey"] isEqualToString:@"ShowAnimation"]){
        self.alert.layer.anchorPoint = CGPointMake(0.5,0.5);
        self.alert.center = CGPointMake(self.alert.center.x-(self.alertWidth/2),self.alert.center.y+(self.alertHeight/2));
    }else if([[anim valueForKey:@"AnimationKey"] isEqualToString:@"CloseAnimation"]){
        self.alert.layer.anchorPoint = CGPointMake(0.5,0.5);
        self.alert.center = CGPointMake(self.alert.center.x-(self.alertWidth/2),self.alert.center.y+(self.alertHeight/2));
        [self setHidden:YES];
    }
}

- (void)closeAlert{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.2; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    animation.autoreverses = NO; // 动画结束时执行逆动画
    animation.fromValue = [NSNumber numberWithFloat:1]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0]; // 结束时的倍率
    self.alert.layer.anchorPoint = CGPointMake(1,0);
    self.alert.center = CGPointMake(self.alert.center.x+(self.alertWidth/2),self.alert.center.y-(self.alertHeight/2));
    animation.delegate = self;
    [animation setValue:@"CloseAnimation" forKey:@"AnimationKey"];
    [self.alert.layer addAnimation:animation forKey:@"scale-layer"];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:0];
    }];
    
}

- (void)itemSelected:(UIButton *)button{
    
//    if(self.mode == PhotosClassModel){
//        if([button.currentTitle isEqualToString:@"编辑"]){
//            [button setTitle:@"取消" forState:UIControlStateNormal];
//        }else if([button.currentTitle isEqualToString:@"取消"]){
//            [button setTitle:@"编辑" forState:UIControlStateNormal];
//        }
//    }
    
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(moreAlertSelected:)]){
        [self.delegate moreAlertSelected:button.tag];
    }
    [self closeAlert];
}

@end
