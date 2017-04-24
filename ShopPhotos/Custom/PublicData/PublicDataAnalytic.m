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
//           NSDictionary * app = [RequestErrorGrab getDicwitKey:@"app" toTarget:datas];
//            congfing.token = [RequestErrorGrab getStringwitKey:@"token" toTarget:app];
//            if(app && app.count > 0){
                NSDictionary * api = [RequestErrorGrab getDicwitKey:@"api" toTarget:datas];
                congfing.bindAccount = [RequestErrorGrab getStringwitKey:@"bindAccount" toTarget:api];
                congfing.bindEmail1 = [RequestErrorGrab getStringwitKey:@"bindEmail1" toTarget:api];
                congfing.bindEmail2 = [RequestErrorGrab getStringwitKey:@"bindEmail2" toTarget:api];
                congfing.forgotPassword1 = [RequestErrorGrab getStringwitKey:@"forgotPassword1" toTarget:api];
                congfing.forgotPassword2 = [RequestErrorGrab getStringwitKey:@"forgotPassword2" toTarget:api];
                congfing.forgotPassword3 = [RequestErrorGrab getStringwitKey:@"forgotPassword3" toTarget:api];
                congfing.getCaptcha = [RequestErrorGrab getStringwitKey:@"getCaptcha" toTarget:api];
                congfing.login = [RequestErrorGrab getStringwitKey:@"login" toTarget:api];
                congfing.logout = [RequestErrorGrab getStringwitKey:@"logout" toTarget:api];
                congfing.register1 = [RequestErrorGrab getStringwitKey:@"register1" toTarget:api];
                congfing.register2 = [RequestErrorGrab getStringwitKey:@"register2" toTarget:api];
                congfing.register3 = [RequestErrorGrab getStringwitKey:@"register3" toTarget:api];
                congfing.updatePassword = [RequestErrorGrab getStringwitKey:@"updatePassword" toTarget:api];
                congfing.useQQLogin = [RequestErrorGrab getStringwitKey:@"useQQLogin" toTarget:api];
                congfing.useWXLogin = [RequestErrorGrab getStringwitKey:@"useWXLogin" toTarget:api];
                congfing.getUserInfo = [RequestErrorGrab getStringwitKey:@"getUserInfo" toTarget:api];
                congfing.updateUserImage = [RequestErrorGrab getStringwitKey:@"updateUserImage" toTarget:api];
                congfing.updateUserInfo = [RequestErrorGrab getStringwitKey:@"updateUserInfo" toTarget:api];
                congfing.updateUserSetting = [RequestErrorGrab getStringwitKey:@"updateUserSetting" toTarget:api];
            
                congfing.appLogin = [RequestErrorGrab getStringwitKey:@"appLogin" toTarget:api];
                congfing.captcha = [RequestErrorGrab getStringwitKey:@"captcha" toTarget:api];
                congfing.authTel = [RequestErrorGrab getStringwitKey:@"authTel" toTarget:api];
                congfing.registerUser  = [RequestErrorGrab getStringwitKey:@"registerUser" toTarget:api];
                congfing.sendAuthCode = [RequestErrorGrab getStringwitKey:@"sendAuthCode" toTarget:api];
                congfing.resetPassword2 = [RequestErrorGrab getStringwitKey:@"resetPassword2" toTarget:api];
                congfing.getCount = [RequestErrorGrab getStringwitKey:@"getCount" toTarget:api];
                congfing.getNewDynamics = [RequestErrorGrab getStringwitKey:@"getNewDynamics" toTarget:api];
                congfing.publishedFeedback = [RequestErrorGrab getStringwitKey:@"publishedFeedback" toTarget:api];
                congfing.getClassifies = [RequestErrorGrab getStringwitKey:@"getClassifies" toTarget:api];
                congfing.getUsers = [RequestErrorGrab getStringwitKey:@"getUsers" toTarget:api];
                congfing.getUserPhotos = [RequestErrorGrab getStringwitKey:@"getUserPhotos" toTarget:api];
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
                congfing.deleteClassify = [RequestErrorGrab getStringwitKey:@"deleteClassify" toTarget:api];
                congfing.deleteClassifies = [RequestErrorGrab getStringwitKey:@"deleteClassifies" toTarget:api];
                congfing.deleteSubclass = [RequestErrorGrab getStringwitKey:@"deleteSubclass" toTarget:api];
                congfing.deleteSubclasses = [RequestErrorGrab getStringwitKey:@"deleteSubclasses" toTarget:api];
                congfing.updateClassify = [RequestErrorGrab getStringwitKey:@"updateClassify" toTarget:api];
                congfing.updateSubclass = [RequestErrorGrab getStringwitKey:@"updateSubclass" toTarget:api];
                congfing.updateSubclassification = [RequestErrorGrab getStringwitKey:@"updateSubclassification" toTarget:api];
                congfing.createClassify = [RequestErrorGrab getStringwitKey:@"createClassify" toTarget:api];
                congfing.createSubclass = [RequestErrorGrab getStringwitKey:@"createSubclass" toTarget:api];
                congfing.cancelStarUser = [RequestErrorGrab getStringwitKey:@"cancelStarUser" toTarget:api];
                congfing.starUser = [RequestErrorGrab getStringwitKey:@"starUser" toTarget:api];
                congfing.cancelConcern = [RequestErrorGrab getStringwitKey:@"cancelConcern" toTarget:api];
                congfing.getPhoto = [RequestErrorGrab getStringwitKey:@"getPhoto" toTarget:api];
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
                congfing.createPhoto1 = [RequestErrorGrab getStringwitKey:@"createPhoto1" toTarget:api];
                congfing.createPhoto2 = [RequestErrorGrab getStringwitKey:@"createPhoto2" toTarget:api];
                congfing.createPhoto3 = [RequestErrorGrab getStringwitKey:@"createPhoto3" toTarget:api];
                congfing.createVideo1 = [RequestErrorGrab getStringwitKey:@"createVideo1" toTarget:api];
                congfing.createVideo2 = [RequestErrorGrab getStringwitKey:@"createVideo1" toTarget:api];
                congfing.createVideo3 = [RequestErrorGrab getStringwitKey:@"createVideo1" toTarget:api];
                congfing.addImageToPhoto1 = [RequestErrorGrab getStringwitKey:@"addImageToPhoto1" toTarget:api];
                congfing.addImageToPhoto2 = [RequestErrorGrab getStringwitKey:@"addImageToPhoto2" toTarget:api];
                congfing.addImageToPhoto3 = [RequestErrorGrab getStringwitKey:@"addImageToPhoto3" toTarget:api];
                congfing.handleImagesName = [RequestErrorGrab getStringwitKey:@"handleImagesName" toTarget:api];
                congfing.mobileSavePhoto = [RequestErrorGrab getStringwitKey:@"mobileSavePhoto" toTarget:api];
           
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
                
//            }
//            
        }

        [self setValue:congfing WithKey:ShopPhotosApi];
        
    } @catch (NSException *exception) {

        
    }
}

@end
