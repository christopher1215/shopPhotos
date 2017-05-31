//
//  AlbumClassModel.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AlbumClassModel.h"
#import "AlbumClassTableModel.h"
#import "AlbumClassTableSubModel.h"

@implementation AlbumClassModel

- (void)analyticInterface:(NSDictionary *)data{

    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status)return;
        self.dataArray = [NSMutableArray array];
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            
            NSArray * classifies = [RequestErrorGrab getArrwitKey:@"classifies" toTarget:json];
            NSArray * subclasses = [RequestErrorGrab getArrwitKey:@"subclasses" toTarget:json];
            NSDictionary * video = [RequestErrorGrab getDicwitKey:@"video" toTarget:json];
            if(classifies && classifies.count > 0){
                for(NSDictionary * classifie in classifies){
                    AlbumClassTableModel * model = [[AlbumClassTableModel alloc] init];
                    model.dataArray = [NSMutableArray array];
                    model.Id = [RequestErrorGrab getIntegetKey:@"id" toTarget:classifie];
                    model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:classifie];
                    model.subclassCount = [RequestErrorGrab getIntegetKey:@"subclassCounts" toTarget:classifie];
                    model.isVideo = NO;
                    [self.dataArray addObject:model];
                }
                
            }
            if(video){
                AlbumClassTableModel * model = [[AlbumClassTableModel alloc] init];
                model.Id = [RequestErrorGrab getIntegetKey:@"id" toTarget:video];
                model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:video];
                model.videosCount = [RequestErrorGrab getIntegetKey:@"videosCount" toTarget:video];
                model.isVideo = YES;
                if (self.dataArray.count) {
                    [self.dataArray insertObject:model atIndex:0];
                } else {
                    [self.dataArray addObject:model];
                }
                
            }
           
            if(subclasses && subclasses.count){
                for(NSDictionary * subclass in subclasses){
//                    NSDictionary *subclass = [subarray objectAtIndex:0];
                    AlbumClassTableSubModel * subModel = [[AlbumClassTableSubModel alloc] init];
                    subModel.classfiyId = [RequestErrorGrab getIntegetKey:@"classfiyId" toTarget:subclass];
                    subModel.Id = [RequestErrorGrab getIntegetKey:@"id" toTarget:subclass];
                    subModel.photoCount = [RequestErrorGrab getIntegetKey:@"photoCounts" toTarget:subclass];
                    subModel.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:subclass];
                    subModel.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:subclass];
                    if (classifies && classifies.count > 0) {
                        for(AlbumClassTableModel * model in self.dataArray){
                            if(subModel.classfiyId == model.Id){
                                 [model.dataArray addObject:subModel];
                            }
                        }
                    }
                    else {
                        [self.dataArray addObject:subModel];
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = exception.name;//NETWORKTIPS;
    }
}

@end
