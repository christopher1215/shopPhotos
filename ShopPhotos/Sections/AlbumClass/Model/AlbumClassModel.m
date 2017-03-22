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
            NSArray * subclassifications = [RequestErrorGrab getArrwitKey:@"subclassifications" toTarget:json];
            
            if(classifies && classifies.count > 0){
                
                for(NSDictionary * classifie in classifies){
                    
                    AlbumClassTableModel * model = [[AlbumClassTableModel alloc] init];
                    model.dataArray = [NSMutableArray array];
                    model.classID = [RequestErrorGrab getIntegetKey:@"id" toTarget:classifie];
                    model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:classifie];
                    [self.dataArray addObject:model];
                }
            }
         
            // --
            if(subclassifications && subclassifications.count){
                
                for(NSDictionary * subclassification in subclassifications){
                    
                    AlbumClassTableSubModel * subModel = [[AlbumClassTableSubModel alloc] init];
                    subModel.classID = [RequestErrorGrab getIntegetKey:@"classify_id" toTarget:subclassification];
                    //[RequestErrorGrab getStringwitKey:@"classify_id" toTarget:subclassification];
                    subModel.subClassID = [RequestErrorGrab getIntegetKey:@"id" toTarget:subclassification];
                    //[RequestErrorGrab getStringwitKey:@"id" toTarget:subclassification];
                    subModel.cover = [RequestErrorGrab getStringwitKey:@"cover" toTarget:subclassification];
                    subModel.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:subclassification];
                    
                    for(AlbumClassTableModel * model in self.dataArray){
                        if(subModel.classID == model.classID){
                             [model.dataArray addObject:subModel];
                        }
//                        if([subModel.classID isEqualToString:model.classID]){
//                            [model.dataArray addObject:subModel];
//                        }
                    }
                }
            }  
        }
    } @catch (NSException *exception) {
        
        self.status = 1;
        self.message = NETWORKTIPS;
    }
}

@end
