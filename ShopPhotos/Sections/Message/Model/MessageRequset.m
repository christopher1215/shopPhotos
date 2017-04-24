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
            self.pageCount = [RequestErrorGrab getIntegetKey:@"pageSize" toTarget:json];
            self.resultsLength = [RequestErrorGrab getIntegetKey:@"total" toTarget:json];
            NSArray * notices = [RequestErrorGrab getArrwitKey:@"notices" toTarget:json];
            if(notices && notices.count > 0){
                for(NSDictionary * noticeArray in notices){
                    MessageModel * model = [[MessageModel alloc] init];
                    model.content = [RequestErrorGrab getStringwitKey:@"content" toTarget:noticeArray];
                    model.title = [RequestErrorGrab getStringwitKey:@"title" toTarget:noticeArray];
                    model.type = [RequestErrorGrab getStringwitKey:@"type" toTarget:noticeArray];
                    model.date = [RequestErrorGrab getStringwitKey:@"createdAt" toTarget:noticeArray];
                    model.itemID = [RequestErrorGrab getIntegetKey:@"id" toTarget:noticeArray];
                    model.state = [RequestErrorGrab getStringwitKey:@"state" toTarget:noticeArray];
                    NSDictionary *meta = [RequestErrorGrab getDicwitKey:@"mete" toTarget:noticeArray];
                    NSDictionary *user = [RequestErrorGrab getDicwitKey:@"user" toTarget:meta];
                    model.avatar = [RequestErrorGrab getStringwitKey:@"avatar" toTarget:user];
                    model.uid = [RequestErrorGrab getStringwitKey:@"uid" toTarget:user];
                    model.name = [RequestErrorGrab getStringwitKey:@"name" toTarget:user];
                    NSDictionary *dataa = [RequestErrorGrab getDicwitKey:@"data" toTarget:meta];
                    model.reply = [RequestErrorGrab getBooLwitKey:@"reply" toTarget:dataa];
                    model.allow = [RequestErrorGrab getBooLwitKey:@"allow" toTarget:dataa];
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
