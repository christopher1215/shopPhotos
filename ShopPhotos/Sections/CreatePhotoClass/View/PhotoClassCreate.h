//
//  PhotoClassCreate.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol PhotoClassCreateDelegate <NSObject>

- (void)photoSelectedClass;

@end

@interface PhotoClassCreate : BaseView

@property (weak, nonatomic) id<PhotoClassCreateDelegate>delegate;
- (void)setSelectedTitle:(NSString *)title;
- (void)setStyleView:(BOOL)style;
- (NSDictionary *)getClassifiesName;

@end
