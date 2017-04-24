//
//  MessageCtr.m
//  ShopPhotos
//
//  Created by addcn on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "MessageCtr.h"
#import "MessageCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import <MJRefresh.h>
#import "MessageRequset.h"
#import "MessageEditOption.h"
#import "MessageMinCell.h"
#import "DetailMessageCtr.h"
#import "DetailMessageMinCtr.h"

@interface MessageCtr ()<UITableViewDelegate,UITableViewDataSource,MessageEditOptionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIView *systemView;
@property (weak, nonatomic) IBOutlet UILabel *systemText;
@property (weak, nonatomic) IBOutlet UIView *systemLine;
@property (weak, nonatomic) IBOutlet UIView *mineView;
@property (weak, nonatomic) IBOutlet UILabel *mineText;
@property (weak, nonatomic) IBOutlet UIView *mineLine;
@property (strong, nonatomic) UITableView * table;
@property (strong, nonatomic) NSMutableArray * systemArray;
@property (strong, nonatomic) NSMutableArray * requsetArray;
@property (strong, nonatomic) MessageEditOption * editOtion;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) UITableView * tableMin;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;
@property (weak, nonatomic) IBOutlet UIButton *btn_search;
@property (weak, nonatomic) IBOutlet UILabel *backText;
@property (assign, nonatomic) BOOL isEdit;
@property (assign, nonatomic) BOOL isEditMin;


@end

@implementation MessageCtr

- (NSMutableArray *)systemArray{
    if(!_systemArray) _systemArray = [NSMutableArray array];
    return _systemArray;
}

- (NSMutableArray *)requsetArray{
    if(!_requsetArray) _requsetArray = [NSMutableArray array];
    return _requsetArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup{
    self.isEdit = NO;
    self.isEditMin = NO;
    self.backText.text = @"";
    [self.back setTitle:self.str_from forState:UIControlStateNormal];
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.systemView addTarget:self action:@selector(systemSelected)];
    [self.mineView addTarget:self action:@selector(mineSelected)];
    
    self.table = [[UITableView alloc] init];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.table registerClass:[MessageCell class] forCellReuseIdentifier:MessageCellID];
    [self.view addSubview:self.table];
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableLongPressSelected)];
    [self.table addGestureRecognizer:longPressGr];
    
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,125)
    .bottomSpaceToView(self.view,0);
    
    self.tableMin = [[UITableView alloc] init];
    self.tableMin.delegate = self;
    self.tableMin.dataSource = self;
    self.tableMin.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableMin registerClass:[MessageMinCell class] forCellReuseIdentifier:MessageMinCellID];
    [self.view addSubview:self.tableMin];
    UILongPressGestureRecognizer * longPressGrMin = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableLongPressSelectedMin)];
    [self.tableMin addGestureRecognizer:longPressGrMin];
    [self.tableMin setHidden:YES];
    
    self.tableMin.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,125)
    .bottomSpaceToView(self.view,0);
    
    
    self.editOtion = [[MessageEditOption alloc] init];
    self.editOtion.delegate = self;
    [self.view addSubview:self.editOtion];
    self.editOtion.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(44);
    [self.editOtion setHidden:YES];
    
    
    __weak __typeof(self)weakSelef = self;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [weakSelef loadNetworkData];
    }];
    
    self.tableMin.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadNetworkData];
    }];
    
    [self systemSelected];
}

#pragma mark - OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)systemSelected{
    
    [self.table setHidden:NO];
    [self.tableMin setHidden:YES];
    [self.systemText setTextColor:IndigoColor];
    [self.systemLine setHidden:NO];
    
    [self.btn_search setHidden:NO];
    [self.btn_add setHidden:NO];
    
    [self.mineLine setHidden:YES];
    [self.mineText setTextColor:[UIColor grayColor]];
    self.type = 1;
    if(self.systemArray.count == 0){
        [self.table.mj_header beginRefreshing];
    }else{
        [self.table reloadData];
    }
    [self setTableEditStyleMin:NO];
}

