//
//  MessageModel.h
//  ShopPhotos
//
//  Created by addcn on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel

@property (strong, nonatomic) NSString * avatar;
@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * date;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * type;
@property (assign, nonatomic) NSInteger itmeID;
@property (assign, nonatomic) BOOL code;
@property (assign, nonatomic) BOOL edit;
@property (assign, nonatomic) BOOL editSelect;
@end
