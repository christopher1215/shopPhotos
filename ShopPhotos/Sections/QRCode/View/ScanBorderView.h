//
//  ScanBorderView.h
//  platform
//
//  Created by addcn on 16/11/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSInteger, BorderType) {
    
    BorderTopLeft,
    BorderTopRight,
    BorderLowerRight,
    BorderLowerLeft,
    
};

@interface ScanBorderView : BaseView

- (instancetype)initWithType:(BorderType)type;

@end
