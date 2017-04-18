//
//  LoginLoadModel.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface LoginLoadModel : BaseModel

@property (strong, nonatomic) NSString * authToken;
@property (strong, nonatomic) NSString * imToken;
@end
