//
//  PhotosControllerCell.m
//  PhotosDemo
//
//  Created by 廖检成 on 17/1/10.
//  Copyright © 2017年 Stanley. All rights reserved.
//

#import "PhotosControllerCell.h"

@interface PhotosControllerCell ()

@property (strong, nonatomic) UIImageView * image;
@property (strong, nonatomic) UIImageView * select;

@end

@implementation PhotosControllerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.image setContentMode:UIViewContentModeCenter];
        [self.image setClipsToBounds:YES];
        [self.contentView addSubview:self.image];
        
        self.select = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-40, 0, 40, 40)];
        [self.select setUserInteractionEnabled:YES];
        [self.select addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selected)]];
        [self.contentView addSubview:self.select];
        [self.select setImage:[UIImage imageNamed:@"btn_circle_default"]];
        
        
    }
    return self;
}

- (void)setIcon:(UIImage *)icon{
    
    [self.image setImage:icon];
}

- (void)selected{
    
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(imageSelected:)]){
        [self.delegate imageSelected:self.indexPath];
    }
}

- (void)setSelectStatu:(BOOL)selectStatu{
    if(selectStatu){
        [self.select setImage:[UIImage imageNamed:@"btn_circle_selected"]];
    }else{
        [self.select setImage:[UIImage imageNamed:@"btn_circle_default"]];
    }
}

@end
