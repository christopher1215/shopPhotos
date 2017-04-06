//
//  PhotoClassCreate.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PhotoClassCreate.h"

@interface PhotoClassCreate ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView * content;
@property (strong, nonatomic) UILabel * tips;
@property (strong, nonatomic) UIView * select;
@property (strong, nonatomic) UILabel * selectText;
@property (strong, nonatomic) UIImageView * selectIcon;
@property (strong, nonatomic) UIView * enterView;
@property (strong, nonatomic) UITextField * enterClass;
@property (strong, nonatomic) UILabel * subTips;
@property (strong, nonatomic) UITextField * tempTextTield;
@property (strong, nonatomic) NSMutableArray * showArray;
@property (assign, nonatomic) CGFloat styleOffse;

@end

@implementation PhotoClassCreate

- (NSMutableArray *)showArray{
    
    if(!_showArray){
        _showArray = [NSMutableArray array];
    }
    return _showArray;
}




- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createAutoLayout];
    }
    return self;
}

- (void)createAutoLayout{
    
    self.content = [[UIScrollView alloc] init];
    [self.content setBackgroundColor:ColorHex(0XEEEEEE)];
    self.content.delegate = self;
    [self.content addTarget:self action:@selector(contentSelcted)];
    [self addSubview:self.content];

    self.tips = [[UILabel alloc] init];
    [self.tips setText:@"新建父分类"];
    [self.tips setFont:Font(13)];
    [self.content addSubview:self.tips];
    
    self.select = [[UIView alloc] init];
    [self.select setBackgroundColor:[UIColor whiteColor]];
    self.select.layer.cornerRadius = 3;
    [self.select addTarget:self action:@selector(classSelected)];
    [self.content addSubview:self.select];
    
    self.selectText = [[UILabel alloc] init];
    [self.selectText setText:@"新建父分类"];
    [self.selectText setFont:Font(13)];
    [self.select addSubview:self.selectText];
    
    self.selectIcon = [[UIImageView alloc] init];
    [self.selectIcon setContentMode:UIViewContentModeScaleAspectFit];
    self.selectIcon.image = [UIImage imageNamed:@"ico_triangle"];
    [self.select addSubview:self.selectIcon];
    
    self.enterView = [[UIView alloc] init];
    [self.enterView setBackgroundColor:[UIColor whiteColor]];
    self.enterView.layer.cornerRadius = 3;
    [self.content addSubview:self.enterView];
    
    self.enterClass = [[UITextField alloc] init];
    self.enterClass.placeholder = @"输入父分类";
    [self.enterClass setFont:Font(13)];
    self.enterClass.delegate = self;
    self.tempTextTield = self.enterClass;
    [self.enterView addSubview:self.enterClass];
    
    self.subTips = [[UILabel alloc] init];
    [self.subTips setText:@"输入子分类"];
    [self.subTips setFont:Font(13)];
    [self.subTips setHidden:YES];
    [self.content addSubview:self.subTips];
    
    
    self.content.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .rightEqualToView(self);
    
    self.tips.sd_layout
    .leftSpaceToView(self.content,10)
    .topSpaceToView(self.content,10)
    .rightSpaceToView(self.content,10)
    .heightIs(40);
    
    self.select.sd_layout
    .leftSpaceToView(self.content,10)
    .rightSpaceToView(self.content,10)
    .topSpaceToView(self.tips,10)
    .heightIs(40);
    
    self.selectText.sd_layout
    .leftSpaceToView(self.select,10)
    .topEqualToView(self.select)
    .bottomEqualToView(self.select)
    .rightSpaceToView(self.select,20);
    
    self.selectIcon.sd_layout
    .leftSpaceToView(self.selectText,5)
    .topEqualToView(self.select)
    .bottomEqualToView(self.select)
    .rightSpaceToView(self.select,5);
    
    self.enterView.sd_layout
    .leftSpaceToView(self.content,10)
    .rightSpaceToView(self.content,10)
    .topSpaceToView(self.select,30)
    .heightIs(45);
    
    self.enterClass.sd_layout
    .leftSpaceToView(self.enterView,10)
    .topSpaceToView(self.enterView,5)
    .bottomSpaceToView(self.enterView,5)
    .rightSpaceToView(self.enterView,10);
    
    
    self.subTips.sd_layout
    .leftSpaceToView(self.content,10)
    .rightSpaceToView(self.content,10)
    .topSpaceToView(self.select,85)
    .heightIs(40);
    
    self.styleOffse = 245;
    [self createSubClassPhoto];
    [self.content setContentSize:CGSizeMake(0, WindowHeight-54)];
}

