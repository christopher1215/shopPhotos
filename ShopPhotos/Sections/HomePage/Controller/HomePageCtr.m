//
//  HomePageCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "HomePageCtr.h"
#import "UserInfoModel.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "HomePageCountModel.h"
#import "SettingCtr.h"
#import "MessageCtr.h"
#import <MJPhotoBrowser.h>
#import "AlbumClassCtr.h"
#import "AlbumPhotosCtr.h"
#import "MoreAlert.h"
#import "AlbumRecommendCtr.h"
#import "SearchAllCtr.h"
#import "QRCodeScanCtr.h"
#import "AddFriendAlert.h"
#import "AppDelegate.h"
#import "CollectionPhotoCtr.h"
#import "PersonalHomeCtr.h"
#import "DynamicCtr.h"
#import "MypointViewController.h"
#import "AddUserViewController.h"
#import "PublishPhotoCtr.h"
#import "MJPhoto.h"

@interface HomePageCtr ()<MoreAlertDelegate,AddFriendAlertDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    int currentPoint;
}
@property (weak, nonatomic) IBOutlet UIView *firstGuidView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UIView *search;
@property (weak, nonatomic) IBOutlet UIButton *more;
@property (weak, nonatomic) IBOutlet UIButton *keep;
@property (weak, nonatomic) IBOutlet UIButton *message;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *uidView;
@property (weak, nonatomic) IBOutlet UILabel *uidText;
@property (weak, nonatomic) IBOutlet UIButton *qqView;
@property (strong, nonatomic) UILabel *qqText;
@property (weak, nonatomic) IBOutlet UIButton *chatView;
@property (strong, nonatomic) UILabel *chatText;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UIButton *recommend;
@property (weak, nonatomic) IBOutlet UIButton *album;
@property (weak, nonatomic) IBOutlet UIButton *albumClass;
@property (weak, nonatomic) IBOutlet UIButton *dynamic;
@property (weak, nonatomic) IBOutlet UIButton *setting;
@property (strong, nonatomic) NSDictionary * settingConfig;
@property (strong, nonatomic) NSString * iconURL;
@property (strong, nonatomic) MoreAlert * moreAlert;
@property (strong, nonatomic) AddFriendAlert * addAlert;
@property (weak, nonatomic) IBOutlet UIButton *scan;
@property (weak, nonatomic) IBOutlet UIButton *point;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;

@end

@implementation HomePageCtr

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNetworkData:@{@"uid":self.photosUserID}];
    [self loadNetworkCount];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.firstGuidView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainView.height = WindowHeight - 60;
    self.mainView.backgroundColor = [UIColor clearColor];
    self.firstGuidView.layer.cornerRadius = 5;
    [self setup];
}

- (void)setup{
    self.qqText = [[UILabel alloc] init];
    self.chatText = [[UILabel alloc] init];
    self.uidView.cornerRadius = 12;
    self.qqView.cornerRadius = 12;
    self.chatView.cornerRadius = 12;
    self.more.layer.cornerRadius = 19;
    [self.more addTarget:self action:@selector(moreSelected)];
    self.search.layer.cornerRadius = 5;
    [self.search addTarget:self action:@selector(searchSelected)];
    [self.keep addTarget:self action:@selector(keepSelected)];
    [self.message addTarget:self action:@selector(messageSelected)];
    self.headImage.layer.borderColor = [UIColor.whiteColor CGColor];
    self.headImage.layer.borderWidth = 3;
    self.headImage.layer.cornerRadius = self.headImage.width/2;
    self.headImage.layer.masksToBounds = YES;
    [self.headImage addTarget:self action:@selector(iconSelected)];
    [self.recommend addTarget:self action:@selector(recommendSelected)];
    [self.album addTarget:self action:@selector(albumSelected)];
    [self.albumClass addTarget:self action:@selector(albumClassSelected)];
    [self.setting addTarget:self action:@selector(settingSelected)];
    [self.dynamic addTarget:self action:@selector(dynamicSelected)];
    [self.scan addTarget:self action:@selector(qrScanSelected)];
    [self.point addTarget:self action:@selector(pointSelected)];
    
    //    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    //    effectview.alpha = 0.95;
    //    [self.head addSubview:effectview];
    //    effectview.sd_layout
    //    .leftEqualToView(self.head)
    //    .rightEqualToView(self.head)
    //    .topEqualToView(self.head)
    //    .bottomEqualToView(self.head);
    
    self.moreAlert = [[MoreAlert alloc] init];
    [self.view addSubview:self.moreAlert];
    self.moreAlert.mode = HomeModel;
    self.moreAlert.delegate = self;
    [self.moreAlert setHidden:YES];
    self.moreAlert.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    __weak __typeof(self)weakSelef = self;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadNetworkData:@{@"uid":weakSelef.photosUserID}];
        [weakSelef loadNetworkCount];
    }];
    if ([[[NSUserDefaults standardUserDefaults] getValueWithKey:@"isFirst"] isEqualToString:@"noFirst"]) {
        [self.firstGuidView setHidden:YES];
    } else {
        [self.firstGuidView setHidden:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@"noFirst" forKey:@"isFirst"];
    }
    
}

