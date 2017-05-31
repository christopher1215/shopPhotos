//
//  AttentionCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AttentionCtr.h"
#import "AttentionTableView.h"
#import "AttentionRequset.h"
#import "PersonalHomeCtr.h"
#import "SearchAllCtr.h"
#import "MoreAlert.h"
#import "PublishPhotoCtr.h"
#import "QRCodeScanCtr.h"
#import "AddFriendAlert.h"
#import "AppDelegate.h"
#import "SharedItem.h"
#import <MJRefresh.h>
#import "AddUserViewController.h"
#import "ChatListViewController.h"
#import "UserInfoModel.h"
#import "ChattingViewController.h"

#define likeType @"concerns"
#define likeMineType @"passiveConcerns"

@interface AttentionCtr ()<UIScrollViewDelegate,AttentionTableViewDelegate,MoreAlertDelegate,AddFriendAlertDelegate,RCIMUserInfoDataSource>
@property (weak, nonatomic) IBOutlet UIView *more;
@property (weak, nonatomic) IBOutlet UIView *search;
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *contactTitle;
@property (weak, nonatomic) IBOutlet UILabel *dialogTitle;
@property (weak, nonatomic) IBOutlet UIView *tabView;

@property (weak, nonatomic) IBOutlet UILabel *like;
@property (weak, nonatomic) IBOutlet UILabel *likeMine;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOffset;
@property (strong, nonatomic) NSString * userType;
@property (strong, nonatomic) AddFriendAlert * addAlert;
@property (strong, nonatomic) AttentionTableView * likeList;
@property (strong, nonatomic) AttentionTableView * likeMineList;
@property (strong, nonatomic) NSMutableArray * likeDataArray;
@property (strong, nonatomic) NSMutableArray * likeMineDataArray;

@property (strong, nonatomic) MoreAlert * moreAlert;
@property (assign, nonatomic) NSInteger likePage;
@property (assign, nonatomic) NSInteger likeMinePage;
@property (weak, nonatomic) IBOutlet UIView *tabChat;
@property (weak, nonatomic) IBOutlet UIView *tabContact;
@property (weak, nonatomic) IBOutlet UIImageView *imgChat;
@property (weak, nonatomic) IBOutlet UIImageView *imgContact;
@property (weak, nonatomic) IBOutlet UIView *viewChat;
@end

@implementation AttentionCtr

- (NSMutableArray *)likeDataArray{
    
    if(!_likeDataArray) _likeDataArray = [NSMutableArray array];
    return _likeDataArray;
}

- (NSMutableArray *)likeMineDataArray{
    
    if(!_likeMineDataArray) _likeMineDataArray = [NSMutableArray array];
    return _likeMineDataArray;
}
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNetworkData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    self.likePage = 1;
    self.likeMinePage = 1;
    [self chatSelected];

    //设置需要显示哪些类型的会话
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    ChatListViewController *chatListVC = [[ChatListViewController alloc] init];
    [chatListVC willMoveToParentViewController:self];
    [self.viewChat addSubview:chatListVC.view];
    [self addChildViewController:chatListVC];
    [chatListVC didMoveToParentViewController:self];
}
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    NSDictionary *data = @{@"uid":userId};
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getUserInfo,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"我的 getuserinfo%@",responseObject);
        
        UserInfoModel * infoModel = [[UserInfoModel alloc] init];
        [infoModel analyticInterface:responseObject];
        if(infoModel.status == 0){
            RCUserInfo *userInfo = [[RCUserInfo alloc] init];
            userInfo.userId = userId;
            userInfo.name=infoModel.name;
            userInfo.portraitUri = infoModel.avatar;
            return completion(userInfo);
        }
    } failure:^(NSError *error){
        
    }];
    
}

- (void)setup{
    
    
    self.userType = likeType;
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.search addTarget:self action:@selector(searchSelected)];
    [self.more addTarget:self action:@selector(moreSelected)];
    [self.like addTarget:self action:@selector(likeSelected)];
    [self.likeMine addTarget:self action:@selector(likeMineSelected)];
    [self.tabChat addTarget:self action:@selector(chatSelected)];
    [self.tabContact addTarget:self action:@selector(contactSelected)];
    
    self.tabView.layer.shadowRadius  = 2.5f;
    self.tabView.layer.shadowColor   = RGBACOLOR(0, 0, 0, 0.3).CGColor;
    self.tabView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.tabView.layer.shadowOpacity = 0.7f;
    self.tabView.layer.masksToBounds = NO;

    [self.scrollView setContentSize:CGSizeMake(WindowWidth*2, 0)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    
    self.likeList = [[AttentionTableView alloc] init];
    [self.likeList setBackgroundColor:[UIColor whiteColor]];
    self.likeList.delegate = self;
    self.likeList.attentionStatu = NO;
    [self.scrollView addSubview:self.likeList];
    
    self.likeMineList = [[AttentionTableView alloc] init];
    [self.likeMineList setBackgroundColor:[UIColor whiteColor]];
    self.likeMineList.delegate = self;
    self.likeMineList.attentionStatu = YES;
    [self.scrollView addSubview:self.likeMineList];
    
    self.likeList.sd_layout
    .leftEqualToView(self.scrollView)
    .topEqualToView(self.scrollView)
    .bottomEqualToView(self.scrollView)
    .widthIs(WindowWidth);
    
    self.likeMineList.sd_layout
    .leftSpaceToView(self.scrollView,WindowWidth)
    .topEqualToView(self.scrollView)
    .bottomEqualToView(self.scrollView)
    .widthIs(WindowWidth);
    
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
    self.likeList.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [weakSelef loadNetworkData];
    }];
    
    self.likeMineList.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadNetworkData];
    }];
    
}

