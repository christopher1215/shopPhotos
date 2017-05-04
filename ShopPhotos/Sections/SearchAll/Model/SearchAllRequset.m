//
//  SearchAllRequset.m
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "SearchAllRequset.h"
#import "AttentionPersonalSearchModel.h"
#import "AlbumPhotosModel.h"

@implementation SearchAllRequset


- (void)analyticInterface:(NSDictionary *)data{

    @try {
        
        self.users = [NSMutableArray array];
        self.photos = [NSMutableArray array];
        self.selfPhotos = [NSMutableArray array];
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
        
            NSArray * photos = [RequestErrorGrab getArrwitKey:@"photos" toTarget:json];
            NSArray * selfPhotos = [RequestErrorGrab getArrwitKey:@"selfPhotos" toTarget:json];
            NSArray * user = [RequestErrorGrab getArrwitKey:@"users" toTarget:json];
            
            if(user && user.count > 0){
                for (NSDictionary * userDic in user) {
                    AttentionPersonalSearchModel * model = [[AttentionPersonalSearchModel alloc] init];
                    model.address = [RequestErrorGrab getStringwitKey:@"address" toTarget:userDic];
                    model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:userDic];
                    model.qq = [RequestErrorGrab getStringwitKey:@"qq" toTarget:userDic];
                    model.phone = [RequestErrorGrab getStringwitKey:@"phone" toTarget:userDic];
                    model.wechat = [RequestErrorGrab getStringwitKey:@"wechat" toTarget:userDic];
                    model.avatar = [RequestErrorGrab getStringwitKey:@"avatar" toTarget:userDic];
                    model.bg_image = [RequestErrorGrab getStringwitKey:@"bg_image" toTarget:userDic];
                    model.signature = [RequestErrorGrab getStringwitKey:@"signature" toTarget:userDic];
                    model.uid = [RequestErrorGrab getStringwitKey:@"uid" toTarget:userDic];
                    model.settings = [RequestErrorGrab getDicwitKey:@"settings" toTarget:userDic];
                    [self.users addObject:model];
                }
            }
            
            if(photos && photos.count > 0){
                for(NSDictionary * photo in photos){
                    AlbumPhotosModel * model = [[AlbumPhotosModel alloc] init];
                    model.title = [RequestErrorGrab getStringwitKey:@"title" toTarget:photo];
                    model.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:photo];
                    model.createdAt = [RequestErrorGrab getStringwitKey:@"createdAt" toTarget:photo];
                    model.Id = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"id" toTarget:photo]];
                    model.user = [RequestErrorGrab getDicwitKey:@"user" toTarget:photo];
                    model.collected = [RequestErrorGrab getIntegetKey:@"collected" toTarget:photo];
                    model.recommend = [RequestErrorGrab getBooLwitKey:@"recommend" toTarget:photo];
                    [self.photos addObject:model];
                }
            }
            
            if(selfPhotos && selfPhotos.count > 0){
                
                for(NSDictionary * photo in selfPhotos){
                    AlbumPhotosModel * model = [[AlbumPhotosModel alloc] init];
                    model.title = [RequestErrorGrab getStringwitKey:@"title" toTarget:photo];
                    model.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:photo];
                    model.createdAt = [RequestErrorGrab getStringwitKey:@"createdAt" toTarget:photo];
                    model.Id = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"id" toTarget:photo]];
                    model.user = [RequestErrorGrab getDicwitKey:@"user" toTarget:photo];
                    model.collected = [RequestErrorGrab getIntegetKey:@"collected" toTarget:photo];
                    model.recommend = [RequestErrorGrab getBooLwitKey:@"recommend" toTarget:photo];

                    [self.selfPhotos addObject:model];
                }

                
            }
        }
        
    } @catch (NSException *exception) {
        self.status = 0;
        self.message = NETWORKTIPS;
    }
}

@end
