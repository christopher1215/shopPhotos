//
//  MypointViewController.m
//  ShopPhotos
//
//  Created by Macbook on 08/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "MypointViewController.h"
#import "ChargeViewController.h"
#import "PointHistoryTableViewCell.h"
#import <MJRefresh.h>
#import "PointLog.h"
#import "PointLogRequest.h"

@interface MypointViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *back;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray * dataArray;

@end

@implementation MypointViewController
- (NSMutableArray *)dataArray{
    
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.back addTarget:self action:@selector(backSelected)];
    _lblCurrentPoint.text = [NSString stringWithFormat:@"%d",_currentPoint];
    self.tblHistory.delegate = self;
    self.tblHistory.dataSource = self;
    [self.tblHistory registerNib:[UINib nibWithNibName:@"PointHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"PointHistoryTableViewCell"];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    [self.tblHistory setTableFooterView:v];
    
    __weak __typeof(self)weakSelef = self;
    self.tblHistory.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadNetworkData];
    }];

    [self dataArray];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.dataArray.count > 0){
        [self loadNetworkData];
    }else{
        [self.tblHistory.mj_header beginRefreshing];
    }
}

- (void)backSelected{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)gotoExplain:(id)sender {
}
- (IBAction)onPay:(id)sender {
    ChargeViewController *vc=[[ChargeViewController alloc] initWithNibName:@"ChargeViewController" bundle:nil];
    vc.currentPoint = _currentPoint;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    self.page = 1;
    NSDictionary * data = @{
                            @"page":[NSString stringWithFormat:@"%ld",self.page],
                            @"pageSize":@"30"
                            };
    __weak __typeof(self)weakSelef = self;
    
    NSString *serverApi = self.congfing.getUserIntegralLog;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"1  %@",responseObject);
        
        [weakSelef.tblHistory.mj_header endRefreshing];
        
        PointLogRequest * request = [[PointLogRequest alloc] init];
        [request analyticInterface:responseObject];
        if(request.status == 0){
            weakSelef.page ++;
            weakSelef.tblHistory.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkMoreData];
            }];
            if(request.dataArray.count < 30){
                [weakSelef.tblHistory.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelef.tblHistory.mj_footer resetNoMoreData];
            }
            [weakSelef.dataArray removeAllObjects];
            [weakSelef.dataArray addObjectsFromArray:request.dataArray];
            [self.tblHistory reloadData];
        }else{
            [weakSelef showToast:request.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef.tblHistory.mj_header endRefreshing];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)loadNetworkMoreData{
    
    
    NSDictionary * data = @{
                            @"page":[NSString stringWithFormat:@"%ld",self.page],
                            @"pageSize":@"30"
                            };
    __weak __typeof(self)weakSelef = self;
    
    NSString *serverApi = self.congfing.getUserIntegralLog;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        
        [weakSelef.tblHistory.mj_footer endRefreshing];
        PointLogRequest * request = [[PointLogRequest alloc] init];
        [request analyticInterface:responseObject];
        if(request.status == 0){
            weakSelef.page ++;
            if(request.dataArray.count < 30){
                [weakSelef.tblHistory.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelef.tblHistory.mj_footer resetNoMoreData];
            }
            [weakSelef.dataArray addObjectsFromArray:request.dataArray];
            [self.tblHistory reloadData];
        }else{
            [weakSelef showToast:request.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.tblHistory.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PointHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointHistoryTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PointHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PointHistoryTableViewCell"];
    }
    if (indexPath.row < [_dataArray count]){
        PointLog *info = [PointLog alloc];
        info = [_dataArray objectAtIndex:indexPath.row];
        cell.blDate.text = info.date;
        cell.lblKind.text = info.desc;
        cell.lblAmount.text = info.diff;
        cell.lblBalance.text = [NSString stringWithFormat:@"余额: %@",info.integral];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
