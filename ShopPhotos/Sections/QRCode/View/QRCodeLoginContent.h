//
//  QRCodeLoginContent.h
//  platform
//
//  Created by addcn on 16/11/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol QRCodeLoginContentDelegate;

@interface QRCodeLoginContent : BaseView

- (instancetype)initWithData:(NSDictionary *)data;
@property (weak, nonatomic) id<QRCodeLoginContentDelegate>delegate;

@end

@protocol QRCodeLoginContentDelegate <NSObject>

- (void)sureLoginSelect;
- (void)cancelLoginSelect;

@end
