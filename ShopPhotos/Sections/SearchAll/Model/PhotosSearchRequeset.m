//
//  PhotosSearchRequeset.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/12.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PhotosSearchRequeset.h"

#import "AlbumPhotosMdel.h"

@implementation PhotosSearchRequeset

- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        self.dataArray = [NSMutableArray array];
        NSArray * josn = [RequestErrorGrab getArrwitKey:@"data" toTarget:data];
        if(josn && josn.count > 0){
            for(NSDictionary * photo in josn){
                AlbumPhotosMdel * model = [[AlbumPhotosMdel alloc] init];
                model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:photo];
                model.big = [RequestErrorGrab getStringwitKey:@"big" toTarget:photo];
                model.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:photo];
                model.date = [RequestErrorGrab getStringwitKey:@"date" toTarget:photo];
                model.photosID = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"id" toTarget:photo]];
                model.price = [RequestErrorGrab getStringwitKey:@"price" toTarget:photo];
                model.showPrice = [RequestErrorGrab getBooLwitKey:@"showPrice" toTarget:photo];
                model.source = [RequestErrorGrab getStringwitKey:@"source" toTarget:photo];
                model.user = [RequestErrorGrab getDicwitKey:@"user" toTarget:photo];
                model.isCollected = [RequestErrorGrab getIntegetKey:@"isCollected" toTarget:photo];
                model.recommend = [RequestErrorGrab getBooLwitKey:@"recommend" toTarget:photo];
                [self.dataArray addObject:model];
            }
        }
        
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }
}

@end
