//
//  ShareCtr2.h
//  ShopPhotos
//
//  Created by PPP on 5/10/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseViewCtr.h"

@protocol Share2Delegate <NSObject>

- (void)share2Selected:(NSInteger)type;

@end

@interface ShareCtr2 : BaseViewCtr

@property (weak, nonatomic) id<Share2Delegate>delegate;

- (void)showAlert;
- (void)closeAlert;

@end
