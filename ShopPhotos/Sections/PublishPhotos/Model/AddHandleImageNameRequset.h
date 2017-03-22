//
//  AddHandleImageNameRequset.h
//  ShopPhotos
//
//  Created by addcn on 17/1/2.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface AddHandleImageNameRequset : BaseModel

@property (strong, nonatomic) NSMutableArray * images;
@property (strong, nonatomic) NSString * uploadToken;
@end
