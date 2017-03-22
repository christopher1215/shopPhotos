//
//  RequestErrorGrab.h
//  GameTradePlatform
//
//  Created by addcn on 15/8/7.
//  Copyright (c) 2015年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestErrorGrab : NSObject

+(NSString *)getStringwitKey:(NSString * )key toTarget:(NSDictionary *)targetDic;
+(NSMutableArray *)getArrwitKey:(NSString *)key toTarget:(NSDictionary *)targetDic;
+(NSDictionary *)getDicwitKey:(NSString * )key toTarget:(NSDictionary *)targetDic;
+(BOOL)getBooLwitKey:(NSString *)key toTarget:(NSDictionary *)targetDic;
+(NSInteger)getIntegetKey:(NSString *)key toTarget:(NSDictionary *)targetDic;

@end
