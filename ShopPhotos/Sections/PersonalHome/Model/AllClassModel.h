//
//  AllClassModel.h
//  ShopPhotos
//
//  Created by Park Jin Hyok on 5/4/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#ifndef AllClassModel_h
#define AllClassModel_h


#import "BaseModel.h"

@interface AllClassModel : BaseModel

@property (assign, nonatomic) NSInteger  Id;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSMutableArray * subclasses;
@property (assign, nonatomic) BOOL  isOpen;

@end


#endif /* AllClassModel_h */
