//
//  DynamicModel.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface DynamicModel : BaseModel

@property (strong, nonatomic) NSString * photosID;
@property (strong, nonatomic) NSString * date;
@property (strong, nonatomic) NSString * descriptionText;
@property (assign, nonatomic) NSInteger isCollected;
@property (strong, nonatomic) NSString * price;
@property (assign, nonatomic) BOOL showPrice;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSMutableArray * images;
@property (strong, nonatomic) NSMutableDictionary * user;

@end
