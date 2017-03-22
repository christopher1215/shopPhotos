//
//  MessageEditOption.h
//  ShopPhotos
//
//  Created by addcn on 16/12/28.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol MessageEditOptionDelegate <NSObject>

- (void)messageEditOptionSelected:(NSInteger)type;


@end

@interface MessageEditOption : BaseView

@property (assign, nonatomic) BOOL allSelect;

- (void)setDeleteCount:(NSInteger)count;
@property (weak, nonatomic) id<MessageEditOptionDelegate>delegate;

@end
