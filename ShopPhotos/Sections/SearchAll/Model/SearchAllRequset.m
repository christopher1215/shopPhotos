//
//  SearchAllRequset.m
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "SearchAllRequset.h"
#import "UserModel.h"
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
                    UserModel * model = [[UserModel alloc] init];
                    model.uid = [RequestErrorGrab getStringwitKey:@"uid" toTarget:userDic];
                    model.address = [RequestErrorGrab getStringwitKey:@"address" toTarget:userDic];
                    model.avatar = [RequestErrorGrab getStringwitKey:@"avatar" toTarget:userDic];
                    model.bg_image = [RequestErrorGrab getStringwitKey:@"bg_image" toTarget:userDic];
                    model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:userDic];
                    model.name_abbr = [RequestErrorGrab getStringwitKey:@"name_abbr" toTarget:userDic];
                    model.phone = [RequestErrorGrab getStringwitKey:@"phone" toTarget:userDic];
                    model.qq = [RequestErrorGrab getStringwitKey:@"qq" toTarget:userDic];
                    model.settings = [RequestErrorGrab getDicwitKey:@"settings" toTarget:userDic];
                    model.signature = [RequestErrorGrab getStringwitKey:@"signature" toTarget:userDic];
                    model.wechat = [RequestErrorGrab getStringwitKey:@"wechat" toTarget:userDic];
                    model.email = [RequestErrorGrab getStringwitKey:@"email" toTarget:userDic];
                    [self.users addObject:model];
                }
            }
            
            if(photos && photos.count > 0){
                for(NSDictionary * photo in photos){
                    AlbumPhotosModel * model = [[AlbumPhotosModel alloc] init];
                    model.title = [RequestErrorGrab getStringwitKey:@"title" toTarget:photo];
                    model.recommend = [RequestErrorGrab getBooLwitKey:@"recommend" toTarget:photo];
                    model.collected = [RequestErrorGrab getBooLwitKey:@"collected" toTarget:photo];
                    model.dateDiff = [RequestErrorGrab getStringwitKey:@"dateDiff" toTarget:photo];
                    model.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:photo];
                    model.video = [RequestErrorGrab getStringwitKey:@"video" toTarget:photo];
                    model.desc = [RequestErrorGrab getStringwitKey:@"description" toTarget:photo];
                    model.Id = [NSString stringWithFormat:@"%ld",(long)[RequestErrorGrab getIntegetKey:@"id" toTarget:photo]];
                    model.createdAt = [RequestErrorGrab getStringwitKey:@"createdAt" toTarget:photo];
                    model.user = [RequestErrorGrab getDicwitKey:@"user" toTarget:photo];
                    model.classify = [RequestErrorGrab getDicwitKey:@"classify" toTarget:photo];
                    model.subclass = [RequestErrorGrab getDicwitKey:@"subclass" toTarget:photo];
                    model.images = [RequestErrorGrab getArrwitKey:@"images" toTarget:photo];
                    model.type = [RequestErrorGrab getStringwitKey:@"type" toTarget:photo];
                    [self.photos addObject:model];
                }
            }
            
            if(selfPhotos && selfPhotos.count > 0){
                
                for(NSDictionary * photo in selfPhotos){
                    AlbumPhotosModel * model = [[AlbumPhotosModel alloc] init];
                    model.title = [RequestErrorGrab getStringwitKey:@"title" toTarget:photo];
                    model.recommend = [RequestErrorGrab getBooLwitKey:@"recommend" toTarget:photo];
                    model.collected = [RequestErrorGrab getBooLwitKey:@"collected" toTarget:photo];
                    model.dateDiff = [RequestErrorGrab getStringwitKey:@"dateDiff" toTarget:photo];
                    model.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:photo];
                    model.video = [RequestErrorGrab getStringwitKey:@"video" toTarget:photo];
                    model.desc = [RequestErrorGrab getStringwitKey:@"description" toTarget:photo];
                    model.Id = [NSString stringWithFormat:@"%ld",(long)[RequestErrorGrab getIntegetKey:@"id" toTarget:photo]];
                    model.createdAt = [RequestErrorGrab getStringwitKey:@"createdAt" toTarget:photo];
                    model.user = [RequestErrorGrab getDicwitKey:@"user" toTarget:photo];
                    model.classify = [RequestErrorGrab getDicwitKey:@"classify" toTarget:photo];
                    model.subclass = [RequestErrorGrab getDicwitKey:@"subclass" toTarget:photo];
                    model.images = [RequestErrorGrab getArrwitKey:@"images" toTarget:photo];
                    model.type = [RequestErrorGrab getStringwitKey:@"type" toTarget:photo];

                    [self.selfPhotos addObject:model];
                }

                
            }
        }
        
    } @catch (NSException *exception) {
        self.status = 0;
        self.message = exception.name;//NETWORKTIPS;
    }
}

@end
