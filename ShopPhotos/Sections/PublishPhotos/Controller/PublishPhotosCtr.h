//
//  PublishPhotosCtr.h
//  ShopPhotos
//
//  Created by addcn on 17/1/2.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseViewCtr.h"

@interface PublishPhotosCtr : BaseViewCtr

@property (strong, nonatomic) NSString * uid;

@property (assign, nonatomic) BOOL is_copy;

@property (strong, nonatomic) NSMutableArray * imageCopy;
@property (strong, nonatomic) NSString * photoTitleText;

@end
