//
//  PublicDataAnalytic.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PublicDataAnalytic.h"
#import "RequestErrorGrab.h"
#import "CongfingURL.h"
#import "NSObject+StoreValue.h"



@implementation PublicDataAnalytic

- (void)analyticInterface:(NSDictionary *)data{
    
    //NSLog(@"%@",data);
    
    @try {
        
        self.status = [RequestErrorGrab getIntegetKey:@"code" toTarget:data];
        self.message = [RequestErrorGrab getStringwitKey:@"message" toTarget:data];
        
        if(self.status) return;
        
        CongfingURL * congfing = [[CongfingURL alloc] init];

        NSDictionary *datas = [RequestErrorGrab getDicwitKey:@"data" toTarget:data];
        if(datas && datas.count > 0){
           NSDictionary * app = [RequestErrorGrab getDicwitKey:@"app" toTarget:datas];
            congfing.token = [RequestErrorGrab getStringwitKey:@"token" toTarget:app];
            if(app && app.count > 0){
                NSDictionary * api = [RequestErrorGrab getDicwitKey:@"api" toTarget:app];
                congfing.appLogin = [RequestErrorGrab getStringwitKey:@"appLogin" toTarget:api];
                congfing.authTel = [RequestErrorGrab getStringwitKey:@"authTel" toTarget:api];
                congfing.registerUser  = [RequestErrorGrab getStringwitKey:@"registerUser" toTarget:api];
                congfing.sendAuthCode = [RequestErrorGrab getStringwitKey:@"sendAuthCode" toTarget:api];
                congfing.resetPassword2 = [RequestErrorGrab getStringwitKey:@"resetPassword2" toTarget:api];
                congfing.getUserInfo = [RequestErrorGrab getStringwitKey:@"getUserInfo" toTarget:api];
                congfing.getCount = [RequestErrorGrab getStringwitKey:@"getCount" toTarget:api];
                congfing.getNewDynamics = [RequestErrorGrab getStringwitKey:@"getNewDynamics" toTarget:api];
                congfing.publishedFeedback = [RequestErrorGrab getStringwitKey:@"publishedFeedback" toTarget:api];
                congfing.getPhotoClassifies = [RequestErrorGrab getStringwitKey:@"getPhotoClassifies" toTarget:api];
                congfing.getUsers = [RequestErrorGrab getStringwitKey:@"getUsers" toTarget:api];
                congfing.getPhotos = [RequestErrorGrab getStringwitKey:@"getPhotos" toTarget:api];
                congfing.getRecommendPhotos = [RequestErrorGrab getStringwitKey:@"getRecommendPhotos" toTarget:api];
                congfing.batchPhotos = [RequestErrorGrab getStringwitKey:@"batchPhotos" toTarget:api];
                congfing.deletePhotos = [RequestErrorGrab getStringwitKey:@"deletePhotos" toTarget:api];
                congfing.getNotices = [RequestErrorGrab getStringwitKey:@"getNotices" toTarget:api];
                congfing.deleteNotices = [RequestErrorGrab getStringwitKey:@"deleteNotices" toTarget:api];
                congfing.getCollectPhotos = [RequestErrorGrab getStringwitKey:@"getCollectPhotos" toTarget:api];
                congfing.concernUser = [RequestErrorGrab getStringwitKey:@"concernUser" toTarget:api];
                congfing.allowUser = [RequestErrorGrab getStringwitKey:@"allowUser" toTarget:api];
                congfing.getLatestAppVersion = [RequestErrorGrab getStringwitKey:@"getLatestAppVersion" toTarget:api];
                congfing.resetPassword = [RequestErrorGrab getStringwitKey:@"resetPassword" toTarget:api];
                congfing.handleChangeConfig = [RequestErrorGrab getStringwitKey:@"handleChangeConfig" toTarget:api];
                congfing.deleteSubclassifications = [RequestErrorGrab getStringwitKey:@"deleteSubclassifications" toTarget:api];
                congfing.deleteClassify = [RequestErrorGrab getStringwitKey:@"deleteClassify" toTarget:api];
                congfing.updateClassify = [RequestErrorGrab getStringwitKey:@"updateClassify" toTarget:api];
                congfing.updateSubclassification = [RequestErrorGrab getStringwitKey:@"updateSubclassification" toTarget:api];
                congfing.createClassifies = [RequestErrorGrab getStringwitKey:@"createClassifies" toTarget:api];
                congfing.cancelStarUser = [RequestErrorGrab getStringwitKey:@"cancelStarUser" toTarget:api];
                congfing.starUser = [RequestErrorGrab getStringwitKey:@"starUser" toTarget:api];
                congfing.cancelConcern = [RequestErrorGrab getStringwitKey:@"cancelConcern" toTarget:api];
                congfing.getDetailPhoto = [RequestErrorGrab getStringwitKey:@"getDetailPhoto" toTarget:api];
                congfing.getPhotoImages = [RequestErrorGrab getStringwitKey:@"getPhotoImages" toTarget:api];
                congfing.getPhotoDescription = [RequestErrorGrab getStringwitKey:@"getPhotoDescription" toTarget:api];
                congfing.setCover = [RequestErrorGrab getStringwitKey:@"setCover" toTarget:api];
                congfing.removeImageLinks = [RequestErrorGrab getStringwitKey:@"removeImageLinks" toTarget:api];
                congfing.photoUpdates = [RequestErrorGrab getStringwitKey:@"photoUpdates" toTarget:api];
                congfing.updatePhoto = [RequestErrorGrab getStringwitKey:@"updatePhoto" toTarget:api];
                congfing.getSubclassificationPhotos = [RequestErrorGrab getStringwitKey:@"getSubclassificationPhotos" toTarget:api];
                congfing.appLogout = [RequestErrorGrab getStringwitKey:@"appLogout" toTarget:api];
                congfing.getConcernsPhotos = [RequestErrorGrab getStringwitKey:@"getConcernsPhotos" toTarget:api];
                congfing.searchUsers = [RequestErrorGrab getStringwitKey:@"searchUsers" toTarget:api];
                congfing.searchSummary = [RequestErrorGrab getStringwitKey:@"searchSummary" toTarget:api];
                congfing.withImageSearch = [RequestErrorGrab getStringwitKey:@"withImageSearch" toTarget:api];
                congfing.createPhoto = [RequestErrorGrab getStringwitKey:@"createPhoto" toTarget:api];
                congfing.handleImagesName = [RequestErrorGrab getStringwitKey:@"handleImagesName" toTarget:api];
                congfing.mobileSavePhoto = [RequestErrorGrab getStringwitKey:@"mobileSavePhoto" toTarget:api];
           
                congfing.updateUserInfo = [RequestErrorGrab getStringwitKey:@"updateUserInfo" toTarget:api];
                congfing.getSubclasses = [RequestErrorGrab getStringwitKey:@"getSubclasses" toTarget:api];
                congfing.isAllow = [RequestErrorGrab getStringwitKey:@"isAllow" toTarget:api];
                congfing.hasCollectPhoto = [RequestErrorGrab getStringwitKey:@"hasCollectPhoto" toTarget:api];
                congfing.collectPhotos = [RequestErrorGrab getStringwitKey:@"collectPhotos" toTarget:api];
                
                congfing.cancelCollectPhotos = [RequestErrorGrab getStringwitKey:@"cancelCollectPhotos" toTarget:api];
                congfing.collssssCopy = [RequestErrorGrab getStringwitKey:@"collectPhotos" toTarget:api];
                congfing.setIcon = [RequestErrorGrab getStringwitKey:@"setIcon" toTarget:api];
                congfing.appWithWeChatLogin = [RequestErrorGrab getStringwitKey:@"appWithWeChatLogin" toTarget:api];
                congfing.appWithQQLogin = [RequestErrorGrab getStringwitKey:@"appWithQQLogin" toTarget:api];
                congfing.activeAccount = [RequestErrorGrab getStringwitKey:@"activeAccount" toTarget:api];
                congfing.updateToken = [RequestErrorGrab getStringwitKey:@"updateToken" toTarget:api];
                congfing.sendCopyRequest = [RequestErrorGrab getStringwitKey:@"sendCopyRequest" toTarget:api];
                
            }
            
        }

        [self setValue:congfing WithKey:ShopPhotosApi];
        
    } @catch (NSException *exception) {

        
    }
}

@end
