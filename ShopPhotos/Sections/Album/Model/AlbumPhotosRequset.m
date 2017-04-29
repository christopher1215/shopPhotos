//
//  AlbumPhotosRequset.m
//  ShopPhotos
//
//  Created by addcn on 16/12/24.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AlbumPhotosRequset.h"
#import "AlbumPhotosModel.h"

@implementation AlbumPhotosRequset

- (void)analyticInterface:(NSDictionary *)data{
    @try {
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message'" toTarget:data];
        if(self.status)return;
        
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            self.pageCount = [RequestErrorGrab getIntegetKey:@"pageSize" toTarget:json];
            self.dataArray = [NSMutableArray array];
            NSArray * photos = [RequestErrorGrab getArrwitKey:@"photos" toTarget:json];
            NSDictionary * photo = [RequestErrorGrab getDicwitKey:@"photo" toTarget:json];
            if(photos && photos.count > 0){
                for(NSDictionary * photo in photos){
                    [self.dataArray addObject:[self analysting:photo]];
                }
            }
            if (photo) {
                [self.dataArray addObject:[self analysting:photo]];
            }
        }
    } @catch (NSException *exception) {
        self.message = NETWORKTIPS;
        self.status = 0;
    }
}

- (AlbumPhotosModel *) analysting:(NSDictionary *)photo {
    
    AlbumPhotosModel * model = [[AlbumPhotosModel alloc] init];
    model.title = [RequestErrorGrab getStringwitKey:@"title" toTarget:photo];
    model.recommend = [RequestErrorGrab getBooLwitKey:@"recommend" toTarget:photo];
    model.collected = [RequestErrorGrab getBooLwitKey:@"collected" toTarget:photo];
    model.dateDiff = [RequestErrorGrab getStringwitKey:@"dateDiff" toTarget:photo];
    model.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:photo];
    model.video = [RequestErrorGrab getStringwitKey:@"video" toTarget:photo];
    model.desc = [RequestErrorGrab getStringwitKey:@"description" toTarget:photo];
    model.Id = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"id" toTarget:photo]];
    model.type = [RequestErrorGrab getStringwitKey:@"type" toTarget:photo];
    model.createdAt = [RequestErrorGrab getStringwitKey:@"createdAt" toTarget:photo];
    model.dateDiff = [RequestErrorGrab getStringwitKey:@"dateDiff" toTarget:photo];
    model.user = [RequestErrorGrab getDicwitKey:@"user" toTarget:photo];
    model.classify = [RequestErrorGrab getDicwitKey:@"classify" toTarget:photo];
    model.subclass = [RequestErrorGrab getDicwitKey:@"subclass" toTarget:photo];
    model.images = [RequestErrorGrab getArrwitKey:@"images" toTarget:photo];
    model.type = [RequestErrorGrab getStringwitKey:@"type" toTarget:photo];
    
    return model;
}


@end
