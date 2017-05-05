//
//  AlbumClassTable.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol PersonalClassTableDelegate <NSObject>
//- (void)personalClassTableSelected:(NSIndexPath *)indexPath;
- (void)personalClassTableHeadSelectType:(NSInteger)type selectedPath:(NSInteger)section;
//- (void)personalClassTableSelectType:(NSInteger)type selectPath:(NSIndexPath *)indexPath;
@end

@interface PersonalClassTable : BaseView
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) UITableView * table;
@property (strong, nonatomic) id<PersonalClassTableDelegate>delegate;
@property (strong, nonatomic) NSMutableArray * dataArray;

@end
