//
//  AlbumClassTableHead.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseView.h"

@protocol PersonalClassTableHeadDelegate <NSObject>

- (void)personalClassTableHeadSelectType:(NSInteger)type selectedPath:(NSInteger)indexPath;

@end

@interface PersonalClassTableHead : BaseView

@property (weak, nonatomic) id<PersonalClassTableHeadDelegate> delegate;
@property (assign, nonatomic) NSInteger indexPath;
@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UILabel * subclassCount;

- (void)openOption;
- (void)closeOption;

@end
