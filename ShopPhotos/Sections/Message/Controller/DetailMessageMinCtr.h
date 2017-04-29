//
//  DetailMessageMinCtr.h
//  ShopPhotos
//
//  Created by Macbook on 24/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseViewCtr.h"

@interface DetailMessageMinCtr : BaseViewCtr
@property (strong, nonatomic) NSString *atitle;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *type;
@property (assign, nonatomic) BOOL reply;
@property (assign, nonatomic) BOOL allow;
@property (assign, nonatomic) int noticeId;

@end