#pragma amrk - OnClick
-(void)chatSelected{
    [self.dialogTitle setHidden:NO];
    [self.contactTitle setHidden:YES];
    [self.imgChat setImage:[UIImage imageNamed:@"btn_chat.png"]];
    [self.imgContact setImage:[UIImage imageNamed:@"ico_follow_default"]];
    [self.scrollView setHidden:YES];
    [self.viewChat setHidden:NO];
}
-(void)contactSelected{
    [self.dialogTitle setHidden:YES];
    [self.contactTitle setHidden:NO];
    [self.imgChat setImage:[UIImage imageNamed:@"btn_chat2.png"]];
    [self.imgContact setImage:[UIImage imageNamed:@"ico_follow_selected"]];
    [self.scrollView setHidden:NO];
    [self.viewChat setHidden:YES];
    [self loadNetworkData];
}
- (void)searchSelected{
    SearchAllCtr * search = GETALONESTORYBOARDPAGE(@"SearchAllCtr");
    [self.navigationController pushViewController:search animated:YES];
}

- (void)moreSelected{
    [self.moreAlert showAlert];
}

- (void)likeSelected{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)likeMineSelected{
    [self.scrollView setContentOffset:CGPointMake(WindowWidth, 0) animated:YES];
}

#pragma mark - MoreAlertDelegate
- (void)moreAlertSelected:(NSInteger)indexPath{
    if(indexPath == 0){
        PublishPhotoCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
        [self.navigationController pushViewController:pulish animated:YES];
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
    }else if(indexPath == 2){
        QRCodeScanCtr * qrCode = [[QRCodeScanCtr alloc] init];
        [self.navigationController pushViewController:qrCode animated:YES];
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


#pragma mark - AttentionTableViewDelegate
- (void)attentionTableSelect:(NSString *)uid WithName:name WithTwoWay:(BOOL)twoWay{
    ChattingViewController *conversationVC = [[ChattingViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = uid;
    conversationVC.name = name;
    if([self.userType isEqualToString:likeType]){
        conversationVC.twoWay = YES;
    }else{
        conversationVC.twoWay = twoWay;
    }
    [self.navigationController pushViewController:conversationVC animated:YES];
    
//    PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
//    personalHome.uid = uid;
//    if([self.userType isEqualToString:likeType]){
//        personalHome.twoWay = YES;
//    }else{
//       personalHome.twoWay = twoWay;
//    }
//    [self.navigationController pushViewController:personalHome animated:YES];
}
- (void)attentionSelected:(AttentionModel *)model;{
    
    if(model.star){
        NSLog(@"1");
        [self starAndCancelStar:self.congfing.handleStarUser loadData:@{@"uid":model.uid, @"action":@"cancelStar"}];
    }else{
        NSLog(@"0");
        [self starAndCancelStar:self.congfing.handleStarUser loadData:@{@"uid":model.uid,@"action":@"star"}];
    }
}
- (void)concernSelected:(AttentionModel *)model;{
    
    if(model.concerned){
        NSLog(@"1");
        [self showToast:[NSString stringWithFormat:@"你已关注%@，无需重复关注。",model.name]];
    }else{
        NSLog(@"0");
        [self concernUserData:@{@"uid":model.uid}];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    CGFloat offsetX = scrollView.contentOffset.x;
    if(offsetX == 0){
        [self.like setTextColor:ThemeColor];
        [self.likeMine setTextColor:ColorHex(0xb6bbc8)];
        self.userType = likeType;
        if(self.likeDataArray.count > 0){
            self.likeList.dataArray = self.likeDataArray;
        }else{
            [self loadNetworkData];
        }
        
    }else if(offsetX == WindowWidth){
        [self.like setTextColor:ColorHex(0xb6bbc8)];
        [self.likeMine setTextColor:ThemeColor];
        self.userType = likeMineType;
        
        if(self.likeMineDataArray.count > 0){
            self.likeMineList.dataArray = self.likeMineDataArray;
        }else{
            [self loadNetworkData];
        }
    }
    
    self.likeMineList.search.text = @"";
    self.likeList.search.text = @"";
    [self.likeList.search resignFirstResponder];
    [self.likeMineList.search resignFirstResponder];
    self.lineOffset.constant = (90) * (offsetX/WindowWidth);
}


#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    if ([self.userType isEqualToString:likeType]) {
        self.likePage = 1;
    } else  {
        self.likeMinePage = 1;
    }
    
    NSDictionary * data =  @{@"type":self.userType,
                             @"page":[NSString stringWithFormat:@"%ld",[self.userType isEqualToString:likeType]?self.likePage:self.likeMinePage],
                             @"pageSize":@"30"};
    if([self.userType isEqualToString:likeType]){
        if(self.likeDataArray.count == 0)[self showLoad];
    }else{
        if(self.likeMineDataArray.count == 0) [self showLoad];
    }
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getUsers,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef.likeList.table.mj_header endRefreshing];
        [weakSelef.likeMineList.table.mj_header endRefreshing];
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        AttentionRequset * model = [[AttentionRequset alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            if([weakSelef.userType isEqualToString:likeType]){
                weakSelef.likePage ++;
                weakSelef.likeList.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelef loadNetworkMoreData];
                }];
                if(model.dataArray.count < 30){
                    [weakSelef.likeList.table.mj_footer endRefreshingWithNoMoreData];
                    [weakSelef.likeList.table.mj_footer setHidden:YES];
                }else{
                    [weakSelef.likeList.table.mj_footer resetNoMoreData];
                }
                [weakSelef.likeDataArray removeAllObjects];
                [weakSelef.likeDataArray addObjectsFromArray:model.dataArray];
                weakSelef.likeList.dataArray = model.dataArray;
            }else{
                weakSelef.likeMinePage ++;
                weakSelef.likeMineList.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelef loadNetworkMoreData];
                }];
                if(model.dataArray.count < 30){
                    [weakSelef.likeMineList.table.mj_footer endRefreshingWithNoMoreData];
                    [weakSelef.likeMineList.table.mj_footer setHidden:YES];
                }else{
                    [weakSelef.likeMineList.table.mj_footer resetNoMoreData];
                }
                [weakSelef.likeMineDataArray removeAllObjects];
                [weakSelef.likeMineDataArray addObjectsFromArray:model.dataArray];
                weakSelef.likeMineList.dataArray = model.dataArray;
            }
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef.likeList.table.mj_header endRefreshing];
        [weakSelef.likeMineList.table.mj_header endRefreshing];
    }];
}
- (void)loadNetworkMoreData{
    
    NSDictionary * data =  @{@"type":self.userType,
                             @"page":[NSString stringWithFormat:@"%ld",[self.userType isEqualToString:likeType]?self.likePage:self.likeMinePage],
                             @"pageSize":@"30"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getUsers,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        
        [weakSelef.likeList.table.mj_header endRefreshing];
        [weakSelef.likeMineList.table.mj_header endRefreshing];
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        AttentionRequset * model = [[AttentionRequset alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            if([weakSelef.userType isEqualToString:likeType]){
                weakSelef.likePage ++;
                weakSelef.likeList.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelef loadNetworkMoreData];
                }];
                if(model.dataArray.count < 30){
                    [weakSelef.likeList.table.mj_footer endRefreshingWithNoMoreData];
                    [weakSelef.likeList.table.mj_footer setHidden:YES];
                }else{
                    [weakSelef.likeList.table.mj_footer resetNoMoreData];
                }
                [weakSelef.likeDataArray removeAllObjects];
                [weakSelef.likeDataArray addObjectsFromArray:model.dataArray];
                weakSelef.likeList.dataArray = model.dataArray;
            }else{
                weakSelef.likeMinePage ++;
                weakSelef.likeMineList.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelef loadNetworkMoreData];
                }];
                if(model.dataArray.count < 30){
                    [weakSelef.likeMineList.table.mj_footer endRefreshingWithNoMoreData];
                    [weakSelef.likeMineList.table.mj_footer setHidden:YES];
                }else{
                    [weakSelef.likeMineList.table.mj_footer resetNoMoreData];
                }
                [weakSelef.likeMineDataArray removeAllObjects];
                [weakSelef.likeMineDataArray addObjectsFromArray:model.dataArray];
                weakSelef.likeMineList.dataArray = model.dataArray;
            }
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef.likeList.table.mj_header endRefreshing];
        [weakSelef.likeMineList.table.mj_header endRefreshing];
    }];
}

- (void)starAndCancelStar:(NSString *)url loadData:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPUTUrl:[NSString stringWithFormat:@"%@%@",url,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef loadNetworkData];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)concernUserData:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.concernUser,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            
            [weakSelef showToast:@"关注成功"];
            //                [self.navigationController popViewControllerAnimated:YES];
            [weakSelef loadNetworkData];
        }else{
            
            [weakSelef showToast:model.message];
            //            [weakSelef showToast:model.message];
        }
    } failure:^(NSError * error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef closeLoad];
    }];
    
}

@end
