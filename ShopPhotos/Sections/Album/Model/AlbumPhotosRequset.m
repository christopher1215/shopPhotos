//
//  AlbumPhotosRequset.m
//  ShopPhotos
//
//  Created by addcn on 16/12/24.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AlbumPhotosRequset.h"
#import "AlbumPhotosMdel.h"

@implementation AlbumPhotosRequset


- (void)analyticInterface:(NSDictionary *)data{
    @try {
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message'" toTarget:data];
        if(self.status)return;
        
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            
            self.pageCount = [RequestErrorGrab getIntegetKey:@"pageCount" toTarget:json];
            self.pagination = [RequestErrorGrab getIntegetKey:@"pagination" toTarget:json];
            self.resultsLength = [RequestErrorGrab getIntegetKey:@"resultsLength" toTarget:json];
            
            self.dataArray = [NSMutableArray array];
            NSArray * photos = [RequestErrorGrab getArrwitKey:@"photos" toTarget:json];
            if(photos && photos.count > 0){
                
                for(NSDictionary * photo in photos){
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
            
        }
        
    } @catch (NSException *exception) {
        self.message = NETWORKTIPS;
        self.status = 0;
    }
}


@end
