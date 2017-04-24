//
//  CongfingURL.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ShopPhotosApi @"ShopPhotosApi"
#define ShopPhotosToken @"ShopPhotosToken"

@interface CongfingURL : NSObject

//----------------------tcg-------------------------//
@property (strong, nonatomic) NSString * bindAccount;
@property (strong, nonatomic) NSString * bindEmail1;
@property (strong, nonatomic) NSString * bindEmail2;
@property (strong, nonatomic) NSString * forgotPassword1;
@property (strong, nonatomic) NSString * forgotPassword2;
@property (strong, nonatomic) NSString * forgotPassword3;
@property (strong, nonatomic) NSString * login;
@property (strong, nonatomic) NSString * logout;
@property (strong, nonatomic) NSString * getCaptcha;
@property (strong, nonatomic) NSString * register1;
@property (strong, nonatomic) NSString * register2;
@property (strong, nonatomic) NSString * register3;
@property (strong, nonatomic) NSString * updatePassword;
@property (strong, nonatomic) NSString * useQQLogin;
@property (strong, nonatomic) NSString * useWXLogin;
// 获取用户信息
@property (strong, nonatomic) NSString * getUserInfo;
@property (strong, nonatomic) NSString * updateUserImage;
@property (strong, nonatomic) NSString * updateUserSetting;
@property (strong, nonatomic) NSString * updateUserInfo;

//----------------------tcg-------------------------//
@property (strong, nonatomic) NSString * token;
// 用户登入
@property (strong, nonatomic) NSString * appLogin;
// 发送验证码 验证验证码
@property (strong, nonatomic) NSString * captcha;
@property (strong, nonatomic) NSString * authTel;
// 注册
@property (strong, nonatomic) NSString * registerUser;
// 忘记密码 发送手机 邮箱验证码
@property (strong, nonatomic) NSString * sendAuthCode;
// 忘记密码 找回密码
@property (strong, nonatomic) NSString * resetPassword2;
// 获取消息 收藏 数量
@property (strong, nonatomic) NSString * getCount;
// 获取用户动态
@property (strong, nonatomic) NSString * getNewDynamics;
// 用户反馈提交
@property (strong, nonatomic) NSString * publishedFeedback;
// 获取用户相册分类、子分类
@property (strong, nonatomic) NSString * getClassifies;
// 被谁允许复制，被谁关注，允许谁复制，关注了谁 列表
@property (strong, nonatomic) NSString * getUsers;
// 获取用户相册
@property (strong, nonatomic) NSString * getUserPhotos;
// 获取用户推荐相册
@property (strong, nonatomic) NSString * getRecommendPhotos;
// 批量更新相册的属性
@property (strong, nonatomic) NSString * batchPhotos;
// 获取消息列表
@property (strong, nonatomic) NSString * getNotices;
// 删除消息
@property (strong, nonatomic) NSString * deleteNotices;
// 获取收藏列表
@property (strong, nonatomic) NSString * getCollectPhotos;
// 关注用户
@property (strong, nonatomic) NSString * concernUser;
// 同意复制请求
@property (strong, nonatomic) NSString * allowUser;
// 检测版本更新
@property (strong, nonatomic) NSString * getLatestAppVersion;
// 修改旧密码
@property (strong, nonatomic) NSString * resetPassword;
// 修改设置
@property (strong, nonatomic) NSString * handleChangeConfig;
// 删除子分类
@property (strong, nonatomic) NSString * deleteSubclasses;
@property (strong, nonatomic) NSString * deleteSubclass;
// 删除分类
@property (strong, nonatomic) NSString * deleteClassify;
@property (strong, nonatomic) NSString * deleteClassifies;
// 批量创建分类
@property (strong, nonatomic) NSString * createClassify;
@property (strong, nonatomic) NSString * createSubclass;
// 取消特别关注
@property (strong, nonatomic) NSString * cancelStarUser;
// 添加特别关注
@property (strong, nonatomic) NSString * starUser;
// 取消关注
@property (strong, nonatomic) NSString * cancelConcern;
// 获取相册详情
@property (strong, nonatomic) NSString * getPhoto;
// 获取相册所有图片
@property (strong, nonatomic) NSString * getPhotoImages;
// 获取相册备注
@property (strong, nonatomic) NSString * getPhotoDescription;
// 设置相册封面
@property (strong, nonatomic) NSString * setCover;
// 删除相册图片
@property (strong, nonatomic) NSString * removeImageLinks;
// 更新相册
@property (strong, nonatomic) NSString * updatePhoto;
// 获取子类相册列表
@property (strong, nonatomic) NSString * getSubclassificationPhotos;
// 退出登入
@property (strong, nonatomic) NSString * appLogout;
// 获取关注的相册
@property (strong, nonatomic) NSString * getConcernsPhotos;
// 搜索用户
@property (strong, nonatomic) NSString * searchUsers;
// 搜索
@property (strong, nonatomic) NSString * searchSummary;
// 图片识别搜索
@property (strong, nonatomic) NSString * withImageSearch;
// 创建相册
@property (strong, nonatomic) NSString * createPhoto1;
@property (strong, nonatomic) NSString * createPhoto2;
@property (strong, nonatomic) NSString * createPhoto3;
@property (strong, nonatomic) NSString * addImageToPhoto1;
@property (strong, nonatomic) NSString * addImageToPhoto2;
@property (strong, nonatomic) NSString * addImageToPhoto3;
@property (strong, nonatomic) NSString * createVideo1;
@property (strong, nonatomic) NSString * createVideo2;
@property (strong, nonatomic) NSString * createVideo3;
// 上传文件名
@property (strong, nonatomic) NSString * handleImagesName;
// 上传图片
@property (strong, nonatomic) NSString * mobileSavePhoto;
// 获取父分类
@property (strong, nonatomic) NSString * getSubclasses;
// 取消收藏相册
@property (strong, nonatomic) NSString * cancelCollectPhotos;
// 收藏相册
@property (strong, nonatomic) NSString * collectPhotos;
@property (strong, nonatomic) NSString * collssssCopy;
// 修改用户头像
@property (strong, nonatomic) NSString * setIcon;
// 微信登入
@property (strong, nonatomic) NSString * appWithWeChatLogin;
// QQ登入
@property (strong, nonatomic) NSString * appWithQQLogin;
// 更新token
@property (strong, nonatomic) NSString * updateToken;




