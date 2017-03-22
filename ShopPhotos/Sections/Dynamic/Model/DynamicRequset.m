//
//  DynamicRequset.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/21.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "DynamicRequset.h"
#import "DynamicModel.h"
#import "DynamicImagesModel.h"


@implementation DynamicRequset

- (void)analyticInterface:(NSDictionary *)data{

    @try {
        
        self.dataArray = [NSMutableArray array];
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status)return;
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            
            NSArray * newDynamisc = [RequestErrorGrab getArrwitKey:@"newDynamics" toTarget:json];
            if(newDynamisc && newDynamisc.count > 0){
                
                //NSLog(@"%@",[newDynamisc objectAtIndex:0]);
                
               
                
                for(NSDictionary * dynamics in newDynamisc){
                    
                    DynamicModel * model = [[DynamicModel alloc] init];
                    
                    
                     NSDictionary * user = [RequestErrorGrab getDicwitKey:@"user" toTarget:dynamics];
                    
                    model.user = [[NSMutableDictionary alloc] initWithDictionary:user];
                    
                    model.date  = [RequestErrorGrab getStringwitKey:@"date" toTarget:dynamics];
                    model.descriptionText = [RequestErrorGrab getStringwitKey:@"description" toTarget:dynamics];
                    
                    
                    NSDictionary * photo = [RequestErrorGrab getDicwitKey:@"photo" toTarget:dynamics];
                    
                    if(photo && photo.count > 0){
                        model.isCollected = [RequestErrorGrab getIntegetKey:@"isCollected" toTarget:photo];
                        model.photosID = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"id" toTarget:photo]];
                        model.showPrice = [RequestErrorGrab getBooLwitKey:@"showPrice" toTarget:photo];
                        model.price = [RequestErrorGrab getStringwitKey:@"price" toTarget:photo];
                        model.title = [RequestErrorGrab getStringwitKey:@"title" toTarget:photo];
                        NSArray * images = [RequestErrorGrab getArrwitKey:@"images" toTarget:photo];
                        model.images = [[NSMutableArray alloc] init];
                        if(images && images.count > 0){
                            for(NSDictionary * image in images){
                                DynamicImagesModel * imageModel = [[DynamicImagesModel alloc] init];
                                imageModel.big = [RequestErrorGrab getStringwitKey:@"big" toTarget:image];
                                imageModel.thumbnails = [RequestErrorGrab getStringwitKey:@"thumbnails" toTarget:image];
                                imageModel.imageID = [RequestErrorGrab getIntegetKey:@"id" toTarget:image];
                                [model.images addObject:imageModel];
                            }
                        }
                    }
                    
                  [self.dataArray addObject:model];  
                }
                
            }
        }
        
        
    } @catch (NSException *exception) {
        self.status = 1;
        self.message = NETWORKTIPS;
    }

}

@end
