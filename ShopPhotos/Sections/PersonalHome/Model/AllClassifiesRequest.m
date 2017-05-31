//
//  AlbumClassModel.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AllClassifiesRequest.h"
#import "AllClassModel.h"

@implementation AllClassifiesRequest

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status)return;
        self.dataArray = [NSMutableArray array];
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            NSArray * classifies = [RequestErrorGrab getArrwitKey:@"classifies" toTarget:json];
            if(classifies && classifies.count > 0){
                for(NSDictionary * classifie in classifies){
                    AllClassModel * model = [[AllClassModel alloc] init];
                    model.Id = [RequestErrorGrab getIntegetKey:@"id" toTarget:classifie];
                    model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:classifie];
                    model.subclasses = [NSMutableArray arrayWithArray:[RequestErrorGrab getArrwitKey:@"subclasses" toTarget:classifie]];
                    [self.dataArray addObject:model];
                }
            }
        }
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = exception.name;//NETWORKTIPS;
    }
}

@end
