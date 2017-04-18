//
//  MoreAlert.h
//  ShopPhotos
//
//  Created by addcn on 16/12/24.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSInteger,AlertModeType) {
    
    OptionModel = 1,
    PhotosModel,
    PhotosClassModel,
    SortOrder
};

@protocol MoreAlertDelegate <NSObject>

- (void)moreAlertSelected:(NSInteger)indexPath;

@end

@interface MoreAlert : BaseView

@property (assign, nonatomic) AlertModeType mode;
@property (weak, nonatomic) id<MoreAlertDelegate>delegate;

- (void)showAlert;
- (void)closeAlert;

@end
