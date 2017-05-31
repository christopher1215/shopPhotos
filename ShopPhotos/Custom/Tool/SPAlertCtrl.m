//
//  SPAlertCtrl.m
//  ShopPhotos
//
//  Created by  on 4/1/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "SPAlertCtrl.h"

@implementation SPAlertCtrl : NSObject

-(void) initWithTitle:(NSString *)title message:(NSString *)msg cancelButtonTitle:(NSString *)btnTitle otherButtonTitles:(NSString *)btnOtherTitle controller:(UIViewController *)ctrl {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:msg
                                preferredStyle:UIAlertControllerStyleAlert];
    /*
     UIAlertAction *Reset = [UIAlertAction
     actionWithTitle:NSLocalizedString(@"Reset", @"Reset action")
     style:UIAlertActionStyleDestructive
     handler:^(UIAlertAction *action)
     {
     NSLog(@"Reset action");
     }];
     */
    UIAlertAction *Cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(btnTitle, @"Cancel action")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action)
                             {
                                 NSLog(@"Cancel action");
                             }];
    
    //    [alert addAction:Reset];
    [alert addAction:Cancel];
    
    [ctrl presentViewController:alert animated:YES completion:nil];
}

@end
