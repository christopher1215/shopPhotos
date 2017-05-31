//
//  ClassByCoverTableViewCell.h
//  ShopPhotos
//
//  Created by Macbook on 15/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumClassTableModel.h"

#define ClassByCoverCellID @"ClassByCoverCellID"

@interface ClassByCoverTableViewCell : UICollectionViewCell
@property (strong, nonatomic) AlbumClassTableModel * model;
@property (strong, nonatomic) NSIndexPath * indexPath;

@end
