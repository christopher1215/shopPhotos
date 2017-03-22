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

@interface UserCtr ()<UITableViewDelegate,UITextFieldDelegate,UserShareAlertDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,TOCropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *edit;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *head;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *qrView;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UITextField *nameEdit;
@property (weak, nonatomic) IBOutlet UILabel *signatureText;
@property (weak, nonatomic) IBOutlet UITextField *signatureEdit;
@property (weak, nonatomic) IBOutlet UILabel *qqText;
@property (weak, nonatomic) IBOutlet UITextField *qqEidt;
@property (weak, nonatomic) IBOutlet UILabel *chatText;
@property (weak, nonatomic) IBOutlet UITextField *chatEdit;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UITextField *phoenEdit;
@property (weak, nonatomic) IBOutlet UILabel *locationText;
@property (weak, nonatomic) IBOutlet UITextField *locationEdit;
@property (weak, nonatomic) IBOutlet UILabel *homeText;
@property (weak, nonatomic) IBOutlet UIImageView *home;
@property (weak, nonatomic) IBOutlet UIView *feedback;
@property (assign, nonatomic) BOOL changeStatu;
@property (strong, nonatomic) QRCodeAlert * qrAlert;
@property (weak, nonatomic) IBOutlet UIButton *loginOut;
@property (strong, nonatomic) NSString * iconURL;
@property (strong, nonatomic) UITextField * tempTextField;
@property (strong, nonatomic) UserShareAlert * shareAlert;
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
    
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.icon addTarget:self action:@selector(iconSelected)];
    [self.head addTarget:self action:@selector(headSelected)];
    [self.qrView addTarget:self action:@selector(qrViewSelected)];
    [self.feedback addTarget:self action:@selector(feedbackSelected)];
    [self.loginOut addTarget:self action:@selector(loginoutSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.home addTarget:self action:@selector(homeSelected)];
    
    __weak __typeof(self)weakSelef = self;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelef loadNetworkData:@{@"uid":weakSelef.photosUserID}];
    }];
    [self.table.mj_header beginRefreshing];
    
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
    [self.nameEdit setHidden:YES];
    [self.nameEdit setDelegate:self];
    [self.signatureEdit setHidden:YES];
    [self.signatureEdit setDelegate:self];
    [self.qqEidt setHidden:YES];
    [self.qqEidt setDelegate:self];
    [self.chatEdit setHidden:YES];
    [self.chatEdit setDelegate:self];
    [self.phoenEdit setHidden:YES];
    [self.phoenEdit setDelegate:self];
    [self.locationEdit setHidden:YES];
    [self.locationEdit setDelegate:self];
    
    [self.nameText setHidden:NO];
    [self.signatureText setHidden:NO];
    [self.qqText setHidden:NO];
    [self.chatText setHidden:NO];
    [self.phone setHidden:NO];
    [self.locationText setHidden:NO];
}

- (void)changeStatu:(BOOL)statu{
    
    if(statu){
        [self.edit setImage:[UIImage imageNamed:@"ico_confirm_black"]];
        [self.nameEdit setHidden:NO];
        [self.signatureEdit setHidden:NO];
        [self.qqEidt setHidden:NO];
        [self.chatEdit setHidden:NO];
        [self.phoenEdit setHidden:NO];
        [self.locationEdit setHidden:NO];
        
        [self.nameText setHidden:YES];
        [self.signatureText setHidden:YES];
        [self.qqText setHidden:YES];
        [self.chatText setHidden:YES];
        [self.phone setHidden:YES];
        [self.locationText setHidden:YES];
        
    }else{
        [self.edit setImage:[UIImage imageNamed:@"btn_edit_black"]];
        [self.nameEdit setHidden:YES];
        [self.signatureEdit setHidden:YES];
        [self.qqEidt setHidden:YES];
        [self.chatEdit setHidden:YES];
        [self.phoenEdit setHidden:YES];
        [self.locationEdit setHidden:YES];
        
        [self.nameText setHidden:NO];
        [self.signatureText setHidden:NO];
        [self.qqText setHidden:NO];
        [self.chatText setHidden:NO];
        [self.phone setHidden:NO];
        [self.locationText setHidden:NO];
        
        
        
        [self updateUserInfo:@{@"name":self.nameEdit.text,
                               @"signature":self.signatureEdit.text,
                               @"title":@"",
                               @"tel":self.phoenEdit.text,
                               @"qq":self.qqEidt.text,
                               @"weixin":self.chatEdit.text,
                               @"address":self.locationEdit.text}];
    }
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
        ShowAlert(@"请允许相册访问");
        return;
    }
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];

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
        NSDictionary * data = @{@"iconType":@"icon"};
        __weak __typeof(self)weakSelef = self;
        [HTTPRequest Manager:self.congfing.setIcon Method:nil dic:data file:file fileName:@"icon" requestSucced:^(id responseObject){
            
            BaseModel * model = [[BaseModel alloc] init];
            [model analyticInterface:responseObject];
            if(model.status == 0){
                [weakSelef showToast:@"修改成功"];
                [self loadNetworkData:@{@"uid":weakSelef.photosUserID}];
                
            }else{
                [self showToast:model.message];
            }
            [weakSelef closeLoad];
        } requestfailure:^(NSError * error){
            [weakSelef closeLoad];
            NSLog(@"%@",error.userInfo);
            [self showToast:@"修改失败"];
        }];
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

- (void)setStyle:(UserInfoModel *)model{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.iconURL = model.icon;
    [self.nameText setText:model.name];
    [self.signatureText setText:model.signature];
    [self.qqText setText:model.qq];
    [self.chatText setText:model.weixin];
    [self.phone setText:model.tel];
    [self.locationText setText:model.address];
    
    [self.nameEdit setText:model.name];
    [self.signatureEdit setText:model.signature];
    [self.qqEidt setText:model.qq];
    [self.chatEdit setText:model.weixin];
    [self.phoenEdit setText:model.tel];
    [self.locationEdit setText:model.address];
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


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.tempTextField = textField;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if(textField == self.signatureEdit){
        if(string.length > 0 && textField.text.length == 40){
            [self showToast:@"个性签名不能超过40个字"];
            return NO;
        }
    }
    
    if(textField == self.locationEdit){
        if(string.length > 0 && textField.text.length == 40){
            [self showToast:@"地址不能超过40个字"];
            return NO;
        }
    }
    
    if(textField == self.phoenEdit){
        if(string.length > 0 && textField.text.length == 11){
            [self showToast:@"电话不能超过11个字"];
            return NO;
        }
    }
    return YES;
}



#pragma makr - AFNetworking网络加载
- (void)loadNetworkData:(NSDictionary *)data{
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getUserInfo parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        
        UserInfoModel * infoModel = [[UserInfoModel alloc] init];
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
    [HTTPRequest requestPOSTUrl:self.congfing.appLogout parametric:nil succed:^(id responseObject){
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
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.updateUserInfo parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"修改成功"];
            [weakSelef.table.mj_header beginRefreshing];
        }
        
    } failure:^(NSError *error){
        [weakSelef.table.mj_header endRefreshing];
    }];
}
@end
