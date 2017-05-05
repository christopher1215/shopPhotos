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
    [self.alert setBackgroundColor:ColorHex(0x484848)];
    [self.alert addTarget:self action:nil];
    [self addSubview:self.alert];
    
    self.alertWidth = 120;
    
    
    NSArray * titleArray;
    if(mode == OptionModel){
        titleArray = @[@"上传相册",@"添加用户",@"扫一扫"];
        //        titleArray = @[@"上传相册",@"添加用户"];
        [self.alert setBackgroundColor:ColorHexA(0X333333,0.9)];
        self.alertHeight = 135;
        self.alert.sd_layout
        .rightSpaceToView(self,10)
        .topSpaceToView(self,64)
        .widthIs(self.alertWidth)
        .heightIs(self.alertHeight);
    }
    else if (mode == HomeModel){
        titleArray = @[@"上传相册",@"添加用户"];
        self.alertHeight = 90;
        //        [self.alert setBackgroundColor:ColorHexA(0X333333,0.9)];
        [self.alert setBackgroundColor:ColorHexA(0xffffff,0.9)];
        self.alert.sd_layout
        .rightSpaceToView(self,10)
        .topSpaceToView(self,64)
        .widthIs(self.alertWidth)
        .heightIs(self.alertHeight);
    }
    else if (mode == DynamicTabModel){
        titleArray = @[@"上传相册",@"添加用户"];
        self.alertHeight = 90;
        //        [self.alert setBackgroundColor:ColorHexA(0X333333,0.9)];
        [self.alert setBackgroundColor:ColorHexA(0X333333,0.9)];
        self.alert.sd_layout
        .rightSpaceToView(self,10)
        .topSpaceToView(self,64)
        .widthIs(self.alertWidth)
        .heightIs(self.alertHeight);
    }
    else if(mode == PhotosModel){
        titleArray = @[@"编辑",@"上传相册"];
        self.alertHeight = 90;
        self.alert.sd_layout
        .rightSpaceToView(self,10)
        .topSpaceToView(self,64)
        .widthIs(self.alertWidth)
        .heightIs(self.alertHeight);
        
    }else if(mode == PhotosClassModel){
        titleArray = @[@"编辑",@"新建分类"];
        self.alertHeight = 90;
        self.alert.sd_layout
        .rightSpaceToView(self,10)
        .topSpaceToView(self,64)
        .widthIs(self.alertWidth)
        .heightIs(self.alertHeight);
    }else if (mode == SortOrder){
        titleArray = @[@"按文件名称",@"按创建日期"];
        self.alertHeight = 90;
        self.alert.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(self,100)
        .widthIs(self.alertWidth)
        .heightIs(self.alertHeight);
    }
    
    if(!titleArray) return;
    
    for(NSInteger index = 0; index < titleArray.count; index++){
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:[titleArray objectAtIndex:index] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        if(mode == HomeModel){
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
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
            if(mode == HomeModel){
                [line setBackgroundColor:ColorHex(0Xcccccc)];
            }
            else {
                [line setBackgroundColor:[UIColor whiteColor]];
            }
            [self.alert addSubview:line];
            
            line.sd_layout
            .leftSpaceToView(self.alert,8)
            .rightSpaceToView(self.alert,8)
            .topSpaceToView(self.alert,index*40+49.5)
            .heightIs(0.5);
        }
    }
}

- (void)setStyle{
    
    CGFloat viewWidth = _alertWidth;
    CGFloat viewHeight = _alertHeight;
    CGPoint point1,point2,point3,point4,point5,point6,point7,point8,point9,point10,point11,center1,center2,center3,center4;
    
    int cornerRadius = 5;
    int tHeight = 5;
    int tWidth = 10;
    
    point1 = CGPointMake(cornerRadius, tHeight);
    if (_mode == SortOrder) {
        point2 = CGPointMake(cornerRadius+5,tHeight);
        point3 = CGPointMake(cornerRadius+5+tWidth/2,0);
        point4 = CGPointMake(cornerRadius+5+tWidth,tHeight);
    }
    else {
        point2 = CGPointMake(viewWidth-tWidth-cornerRadius-5,tHeight);
        point3 = CGPointMake(viewWidth-tWidth/2-cornerRadius-5,0);
        point4 = CGPointMake(viewWidth-cornerRadius-5,tHeight);
    }
    
    point5 = CGPointMake(viewWidth-cornerRadius, tHeight);
    point6 = CGPointMake(viewWidth, cornerRadius+tHeight);
    point7 = CGPointMake(viewWidth, viewHeight-cornerRadius);
    point8 = CGPointMake(viewWidth-cornerRadius, viewHeight);
    point9 = CGPointMake(cornerRadius, viewHeight);
    point10 = CGPointMake(0, viewHeight-cornerRadius);
    point11 = CGPointMake(0, cornerRadius+tHeight);
    center1 = CGPointMake(cornerRadius, tHeight+cornerRadius);
    center2 = CGPointMake(viewWidth-cornerRadius, tHeight+cornerRadius);
    center3 = CGPointMake(viewWidth-cornerRadius, viewHeight-cornerRadius);
    center4 = CGPointMake(cornerRadius, viewHeight-cornerRadius);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addArcWithCenter:center2 radius:cornerRadius startAngle:M_PI/2 endAngle:0 clockwise:YES];
    [path addLineToPoint:point7];
    [path addArcWithCenter:center3 radius:cornerRadius startAngle:0 endAngle:M_PI/2 clockwise:YES];
    [path addLineToPoint:point9];
    [path addArcWithCenter:center4 radius:cornerRadius startAngle:M_PI*3/2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:point11];
    [path addArcWithCenter:center1 radius:cornerRadius startAngle:M_PI endAngle:M_PI/2 clockwise:YES];
    [path closePath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    self.alert.layer.mask = layer;
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
