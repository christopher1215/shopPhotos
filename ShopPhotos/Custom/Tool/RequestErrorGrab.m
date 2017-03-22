//
//  RequestErrorGrab.m
//  GameTradePlatform
//
//  Created by addcn on 15/8/7.
//  Copyright (c) 2015年 SR. All rights reserved.
//

#import "RequestErrorGrab.h"

@implementation RequestErrorGrab

+(NSString *)getStringwitKey:(NSString *)key toTarget:(NSDictionary *)targetDic{
    NSMutableString * value_str=[[NSMutableString alloc]init];
    
    if(!targetDic || [targetDic class] == [NSNull class]){
        return value_str;
    }
    
    if(targetDic.count <= 0){
        return value_str;
    }
    @try {
        NSString * temp_str =[targetDic objectForKey:key];
        if([temp_str isKindOfClass:[NSString class]]){
            if(temp_str && temp_str.length>0){
                [value_str appendString:temp_str];
            }else{
                return @"";
            }
        }else{
            return @"";
        }
    }
    @catch (NSException *exception) {
       
    }
    return value_str;
}
+(NSMutableArray *)getArrwitKey:(NSString *)key toTarget:(NSDictionary *)targetDic{
    NSMutableArray * value_arr ;
    if(!targetDic || [targetDic class] == [NSNull class]){
        return value_arr;
    }
    @try {
        
        id value = [targetDic objectForKey:key];
        
        if([value isKindOfClass:[NSArray class]]){
            
            value_arr = [targetDic objectForKey:key];
            
        }
        value_arr=[targetDic objectForKey:key];
    }
    @catch (NSException *exception) {
    }
    
    return value_arr;
}
+(NSInteger)getIntegetKey:(NSString *)key toTarget:(NSDictionary *)targetDic{
   
    NSNumber *value_num = [[NSNumber alloc]initWithInt:0];
    if(!targetDic){
        return [value_num intValue];
    }
    @try {
        
        value_num=[targetDic objectForKey:key];
    }
    @catch (NSException *exception) {
        return 0;
    }
    if(![[value_num class] isKindOfClass:[NSNull class]]){
        return [value_num intValue];
    }else{
        return 0;
    }
    
}
+(NSDictionary *)getDicwitKey:(NSString *)key toTarget:(NSDictionary *)targetDic{
    NSDictionary * value_dic ;
    if((!targetDic && targetDic.count<=0)|| [targetDic class] == [NSNull class]){
        
        value_dic=[[NSDictionary alloc]init];
        return value_dic;
    }
    @try {
        
        id value = [targetDic objectForKey:key];
        
        if([value isKindOfClass:[NSDictionary class]]){
            
            value_dic = [targetDic objectForKey:key];
            
        }

    }
    @catch (NSException *exception) {
        
    }
    return value_dic;
}
+(BOOL)getBooLwitKey:(NSString *)key toTarget:(NSDictionary *)targetDic{
    BOOL value_bool=0;
    NSNumber *value_num = [NSNumber numberWithInt: 2];
    
    if(!targetDic){
        return NO;
    }
    
    @try {
        value_num=[targetDic objectForKey:key];
    }
    @catch (NSException *exception) {
        
    }
    value_bool=[value_num intValue];
    return value_bool;
}
@end
