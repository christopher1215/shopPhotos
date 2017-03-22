//
//  PhotoImagesRequset.m
//  ShopPhotos
//
//  Created by addcn on 16/12/31.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PhotoImagesRequset.h"
#import "PhotoImagesModel.h"

@implementation PhotoImagesRequset

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        self.dataArray = [NSMutableArray array];
        NSArray * json = [RequestErrorGrab getArrwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            for(NSDictionary * images in json){
                PhotoImagesModel * model = [[PhotoImagesModel alloc] init];
                model.imageID = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"id" toTarget:images]];
                model.imageLink_id = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"imageLink_id" toTarget:images]];
                model.thumbnails = [RequestErrorGrab getStringwitKey:@"thumbnails" toTarget:images];
                model.big = [RequestErrorGrab getStringwitKey:@"big" toTarget:images];
                model.source = [RequestErrorGrab getStringwitKey:@"source" toTarget:images];
                model.isCover = [RequestErrorGrab getBooLwitKey:@"isCover" toTarget:images];
                if (model.isCover) {
                    [self.dataArray insertObject:model atIndex:0];
                }else{
                    [self.dataArray addObject:model];
                }
                
            }
        }
        
        
    } @catch (NSException *exception) {
        
        self.status = 1;
        self.message = NETWORKTIPS;
        
    }
}

@end