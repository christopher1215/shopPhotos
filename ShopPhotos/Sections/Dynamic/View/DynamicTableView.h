//
//  DynamicTableView.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/25.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"
#import "DynamicModel.h"

@protocol DynamicTableViewDelegate <NSObject>

- (void)cellSelectType:(NSInteger)type tableViewCelelIndexPath:(NSIndexPath *)indexPath;

- (void)cellImageSelected:(NSInteger)tag TabelViewCellIndexPath:(NSIndexPath *)indexPath;

- (void)dynamicTableCellSelected:(NSIndexPath *)indexPath;
@end

@interface DynamicTableView : BaseView
@property (weak, nonatomic) id<DynamicTableViewDelegate>delegate;
@property (strong, nonatomic) UITableView * table;

- (void)loadData:(NSArray *)dataArray;
- (void)loadMoreData:(NSArray *)dataArray;
@end
