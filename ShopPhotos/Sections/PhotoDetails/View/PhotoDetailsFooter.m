//
//  PhotoDetailsFooter.m
//  ShopPhotos
//
//  Created by addcn on 16/12/31.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PhotoDetailsFooter.h"
#import "PhotoImagesModel.h"
#import <UIImageView+WebCache.h>

@interface PhotoDetailsFooter ()

@property (strong, nonatomic) UIView * line;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UILabel * date;
@property (strong, nonatomic) UIView * images;
@property (strong, nonatomic) UILabel * footTitle;

@end

@implementation PhotoDetailsFooter

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createAutoLayout];
        
    }
    return self;
}


- (void)createAutoLayout{
    
    self.line = [[UILabel alloc] init];
    [self.line setBackgroundColor:ColorHex(0XEEEEEE)];
    [self addSubview:self.line];
    self.line.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .heightIs(15);
    
    self.title = [[UILabel alloc] init];
    [self.title setText:@"图片详情"];
    [self.title setFont:Font(14)];
    [self addSubview:self.title];
    
    self.title.sd_layout
    .leftSpaceToView(self,10)
    .topSpaceToView(self,15)
    .widthIs(100)
    .heightIs(40);
    
    self.date = [[UILabel alloc] init];
    [self.date setFont:Font(11)];
    [self.date setTextAlignment:NSTextAlignmentRight];
    [self.date setText:@"1992-11-08 24:11:56"];
    [self.date setTextColor:ColorHex(0X888888)];
    [self addSubview:self.date];
    self.date.sd_layout
    .rightSpaceToView(self,10)
    .topSpaceToView(self,15)
    .widthIs(200)
    .heightIs(40);
    
    self.images = [[UIView alloc] init];
    [self addSubview:self.images];
    self.images.sd_layout
    .leftSpaceToView(self,10)
    .rightSpaceToView(self,10)
    .topSpaceToView(self,55)
    .heightIs(WindowWidth-20);
    
    self.footTitle = [[UILabel alloc] init];
    [self.footTitle setText:@"已经到底部了"];
    [self.footTitle setFont:Font(12)];
    [self.footTitle setTextColor:ColorHex(0X888888)];
    [self.footTitle setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.footTitle];
    
    self.footTitle.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self.images,-10)
    .heightIs(30);
}

- (CGFloat)setStyle:(NSArray *)imageArray{
    
    for(UIView * subView in self.images.subviews){
        [subView removeFromSuperview];
    }
    
    CGFloat height = WindowWidth-40;
    for(NSInteger index = 0; index < imageArray.count; index++){
        
        PhotoImagesModel * imageModel = [imageArray objectAtIndex:index];
        
        UIView * imageView = [[UIView alloc] init];
        [self.images addSubview:imageView];
        
        imageView.sd_layout
        .leftSpaceToView(self.images,0)
        .rightSpaceToView(self.images,0)
        .topSpaceToView(self.images,(height+20)*index)
        .heightIs(height);
        
        UIImageView * image = [[UIImageView alloc] init];
        [image setBackgroundColor:ColorHex(0XEEEEEE)];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [image sd_setImageWithURL:[NSURL URLWithString:imageModel.source]];
        image.tag = index;
        [image addTarget:self action:@selector(imageSelected:)];
        [imageView addSubview:image];
        image.sd_layout
        .leftEqualToView(imageView)
        .topEqualToView(imageView)
        .rightEqualToView(imageView)
        .bottomEqualToView(imageView);
        
        if(imageModel.isCover){
            UIImageView * cover = [[UIImageView alloc] init];
            [cover setBackgroundColor:[UIColor clearColor]];
            [cover setImage:[UIImage imageNamed:@"cover"]];
            [imageView addSubview:cover];
            cover.sd_layout
            .leftEqualToView(imageView)
            .topEqualToView(imageView)
            .widthIs(60)
            .heightIs(60);
        }
    }
    
    self.images.sd_layout.heightIs(imageArray.count * (WindowWidth-20));
    [self.images updateLayout];
    
    
    return self.images.height+self.images.top + 30;
}

- (void)setDateTitle:(NSString *)date{
    [self.date setText:date];
}


- (void)imageSelected:(UITapGestureRecognizer *)tap{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(footerImageSelcted:)]){
        [self.delegate footerImageSelcted:tap.view.tag];
    }
}
@end