- (void)mineSelected{
    
    [self.table setHidden:YES];
    [self.tableMin setHidden:NO];
    
    [self.btn_search setHidden:YES];
    [self.btn_add setHidden:YES];
    
    [self.mineText setTextColor:IndigoColor];
    [self.mineLine setHidden:NO];
    
    [self.systemLine setHidden:YES];
    [self.systemText setTextColor:[UIColor grayColor]];
    self.type = 2;
    if(self.requsetArray.count == 0){
        [self.tableMin.mj_header beginRefreshing];
    }else{
        [self.tableMin reloadData];
    }
    [self setTableEditStyle:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView == self.table){
        return [self.systemArray count];
    }else{
        return [self.requsetArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.table){
        MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:MessageCellID forIndexPath:indexPath];
        cell.model = [self.systemArray objectAtIndex:indexPath.row];
        return cell;
    }else{
    
        MessageMinCell * cell = [tableView dequeueReusableCellWithIdentifier:MessageMinCellID forIndexPath:indexPath];
        cell.model = [self.requsetArray objectAtIndex:indexPath.row];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if(tableView == self.table){
//        MessageModel *   model = [self.systemArray objectAtIndex:indexPath.row];
//        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MessageCell class] contentViewWidth:WindowWidth];
//    }else{
        return 80;
//    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.table){
        MessageModel * model = [self.systemArray objectAtIndex:indexPath.row];
        if (self.isEdit) {
            model.editSelect = !model.editSelect;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            NSInteger index = 0;
            for(MessageModel * model in self.systemArray){
                if(model.editSelect){
                    index++;
                }
            }
            [self.editOtion setDeleteCount:index];
            if(index == self.systemArray.count){
                self.editOtion.allSelect = YES;
            }else{
                self.editOtion.allSelect = NO;
            }
        } else {
            DetailMessageCtr * detailMsg = [[UIStoryboard storyboardWithName:@"MessageCtr" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DetailMessageCtr"];
            detailMsg.atitle = model.title;
            detailMsg.content = model.content;
            detailMsg.avatar = model.avatar;
            detailMsg.type = model.type;
            detailMsg.date = model.date;
            [self.navigationController pushViewController:detailMsg animated:YES];
        }
    } else if(tableView == self.tableMin){
        MessageModel * model = [self.requsetArray objectAtIndex:indexPath.row];
        if (self.isEditMin) {
            model.editSelect = !model.editSelect;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            NSInteger index = 0;
            for(MessageModel * model in self.requsetArray){
                if(model.editSelect){
                    index++;
                }
            }
            [self.editOtion setDeleteCount:index];
            if(index == self.requsetArray.count){
                self.editOtion.allSelect = YES;
            }else{
                self.editOtion.allSelect = NO;
            }
        } else {
            DetailMessageMinCtr * detailMsg = [[UIStoryboard storyboardWithName:@"MessageCtr" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DetailMessageMinCtr"];
            detailMsg.atitle = model.title;
            detailMsg.content = model.content;
            detailMsg.avatar = model.avatar;
            detailMsg.type = model.type;
            detailMsg.date = model.date;
            [self.navigationController pushViewController:detailMsg animated:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.table){
        return NO;
    }else{
        return NO;
    }
   
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MessageModel * model = [self.requsetArray objectAtIndex:indexPath.row];
    NSString * uid = @"";
    NSLog(@"%@",model.type);
    NSRange range = [model.type rangeOfString:@"copyRequest:"];
    if(model.type.length > 12){
        uid = [model.type substringFromIndex:range.length];
    }
    
    __weak __typeof(self)weakSelef = self;
    UITableViewRowAction *
    refuse = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"拒绝" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"拒绝");
        NSDictionary * data = @{@"noticesId":[NSString stringWithFormat:@"%ld",model.itemID]};
        [weakSelef deleteNotice:data];
    }];
    
    UITableViewRowAction * agree = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"同意" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSDictionary * data = @{@"uid":uid,@"notice_ids":[NSString stringWithFormat:@"%ld",model.itemID]};
        [weakSelef allowUserCopy:data];
    }];
    
    [agree setBackgroundColor:ThemeColor];
    [refuse setBackgroundColor:[UIColor blackColor]];
    
    return @[refuse,agree];
}



- (void)tableLongPressSelected{
    [self setTableEditStyle:YES];
}

- (void)setTableEditStyle:(BOOL)edit{
    self.isEdit = edit;

    if(!edit)[self.editOtion setDeleteCount:0];
    
    for(MessageModel * model in self.systemArray){
        if(model.edit == edit)return;
        model.edit = edit;
        if(!edit)model.editSelect = NO;
            
    }
    [self.table reloadData];
    [self.editOtion setHidden:!edit];
    if(edit){
        self.table.sd_layout.bottomSpaceToView(self.view,44);
    }else{
        self.table.sd_layout.bottomSpaceToView(self.view,0);
    }
    [self.table updateLayout];
    
}
- (void)tableLongPressSelectedMin{
    [self setTableEditStyleMin:YES];
}
- (void)setTableEditStyleMin:(BOOL)edit{
    self.isEditMin = edit;
    if(!edit)[self.editOtion setDeleteCount:0];
    
    for(MessageModel * model in self.requsetArray){
        if(model.edit == edit)return;
        model.edit = edit;
        if(!edit)model.editSelect = NO;
        
    }
    [self.tableMin reloadData];
    [self.editOtion setHidden:!edit];
    if(edit){
        self.tableMin.sd_layout.bottomSpaceToView(self.view,44);
    }else{
        self.tableMin.sd_layout.bottomSpaceToView(self.view,0);
    }
    [self.tableMin updateLayout];
    
}

#pragma mark - MessageEditOptionDelegate
- (void)messageEditOptionSelected:(NSInteger)type{
    if(self.type == 1){
    
        if(type == 1){
            NSLog(@"全选");
            if(self.editOtion.allSelect){
                for(MessageModel * model in self.systemArray){
                    model.edit = YES;
                    model.editSelect = NO;
                }
                 [self.editOtion setDeleteCount:0];
            }else{
                for(MessageModel * model in self.systemArray){
                    model.edit = YES;
                    model.editSelect = YES;
                }
                 [self.editOtion setDeleteCount:self.systemArray.count];
            }
            self.editOtion.allSelect = !self.editOtion.allSelect;
            [self.table reloadData];
           
            
        }else if(type == 2){
            NSLog(@"删除");
            int selectCount = 0;
            NSMutableDictionary * data = [NSMutableDictionary new];
            for(MessageModel * model in self.systemArray){
                if(model.editSelect){
                    [data setValue:[NSString stringWithFormat:@"%ld", model.itemID] forKey:[NSString stringWithFormat:@"noticesId[%d]", selectCount]];
                    selectCount++;
                }
                
            }
            if(selectCount == 0) {
    //            ShowAlert(@"当前未选中哦！");
                SPAlert(@"当前未选中哦！",self);
                return;
            }
            __weak __typeof(self)weakSelef = self;
            NSString * msg = [NSString stringWithFormat:@"确定删除%ld项",selectCount];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                [weakSelef deleteNotice:data];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else if(type == 3){
            NSLog(@"取消");
                [self setTableEditStyle:NO];
            
        }
    } else if(self.type == 2){
        if(type == 1){
            NSLog(@"全选");
            if(self.editOtion.allSelect){
                for(MessageModel * model in self.requsetArray){
                    model.edit = YES;
                    model.editSelect = NO;
                }
                [self.editOtion setDeleteCount:0];
            }else{
                for(MessageModel * model in self.requsetArray){
                    model.edit = YES;
                    model.editSelect = YES;
                }
                [self.editOtion setDeleteCount:self.requsetArray.count];
            }
            self.editOtion.allSelect = !self.editOtion.allSelect;
            [self.tableMin reloadData];
            
            
        }else if(type == 2){
            NSLog(@"删除");
            int selectCount = 0;
            NSMutableDictionary * data = [NSMutableDictionary new];
            for(MessageModel * model in self.requsetArray){
                if(model.editSelect){
                    [data setValue:[NSString stringWithFormat:@"%ld", model.itemID] forKey:[NSString stringWithFormat:@"noticesId[%d]", selectCount]];
                    selectCount++;
                }
                
            }
            if(selectCount == 0) {
                //            ShowAlert(@"当前未选中哦！");
                SPAlert(@"当前未选中哦！",self);
                return;
            }
            __weak __typeof(self)weakSelef = self;
            NSString * msg = [NSString stringWithFormat:@"确定删除%ld项",selectCount];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                [weakSelef deleteNotice:data];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else if(type == 3){
            NSLog(@"取消");
            [self setTableEditStyleMin:NO];
            
        }
    }
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData{
    
    self.pageIndex = 1;
    [self setTableEditStyle:NO];
    NSString * type = @"";
    if(self.type == 1){
        type = @"system";
    }else{
        type = @"copyRequest";
    }
    
    NSDictionary * data = @{@"page":[NSString stringWithFormat:@"%ld",self.pageIndex],
                            @"pageSize":@"20",
                            @"type":type};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getNotices,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef.tableMin.mj_header endRefreshing];
        [weakSelef.table.mj_header endRefreshing];
        MessageRequset * requset = [[MessageRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            if(weakSelef.type == 1){
                weakSelef.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelef loadNetworkMoreData];
                }];
                [weakSelef.systemArray removeAllObjects];
                [weakSelef.systemArray addObjectsFromArray:requset.dataArray];
                if(requset.dataArray.count < 20){
                    [weakSelef.table.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [weakSelef.table.mj_footer resetNoMoreData];
                }
                [weakSelef.table reloadData];
            }else{
                weakSelef.tableMin.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelef loadNetworkMoreData];
                }];
                [weakSelef.requsetArray removeAllObjects];
                [weakSelef.requsetArray addObjectsFromArray:requset.dataArray];
                if(requset.dataArray.count < 20){
                    [weakSelef.tableMin.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [weakSelef.tableMin.mj_footer resetNoMoreData];
                }
                [weakSelef.tableMin reloadData];
            }
           weakSelef.pageIndex++;
        }else{
            [self.backText setText:requset.message];
//            [weakSelef showToast:requset.message];
        }
        
        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.table.mj_header endRefreshing];
        [weakSelef.tableMin.mj_header endRefreshing];
    }];
}

