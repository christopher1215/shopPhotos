//
//  ShareCtr.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseViewCtr.h"

@protocol ShareDelegate <NSObject>

- (void)shareSelected:(NSInteger)type;

@end

@interface ShareCtr : BaseViewCtr

@property (weak, nonatomic) id<ShareDelegate>delegate;

- (void)showAlert;
- (void)closeAlert;

@end
