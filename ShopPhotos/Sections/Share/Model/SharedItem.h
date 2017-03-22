//
//  SharedItem.h
//  ShopPhotos
//
//  Created by addcn on 17/1/3.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharedItem : NSObject<UIActivityItemSource>
-(instancetype)initWithData:(UIImage*)img andFile:(NSURL*)file;

@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSURL *path;
@end