- (IBAction)changeBgImg:(id)sender {
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
- (IBAction)uidSelect:(id)sender {
}
- (IBAction)qqSelect:(id)sender {
    NSString * qqStr = self.qqText.text;
    if(qqStr && qqStr.length >0){
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = qqStr;
    }else {
        [self showToast:@"QQ号为空"];
        return;
    }
    __weak __typeof(self)weakSelef = self;
    NSString * msg = [NSString stringWithFormat:@"QQ号已复制，可以进入QQ粘贴"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"打开QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mqq://"] options:@{} completionHandler:nil];
        }else{
            [weakSelef showToast:@"您没有安装QQ"];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)wechatSelect:(id)sender {
    NSString * chatStr = self.chatText.text;
    if(chatStr && chatStr.length > 0){
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = chatStr;
    }else{
        [self showToast:@"微信号为空"];
        return;
    }

    __weak __typeof(self)weakSelef = self;
    NSString * msg = [NSString stringWithFormat:@"微信号已复制，可以进入微信粘贴"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"打开微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"] options:@{} completionHandler:nil];
        }else{
            [weakSelef showToast:@"您没有安装微信"];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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
        
        NSDictionary * data = @{@"_method":@"put",@"target":@"bg_image"};
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
    }
}

- (IBAction)hideFirstGuide:(id)sender {
    [self.firstGuidView setHidden:YES];
}
#pragma mark - OnClick
- (void)moreSelected{
    [self.moreAlert showAlert];
}

- (void)searchSelected{
    SearchAllCtr * search = GETALONESTORYBOARDPAGE(@"SearchAllCtr");
    search.uid = self.photosUserID;
    [self.navigationController pushViewController:search animated:YES];
}
- (IBAction)gotoSearch:(id)sender {
    SearchAllCtr * search = GETALONESTORYBOARDPAGE(@"SearchAllCtr");
    search.uid = self.photosUserID;
    [self.navigationController pushViewController:search animated:YES];
}


- (void)keepSelected{
    CollectionPhotoCtr * collecttion = GETALONESTORYBOARDPAGE(@"CollectionPhotoCtr");
    collecttion.uid = self.photosUserID;
    collecttion.str_from = @"首页";
    collecttion.isVideo = NO;
    
    [self.navigationController pushViewController:collecttion animated:YES];
}

- (void) qrScanSelected{
    [self moreAlertSelected:2];
}

