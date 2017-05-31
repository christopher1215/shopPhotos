//
//  PhotosSearchRequset.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/7.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PhotosSearchRequset.h"
#import "AlbumPhotosModel.h"

@implementation PhotosSearchRequset
- (void)analyticInterface:(NSDictionary *)data{
    @try {
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message'" toTarget:data];
        if(self.status)return;
        
        NSArray * photos = [RequestErrorGrab getArrwitKey:@"photos" toTarget:[RequestErrorGrab getDicwitKey:@"data" toTarget:data]];
        if(photos && photos.count > 0){
            
            self.dataArray = [NSMutableArray array];
            if(photos && photos.count > 0){
                
                for(NSDictionary * photo in photos){
                    AlbumPhotosModel * model = [[AlbumPhotosModel alloc] init];
                    model.title = [RequestErrorGrab getStringwitKey:@"title" toTarget:photo];
//                    model.big = [RequestErrorGrab getStringwitKey:@"big" toTarget:photo];
                    model.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:photo];
                    model.createdAt = [RequestErrorGrab getStringwitKey:@"createdAt" toTarget:photo];
                    model.Id = [NSString stringWithFormat:@"%ld",(long)[RequestErrorGrab getIntegetKey:@"id" toTarget:photo]];
                    model.user = [RequestErrorGrab getDicwitKey:@"user" toTarget:photo];
                    model.collected = [RequestErrorGrab getIntegetKey:@"collected" toTarget:photo];
                    model.recommend = [RequestErrorGrab getBooLwitKey:@"recommend" toTarget:photo];
                    [self.dataArray addObject:model];
                    
                }
            }
            
        }
        
    } @catch (NSException *exception) {
        self.message = exception.name;//NETWORKTIPS;
        self.status = 0;
    }
}

@end
