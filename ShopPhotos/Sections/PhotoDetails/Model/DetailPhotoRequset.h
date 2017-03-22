//
//  DetailPhotoRequset.h
//  ShopPhotos
//
//  Created by addcn on 16/12/31.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface DetailPhotoRequset : BaseModel

@property (strong, nonatomic) NSString * cover;
@property (strong, nonatomic) NSString * big;
@property (strong, nonatomic) NSString * photoId;
@property (strong, nonatomic) NSString * name;
@property (assign, nonatomic) BOOL isCollected;
@property (strong, nonatomic) NSString * date;
@property (strong, nonatomic) NSMutableArray * images;
@property (strong, nonatomic) NSString * price;
@property (strong, nonatomic) NSString * recommend;
@property (strong, nonatomic) NSString * source;
@property (strong, nonatomic) NSString * userID;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * subclassID;
@property (strong, nonatomic) NSString * subclassName;
@property (strong, nonatomic) NSString * classifyID;
@property (strong, nonatomic) NSString * classifyName;
@property (assign, nonatomic) BOOL showPrice;


@end
