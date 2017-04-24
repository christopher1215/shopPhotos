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
- (void)albumClassTableSelectType:(NSInteger)type selectPath:(NSIndexPath *)indexPath;
- (void)albumClassTableHeadSelected:(NSInteger )index;
//- (void)albumClassTableHeadSelectType:(NSInteger)type selectedPath:(NSInteger)section;
- (void)albumClassTableHeadSelectCheck:(BOOL)isChecked selectedPath:(NSInteger)index;
@end

@interface AlbumClassTable : BaseView

@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) UITableView * table;
@property (strong, nonatomic) id<AlbumClassTableDelegate>albumDelegage;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (readwrite, nonatomic) BOOL isEditMode;
@property (readwrite, nonatomic) BOOL isSubClass;
@property (readwrite, nonatomic) BOOL isAllSelect;

@end
