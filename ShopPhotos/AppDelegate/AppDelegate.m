//
//  AppDelegate.m
//  ShopPhotos
//
//  Created by addcn on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonDefine.h"
#import "PublicDataAnalytic.h"
#import "HTTPRequest.h"
#import "NSObject+StoreValue.h"
#import "BaseNavigationCtr.h"
#import "LoginCtr.h"
#import "TabBarCtr.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WXApi.h>
#import <IQKeyboardManager.h>
#import "RequestErrorGrab.h"
#import "GuideViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <RongIMKit/RongIMKit.h>
#import "WXApi.h"
#import "WXApiManager.h" //wechat pay
#import "UserModel.h"
#import <AlipaySDK/AlipaySDK.h>

#import "ShareCtr.h"
#import "ShareCtr2.h"
#import "AlbumPhotosModel.h"
#import "PhotoImagesModel.h"
#import "DynamicImagesModel.h"
#import "ShareContentSelectCtr.h"
#import "DownloadImageCtr.h"
#import "DynamicQRAlert.h"
#import "DynamicCtr.h"
#import "CopyPhotoCtr.h"
#import "PersonalHomeCtr.h"

#import "SplashViewController.h"

@interface AppDelegate ()<ShareDelegate, Share2Delegate,RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate>

@property (strong, nonatomic) NSTimer * updateToken;

//Image Array for share
@property (strong, nonatomic) AlbumPhotosModel * photoModel;
@property (strong, nonatomic) ShareCtr * shareView;
@property (strong, nonatomic) ShareCtr2 * share2View;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [self initShareSDK];
    [[RCIM sharedRCIM] initWithAppKey:@"25wehl3u27juw"];
    [self getApi];
    [self pageJump];
    
    //    self.updateToken =  [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(updateTokenUse) userInfo:nil repeats:YES];
    // share
    self.shareView = GETALONESTORYBOARDPAGE(@"ShareCtr");
    self.shareView.delegate = self;

    self.share2View = GETALONESTORYBOARDPAGE(@"ShareCtr2");
    self.share2View.delegate = self;
    
    self.photoModel = [[AlbumPhotosModel alloc] init];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    return YES;
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    NSNumber *left = [notification.userInfo objectForKey:@"left"];
    if ([RCIMClient sharedRCIMClient].sdkRunningMode ==
        RCSDKRunningMode_Background &&
        0 == left.integerValue) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE),
                                                                             @(ConversationType_DISCUSSION),
                                                                             @(ConversationType_APPSERVICE),
                                                                             @(ConversationType_PUBLICSERVICE),
                                                                             @(ConversationType_GROUP)
                                                                             ]];
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        unreadMsgCount;
    }
    NSDictionary * userInfo = @{ @"totalUnreadCount": [NSString stringWithFormat:@"%@", left]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getTotalUnreadCount" object:nil userInfo:userInfo];
}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:
                              @"您的帐号在别的设备上登录，"
                              @"您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        [self loadLoginOutData];
    }
}
- (void)loadLoginOutData{
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    [self removeValueWithKey:CacheUserModel];
    [self removeValueWithKey:SESSIONCOOKKEY];
    LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
    [self setStartViewController:login];
}

- (void)updateTokenUse{
    
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
    if (congfing != nil) {
        [HTTPRequest requestPOSTUrl:congfing.updateToken parametric:nil succed:^(id responseObject){
            NSLog(@"%@",responseObject);
            NSDictionary * data = [RequestErrorGrab getDicwitKey:@"data" toTarget:responseObject];
            if(data && data.count){
                NSString * token = [RequestErrorGrab getStringwitKey:@"token" toTarget:data];
                [self setValue:token WithKey:ShopPhotosToken];
            }
            
        } failure:^(NSError * error){
        }];
    }
    NSLog(@"123");
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self updateTokenUse];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
//            NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:[resultDic objectForKey:@"memo"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
            if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"successNoti" object:@{}];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"failNoti" object:@{}];
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    } else if ([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}
#pragma mark - 初始化QQ 微信
- (void)initShareSDK{
    
    
    [ShareSDK registerApp:@"1a33d2c6eb1d8" activePlatforms:@[@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeWechat)] onImport:^(SSDKPlatformType platformType){
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo){
        switch (platformType){
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wxc5b4fa1432aef3f4"
                                      appSecret:@"8c102064749b4a7b9e6813dc2e66c964"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1105920910"
                                     appKey:@"woVPo3Vxp5WF49fi"
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}

#pragma mark -  获取Api
- (void)getApi{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",UOOTUURL,[self getParameterString]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    //    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *received, NSURLResponse *response,
                                                         NSError *error) {
                                         // handle response
                                         if(received){
                                             NSDictionary * responseObject = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
                                             NSLog(@"%@",responseObject);
                                             PublicDataAnalytic * publicData = [[PublicDataAnalytic alloc] init];
                                             [publicData analyticInterface:responseObject];
                                         }
                                     }] resume];
    
//    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",UOOTUURL,[self getParameterString]] parametric:@{} succed:^(id responseObject){
//        NSLog(@"%@",responseObject);
//    } failure:^(NSError * error){
//        NSLog(@"%@",error);
//    }];
}

