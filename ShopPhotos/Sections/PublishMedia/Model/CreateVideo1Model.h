//
//  CreateVideo1Model.h
//  ShopPhotos
//
//  Created by Park Jin Hyok on 4/28/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#ifndef CreateVideo1Model_h
#define CreateVideo1Model_h

#import "BaseModel.h"

@interface CreateVideo1Model : BaseModel

@property (strong, nonatomic) NSString * qiniuToken;
@property (strong, nonatomic) NSString * cover;
@property (strong, nonatomic) NSString * video;

@end

#endif /* CreateVideo1Model_h */
