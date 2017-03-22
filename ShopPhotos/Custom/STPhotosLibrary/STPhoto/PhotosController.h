//
//  PhotosController.h
//  PhotosDemo
//
//  Created by 廖检成 on 17/1/10.
//  Copyright © 2017年 Stanley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "STPhotosModel.h"

@protocol PhotosControllerDelegate  <NSObject>

- (void)photosSelecteImages:(NSArray *)images;

@end
@interface PhotosController : UIViewController
@property (assign, nonatomic) id<PhotosControllerDelegate>delegate;
@property (strong, nonatomic) NSMutableArray  * dataArray;
@property (assign, nonatomic) NSInteger maxIndex;

@end
