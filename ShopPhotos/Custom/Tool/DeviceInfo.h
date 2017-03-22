//
//
//  功能：获取用户设备相关信息
//  开发：Stanley
//  时间：2016.11.2
//
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

// 设备昵称
@property (strong, nonatomic) NSString * name;
// 设备类型 iphon/iPad
@property (strong, nonatomic) NSString * type;
// 设备系统版本
@property (strong, nonatomic) NSString * systemVersion;
// 设备唯一码
@property (strong, nonatomic) NSString * UUID;

@end
