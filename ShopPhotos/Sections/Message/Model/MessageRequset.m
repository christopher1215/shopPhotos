//
//  MessageRequset.m
//  ShopPhotos
//
//  Created by addcn on 16/12/28.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "MessageRequset.h"
#import "MessageModel.h"

@implementation MessageRequset


- (void)analyticInterface:(NSDictionary *)data{
    
    @try {
        self.dataArray = [NSMutableArray array];
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        if(self.status) return;
        NSDictionary * json = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(json && json.count > 0){
            self.page = [RequestErrorGrab getIntegetKey:@"page" toTarget:json];
            self.pageCount = [RequestErrorGrab getIntegetKey:@"pageCount" toTarget:json];
            self.resultsLength = [RequestErrorGrab getIntegetKey:@"resultsLength" toTarget:json];
            NSArray * notices = [RequestErrorGrab getArrwitKey:@"notices" toTarget:json];
            if(notices && notices.count > 0){
                for(NSDictionary * noticeArray in notices){
                    MessageModel * model = [[MessageModel alloc] init];
                    model.content = [RequestErrorGrab getStringwitKey:@"content" toTarget:noticeArray];
                    model.date = [RequestErrorGrab getStringwitKey:@"date" toTarget:noticeArray];
                    model.itmeID = [RequestErrorGrab getIntegetKey:@"id" toTarget:noticeArray];
                    model.code = [RequestErrorGrab getStringwitKey:@"status" toTarget:noticeArray];
                    model.title = [RequestErrorGrab getStringwitKey:@"title" toTarget:noticeArray];
                    model.type = [RequestErrorGrab getStringwitKey:@"type" toTarget:noticeArray];
                    model.avatar = [RequestErrorGrab getStringwitKey:@"avatar" toTarget:noticeArray];
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
