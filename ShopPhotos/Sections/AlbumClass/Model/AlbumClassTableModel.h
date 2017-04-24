//
//  AlbumClassTableModel.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface AlbumClassTableModel : BaseModel

@property (assign, nonatomic) NSInteger  Id;
@property (assign, nonatomic) NSInteger  subclassCount;
@property (strong, nonatomic) NSString * name;
@property (assign, nonatomic) BOOL open;
@property (assign, nonatomic) BOOL edit;
@property (assign, nonatomic) BOOL delChecked;
@property (strong, nonatomic) NSMutableArray * dataArray;

@end
