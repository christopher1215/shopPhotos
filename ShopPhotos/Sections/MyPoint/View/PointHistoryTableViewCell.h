//
//  PointHistoryTableViewCell.h
//  ShopPhotos
//
//  Created by Macbook on 08/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblKind;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *blDate;
@property (weak, nonatomic) IBOutlet UILabel *lblBalance;

@end
