//
//  AttentionTableView.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/19.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"
#import "AttentionModel.h"

@protocol AttentionTableViewDelegate  <NSObject>

- (void)attentionTableSelect:(NSString *)uid WithTwoWay:(BOOL)twoWay;
- (void)attentionSelected:(AttentionModel *)model;

@end

@interface AttentionTableView : BaseView
@property (assign, nonatomic) BOOL attentionStatu;
@property (weak, nonatomic) id<AttentionTableViewDelegate>delegate;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) UITableView * table;
@property (strong, nonatomic) UITextField * search;
@end
