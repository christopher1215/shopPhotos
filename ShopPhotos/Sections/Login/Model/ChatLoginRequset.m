//
//  ChatLoginRequset.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/7.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "ChatLoginRequset.h"
#import "UserModel.h"
#import "NSObject+StoreValue.h"

@implementation ChatLoginRequset

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        
        //NSLog(<#NSString * _Nonnull format, ...#>)
        
        
//        if(obj){
//            NSLog(NSStringFromClass([obj class]));
//        }
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status)return;
        
        id obj  = [data objectForKey:@"data"];
        if(obj){
            if([obj isKindOfClass:[NSNumber class]]){
                self.userID = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"data" toTarget:data]];
            }else{
                self.userID = [RequestErrorGrab getStringwitKey:@"data" toTarget:data];
            }
            
        }
        
        
        
        
        if(self.userID && self.userID.length > 0){
            UserModel * userModel = [[UserModel alloc] init];
            userModel.uid = self.userID;
            [self setValue:userModel WithKey:CacheUserModel];
        }
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }
}

@end
