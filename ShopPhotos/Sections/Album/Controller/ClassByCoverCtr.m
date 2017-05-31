//
//  ClassByCoverCtr.m
//  ShopPhotos
//
//  Created by Macbook on 15/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "ClassByCoverCtr.h"
#import "ClassByCoverTableView.h"
#import <MJRefresh.h>
#import "AlbumPhotosCtr.h"
#import "AlbumClassModel.h"
@interface ClassByCoverCtr ()<ClassByCoverTableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) ClassByCoverTableView * table;

@property (strong, nonatomic) NSMutableArray * dataArray;

@end

@implementation ClassByCoverCtr

- (NSMutableArray *)dataArray{
    
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self dataArray];
    [self.back addTarget:self action:@selector(backSelected)];
    _lblTitle.text = _parentModel.name;
    [self createAutoLayout];
}
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createAutoLayout{
    
    self.table = [[ClassByCoverTableView alloc] init];
    
    self.table.delegate = self;
    [self.table setBackgroundColor:ColorHex(0XF5F5F5)];
    [self.view addSubview:self.table];
    
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .bottomEqualToView(self.view);
    
    __weak __typeof(self)weakSelef = self;
    self.table.classes.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadNetworkData:@"updated_at"];
    }];
    [self.table.classes.mj_header beginRefreshing];

}

- (void)albumPhotoSelectPath:(NSInteger)indexPath{
    AlbumClassTableModel * model = [self.dataArray objectAtIndex:indexPath];
    AlbumPhotosCtr * albumPhotos = GETALONESTORYBOARDPAGE(@"AlbumPhotosCtr");
    albumPhotos.type = @"photo";
    albumPhotos.uid = _uid;
    albumPhotos.subClassid = model.Id;
    albumPhotos.ptitle = model.name;
    [self.navigationController pushViewController:albumPhotos animated:YES];
}
#pragma makr - AFNetworking网络加载
- (void)loadNetworkData:(NSString *)order {
    
    [self showLoad];
    NSDictionary *data = nil;
    NSString *url = nil;
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    data = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_parentModel.Id],@"classifyId",@"desc",@"order",order,@"orderBy", nil];
    url = config.getSubclasses;
    
    __weak __typeof(self)weakSelef = self;
    
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",url,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [self closeLoad];
        [weakSelef.table.classes.mj_header endRefreshing];
        NSLog(@"%@",responseObject);
        AlbumClassModel * model = [[AlbumClassModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef.dataArray removeAllObjects];
            [weakSelef.dataArray addObjectsFromArray:model.dataArray];
            weakSelef.table.dataArray = weakSelef.dataArray;
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [self closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef.table.classes.mj_header endRefreshing];
    }];
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