- (void)createSubClassPhoto{
    
    for(NSInteger index = 0; index<5;index++){
    
        UIView * enterView = [[UIView alloc] init];
        [enterView setBackgroundColor:[UIColor whiteColor]];
        enterView.layer.cornerRadius = 3;
        [enterView setHidden:YES];
        enterView.tag = 100+index;
        [self.content addSubview:enterView];
        
        UITextField * enter = [[UITextField alloc] init];
        enter.placeholder = @"请输入子分类";
        [enter setFont:Font(13)];
        enter.delegate = self;
        enter.tag = 30+index;
        [enterView addSubview:enter];
        
        UIImageView * enterIcon = [[UIImageView alloc] init];
        [enterIcon setBackgroundColor:[UIColor clearColor]];
        if(index == 0){
            [enterIcon setImage:[UIImage imageNamed:@"add_orange"]];
        }else{
            [enterIcon setImage:[UIImage imageNamed:@"jian"]];
        }
        
        [enterIcon setContentMode:UIViewContentModeScaleAspectFit];
        [enterIcon addTarget:self action:@selector(enterIocnSelected:)];
        enterIcon.tag = index+10;
        [enterView addSubview:enterIcon];
        
        enterView.sd_layout
        .leftSpaceToView(self.content,10)
        .rightSpaceToView(self.content,10)
        .topSpaceToView(self.subTips,index*60+10)
        .heightIs(45);
        
        enter.sd_layout
        .leftSpaceToView(enterView,10)
        .topSpaceToView(enterView,5)
        .bottomSpaceToView(enterView,5)
        .rightSpaceToView(enterView,50);
        
        enterIcon.sd_layout
        .leftSpaceToView(enter,8)
        .topSpaceToView(enterView,8)
        .bottomSpaceToView(enterView,8)
        .rightSpaceToView(enterView,8);
        
    }
}

- (void)setSelectedTitle:(NSString *)title{
    [self.selectText setText:title];
}

- (void)setStyleView:(BOOL)style{
    
    if(style){
        [self.enterView setHidden:NO];
        self.subTips.sd_layout.topSpaceToView(self.select,85);
        [self.subTips updateLayout];
    }else{
        [self.enterView setHidden:YES];
        self.subTips.sd_layout.topSpaceToView(self.select,10);
        [self.subTips updateLayout];
        [self setStyle:YES];
    }
}

- (void)setStyle:(BOOL)show{

    if(show){
        
        [self.subTips setHidden:NO];
        if(self.showArray.count == 0){
            UIView * enterView = [self.content viewWithTag:100];
            [self.showArray addObject:enterView];
        }
        for(UIView * v in self.showArray){
            [v setHidden:NO];
        }
        
        
    }else{
        [self.subTips setHidden:YES];
        for(UIView * v in self.showArray){
            [v setHidden:YES];
        }
    }
}

- (NSDictionary *)getClassifiesName{
    
    NSMutableDictionary * data  = [NSMutableDictionary dictionary];
    if(self.enterClass.text && self.enterClass.text.length > 0){
        [data setObject:self.enterClass.text forKey:@"name"];
    }
    
    
    NSMutableString * subName = [[NSMutableString alloc] init];
    
    for(NSInteger index = 0;index<self.showArray.count;index++){
        UIView * enterView = [self.showArray objectAtIndex:index];
        UITextField * enter = [enterView viewWithTag:index+30];
        if(!enter.text || enter.text.length == 0) break;
        if(index != 0){
            [subName appendFormat:@"*%@",enter.text];
        }else{
            [subName appendString:enter.text];
        }
    }
    
    if(subName.length > 0){
        [data setObject:subName forKey:@"subName"];
    }
    
    return data;
}

#pragma mark - OnClick
- (void)enterIocnSelected:(UITapGestureRecognizer *)tap{
    [self.tempTextTield resignFirstResponder];
    if(tap.view.tag == 10){
        if(self.showArray.count == 5) {
            SPAlert(@"一次最多新建5个子分类",self);
            return;
        }
        UIView * enterView = [self.content viewWithTag:100+self.showArray.count];
        [enterView setHidden:NO];
        [self.showArray addObject:enterView];
        
    }else{
        UIView * enterView = [self.content viewWithTag:100+self.showArray.count-1];
        [enterView setHidden:YES];
        [self.showArray removeObjectAtIndex:self.showArray.count-1];
    }
}

- (void)contentSelcted{
    [self.tempTextTield resignFirstResponder];
}

- (void)classSelected{
    if(self.delegate && [self.delegate respondsToSelector:@selector(photoSelectedClass)]){
        [self.delegate photoSelectedClass];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.tempTextTield = textField;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.enterClass){
        
        if(textField.text.length == 1 &&
           string.length == 0){
            NSLog(@"没有文字了");
            [self setStyle:NO];
        }else{
            NSLog(@"有文字");
            [self setStyle:YES];
        }
    }

    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tempTextTield resignFirstResponder];
}

#pragma mark - 键盘监听
- (void)keyboardWillShow:(NSNotification *)notification{
    
    UIView * superView = self.tempTextTield.superview;
    NSLog(@"%@",NSStringFromCGRect(superView.frame));
    
    CGFloat offset = WindowHeight - superView.frame.origin.y-superView.frame.size.height-64;
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSLog(@"%f----%f",offset,keyboardHeight);
    
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if(offset - keyboardHeight < 60){
        [UIView animateWithDuration:duration animations:^{
            NSLog(@"%f",keyboardHeight -offset + 60);
            [self.content setContentOffset:CGPointMake(0,keyboardHeight -offset + 80)];
            
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.content setContentOffset:CGPointMake(0,0)];
    }];
}

@end