- (NSString *)getParameterString{
    NSString *timestamps = TimeStamp;
    NSString *ak = ACCESS_KEY;
    NSString *dive = [self randomString:64];
    NSString *equ = @"ios";
    NSString *secret_key = SECRET_KEY;
    NSString *sign = [self md5:[NSString stringWithFormat:@"%@%@%@%@",secret_key,dive,timestamps,equ]];
    return [NSString stringWithFormat:@"?timestamps=%@&sign=%@&ak=%@&dive=%@&equ=%@",timestamps,sign,ak,dive,equ];
}
- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
- (NSString *)randomString:(int) len{
    NSString *tmpChars = @"ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz";
    NSInteger maxPos = tmpChars.length;
    NSString  *pwd = @"";
    for (int i = 0; i<len; i++) {
        NSUInteger ind =floor(arc4random() % 10 * maxPos / 10);
        NSString* tmp =[tmpChars substringWithRange:NSMakeRange(ind, 1)];
        pwd= [NSString stringWithFormat:@"%@%@",pwd,tmp];
    }
    return pwd;
}
#pragma mark -  页面跳转
- (void)pageJump{
    NSString * str = [self getValueWithKey:FirstRun];
    if([str isEqualToString:FirstRun]){

//    if([self getValueWithKey:@"CacheUserModelKeY"]){
        // 已登入
        
        SplashViewController * tabbar = [[SplashViewController alloc] init];
        [self setStartViewController:tabbar];
        
    }else{
        GuideViewController *vc=[[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
        BaseNavigationCtr * baseNaviga = [[BaseNavigationCtr alloc] initWithRootViewController:vc];
        self.window.rootViewController = baseNaviga;
        [self setValue:FirstRun WithKey:FirstRun];
    }
}
- (void)setStartViewController:(UIViewController*)vc {
    self.window.rootViewController = [[BaseNavigationCtr alloc] initWithRootViewController:vc];
//    self.window.rootViewController.view.alpha = 0.0;
    [self.window makeKeyAndVisible];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.window.rootViewController.view.alpha = 1.0;
//    }];
}

#pragma share 
- (UIView *) showShareview:(NSString *)type collected:(BOOL)isCollected model:(AlbumPhotosModel *)photoModel from:(UIViewController *)ctr {
    
    NSString * uid = [photoModel.user objectForKey:@"uid"];
    BaseViewCtr *vc = (BaseViewCtr *)ctr;
    BOOL isMyPhoto = NO;
    if(uid && uid.length > 0){
        if([vc.photosUserID isEqualToString:uid]){
            isMyPhoto = YES;
        }
    }
    
    self.photoModel = photoModel;
    self.fromCtr = ctr;
    
    DynamicCtr * dynamic = GETALONESTORYBOARDPAGE(@"DynamicCtr");
    if ([ctr isKindOfClass:dynamic.class]) {
        if (((DynamicCtr *)ctr).isMyDynamic == NO) {
            [self.window.rootViewController.view addSubview:self.shareView.view];
        }
        else{
            [self.fromCtr.view addSubview:self.shareView.view];
        }
    }
    else{
        [self.fromCtr.view addSubview:self.shareView.view];
    }

    [self.shareView setLayout:type isCollected:photoModel.collected whoisPhoto:isMyPhoto];
    [self.shareView showAlert];
    
    return self.shareView.view;
}

- (UIView *) showShare2view:(UIViewController *)ctr {
    
    self.fromCtr = ctr;
    
    [self.fromCtr.view addSubview:self.share2View.view];
    [self.share2View showAlert];
    
    return self.share2View.view;
}

#pragma mark - Share2Delegate
- (void)share2Selected:(NSInteger)type {
    
    PersonalHomeCtr *vc = (PersonalHomeCtr *)self.fromCtr;
    NSString * text = [NSString stringWithFormat:@"%@%@",URLHead,vc.uid];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:nil
                                        url:nil
                                      title:text
                                       type:SSDKContentTypeAuto];
    
    switch (type) {
        case 1: //微信好友
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
            }];
        }
            break;
        case 2:// QQ好友
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
            }];
        }
            break;
    }
}


