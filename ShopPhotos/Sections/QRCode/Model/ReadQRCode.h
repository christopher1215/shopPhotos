//
//  ReadQRCode.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/27.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ReadQRCode : NSObject

+ (NSString *)readQRCodeFromImage:(UIImage *)image;

+ (UIImage *)creatCIQRCodeContent:(NSString *)content ImageSize:(CGFloat)width;

@end
