//
//  UserUpdateViewController.h
//  ShopPhotos
//
//  Created by Macbook on 12/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "BaseViewCtr.h"
#import "UserCtr.h"

@interface UserUpdateViewController : BaseViewCtr
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtValue;
@property (assign, nonatomic) short type;
@property (weak, nonatomic) IBOutlet UIView *back;
@property (strong, nonatomic) UserCtr *parentVC;
@property (strong, nonatomic) NSString *value;

@end
