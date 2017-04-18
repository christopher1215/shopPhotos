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


- (CGFloat)setStyle:(NSArray *)imageArray mode:(BOOL) isEditMode{
    for(UIView * subView in self.subviews){
        [subView removeFromSuperview];
    }
    [self setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat width = (WindowWidth - (Clearance*2))/3;
    NSInteger index = 0;
    for(int i = 0; i<3; i++){
        for(int j = 0; j<3; j++){
            if (isEditMode == YES) {
                if(index >= (imageArray.count +1)) break;
                UIView * content = [[UIView alloc] init];
                [content setBackgroundColor:[UIColor whiteColor]];
                [self addSubview:content];
                
                content.sd_layout
                .leftSpaceToView(self,j*width)
                .topSpaceToView(self,i*width)
                .widthIs(width)
                .heightIs(width);
                
                PhotoImagesModel * imageModel = nil;
                PhotoDetailsHeadImage * image = [[PhotoDetailsHeadImage alloc] init];
                [content addSubview:image];
                if(imageArray && index < imageArray.count) {
                    imageModel = [imageArray objectAtIndex:index];
                    [image.image sd_setImageWithURL:[NSURL URLWithString:imageModel.thumbnails]];
                    [image setBackgroundColor:ColorHex(0xEEEEEE)];
                    image.sd_layout
                    .leftSpaceToView(content,2.5)
                    .topSpaceToView(content,2.5)
                    .widthIs(width-5)
                    .heightIs(width-5);
                    image.layer.cornerRadius = 5.0f;
                    image.layer.masksToBounds = TRUE;
                }
                else {
                    [image.image setImage:[UIImage imageNamed:@"ico_add"]];
                    image.sd_layout
                    .centerXEqualToView(content)
                    .centerYEqualToView(content)
                    .widthIs(20)
                    .heightIs(20);
                    content.layer.borderColor = ColorHex(0xEEEEEE).CGColor;
                    content.layer.borderWidth = 1.0;
                    content.layer.cornerRadius = 5.0f;
                    content.layer.masksToBounds = YES;
                }
                
                image.tag = index;
                if(imageArray && index < imageArray.count) {
                    [image setImageCover:imageModel.isCover];
                    [image setEditStyle:imageModel.edit];
                    [image.deleteBtn addTarget:self action:@selector(deleteSelected:) forControlEvents:UIControlEventTouchUpInside];
                    [image.settingBtn addTarget:self action:@selector(settingSelected:) forControlEvents:UIControlEventTouchUpInside];
                }
                [image.image addTarget:self action:@selector(imageSelected:)];
                
                index++;
            }
            else{
                if(index >= imageArray.count) break;
                UIView * content = [[UIView alloc] init];
                [content setBackgroundColor:[UIColor whiteColor]];
                [self addSubview:content];
                
                content.sd_layout
                .leftSpaceToView(self,j*width)
                .topSpaceToView(self,i*width)
                .widthIs(width)
                .heightIs(width);
                
                PhotoImagesModel * imageModel = nil;
                PhotoDetailsHeadImage * image = [[PhotoDetailsHeadImage alloc] init];
                [content addSubview:image];
                imageModel = [imageArray objectAtIndex:index];
                [image.image sd_setImageWithURL:[NSURL URLWithString:imageModel.thumbnails]];
                [image setBackgroundColor:ColorHex(0xEEEEEE)];
                image.sd_layout
                .leftSpaceToView(content,2.5)
                .topSpaceToView(content,2.5)
                .widthIs(width-5)
                .heightIs(width-5);
                image.layer.cornerRadius = 5.0f;
                image.layer.masksToBounds = TRUE;
                
                image.tag = index;
                [image setImageCover:imageModel.isCover];
                [image setEditStyle:imageModel.edit];
                [image.deleteBtn addTarget:self action:@selector(deleteSelected:) forControlEvents:UIControlEventTouchUpInside];
                [image.settingBtn addTarget:self action:@selector(settingSelected:) forControlEvents:UIControlEventTouchUpInside];
                [image.image addTarget:self action:@selector(imageSelected:)];
               
                index++;
            }
        }
    }
    
    CGFloat height  = imageArray.count/3*width;
    if(imageArray.count % 3 >0){
        height+=width;
    }
    
    if (isEditMode == YES && imageArray.count < 9) {
        height  = (imageArray.count+1)/3*width;
        
        if ((imageArray.count+1)%3 > 0 && (imageArray.count+1) < 10) {
            height+=width;
        }
    }
    

    NSLog(@"head height --- > %f",height);
    return height;
}

- (void)imageSelected:(UITapGestureRecognizer *)tap {
    NSLog(@"%ld",tap.view.superview.tag);
    if(self.delegate && [self.delegate respondsToSelector:@selector(photoDetailsHeadSelectType:select:)]){
        UIImageView *imgView = (UIImageView *)tap.view;
        if([UIImagePNGRepresentation(imgView.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"ico_add"])]){
            [self.delegate photoDetailsHeadAddImage:imgView select:tap.view.superview.tag];
        }
        else {
            [self.delegate photoDetailsHeadSelectType:1 select:tap.view.superview.tag];
        }
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
