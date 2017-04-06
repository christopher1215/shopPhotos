//
//  HomePageCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "HomePageCtr.h"
#import "UserModel.h"
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
#import "PublishPhotosCtr.h"
#import "DynamicCtr.h"

@interface HomePageCtr ()<MoreAlertDelegate,AddFriendAlertDelegate>
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
@property (weak, nonatomic) IBOutlet UILabel *qqText;
@property (weak, nonatomic) IBOutlet UIButton *chatView;
//@property (weak, nonatomic) IBOutlet UILabel *chatText;
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

@end

@implementation HomePageCtr

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNetworkData:@{@"uid":self.photosUserID}];
    [self loadNetworkCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainView.height = WindowHeight - 60;
    self.mainView.backgroundColor = [UIColor clearColor];
    [self setup];
}

- (void)setup{
    
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
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.alpha = 0.95;
    [self.head addSubview:effectview];
    effectview.sd_layout
    .leftEqualToView(self.head)
    .rightEqualToView(self.head)
    .topEqualToView(self.head)
    .bottomEqualToView(self.head);
    
    self.moreAlert = [[MoreAlert alloc] init];
    [self.view addSubview:self.moreAlert];
    self.moreAlert.mode = OptionModel;
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


- (void)keepSelected{
    CollectionPhotoCtr * collecttion = GETALONESTORYBOARDPAGE(@"CollectionPhotoCtr");
    collecttion.uid = self.photosUserID;
    collecttion.str_from = @"首页";
    [self.navigationController pushViewController:collecttion animated:YES];
    
}

-(void) qrScanSelected{
    [self moreAlertSelected:1];
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
    albumPhotos.type = 1;
    [self.navigationController pushViewController:albumPhotos animated:YES];
}

- (void)albumClassSelected{
    AlbumClassCtr * albumClass = GETALONESTORYBOARDPAGE(@"AlbumClassCtr");
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
//    dynamic.uid = self.photosUserID;
    [self.navigationController pushViewController:dynamic animated:YES];
}

#pragma mark - MoreAlertDelegate
- (void)moreAlertSelected:(NSInteger)indexPath{
    
    if(indexPath == 0){
        PublishPhotosCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotosCtr");
        [self.navigationController pushViewController:pulish animated:YES];
    }else if(indexPath == 1){
        QRCodeScanCtr * qrCode = [[QRCodeScanCtr alloc] init];
        [self.navigationController pushViewController:qrCode animated:YES];
    }else if(indexPath == 2){
        if(!self.addAlert){
            self.addAlert = [[AddFriendAlert alloc] init];
            AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.window addSubview:self.addAlert];
            self.addAlert.delegate = self;
            self.addAlert.sd_layout
            .leftEqualToView(appDelegate.window)
            .rightEqualToView(appDelegate.window)
            .topEqualToView(appDelegate.window)
            .bottomEqualToView(appDelegate.window);
        }
        [self.addAlert showAlert];
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
    
    [self.head sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.iconURL = model.icon;
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
        if(qqs.length >11){
            qqs = [qqs substringToIndex:11];
        }
        NSMutableAttributedString * qqText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",qqs]];
        NSTextAttachment * qqIocn = [[NSTextAttachment alloc] init];
        qqIocn.image = [UIImage imageNamed:@"qq_icon_white"];
        qqIocn.bounds = CGRectMake(0, -2, 13, 13);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:qqIocn];
        [qqText insertAttributedString:string atIndex:0];
        
        [self.qqText setAttributedText:qqText];
        [self.qqText setTextAlignment:NSTextAlignmentCenter];
    }else{
        NSMutableAttributedString * qqText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
        NSTextAttachment * qqIocn = [[NSTextAttachment alloc] init];
        qqIocn.image = [UIImage imageNamed:@"qq_icon_white"];
        qqIocn.bounds = CGRectMake(5, -2, 13, 13);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:qqIocn];
        [qqText insertAttributedString:string atIndex:0];
        
        [self.qqText setAttributedText:qqText];
        [self.qqText setTextAlignment:NSTextAlignmentLeft];
    }
    
    if(model.weixin && model.weixin.length >0){
        
        NSString * qqs = model.weixin;
        if(qqs.length >11){
            qqs = [qqs substringToIndex:11];
            NSString * qqr = [NSString stringWithFormat:@"%@..",qqs];
            qqs = qqr;
        }
        NSMutableAttributedString * chatText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",qqs]];
        NSTextAttachment * chatIocn = [[NSTextAttachment alloc] init];
        chatIocn.image = [UIImage imageNamed:@"wexin_icon_white"];
        chatIocn.bounds = CGRectMake(0, -3, 15, 13);
        NSAttributedString *chatIocnStr = [NSAttributedString attributedStringWithAttachment:chatIocn];
        [chatText insertAttributedString:chatIocnStr atIndex:0];
//        [self.chatText setAttributedText:chatText];
//        [self.chatText setTextAlignment:NSTextAlignmentCenter];
    }else{
        NSMutableAttributedString * chatText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
        NSTextAttachment * chatIocn = [[NSTextAttachment alloc] init];
        chatIocn.image = [UIImage imageNamed:@"wexin_icon_white"];
        chatIocn.bounds = CGRectMake(5, -3, 15, 13);
        NSAttributedString *chatIocnStr = [NSAttributedString attributedStringWithAttachment:chatIocn];
        [chatText insertAttributedString:chatIocnStr atIndex:0];
//        [self.chatText setAttributedText:chatText];
//        [self.chatText setTextAlignment:NSTextAlignmentLeft];
    }
    
    NSString * sign = @"";
    if(model.signature && model.signature.length > 0){
        sign = [NSString stringWithFormat:@"个性签名:%@",model.signature];
    }else{
        sign = [NSString stringWithFormat:@"个性签名:这个人很懒什么都没有留下"];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraphStyle};
    self.signature.attributedText = [[NSAttributedString alloc] initWithString:sign attributes:attributes];
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData:(NSDictionary *)data{
    if(self.uidText.text.length == 0)[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getUserInfo parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"1  %@",responseObject);
        [weakSelef.table.mj_header endRefreshing];
        UserInfoModel * infoModel = [[UserInfoModel alloc] init];
        [infoModel analyticInterface:responseObject];
        if(infoModel.status == 0){
            [weakSelef setStyle:infoModel];
            if(infoModel.config && infoModel.config.count > 0){
                weakSelef.settingConfig = infoModel.config;
            }
        }else{
            [self showToast:infoModel.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.table.mj_header endRefreshing];
    }];
}

- (void)loadNetworkCount{
//    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getCount parametric:nil succed:^(id responseObject){
        NSLog(@"2  %@",responseObject);
        HomePageCountModel * model = [[HomePageCountModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
//            [weakSelef.keep setText:[NSString stringWithFormat:@"%@\n收藏",model.collectsCount]];
//            [weakSelef.message setText:[NSString stringWithFormat:@"%@\n消息",model.noticesCount]];
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
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.table.mj_header endRefreshing];
    }];
}



@end
