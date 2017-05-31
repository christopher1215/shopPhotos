//
//  UIPlaceHolderTextView.h
//  youtu
//
//  Created by qqq on 12/11/15.
//  Copyright © 2015 Christopher sh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
