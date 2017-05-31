//
//  DetailMessageCtr.h
//  ShopPhotos
//
//  Created by  on 4/6/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#ifndef DetailMessageCtr_h
#define DetailMessageCtr_h


#import "BaseViewCtr.h"

@interface DetailMessageCtr : BaseViewCtr
@property (strong, nonatomic) NSString *atitle;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *type;


@end


#endif /* DetailMessageCtr_h */