#pragma mark - ShareDelegate
- (void)shareSelected:(NSInteger)type  {
    
    BaseViewCtr *vc = (BaseViewCtr *)self.fromCtr;
    AlbumPhotosModel * model = self.photoModel;
    NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,vc.photosUserID,model.Id];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@""
                                     images:model.cover
                                        url:[NSURL URLWithString:text]
                                      title:@"有图分享"
                                       type:SSDKContentTypeAuto];
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    
    for(NSDictionary * image in model.images){
        PhotoImagesModel * imageModel = [[PhotoImagesModel alloc] init];
        imageModel.Id = [NSString stringWithFormat:@"%ld",(long)[RequestErrorGrab getIntegetKey:@"id" toTarget:image]];
        //                model.imageLink_id = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"imageLink_id" toTarget:images]];
        imageModel.thumbnailUrl = [RequestErrorGrab getStringwitKey:@"thumbnailUrl" toTarget:image];
        imageModel.bigImageUrl = [RequestErrorGrab getStringwitKey:@"bigImageUrl" toTarget:image];
        imageModel.srcUrl = [RequestErrorGrab getStringwitKey:@"srcUrl" toTarget:image];
        imageModel.isCover = [RequestErrorGrab getBooLwitKey:@"isCover" toTarget:image];
        if (imageModel.isCover) {
            [imageArray insertObject:imageModel atIndex:0];
        }else{
            [imageArray addObject:imageModel];
        }
    }
    
    
    switch (type) {
        case 1: //微信好友
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
            }];
        }
            break;
        case 2:// 朋友圈
        {
            if ([model.type isEqualToString:@"photo"]) {
                NSMutableArray * images = [NSMutableArray array];
                for(PhotoImagesModel * imageModel in imageArray){
                    DynamicImagesModel * model = [[DynamicImagesModel alloc] init];
                    model.bigImageUrl = imageModel.bigImageUrl;
                    model.thumbnailUrl = imageModel.thumbnailUrl;
                    [images addObject:model];
                }
                UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = model.title;
                ShareContentSelectCtr * shareSelect = GETALONESTORYBOARDPAGE(@"ShareContentSelectCtr");
                shareSelect.dataArray = images;
                [vc.navigationController pushViewController:shareSelect animated:YES];

            } else {
                UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = text;
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
                }];
            }
        }
            break;
        case 3:// QQ好友
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
            }];
        }
            
            break;
        case 4:// 复制相册
        {
            NSString * uid = [model.user objectForKey:@"uid"];
            if(uid && uid.length > 0){
                if([vc.photosUserID isEqualToString:uid]){
                    [vc showToast:@"不能复制自己的相册"];
                    break;
                }
            }
            [self isPassiveUserAllow:uid fromCtr:vc modelId:model.Id];
            
        }
            break;
        case 5:// 复制链接
        {
            NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,vc.photosUserID,model.Id];
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [vc showToast:@"复制成功"];
        }
            
            break;
        case 6:// 复制标题
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = model.title;
            [vc showToast:@"复制成功"];
        }
            break;
        case 7:// 查看二维码
        {
            DynamicQRAlert *qrAlert = [[DynamicQRAlert alloc] init];
            [vc.view addSubview:qrAlert];
            qrAlert.sd_layout
            .leftEqualToView(vc.view)
            .rightEqualToView(vc.view)
            .topEqualToView(vc.view)
            .bottomEqualToView(vc.view);
            
            qrAlert.titleText = model.title;
            qrAlert.contentText = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,vc.photosUserID,model.title];
            [qrAlert showAlert];
        }
            
            break;
        case 8:// 收藏相册
        {
            NSString * uid = [model.user objectForKey:@"uid"];
            if(uid && uid.length > 0){
                if([vc.photosUserID isEqualToString:uid]){
                    [vc showToast:@"不能收藏自己的相册"];
                    break;
                }
            }
            if (model.collected == YES) {
                // cancel collect
                if ([model.type isEqualToString:@"photo"]) [self cancelCollectPhotos:@{@"photosId[0]":model.Id} fromCtr:vc];
                if ([model.type isEqualToString:@"video"]) [self cancelCollectVideos:@{@"videosId[0]":model.Id} fromCtr:vc];
                
            }
            else {
                // add collect
                if ([model.type isEqualToString:@"photo"]) [self collectPhoto:@{@"photoId":model.Id} fromCtr:vc];
                if ([model.type isEqualToString:@"video"]) [self collectVideo:@{@"videoId":model.Id} fromCtr:vc];
            }
        }
            break;
        case 9:// 下载图片
        {
            if ([model.type isEqualToString:@"photo"]) {
                DownloadImageCtr * shareSelect = GETALONESTORYBOARDPAGE(@"DownloadImageCtr");
                NSMutableArray * arrImg = [NSMutableArray array];
                for (NSDictionary * dict in model.images) {
                    DynamicImagesModel * dynamic = [[DynamicImagesModel alloc] init];
                    dynamic.Id = [[dict objectForKey:@"id"] integerValue];
                    dynamic.bigImageUrl = [dict objectForKey:@"bigImageUrl"];
                    dynamic.thumbnailUrl = [dict objectForKey:@"thumbnailUrl"];
                    dynamic.select = NO;
                    
                    [arrImg addObject:dynamic];
                }
                shareSelect.dataArray = arrImg;
                [vc.navigationController pushViewController:shareSelect animated:YES];
            }
            
            if ([model.type isEqualToString:@"video"]) {
                [vc showLoad];
//                NSData * video = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.video]];
                
                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                
                NSURL *URL = [NSURL URLWithString:model.video];
                NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                
                NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    NSLog(@"File downloaded to: %@", filePath.path);
                    UISaveVideoAtPathToSavedPhotosAlbum(filePath.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }];
                [downloadTask resume];
            }
            
        }
            break;
    }
}

