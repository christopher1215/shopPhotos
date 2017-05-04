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
@interface AppDelegate ()

@property (strong, nonatomic) NSTimer * updateToken;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    
    [self initShareSDK];
    [[RCIM sharedRCIM] initWithAppKey:@"25wehl3u27juw"];
    
    [self getApi];
    
    [self pageJump];
    
    //    self.updateToken =  [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(updateTokenUse) userInfo:nil repeats:YES];
    return YES;
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
                [appInfo SSDKSetupWeChatByAppId:@"wx86f699c5f590353b"
                                      appSecret:@"43c01a63924019454bfc7e21380a5430"];
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
    GuideViewController *vc=[[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
    BaseNavigationCtr * baseNaviga = [[BaseNavigationCtr alloc] initWithRootViewController:vc];
    self.window.rootViewController = baseNaviga;
}
- (void)setStartViewController:(UIViewController*)vc {
    self.window.rootViewController = [[BaseNavigationCtr alloc] initWithRootViewController:vc];
    self.window.rootViewController.view.alpha = 0.0;
    [self.window makeKeyAndVisible];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.window.rootViewController.view.alpha = 1.0;
    }];
}
@end
