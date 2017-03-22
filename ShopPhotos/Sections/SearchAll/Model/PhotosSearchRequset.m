//
//  PhotosSearchRequset.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/7.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PhotosSearchRequset.h"
#import "AlbumPhotosMdel.h"

@implementation PhotosSearchRequset
- (void)analyticInterface:(NSDictionary *)data{
    @try {
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message'" toTarget:data];
        if(self.status)return;
        
        NSArray * photos = [RequestErrorGrab getArrwitKey:@"data" toTarget:data];
        if(photos && photos.count > 0){
            
            self.dataArray = [NSMutableArray array];
            if(photos && photos.count > 0){
                
                for(NSDictionary * photo in photos){
                    AlbumPhotosMdel * model = [[AlbumPhotosMdel alloc] init];
                    model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:photo];
                    model.big = [RequestErrorGrab getStringwitKey:@"big" toTarget:photo];
                    model.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:photo];
                    model.date = [RequestErrorGrab getStringwitKey:@"date" toTarget:photo];
                    model.photosID = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"id" toTarget:photo]];
                    model.price = [RequestErrorGrab getStringwitKey:@"price" toTarget:photo];
                    model.showPrice = [RequestErrorGrab getIntegetKey:@"showPrice" toTarget:photo];
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