@property (strong, nonatomic) NSString * activeAccount;
@property (strong, nonatomic) NSString * addImage;
@property (strong, nonatomic) NSString * addImageToMaLong;
@property (strong, nonatomic) NSString * advancedSearch;
@property (strong, nonatomic) NSString * androidUpdateUserInfo;
@property (strong, nonatomic) NSString * batchUpdateClassifies;
@property (strong, nonatomic) NSString * clearImages;
@property (strong, nonatomic) NSString * clearTempPhoto;
@property (strong, nonatomic) NSString * photoUpdates;
@property (strong, nonatomic) NSString * createClassifies2;
@property (strong, nonatomic) NSString * createGetClassifies;
@property (strong, nonatomic) NSString * createImagesLink;
@property (strong, nonatomic) NSString * createMoment;
@property (strong, nonatomic) NSString * deleteMoments;
@property (strong, nonatomic) NSString * deletePhoto;
@property (strong, nonatomic) NSString * deletePhotos;
@property (strong, nonatomic) NSString * downloadPageUrl;
@property (strong, nonatomic) NSString * forwardingToMoment;
@property (strong, nonatomic) NSString * forwardingToPhoto;
@property (strong, nonatomic) NSString * getAllNewDynamics;
@property (strong, nonatomic) NSString * getCapacity;
@property (strong, nonatomic) NSString * getConcernMoments;
@property (strong, nonatomic) NSString * getMoments;
@property (strong, nonatomic) NSString * getSubclassCover;
@property (strong, nonatomic) NSString * handleRecommends;
@property (strong, nonatomic) NSString * hasCollectPhoto;
@property (strong, nonatomic) NSString * index;
@property (strong, nonatomic) NSString * isAllow;
@property (strong, nonatomic) NSString * logoUrl;
@property (strong, nonatomic) NSString * momentAddImage;
@property (strong, nonatomic) NSString * momentRemoveImage;
@property (strong, nonatomic) NSString * qqAuth;
@property (strong, nonatomic) NSString * saveMoment;
@property (strong, nonatomic) NSString * savePhoto;
@property (strong, nonatomic) NSString * sendCopyRequest;
@property (strong, nonatomic) NSString * uLogin;
@property (strong, nonatomic) NSString * updateClassifies;
@property (strong, nonatomic) NSString * updateClassify;
@property (strong, nonatomic) NSString * updatePhotoName;
@property (strong, nonatomic) NSString * updatePrice;
@property (strong, nonatomic) NSString * updateSubclass;
@property (strong, nonatomic) NSString * updateSubclassification;
@property (strong, nonatomic) NSString * uploadToken;
@property (strong, nonatomic) NSString * weChatAuth;
@property (strong, nonatomic) NSString * webLogin;
@property (strong, nonatomic) NSString * webLogout;

@end
