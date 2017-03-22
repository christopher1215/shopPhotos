//
//  PhotoDetailsFooter.h
//  ShopPhotos
//
//  Created by addcn on 16/12/31.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol PhotoDetailsFooterDelegate <NSObject>

- (void)footerImageSelcted:(NSInteger)indexPath;

@end

@interface PhotoDetailsFooter : BaseView

@property (weak, nonatomic) id<PhotoDetailsFooterDelegate>delegate;
- (CGFloat)setStyle:(NSArray *)imageArray;
- (void)setDateTitle:(NSString *)date;
@end
