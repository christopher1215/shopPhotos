//
//  PublishPhotoCtr.h
//  ShopPhotos
//
//  Created by Park Jin Hyok on 4/13/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#ifndef PublishPhotoCtr_h
#define PublishPhotoCtr_h

#import "BaseViewCtr.h"

@interface PublishPhotoCtr : BaseViewCtr

@property (strong, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) UITextView * photoTitle;
@property (strong, nonatomic) UITextView * remarksContent;
@property (assign, nonatomic) BOOL isAdd;
@property (strong, nonatomic) NSString * photoId;

- (void)setClassifies:(NSString *)parent subClass:(NSString *)subclass;

@end


#endif /* PublishPhotoCtr_h */