- (void)loadNetworkMoreData{
    [self setTableEditStyle:NO];
    
    NSString * type = @"";
    if(self.type == 1){
        type = @"system";
    }else{
        type = @"copyRequest";
    }
    
    NSDictionary * data = @{@"page":[NSString stringWithFormat:@"%ld",self.pageIndex],
                            @"pageSize":@"20",
                            @"noticeType":type};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getNotices,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef.table.mj_footer endRefreshing];
        [weakSelef.tableMin.mj_footer endRefreshing];
        MessageRequset * requset = [[MessageRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            
            if(weakSelef.type == 1){
                [weakSelef.systemArray addObjectsFromArray:requset.dataArray];
                if(requset.dataArray.count < 20){
                    [weakSelef.table.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [weakSelef.table.mj_footer resetNoMoreData];
                }
                [weakSelef.table reloadData];
            }else{
                [weakSelef.requsetArray addObjectsFromArray:requset.dataArray];
                if(requset.dataArray.count < 20){
                    [weakSelef.tableMin.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [weakSelef.tableMin.mj_footer resetNoMoreData];
                }
                [weakSelef.tableMin reloadData];
            }
            weakSelef.pageIndex++;
        }else{
            [weakSelef showToast:requset.message];
        }
        
        NSLog(@"%@",responseObject);
     
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.table.mj_footer endRefreshing];
        [weakSelef.tableMin.mj_footer endRefreshing];
    }];
}

- (void)deleteNotice:(NSDictionary *)data{
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",self.congfing.deleteNotices,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            //[weakSelef showToast:@"删除成功"];
            [weakSelef loadNetworkData];
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)allowUserCopy:(NSDictionary *)data{
    //@{@"uid":uid,@"notice_ids":[NSString stringWithFormat:@"%ld",model.itmeID]}
    NSDictionary * allowData = @{@"uid":[data objectForKey:@"uid"]};
    NSDictionary * deleteData = @{@"noticesId":[data objectForKey:@"notice_ids"]};
    
    
    NSLog(@"%@",data);
    NSLog(@"%@",self.congfing.allowUser);
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.allowUser parametric:allowData succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef deleteNotice:deleteData];
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

@end