- (void)isPassiveUserAllow:(NSString * )uid fromCtr:(BaseViewCtr *)vc modelId:(NSString*)modelId{
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",vc.congfing.isPassiveUserAllow,[self getParameterString]] parametric:@{@"uid":uid} succed:^(id responseObject){
        [vc closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            NSDictionary *data = [RequestErrorGrab getDicwitKey:@"data" toTarget:responseObject];
            if ([RequestErrorGrab getBooLwitKey:@"isAllow" toTarget:data]) {
                CopyPhotoCtr *copyPhoto = GETALONESTORYBOARDPAGE(@"CopyPhotoCtr");
                copyPhoto.srcPhotoId = modelId;
                [vc.navigationController pushViewController:copyPhoto animated:YES];

            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"对方设置了限制复制，是否发送请求复制" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                    
                    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",vc.congfing.sendCopyRequest,[self getParameterString]] parametric:@{@"uid":uid} succed:^(id responseObject){
                        [vc closeLoad];
                        NSLog(@"%@",responseObject);
                        BaseModel * model = [[BaseModel alloc] init];
                        [model analyticInterface:responseObject];
                        if(model.status == 0){
                            [vc showToast:@"发送请求成功"];
                            //            [vc loadNetworkData];
                        }else{
                            [vc showToast:model.message];
                        }
                    } failure:^(NSError *error){
                        [vc closeLoad];
                        [vc showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
                    }];
                    
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [vc presentViewController:alert animated:YES completion:nil];
                
            }

        }else{
            [vc showToast:model.message];
        }

    } failure:^(NSError *error){
        [vc closeLoad];
        [vc showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)cancelCollectPhotos:(NSDictionary * )data fromCtr:(BaseViewCtr *)vc {
    
    [vc showLoad];
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",vc.congfing.cancelCollectPhotos,[self getParameterString]] parametric:data succed:^(id responseObject){
        [vc closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [vc showToast:@"取消收藏成功"];
            [vc viewWillAppear:YES];
//            [vc loadNetworkData];
        }else{
            [vc showToast:model.message];
        }
    } failure:^(NSError *error){
        [vc closeLoad];
        [vc showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)cancelCollectVideos:(NSDictionary * )data fromCtr:(BaseViewCtr *)vc{
    
    [vc showLoad];
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",vc.congfing.cancelCollectVideos,[self getParameterString]] parametric:data succed:^(id responseObject){
        [vc closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [vc showToast:@"取消收藏成功"];
            [vc viewWillAppear:YES];
//            [weakSelef loadNetworkData];
        }else{
            [vc showToast:model.message];
        }
    } failure:^(NSError *error){
        [vc closeLoad];
        [vc showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)collectPhoto:(NSDictionary *)data fromCtr:(BaseViewCtr *)vc{
    
    [vc showLoad];
    
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",vc.congfing.collectPhoto,[self getParameterString]] parametric:data succed:^(id responseObject){
        [vc closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [vc showToast:@"收藏成功"];
            [vc viewWillAppear:YES];
//            [vc loadNetworkData];
        }else{
            [vc showToast:model.message];
        }
    } failure:^(NSError *error){
        [vc closeLoad];
        [vc showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)collectVideo:(NSDictionary *)data fromCtr:(BaseViewCtr *)vc{
    
    [vc showLoad];
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",vc.congfing.collectVideo,[self getParameterString]] parametric:data succed:^(id responseObject){
        [vc closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [vc showToast:@"收藏成功"];
            [vc viewWillAppear:YES];
//            [vc loadNetworkData];
        }else{
            [vc showToast:model.message];
        }
    } failure:^(NSError *error){
        [vc closeLoad];
        [vc showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    BaseViewCtr *vc = (BaseViewCtr *)self.fromCtr;
    [vc closeLoad];
    
    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
        [vc showToast:@"下载失败"];
    } else {
        NSLog(@"saved");
        [vc showToast:@"下载完成"];
    }
}

@end
