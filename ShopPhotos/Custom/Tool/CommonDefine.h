//
//
//
//  功能:常用宏定义
//  时间:2016.8.18
//  开发:廖检成
//

// 打印日志
#ifdef DEBUG

#define Log(...) NSLog(@"%s 第%d行 \n %@ \n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else

#define Log(...)

#endif

// 屏幕宽度
#define WindowWidth     [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define WindowHeight    [UIScreen mainScreen].bounds.size.height
// NavBar高度
#define NavigationBarHeight 44
// tabbar高度
#define TabBarHeight 49
// 通知中心
#define NotificationCenter [NSNotificationCenter defaultCenter]

// 接口
#define UOOTUURL @"https://m.uootu.com/get/app/index/initial/data/center/android"
// 主题颜色
#define ThemeColor [UIColor colorWithRed:1 green:84/255.0 blue:0/255.0 alpha:1.0]
// 一级色
#define ONECALLSCOLOR [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
// 二级色
#define TOWCALLSCOLOR [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0]
// 三级色
#define THREECALLSCOLOR [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0]
// 四级色
#define FOURCALLSCOLOR [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0]
// 颜色设置RBG
#define ColorRgb(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 颜色设置RBG alpha值
#define ColorRgbA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
// 颜色设置RBG(16进制)
#define ColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]
// 颜色设置RBG alpha值(16进制)
#define ColorHexA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
// 引用计算
#define RetainCount(obj) CFGetRetainCount((__bridge CFTypeRef)obj)
// 读取本地图片
#define LoadImage(file,ext) [UIImage imageWithContentsOfFile:［NSBundle mainBundle]pathForResource:file ofType:ext］
#define ImageNamed(file) [UIImage imageNamed:[UIUtil imageName:fileName]
// 字体大小
#define Font(size) [UIFont systemFontOfSize:size]
// 字体加粗
#define FontBold(size) [UIFont fontWithName:@"Helvetica-Bold" size:size]
// 显示普通提示AlertView
#define ShowAlert(msg) [[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]
// 获取Storyboard 上页面
#define GETSTORYBOARD_MAIN_PAGE(identifier) [[UIStoryboard storyboardWithName:@"Platform" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier]

#define GETALONESTORYBOARDPAGE(identifier)[[UIStoryboard storyboardWithName:identifier bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier]

#define NETWORKTIPS @"网络加载失败"

/**
 *  适配机型
 *
 */


#define iPHone6Plus ([UIScreen mainScreen].bounds.size.height == 736) ? YES : NO

#define iPHone6 ([UIScreen mainScreen].bounds.size.height == 667) ? YES : NO

#define iPHone5 ([UIScreen mainScreen].bounds.size.height == 568) ? YES : NO

#define iPHone4oriPHone4s ([UIScreen mainScreen].bounds.size.height == 480) ? YES : NO


#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/**
 *  屏幕宽
 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

/**
 *  屏幕高
 */
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

