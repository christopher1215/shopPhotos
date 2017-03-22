//
//  STPhotosModel.h
//  PhotosDemo
//
//  Created by 廖检成 on 17/1/10.
//  Copyright © 2017年 Stanley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface STPhotosModel : NSObject

@property (strong, nonatomic) PHAsset * asset;
@property (assign, nonatomic) BOOL select;

@end
