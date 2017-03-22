//
//  AlbumPhotosMdel.h
//  ShopPhotos
//
//  Created by addcn on 16/12/24.
//  Copyright © 2016年 addcn. All rights reserved.
//



#import "BaseModel.h"

@interface AlbumPhotosMdel : BaseModel

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * big;
@property (strong, nonatomic) NSString * cover;
@property (strong, nonatomic) NSString * date;
@property (strong, nonatomic) NSString * photosID;
@property (strong, nonatomic) NSString * price;
@property (assign, nonatomic) BOOL showPrice;
@property (strong, nonatomic) NSString * source;
@property (strong, nonatomic) NSDictionary * user;
@property (assign, nonatomic) BOOL isCollected;
@property (assign, nonatomic) BOOL recommend;
@property (assign, nonatomic) BOOL openEdit;
@property (assign, nonatomic) BOOL selected;
@end
