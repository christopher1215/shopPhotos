
//
//  StoreValue.m
//  StoreValue
//
//  Created by YouXianMing on 15/9/29.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import "StoreValue.h"
#import "FastCoder.h"

@implementation StoreValue

+ (StoreValue *)sharedInstance {

    static StoreValue *storeValue = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        storeValue = [[StoreValue alloc] init];
    });
    
    return storeValue;
}

- (void)setValue:(id)value withKey:(NSString *)key {

    if(!value)return;
    if(!key)return;
    
    NSData *data = [FastCoder dataWithRootObject:value];
    if (data) {
        
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:key];
    }
}

- (id)getValueWithKey:(NSString *)key {

    if(!key)return nil;
    
    id data = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    
    if([data isKindOfClass:[NSData class]]){
        
       return [FastCoder objectWithData:data];
    }else{
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    
    
}

-(void)removeValueWithKey:(NSString *)key{
    
    if(!key)return;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
@end
