//
//  AlbumClassTableHead.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//


#import "BaseView.h"

@protocol AlbumClassTableHeadDelegate <NSObject>

- (void)albmClassTableHeadSelectType:(NSInteger)type slectedPath:(NSInteger)indexPath;

@end

@interface AlbumClassTableHead : BaseView
@property (weak, nonatomic) id<AlbumClassTableHeadDelegate>delegate;
@property (assign, nonatomic) NSInteger indexPath;
@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UIView * change;
@property (strong, nonatomic) UIView * deleteBtn;

- (void)openOption;
- (void)closeOption;

@end
