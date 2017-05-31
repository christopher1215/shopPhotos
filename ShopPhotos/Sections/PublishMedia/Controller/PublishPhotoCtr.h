//
//  PublishPhotoCtr.h
//  ShopPhotos
//
//  Created by  on 4/13/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#ifndef PublishPhotoCtr_h
#define PublishPhotoCtr_h

#import "BaseViewCtr.h"

@interface PublishPhotoCtr : BaseViewCtr

@property (assign, nonatomic) BOOL isAdd;
@property (assign, nonatomic) BOOL isCopy;
//@property (strong, nonatomic) NSString * headTitle;
//@property (strong, nonatomic) NSString * strPhotoTitle;
//@property (strong, nonatomic) NSString * strRemarksContent;
//@property (strong, nonatomic) NSString * parentClass;
//@property (strong, nonatomic) NSString * subClass;

@property (strong, nonatomic) NSDictionary * editData;

- (void)setClassifies:(NSString *)parent subClass:(NSString *)subclass;

@end


#endif /* PublishPhotoCtr_h */
