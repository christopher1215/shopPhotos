//
//  ChattingViewController.h
//  ShopPhotos
//
//  Created by Macbook on 26/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseViewCtr.h"
#import <RongIMKit/RongIMKit.h>

@interface ChattingViewController : BaseViewCtr
@property (assign, nonatomic) RCConversationType conversationType;
@property (strong, nonatomic) NSString * targetId;
@property (strong, nonatomic) NSString * name;
@property (assign, nonatomic) BOOL twoWay;

@end
