//
//  TabBarModel.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/19.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface TabBarModel : BaseModel

@property (strong, nonatomic) NSString * selectedImage;
@property (strong, nonatomic) NSString * defaultImage;
@property (strong, nonatomic) NSString * text;

@end
