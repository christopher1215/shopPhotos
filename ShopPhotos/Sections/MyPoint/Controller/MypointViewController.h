//
//  MypointViewController.h
//  ShopPhotos
//
//  Created by Macbook on 08/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseViewCtr.h"
@interface MypointViewController : BaseViewCtr
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentPoint;
@property (assign, nonatomic) int currentPoint;
@property (weak, nonatomic) IBOutlet UITableView *tblHistory;

@end
