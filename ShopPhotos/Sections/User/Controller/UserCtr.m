//
//  UserCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "UserCtr.h"
#import "UserInfoModel.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "QRCodeAlert.h"
#import "AppDelegate.h"
#import "FeedbackCtr.h"
#import "LoginCtr.h"
#import "RequestUtil.h"
#import <MJPhotoBrowser.h>
#import "UserModel.h"
#import "NSObject+StoreValue.h"
#import "UserShareAlert.h"
#import <ShareSDK/ShareSDK.h>
#import "PhotosController.h"
#import <TZImagePickerController.h>
#import <TOCropViewController.h>
#import "ErrMsgViewController.h"

#import "UserUpdateViewController.h"
#import "BindEmailViewController.h"

@interface UserCtr ()<UITableViewDelegate,UserShareAlertDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,TOCropViewControllerDelegate>{
}
@property (strong, nonatomic) QRCodeAlert * qrAlert;
@property (strong, nonatomic) UserShareAlert * shareAlert;
@property (strong, nonatomic) ErrMsgViewController * popupErrVC;

@end

@implementation UserCtr

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup{
    
    self.popupErrVC = [[ErrMsgViewController alloc] initWithNibName:@"ErrMsgViewController" bundle:nil];
    self.firstFlag = YES;
    
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.icon addTarget:self action:@selector(iconSelected)];
    [self.head addTarget:self action:@selector(headSelected)];
    [self.qrView addTarget:self action:@selector(qrViewSelected)];
    [self.feedback addTarget:self action:@selector(feedbackSelected)];
    [self.loginOut addTarget:self action:@selector(loginoutSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.viewName addTarget:self action:@selector(nameSelected)];
    [self.viewSign addTarget:self action:@selector(signSelected)];
    [self.viewQQ addTarget:self action:@selector(qqSelected)];
    [self.viewWechat addTarget:self action:@selector(wechatSelected)];
    [self.viewPhone addTarget:self action:@selector(phoneSelected)];
    [self.viewAddress addTarget:self action:@selector(addressSelected)];
    [self.viewEmail addTarget:self action:@selector(emailSelected)];
    
    __weak __typeof(self)weakSelef = self;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelef loadNetworkData:@{@"uid":weakSelef.photosUserID}];
    }];
//    [self.table.mj_header beginRefreshing];
    
    [self.edit addTarget:self action:@selector(editSelected)];
    
    self.qrAlert = [[QRCodeAlert alloc] init];
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self.qrAlert];
    self.qrAlert.sd_layout
    .leftEqualToView(appDelegate.window)
    .rightEqualToView(appDelegate.window)
    .rightEqualToView(appDelegate.window)
    .bottomEqualToView(appDelegate.window);
    [self.qrAlert setHidden:YES];
    
    self.shareAlert = [[UserShareAlert alloc] init];
    self.shareAlert.delegate = self;
    [appDelegate.window addSubview:self.shareAlert];
    self.shareAlert.sd_layout
    .leftEqualToView(appDelegate.window)
    .rightEqualToView(appDelegate.window)
    .rightEqualToView(appDelegate.window)
    .bottomEqualToView(appDelegate.window);
    [self.shareAlert setHidden:YES];
    
    [self.edit setImage:[UIImage imageNamed:@"btn_edit_black"]];
    
    [self.nameText setHidden:NO];
    [self.signatureText setHidden:NO];
    [self.qqText setHidden:NO];
    [self.chatText setHidden:NO];
    [self.phone setHidden:NO];
    [self.locationText setHidden:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    if (self.firstFlag) {
        [self.table.mj_header beginRefreshing];
        self.firstFlag = YES;
    }
    

}
//- (void)initData{
//    NSDictionary *dic = [self getValueWithKey:CacheUserModel];
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon]];
//    self.iconURL = model.icon;
//    [self.nameText setText:model.name];
//    [self.signatureText setText:model.signature];
//    [self.qqText setText:model.qq];
//    [self.chatText setText:model.weixin];
//    [self.phone setText:model.tel];
//    [self.locationText setText:model.address];
//    
//    [self.nameEdit setText:model.name];
//    [self.signatureEdit setText:model.signature];
//    [self.qqEidt setText:model.qq];
//    [self.chatEdit setText:model.weixin];
//    [self.phoenEdit setText:model.tel];
//    [self.locationEdit setText:model.address];
//    [self.homeText setText:[NSString stringWithFormat:@"%@%@",URLHead,model.uid]];
//}

