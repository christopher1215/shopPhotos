//
//  ChatLoginRequset.h
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/7.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface ChatLoginRequset : BaseModel

@property (strong, nonatomic) NSString * authToken;
@property (strong, nonatomic) NSString * imToken;

@end
