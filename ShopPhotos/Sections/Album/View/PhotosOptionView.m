//
//  PhotosOptionView.m
//  ShopPhotos
//
//  Created by addcn on 16/12/26.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PhotosOptionView.h"

@interface PhotosOptionView ()

@property (strong, nonatomic) UIButton * cancelRecommended;
@property (strong, nonatomic) UIButton * deleteBtn;

@end

@implementation PhotosOptionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createAutoLayout];
    }
    return self;
}

- (void)createAutoLayout{

    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.cancelRecommended = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelRecommended setTitle:@"取消推荐" forState:UIControlStateNormal];
    [self.cancelRecommended setTitleColor:ColorHex(0x333333) forState:UIControlStateNormal];
    [self.cancelRecommended setBackgroundColor:[UIColor whiteColor]];
    [self.cancelRecommended addTarget:self action:@selector(cancelRecommendedSelected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelRecommended];
    
    UIView * line = [[UIView alloc] init];
    [line setBackgroundColor:ColorHex(0Xeeeeee)];
    [self addSubview:line];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.deleteBtn setBackgroundColor:[UIColor whiteColor]];
    [self.deleteBtn addTarget:self action:@selector(deleteSelected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteBtn];
    
    line.sd_layout
    .leftSpaceToView(self,(WindowWidth-2)/2)
    .topSpaceToView(self,2)
    .bottomSpaceToView(self,2)
    .widthIs(2);
    
    self.cancelRecommended.sd_layout
    .leftSpaceToView(self,10)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .rightSpaceToView(line,10);
    
    self.deleteBtn.sd_layout
    .leftSpaceToView(line,10)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .rightSpaceToView(self,10);
}

- (void)cancelRecommendedSelected{

    if(self.delegate && [self.delegate respondsToSelector:@selector(photosOptionSelected:)]){
        [self.delegate photosOptionSelected:1];
    }
}

- (void)deleteSelected{
    if(self.delegate && [self.delegate respondsToSelector:@selector(photosOptionSelected:)]){
        [self.delegate photosOptionSelected:2];
    }
}

@end