- (void)changeStatu:(BOOL)statu{
    
    if(statu){
        [self.edit setImage:[UIImage imageNamed:@"ico_confirm_black"]];
        [self.nameText setHidden:YES];
        [self.signatureText setHidden:YES];
        [self.qqText setHidden:YES];
        [self.chatText setHidden:YES];
        [self.phone setHidden:YES];
        [self.locationText setHidden:YES];
        
    }else{
        [self.edit setImage:[UIImage imageNamed:@"btn_edit_black"]];
        
        [self.nameText setHidden:NO];
        [self.signatureText setHidden:NO];
        [self.qqText setHidden:NO];
        [self.chatText setHidden:NO];
        [self.phone setHidden:NO];
        [self.locationText setHidden:NO];
        
        
        
    }
}

- (IBAction)onUpdate:(id)sender {
    [self updateUserInfo:@{@"name":self.nameText.text,
                           @"signature":self.signatureText.text,
                           @"qq":self.qqText.text,
                           @"wechat":self.chatText.text,
                           @"phone":self.phone.text,
                           @"address":self.locationText.text}];
}

#pragma mark - OnClick
- (void)editSelected{
    self.changeStatu = !self.changeStatu;
    [self changeStatu:self.changeStatu];
}

- (void)homeSelected{
    [self.shareAlert showAlert];
}

- (void)iconSelected{
    NSMutableArray *photos = [NSMutableArray array];
    MJPhoto *photo = [[MJPhoto alloc] init];
    if(self.iconURL){
        photo.url = [NSURL URLWithString:self.iconURL];
        [photos addObject:photo];
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0;
        browser.photos = photos;
        [browser show];
    }
}

- (void)headSelected{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        SPAlert(@"请允许相册访问",self);
        return;
    }
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];

}
- (void)nameSelected{
    UserUpdateViewController *vc=[[UserUpdateViewController alloc] initWithNibName:@"UserUpdateViewController" bundle:nil];
    vc.type = 0;
    vc.parentVC = self;
    vc.value = _nameText.text;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)signSelected{
    UserUpdateViewController *vc=[[UserUpdateViewController alloc] initWithNibName:@"UserUpdateViewController" bundle:nil];
    vc.type = 1;
    vc.parentVC = self;
    vc.value = _signatureText.text;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)qqSelected{
    UserUpdateViewController *vc=[[UserUpdateViewController alloc] initWithNibName:@"UserUpdateViewController" bundle:nil];
    vc.type = 2;
    vc.parentVC = self;
    vc.value = _qqText.text;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)wechatSelected{
    UserUpdateViewController *vc=[[UserUpdateViewController alloc] initWithNibName:@"UserUpdateViewController" bundle:nil];
    vc.type = 3;
    vc.parentVC = self;
    vc.value = _chatText.text;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)phoneSelected{
    UserUpdateViewController *vc=[[UserUpdateViewController alloc] initWithNibName:@"UserUpdateViewController" bundle:nil];
    vc.type = 4;
    vc.parentVC = self;
    vc.value = _phone.text;

    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)addressSelected{
    UserUpdateViewController *vc=[[UserUpdateViewController alloc] initWithNibName:@"UserUpdateViewController" bundle:nil];
    vc.type = 5;
    vc.parentVC = self;
    vc.value = _locationText.text;

    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)emailSelected{
    BindEmailViewController *vc=[[BindEmailViewController alloc] initWithNibName:@"BindEmailViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * image = info[UIImagePickerControllerEditedImage];
    UIImage * testImage = info[UIImagePickerControllerOriginalImage];
    NSLog(@"1 size = %@", NSStringFromCGSize(testImage.size));
    NSLog(@"2 size = %@",NSStringFromCGSize(CGSizeMake(CGImageGetWidth(testImage.CGImage) , CGImageGetHeight(testImage.CGImage))));
    if(image){
        [self showLoad];
        NSData * file = UIImageJPEGRepresentation(image, 0.5);
        
        NSDictionary * data = @{@"_method":@"put",@"target":@"avatar"};
        __weak __typeof(self)weakSelef = self;
        [HTTPRequest Manager:[NSString stringWithFormat:@"%@%@",self.congfing.updateUserImage,[self.appd getParameterString]] Method:nil dic:data file:file fileName:@"image" requestSucced:^(id responseObject){
            [weakSelef closeLoad];
            NSLog(@"%@",responseObject);
            
            BaseModel * model = [[BaseModel alloc] init];
            [model analyticInterface:responseObject];
            if(model.status == 0){
                [weakSelef showToast:@"修改成功"];
                [self loadNetworkData:@{@"uid":weakSelef.photosUserID}];
                
            }else{
                [self showToast:model.message];
            }
        } requestfailure:^(NSError * error){
            [weakSelef closeLoad];
            NSLog(@"%@",error.userInfo);
            [self showToast:@"修改失败"];
        }];
        
//        [HTTPRequest requestPUTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.updateUserImage,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
//            [weakSelef closeLoad];
//            NSLog(@"%@",responseObject);
//            
//            BaseModel * model = [[BaseModel alloc] init];
//            [model analyticInterface:responseObject];
//            if(model.status == 0){
//                [weakSelef showToast:@"修改成功"];
//                [self loadNetworkData:@{@"uid":weakSelef.photosUserID}];
//                
//            }else{
//                [self showToast:model.message];
//            }
//        } failure:^(NSError * error){
//            [weakSelef closeLoad];
//            NSLog(@"%@",error.userInfo);
//            [self showToast:@"修改失败"];
//        }];
    }
    
}



- (void)qrViewSelected{
    [self.qrAlert showAlert];
}

- (void)feedbackSelected{
    
    FeedbackCtr * feedback = GETALONESTORYBOARDPAGE(@"FeedbackCtr");
    [self.navigationController pushViewController:feedback animated:YES];
}

- (void)loginoutSelected{
    [self loadLoginOutData];
}

- (void)setStyle:(UserModel *)model{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"default-avatar.png"]];
    self.iconURL = model.avatar;
    [self.nameText setText:model.name];
    self.lblNameHead.text = model.name;
    self.lblUid.text = model.uid;
    [self.signatureText setText:model.signature];
    [self.qqText setText:model.qq];
    [self.chatText setText:model.wechat];
    [self.phone setText:model.phone];
    [self.locationText setText:model.address];
    [self.emailText setText:model.email];
    [self.homeText setText:[NSString stringWithFormat:@"%@%@",URLHead,model.uid]];
}

