//
//  PhotosSearchRequeset.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/12.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PhotosSearchRequeset.h"

#import "AlbumPhotosModel.h"

@implementation PhotosSearchRequeset

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        self.dataArray = [NSMutableArray array];
        NSArray * josn = [RequestErrorGrab getArrwitKey:@"data" toTarget:data];
        if(josn && josn.count > 0){
            for(NSDictionary * photo in josn){
                AlbumPhotosModel * model = [[AlbumPhotosModel alloc] init];
                model.title = [RequestErrorGrab getStringwitKey:@"title" toTarget:photo];
                model.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:photo];
                model.createdAt = [RequestErrorGrab getStringwitKey:@"createdAt" toTarget:photo];
                model.Id = [NSString stringWithFormat:@"%ld",(long)[RequestErrorGrab getIntegetKey:@"id" toTarget:photo]];
                model.user = [RequestErrorGrab getDicwitKey:@"user" toTarget:photo];
                model.collected = [RequestErrorGrab getIntegetKey:@"isCollected" toTarget:photo];
                model.recommend = [RequestErrorGrab getBooLwitKey:@"recommend" toTarget:photo];
                [self.dataArray addObject:model];
            }
        }
        
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = exception.name;//NETWORKTIPS;
    }
}

@end
