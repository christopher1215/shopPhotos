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
#import "PublishPhotosCtr.h"
#import "QRCodeScanCtr.h"
#import "AddFriendAlert.h"
#import "AppDelegate.h"
#import "SharedItem.h"
#import <MJRefresh.h>

#define likeType @"concernUsers"
#define likeMineType @"passive"

@interface AttentionCtr ()<UIScrollViewDelegate,AttentionTableViewDelegate,MoreAlertDelegate,AddFriendAlertDelegate>
@property (weak, nonatomic) IBOutlet UIView *more;
@property (weak, nonatomic) IBOutlet UIView *search;

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
   
}

- (void)setup{
    
    
    self.userType = likeType;
    
    [self.search addTarget:self action:@selector(searchSelected)];
    [self.more addTarget:self action:@selector(moreSelected)];
    [self.like addTarget:self action:@selector(likeSelected)];
    [self.likeMine addTarget:self action:@selector(likeMineSelected)];
    
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


#pragma mark - AttentionTableViewDelegate
- (void)attentionTableSelect:(NSString *)uid WithTwoWay:(BOOL)twoWay{
    
    PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
    personalHome.uid = uid;
    if([self.userType isEqualToString:likeType]){
        personalHome.twoWay = YES;
    }else{
       personalHome.twoWay = twoWay;
    }
    [self.navigationController pushViewController:personalHome animated:YES];
}
- (void)attentionSelected:(AttentionModel *)model;{
    
    if(model.star){
        NSLog(@"1");
        [self starAndCancelStar:self.congfing.cancelStarUser loadData:@{@"uid":model.uid}];
    }else{
        NSLog(@"0");
        [self starAndCancelStar:self.congfing.starUser loadData:@{@"uid":model.uid}];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    CGFloat offsetX = scrollView.contentOffset.x;
    if(offsetX == 0){
        [self.like setTextColor:ThemeColor];
        [self.likeMine setTextColor:ColorHex(0X000000)];
        self.userType = likeType;
        if(self.likeDataArray.count > 0){
            self.likeList.dataArray = self.likeDataArray;
        }else{
            [self loadNetworkData];
        }
        
    }else if(offsetX == WindowWidth){
        [self.like setTextColor:ColorHex(0X000000)];
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
    
    NSDictionary * data =  @{@"uid":self.photosUserID,
                             @"lastId":@"0",
                             @"userType":self.userType};
    if([self.userType isEqualToString:likeType]){
        if(self.likeDataArray.count == 0)[self showLoad];
    }else{
        if(self.likeMineDataArray.count == 0) [self showLoad];
    }
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.getUsers parametric:data succed:^(id responseObject){
        [weakSelef.likeList.table.mj_header endRefreshing];
        [weakSelef.likeMineList.table.mj_header endRefreshing];
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        AttentionRequset * model = [[AttentionRequset alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            if([weakSelef.userType isEqualToString:likeType]){
                [weakSelef.likeDataArray removeAllObjects];
                [weakSelef.likeDataArray addObjectsFromArray:model.dataArray];
                weakSelef.likeList.dataArray = model.dataArray;
            }else{
                [weakSelef.likeMineDataArray removeAllObjects];
                [weakSelef.likeMineDataArray addObjectsFromArray:model.dataArray];
                weakSelef.likeMineList.dataArray = model.dataArray;
            }
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.likeList.table.mj_header endRefreshing];
        [weakSelef.likeMineList.table.mj_header endRefreshing];
    }];
}

- (void)starAndCancelStar:(NSString *)url loadData:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:url parametric:data succed:^(id responseObject){
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
        [weakSelef showToast:NETWORKTIPS];
    }];
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
    }];
}

@end
