//
//  PulishClassSelectAlert.m
//  ShopPhotos
//
//  Created by addcn on 17/1/2.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PulishClassSelectAlert.h"


@interface PulishClassSelectAlert ()
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) UIView * alert;
@property (strong, nonatomic) UIScrollView * content;

@end

@implementation PulishClassSelectAlert

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addTarget:self action:@selector(closeAlert)];
        
        self.alert = [[UIView alloc] init];
        self.cornerRadius = 5;
        [self.alert setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.alert];
        self.alert .sd_layout
        .widthIs(WindowWidth-40)
        .centerYIs(WindowHeight/2)
        .centerXIs(WindowWidth/2)
        .heightIs(0);
        
        self.content = [[UIScrollView alloc] init];
        [self.content setBackgroundColor:[UIColor whiteColor]];
        [self.alert addSubview:self.content];
        self.content.sd_layout
        .leftEqualToView(self.alert)
        .rightEqualToView(self.alert)
        .topEqualToView(self.alert)
        .bottomEqualToView(self.alert);
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    }
    return self;
}

- (NSMutableArray *)dataArray{
    
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (void)showFtherAlert:(NSArray *)classArray{
    if(!classArray || classArray.count == 0)return;
    [self showAlert];
    [self.dataArray addObjectsFromArray:classArray];
    NSInteger index = 0;
    for(AlbumClassTableModel * model in self.dataArray){
        
        UILabel * label = [[UILabel alloc] init];
        [label setFont:Font(15)];
        if(index == 0) {
            [label setTextColor:ThemeColor];
        }else{
            [label setTextColor:[UIColor blackColor]];
        }
        
        label.tag = index;
        [label addTarget:self action:@selector(labelSelected:)];
        [label setText:model.name];
        [self.content addSubview:label];
        
        UIView * line = [[UIView alloc] init];
        [line setBackgroundColor:ColorHex(0XEEEEEE)];
        [self.content addSubview:line];
        
        label.sd_layout
        .leftSpaceToView(self.content,10)
        .rightSpaceToView(self.content,10)
        .topSpaceToView(self.content,index*40)
        .heightIs(39);
        
        line.sd_layout
        .leftEqualToView(self.content)
        .rightEqualToView(self.content)
        .topSpaceToView(label,0)
        .heightIs(1);
        
        index ++;
    }
    
    CGFloat height = self.dataArray.count * 40;
    if(height > WindowHeight - 150) height = WindowHeight-150;
   
    self.alert.sd_layout.heightIs(height);
    [self.alert updateLayout];
     [self.content setContentSize:CGSizeMake(0,self.dataArray.count *40)];
    [self.content updateLayout];
}

- (void)showSubAlert:(NSArray *)classArray{
    if(!classArray || classArray.count == 0)return;
    [self showAlert];
    [self.dataArray addObjectsFromArray:classArray];
     NSInteger index = 0;
    for(AlbumClassTableSubModel * model in self.dataArray){
        UILabel * label = [[UILabel alloc] init];
        [label setFont:Font(15)];
        if(index == 0) {
            [label setTextColor:ThemeColor];
        }else{
            [label setTextColor:[UIColor blackColor]];
        }
        [label addTarget:self action:@selector(labelSubSelected:)];
        label.tag = index;
        [label setText:model.name];
        [self.content addSubview:label];
        
        UIView * line = [[UIView alloc] init];
        [self.content addSubview:line];
        
        label.sd_layout
        .leftSpaceToView(self.content,10)
        .rightSpaceToView(self.content,10)
        .topSpaceToView(self.content,index*40)
        .heightIs(39);
        
        line.sd_layout
        .leftEqualToView(self.content)
        .rightEqualToView(self.content)
        .topSpaceToView(label,0)
        .heightIs(1);
        
        index ++;

    }
    
    CGFloat height = self.dataArray.count * 40;
    if(height > WindowHeight - 150) height = WindowHeight-150;
    [self.content setContentSize:CGSizeMake(0,self.dataArray.count *40)];
    self.alert.sd_layout.heightIs(height);
    [self.alert updateLayout];
}


- (void)showAlert{
    [self.dataArray removeAllObjects];
    for(UIView * subView in self.content.subviews){
        [subView removeFromSuperview];
    }
    
    [self setHidden:NO];
    [self setAlpha:0];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:1];
    }];
}

- (void)closeAlert{
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0];
    }completion:^(BOOL finished){
        [self setHidden:YES];
    }];
}

- (void)labelSelected:(UITapGestureRecognizer *)tap{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(ftherClassSelected:)]){
        [self.delegate ftherClassSelected:tap.view.tag];
    }
    [self closeAlert];
}

- (void)labelSubSelected:(UITapGestureRecognizer *)tap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(subClassSelected:)]){
        [self.delegate subClassSelected:tap.view.tag];
    }
    [self closeAlert];
}

@end
