//
//  AlbumPhotosModel.h
//  ShopPhotos
//
//  Created by  on 4/24/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#ifndef AlbumPhotosModel_h
#define AlbumPhotosModel_h

#import "BaseModel.h"

@interface AlbumPhotosModel : BaseModel

@property (strong, nonatomic) NSString * title;
@property (assign, nonatomic) BOOL recommend;
@property (assign, nonatomic) BOOL collected;
@property (strong, nonatomic) NSString * dateDiff;
@property (strong, nonatomic) NSString * cover;
@property (strong, nonatomic) NSString * video;
@property (strong, nonatomic) NSString * desc;
@property (strong, nonatomic) NSString * Id;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * createdAt;
@property (strong, nonatomic) NSArray * images;
@property (strong, nonatomic) NSDictionary * classify;
@property (strong, nonatomic) NSDictionary * subclass;
@property (strong, nonatomic) NSDictionary * user;

@property (assign, nonatomic) BOOL openEdit;
@property (assign, nonatomic) BOOL isExpend;
@property (assign, nonatomic) BOOL selected;

@property (assign, nonatomic) NSInteger imageRows;

@property (assign, nonatomic) NSInteger textLines;
@property (assign, nonatomic) NSInteger extraHeight;

@end


#endif /* AlbumPhotosModel_h */
