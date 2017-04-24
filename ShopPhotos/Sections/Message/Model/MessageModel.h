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
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * date;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * state;
@property (assign, nonatomic) NSInteger itemID;
//@property (assign, nonatomic) BOOL code;
@property (assign, nonatomic) BOOL edit;
@property (assign, nonatomic) BOOL editSelect;
@property (assign, nonatomic) BOOL reply;
@property (assign, nonatomic) BOOL allow;
@end
