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

- (void)setClassifies:(NSString *)parent subClass:(NSString *)subclass;

@end


#endif /* PublishPhotoCtr_h */
