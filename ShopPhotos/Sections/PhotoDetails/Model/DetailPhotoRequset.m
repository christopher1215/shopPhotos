//
//  DetailPhotoRequset.m
//  ShopPhotos
//
//  Created by addcn on 16/12/31.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "DetailPhotoRequset.h"

@implementation DetailPhotoRequset


- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            self.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:json];
            self.showPrice = [RequestErrorGrab getBooLwitKey:@"showPrice" toTarget:json];
            self.big = [RequestErrorGrab getStringwitKey:@"big" toTarget:json];
            self.photoId = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"id" toTarget:json]];
            self.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:json];
            self.isCollected = [RequestErrorGrab getBooLwitKey:@"isCollected" toTarget:json];
            self.date = [RequestErrorGrab getStringwitKey:@"date" toTarget:json];
            self.price = [RequestErrorGrab getStringwitKey:@"price" toTarget:json];
            self.recommend = [RequestErrorGrab getStringwitKey:@"recommend" toTarget:json];
            self.source = [RequestErrorGrab getStringwitKey:@"source" toTarget:json];
            NSDictionary * user = [RequestErrorGrab getDicwitKey:@"user" toTarget:json];
            if(user && user.count > 0){
                self.userID = [RequestErrorGrab getStringwitKey:@"uid" toTarget:user];
                self.userName = [RequestErrorGrab getStringwitKey:@"name" toTarget:user];
            }
            
            NSDictionary * subclass = [RequestErrorGrab getDicwitKey:@"subclass" toTarget:json];
            if(subclass && subclass.count > 0){
                self.subclassID = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"id" toTarget:subclass]];
                self.subclassName = [RequestErrorGrab getStringwitKey:@"name" toTarget:subclass];
            }
            
            NSDictionary * classify = [RequestErrorGrab getDicwitKey:@"classify" toTarget:json];
            if(classify && classify.count > 0){
                self.classifyName = [RequestErrorGrab getStringwitKey:@"name" toTarget:classify];
                self.classifyID = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"id" toTarget:classify]];
            }
        }
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }
}

@end