- (void) pointSelected {
    MypointViewController *vc=[[MypointViewController alloc] initWithNibName:@"MypointViewController" bundle:nil];
    vc.currentPoint = currentPoint;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageSelected{
    MessageCtr * message = GETALONESTORYBOARDPAGE(@"MessageCtr");
    message.str_from = @"首页";
    [self.navigationController pushViewController:message animated:YES];
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

- (void)recommendSelected{
    //[self showToast:@"123454wegsdgsdfgdsdsfadsfasdfdsafsdafdsafsdafdsafdsafsdafdsfsdfdsafsadfds"];
    AlbumRecommendCtr * albumRecommend = GETALONESTORYBOARDPAGE(@"AlbumRecommendCtr");
    albumRecommend.uid = self.photosUserID;
    [self.navigationController pushViewController:albumRecommend animated:YES];
}

- (void)albumSelected{
    AlbumPhotosCtr * albumPhotos = GETALONESTORYBOARDPAGE(@"AlbumPhotosCtr");
    albumPhotos.uid = self.photosUserID;
    albumPhotos.type = @"photo";
    albumPhotos.subClassid = -1;
    albumPhotos.ptitle = @"所有相册";
    [self.navigationController pushViewController:albumPhotos animated:YES];
}

- (void)albumClassSelected{
    AlbumClassCtr * albumClass = GETALONESTORYBOARDPAGE(@"AlbumClassCtr");
    albumClass.isSubClass = NO;
    albumClass.uid = self.photosUserID;
    [self.navigationController pushViewController:albumClass animated:YES];
}

- (void)settingSelected{
    SettingCtr * setting = GETALONESTORYBOARDPAGE(@"SettingCtr");
    setting.uid = self.photosUserID;
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)dynamicSelected{
    DynamicCtr * dynamic = GETALONESTORYBOARDPAGE(@"DynamicCtr");
    dynamic.isMyDynamic = YES;
    //    dynamic.uid = self.photosUserID;
    [self.navigationController pushViewController:dynamic animated:YES];
}

#pragma mark - MoreAlertDelegate
- (void)moreAlertSelected:(NSInteger)indexPath{
    
    if(indexPath == 0){
        PublishPhotoCtr * publish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
        [self.navigationController pushViewController:publish animated:YES];
    }else if(indexPath == 2){
        QRCodeScanCtr * qrCode = [[QRCodeScanCtr alloc] init];
        [self.navigationController pushViewController:qrCode animated:YES];
    }else if(indexPath == 1){
        AddUserViewController *vc=[[AddUserViewController alloc] initWithNibName:@"AddUserViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
        //        if(!self.addAlert){
        //            self.addAlert = [[AddFriendAlert alloc] init];
        //            AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //            [appDelegate.window addSubview:self.addAlert];
        //            self.addAlert.delegate = self;
        //            self.addAlert.sd_layout
        //            .leftEqualToView(appDelegate.window)
        //            .rightEqualToView(appDelegate.window)
        //            .topEqualToView(appDelegate.window)
        //            .bottomEqualToView(appDelegate.window);
        //        }
        //        [self.addAlert showAlert];
    }
}

#pragma mark - AddFriendAlertDelegate
- (void)addFriendSure:(NSString *)uid{
    if(uid && uid.length > 0){
        if([uid isEqualToString:self.photosUserID]){
            [self showToast:@"不能关注自己哦"];
        }else{
            [self concernUserData:@{@"uid":uid}];
        }
    }else{
        [self showToast:@"请输入有图号"];
    }
}
- (void)useQRCodeScan{
    QRCodeScanCtr * qrCode = [[QRCodeScanCtr alloc] init];
    [self.navigationController pushViewController:qrCode animated:YES];
}

#pragma mark - 修改样式
- (void)setStyle:(UserInfoModel *)model{
    
//    [self.head sd_setImageWithURL:[NSURL URLWithString:model.bg_image]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.iconURL = model.avatar;
    [self.name setText:model.name];
    
    if(model.uid && model.uid.length > 0){
        NSMutableAttributedString * qqText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",model.uid]];
        NSTextAttachment * qqIocn = [[NSTextAttachment alloc] init];
        qqIocn.image = [UIImage imageNamed:@"uid_icon_white"];
        qqIocn.bounds = CGRectMake(0, -2, 11, 13);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:qqIocn];
        [qqText insertAttributedString:string atIndex:0];
        [self.uidText setAttributedText:qqText];
        [self.uidText setTextAlignment:NSTextAlignmentCenter];
    }else{
        NSMutableAttributedString * qqText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
        NSTextAttachment * qqIocn = [[NSTextAttachment alloc] init];
        qqIocn.image = [UIImage imageNamed:@"uid_icon_white"];
        qqIocn.bounds = CGRectMake(5, -2, 11, 13);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:qqIocn];
        [qqText insertAttributedString:string atIndex:0];
        [self.uidText setAttributedText:qqText];
        [self.uidText setTextAlignment:NSTextAlignmentLeft];
    }
    
    if(model.qq && model.qq.length > 0){
        NSString * qqs = model.qq;
        
        [self.qqText setText:qqs];
    }else{
        NSMutableAttributedString * qqText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
        NSTextAttachment * qqIocn = [[NSTextAttachment alloc] init];
        qqIocn.image = [UIImage imageNamed:@"qq_icon_white"];
        qqIocn.bounds = CGRectMake(5, -2, 13, 13);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:qqIocn];
        [qqText insertAttributedString:string atIndex:0];
        
        [self.qqText setText:@""];
    }
    
    if(model.wechat && model.wechat.length >0){
        
        NSString * qqs = model.wechat;
        [self.chatText setText:qqs];
    }else{
        NSMutableAttributedString * chatText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
        NSTextAttachment * chatIocn = [[NSTextAttachment alloc] init];
        chatIocn.image = [UIImage imageNamed:@"wexin_icon_white"];
        chatIocn.bounds = CGRectMake(5, -3, 15, 13);
        NSAttributedString *chatIocnStr = [NSAttributedString attributedStringWithAttachment:chatIocn];
        [chatText insertAttributedString:chatIocnStr atIndex:0];
        [self.chatText setText:@""];
        [self.chatText setTextAlignment:NSTextAlignmentLeft];
    }
    
    NSString * sign = @"";
    if(model.signature && model.signature.length > 0){
        sign = [NSString stringWithFormat:@"%@",model.signature];
    }else{
        //sign = [NSString stringWithFormat:@"这个人很懒什么都没有留下"];
    }
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.lineSpacing = 3;
    //    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraphStyle};
    //    self.signature.attributedText = [[NSAttributedString alloc] initWithString:sign attributes:attributes];
    self.signature.text = sign;
    self.lblNumber.text = [NSString stringWithFormat:@"有图号:%@", model.uid];
    //[self.point setTitle:[NSString stringWithFormat:@"积分:%ld", (long)model.integral] forState:UIControlStateNormal];
    //    [self.keep setTitle:[NSString stringWithFormat:@"收藏:%ld", model.concerned] forState:UIControlStateNormal];
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData:(NSDictionary *)data{
    if(self.uidText.text.length == 0)[self showLoad];
    
    NSLog(@"%@, %@ %@",[data objectForKey:@"uid"],self.congfing.getUserInfo,[self.appd getParameterString]);
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getUserInfo,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"1  %@",responseObject);
        UserInfoModel * infoModel = [[UserInfoModel alloc] init];
        [infoModel analyticInterface:responseObject];
        if(infoModel.status == 0){
            [weakSelef setStyle:infoModel];
            currentPoint = infoModel.integral;
            if(infoModel.settings && infoModel.settings.count > 0){
                weakSelef.settingConfig = infoModel.settings;
            }
        }else{
            [self showToast:infoModel.message];
        }
        [weakSelef.table.mj_header endRefreshing];
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef.table.mj_header endRefreshing];
    }];
}

- (void)loadNetworkCount{
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getCounts,[self.appd getParameterString]] parametric:nil succed:^(id responseObject){
        NSLog(@"2  %@",responseObject);
        HomePageCountModel * model = [[HomePageCountModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
//            [weakSelef.keep setTitle:[NSString stringWithFormat:@"收藏:%ld",(model.collectPhotosCount + model.collectVideosCount)] forState:UIControlStateNormal];
//            [weakSelef.point setTitle:[NSString stringWithFormat:@"积分:%ld",(long)model.integral] forState:UIControlStateNormal];
        }
    } failure:nil];
}

- (void)concernUserData:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.concernUser parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"关注成功"];
            PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
            personalHome.uid = [data objectForKey:@"uid"];
            personalHome.twoWay = YES;
            [self.navigationController pushViewController:personalHome animated:YES];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef.table.mj_header endRefreshing];
    }];
}



@end
