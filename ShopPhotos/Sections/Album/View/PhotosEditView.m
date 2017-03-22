//
//  PhotosEditView.m
//  ShopPhotos
//
//  Created by addcn on 16/12/26.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PhotosEditView.h"

@interface PhotosEditView ()

@property (strong, nonatomic) UIView * navigation;
@property (strong, nonatomic) UIButton * cancel;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UIButton * all;


@end

@implementation PhotosEditView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createAutoLayout];
        
    }
    return self;
}

- (void)createAutoLayout{
    
    self.navigation = [[UIView alloc] init];
    [self.navigation setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.navigation];
    
    self.cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancel setBackgroundColor:[UIColor whiteColor]];
    [self.cancel addTarget:self action:@selector(cancelSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.cancel.titleLabel setFont:Font(16)];
    [self.navigation addSubview:self.cancel];
    
    self.title = [[UILabel alloc] init];
    [self.title setText:@"已选择0项"];
    [self.title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    [self.title setTextAlignment:NSTextAlignmentCenter];
    [self.navigation addSubview:self.title];
    
    self.all = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.all setTitle:@"全选" forState:UIControlStateNormal];
    [self.all.titleLabel setFont:Font(16)];
    [self.all addTarget:self action:@selector(allSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.all setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.all setBackgroundColor:[UIColor whiteColor]];
    [self.navigation addSubview:self.all];
    
    
    self.navigation.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    self.cancel.sd_layout
    .leftSpaceToView(self.navigation,10)
    .topSpaceToView(self.navigation,20)
    .bottomSpaceToView(self.navigation,0)
    .widthIs(60);
    
    self.all.sd_layout
    .rightSpaceToView(self.navigation,10)
    .topSpaceToView(self.navigation,20)
    .bottomSpaceToView(self.navigation,0)
    .widthIs(60);
    
    self.title.sd_layout
    .leftSpaceToView(self.cancel,10)
    .rightSpaceToView(self.all,10)
    .topSpaceToView(self.navigation,20)
    .bottomSpaceToView(self.navigation,0);
}

- (void)cancelSelected{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(photosEditSelected:)]){
        [self.delegate photosEditSelected:1];
    }
}
- (void)allSelected{

    if(self.delegate && [self.delegate respondsToSelector:@selector(photosEditSelected:)]){
        [self.delegate photosEditSelected:2];
    }
}

- (void)setAllSelectStatus:(BOOL)allSelectStatus{
    _allSelectStatus = allSelectStatus;
    if(_allSelectStatus){
        [self.all setTitle:@"清除" forState:UIControlStateNormal];
    }else{
        [self.all setTitle:@"全选" forState:UIControlStateNormal];
    }
}

- (void)setSelectedCount:(NSInteger)count{
    [self.title setText:[NSString stringWithFormat:@"已选择%ld项",count]];
}


@end