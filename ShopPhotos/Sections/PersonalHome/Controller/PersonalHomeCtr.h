//
//  PersonalHomeCtr.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/25.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseViewCtr.h"
#import "AlbumClassTableModel.h"

@interface PersonalHomeCtr : BaseViewCtr

@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) NSString * username;
@property (assign, nonatomic) BOOL twoWay;
@property (assign, nonatomic) BOOL caan;
@property (readwrite, nonatomic) BOOL isSubClass;
@property (strong, nonatomic) AlbumClassTableModel * parentModel;

@end
