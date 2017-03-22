//
//  ResetEnterView.h
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSInteger, EnterStyle) {
    
    GeneralEnter,
    SendEnter,
    
};

@interface ResetEnterView : BaseView

@property (assign, nonatomic) EnterStyle style;
@property (assign, nonatomic) NSString * iconName;
@property (strong, nonatomic) NSString * text;
@property (strong, nonatomic) UITextField * enter;
@property (strong, nonatomic) UIButton * send;
@end
