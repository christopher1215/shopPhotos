//
//  PhotoDetailsHead.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/25.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PhotoDetailsHead.h"
#import "PhotoDetailsHeadImage.h"
#import "PhotoImagesModel.h"
#import <UIImageView+WebCache.h>

@interface PhotoDetailsHead ()

@property (strong, nonatomic) NSMutableArray * imageArray;

@end

@implementation PhotoDetailsHead


- (CGFloat)setStyle:(NSArray *)imageArray{
    for(UIView * subView in self.subviews){
        [subView removeFromSuperview];
    }
    [self setBackgroundColor:[UIColor whiteColor]];
    if(!imageArray || imageArray.count == 0) return 0;
    
    CGFloat width = (WindowWidth - (Clearance*2))/3;
    NSInteger index = 0;
    for(int i = 0; i<3; i++){
        for(int j = 0; j<3; j++){
            if(index >= imageArray.count) break;
            
            PhotoImagesModel * imageModel = [imageArray objectAtIndex:index];
            
            UIView * content = [[UIView alloc] init];
            [content setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:content];
            
            
            content.sd_layout
            .leftSpaceToView(self,j*width)
            .topSpaceToView(self,i*width)
            .widthIs(width)
            .heightIs(width);
            
            PhotoDetailsHeadImage * image = [[PhotoDetailsHeadImage alloc] init];
            image.tag = index;
            [image setBackgroundColor:ColorHex(0Xeeeeee)];
            [image.image sd_setImageWithURL:[NSURL URLWithString:imageModel.thumbnails]];
            [content addSubview:image];
            
            image.sd_layout
            .leftSpaceToView(content,2.5)
            .topSpaceToView(content,2.5)
            .widthIs(width-5)
            .heightIs(width-5);
            
            [image setImageCover:imageModel.isCover];
            [image setEditStyle:imageModel.edit];
            
            [image.image addTarget:self action:@selector(imageSelected:)];
            [image.deleteBtn addTarget:self action:@selector(deleteSelected:) forControlEvents:UIControlEventTouchUpInside];
            [image.settingBtn addTarget:self action:@selector(settingSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            index++;
        }
    }
    
    CGFloat height  = imageArray.count/3*width;
    if(imageArray.count % 3 >0){
        height+=width;
    }
    NSLog(@"head height --- > %f",height);
    return height;
}

- (void)imageSelected:(UITapGestureRecognizer *)tap{
    NSLog(@"%ld",tap.view.superview.tag);
    if(self.delegate && [self.delegate respondsToSelector:@selector(photoDetailsHeadSelectType:select:)]){
        [self.delegate photoDetailsHeadSelectType:1 select:tap.view.superview.tag];
    }
}

- (void)deleteSelected:(UIButton *)button{
    NSLog(@"%ld",button.superview.superview.tag);
    if(self.delegate && [self.delegate respondsToSelector:@selector(photoDetailsHeadSelectType:select:)]){
        [self.delegate photoDetailsHeadSelectType:2 select:button.superview.superview.tag];
    }
}

- (void)settingSelected:(UIButton *)button{
    NSLog(@"%ld",button.superview.superview.tag);
    [self.delegate photoDetailsHeadSelectType:3 select:button.superview.superview.tag];
}


@end
