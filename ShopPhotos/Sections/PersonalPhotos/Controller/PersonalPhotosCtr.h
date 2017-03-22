//
//  PersonalPhotosCtr.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/25.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseViewCtr.h"

@interface PersonalPhotosCtr : BaseViewCtr

@property (strong, nonatomic) NSString * pageTitleText;
@property (strong, nonatomic) NSString * uid;
@property (assign, nonatomic) NSInteger initialType;
@property (assign, nonatomic) BOOL twoWay;
@end
