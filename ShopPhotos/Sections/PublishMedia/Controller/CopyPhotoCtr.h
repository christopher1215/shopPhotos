//
//  CopyPhotoCtr.h
//  ShopPhotos
//
//  Created by PKJ on 5/10/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseViewCtr.h"

@interface CopyPhotoCtr : BaseViewCtr

- (void)setClassifies:(NSString *)parent subClass:(NSString *)subclass;
@property (strong, nonatomic) NSString* srcPhotoId;
@property (assign, nonatomic) BOOL copySuccess;

@end
