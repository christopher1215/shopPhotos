//
//  AlbumClassTableSubModel.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface AlbumClassTableSubModel : BaseModel

@property (assign, nonatomic) NSInteger  classID;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * cover;
@property (assign, nonatomic) NSInteger  subClassID;
@property (assign, nonatomic) BOOL edit;
@property (assign, nonatomic) BOOL severData;
@end
