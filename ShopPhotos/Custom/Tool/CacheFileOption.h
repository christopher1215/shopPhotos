//
//  CacheFileOption.h
//  ShopPhotos
//
//  Created by addcn on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheFileOption : NSObject

- (float)getCacheSize;

- (void)clearCacheAtPath;

@end
