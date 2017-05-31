//
//  ClassByCoverTableView.h
//  ShopPhotos
//
//  Created by Macbook on 15/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseView.h"
@protocol ClassByCoverTableViewDelegate  <NSObject>

- (void)albumPhotoSelectPath:(NSInteger)indexPath;

@end

@interface ClassByCoverTableView : BaseView
@property (weak, nonatomic) id<ClassByCoverTableViewDelegate>delegate;
@property (strong, nonatomic)UICollectionView * classes;
@property (strong, nonatomic) NSMutableArray * dataArray;

@end
