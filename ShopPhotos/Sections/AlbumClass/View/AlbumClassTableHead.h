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
- (void)albmClassTableHeadSelectCheck:(BOOL)type slectedPath:(NSInteger)indexPath;

@end

@interface AlbumClassTableHead : BaseView
@property (weak, nonatomic) id<AlbumClassTableHeadDelegate>delegate;
@property (assign, nonatomic) NSInteger indexPath;
@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UIImageView * folder;
@property (strong, nonatomic) UIImageView * checkBox;
@property (strong, nonatomic) UILabel * title;
@property (readwrite, nonatomic) BOOL isChecked;

- (void)creteAutoLayout:(BOOL) isCheckBox selected:(BOOL) isChecked;

- (void)openOption;
- (void)closeOption;

- (void)check;
- (void)unCheck;

@end
