//
//  SuperAlbumClassRequset.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/3.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "SuperAlbumClassRequset.h"
#import "SuperAlbumClassModel.h"

@implementation SuperAlbumClassRequset

- (void)analyticInterface:(NSDictionary *)data{

    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        self.dataArray = [NSMutableArray array];
        NSArray * json = [RequestErrorGrab getArrwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            for(NSDictionary * sun in json){
                SuperAlbumClassModel * model = [[SuperAlbumClassModel alloc] init];
                model.itmeID = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"id" toTarget:sun]];
                model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:sun];
                model.classify_id = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"classify_id" toTarget:sun]];
                model.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:sun];
                [self.dataArray addObject:model];
            }
        }
        
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }
}

@end
