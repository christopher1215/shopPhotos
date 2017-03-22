//
//  FZJBigPhotoController.h
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/13.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void (^returnBackPhotoArr)(id data);


@interface FZJBigPhotoController : UIViewController
/**
 *  数据源
 */
@property (nonatomic,strong)NSArray * fetchResult;
@property (assign, nonatomic) NSInteger select;
@end
