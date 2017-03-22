//
//  AlbumClassTable.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol AlbumClassTableDelegate <NSObject>

- (void)albumClassTableSelected:(NSIndexPath *)indexPath;
- (void)albmClassTableHeadSelectType:(NSInteger)type slectedPath:(NSInteger)section;
- (void)albumClassTableSelectType:(NSInteger)type selectPath:(NSIndexPath *)indexPath;
@end

@interface AlbumClassTable : BaseView
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) UITableView * table;
@property (strong, nonatomic) id<AlbumClassTableDelegate>albumDelegage;
@property (strong, nonatomic) NSMutableArray * dataArray;
@end
