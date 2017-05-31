//
//  ClassByCoverCtr.h
//  ShopPhotos
//
//  Created by Macbook on 15/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseViewCtr.h"
#import "AlbumClassTableModel.h"

@interface ClassByCoverCtr : BaseViewCtr
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) AlbumClassTableModel * parentModel;

@end
