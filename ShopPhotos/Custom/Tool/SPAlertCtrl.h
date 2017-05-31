//
//  UIAlertController_SPAlertCtr.h
//  ShopPhotos
//
//  Created by  on 4/1/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPAlertCtrl : NSObject

- (void) initWithTitle:(NSString *)title message:(NSString *)msg cancelButtonTitle:(NSString *)btnTitle otherButtonTitles:(NSString *)btnOtherTitle controller:(UIViewController *)ctrl;

@end

