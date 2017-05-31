//
//  AlbumClassCtr.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseViewCtr.h"
#import "AlbumClassTableModel.h"
#import "AlbumClassTableSubModel.h"
//#import "PublishPhotoCtr.h"

@interface AlbumClassCtr : BaseViewCtr

@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) AlbumClassTableModel * parentModel;
@property (readwrite, nonatomic) BOOL isSubClass;
@property (readwrite, nonatomic) BOOL isFromUploadPhoto;
@property (readwrite, nonatomic) BOOL isFromCopyPhoto;
@property (strong, nonatomic) BaseViewCtr * fromCtr;

@end
