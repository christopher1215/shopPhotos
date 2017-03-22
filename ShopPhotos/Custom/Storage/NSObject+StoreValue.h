//
//  NSObject+StoreValue.h
//  StoreValue
//
//  Created by YouXianMing on 15/9/29.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (StoreValue)


- (void)setValue:(id)value WithKey:(NSString *)key;
- (id)getValueWithKey:(NSString *)key;
- (void)removeValueWithKey:(NSString *)key;

@end