#pragma mark - UserShareAlertDelegate
- (void)userShareOption:(NSInteger)indexPath{
    
    if(indexPath == 0){
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.homeText.text
                                         images:nil
                                            url:nil
                                          title:self.homeText.text
                                           type:SSDKContentTypeAuto];
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.homeText.text;
        [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
        }];
    }else if(indexPath == 1){
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.homeText.text
                                         images:nil
                                            url:nil
                                          title:self.homeText.text
                                           type:SSDKContentTypeAuto];
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.homeText.text;
        [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
        }];
        
    }else if(indexPath == 2){
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.homeText.text;
        [self showToast:@"复制成功"];
    }
}





#pragma makr - AFNetworking网络加载
- (void)loadNetworkData:(NSDictionary *)data{
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getUserInfo,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"我的 getuserinfo%@",responseObject);
        
        UserModel * infoModel = [[UserModel alloc] init];
        [infoModel analyticInterface:responseObject];
        if(infoModel.status == 0){
            [weakSelef setStyle:infoModel];
            weakSelef.qrAlert.model = infoModel;
        }else{
            
            [weakSelef showToast:infoModel.message];
        }
        [weakSelef.table.mj_header endRefreshing];
        
    } failure:^(NSError *error){
        [weakSelef.table.mj_header endRefreshing];
    }];
}
- (void)loadLoginOutData{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",self.congfing.logout,[self.appd getParameterString]] parametric:nil succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
        [weakSelef removeValueWithKey:CacheUserModel];
        [weakSelef removeValueWithKey:SESSIONCOOKKEY];
        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
        [weakSelef.navigationController pushViewController:login animated:YES];
    } failure:^(NSError *error){
        [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
        [weakSelef removeValueWithKey:CacheUserModel];
        [weakSelef removeValueWithKey:SESSIONCOOKKEY];
        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
        [weakSelef.navigationController pushViewController:login animated:YES];
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)updateUserInfo:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPUTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.updateUserInfo,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        
        NSLog(@"%@",responseObject);
        
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [_popupErrVC showInView:self animated:YES type:@"success" message:@"更新成功"];
            [weakSelef.table.mj_header beginRefreshing];
        } else {
            [_popupErrVC showInView:self animated:YES type:@"error" message:model.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef.table.mj_header endRefreshing];
    }];
}
- (void)closePopupErr {
    [_popupErrVC removeAnimate];
}

@end
