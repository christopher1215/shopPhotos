//
//  FeedbackOptionAlert.h
//  ShopPhotos
//
//  Created by addcn on 16/12/23.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol FeedbackOptionAlertDelegate <NSObject>

- (void)feedbackOption:(NSString * )titiel selectedType:(NSInteger)type;

@end

@interface FeedbackOptionAlert : BaseView

@property (weak, nonatomic) id<FeedbackOptionAlertDelegate>delegate;

- (void)showAlert;
- (void)closeAlert;

@end
