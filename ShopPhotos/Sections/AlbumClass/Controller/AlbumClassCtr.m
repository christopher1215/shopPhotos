//
//  AlbumClassCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AlbumClassCtr.h"
#import "AlbumClassTable.h"
#import "AlbumClassModel.h"
#import "MoreAlert.h"
#import "AlbumClassTableModel.h"
#import "AlbumClassTableSubModel.h"
#import "SearchAllCtr.h"
#import "ChangeClassAlert.h"
#import "CreatePhotoClassCtr.h"
#import "AlbumClassTabelCtr.h"
#import <MJRefresh.h>

@interface AlbumClassCtr ()<MoreAlertDelegate,AlbumClassTableDelegate,ChangeClassAlertDelegate>

@property (weak, nonatomic) IBOutlet UIView *more;
@property (weak, nonatomic) IBOutlet UIImageView *more_icon;

@property (weak, nonatomic) IBOutlet UIView *search;
@property (weak, nonatomic) IBOutlet UIImageView *search_icon;

@property (weak, nonatomic) IBOutlet UIView *back;
@property (strong, nonatomic) AlbumClassTable * table;
@property (strong, nonatomic) MoreAlert * moreAlert;
@property (assign, nonatomic) BOOL editStatu;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) NSIndexPath * subEditIndexPath;
@property (assign, nonatomic) NSInteger editSection;
@property (strong, nonatomic) ChangeClassAlert * changeAlert;
@property (strong, nonatomic) NSString * photoName;
@property (strong, nonatomic) NSString * photoSubName;

@end

@implementation AlbumClassCtr

- (NSMutableArray *)dataArray{
    
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.more_icon setImage:[UIImage imageNamed:@"add_orange"]];
    [self.search_icon setImage:[UIImage imageNamed:@"search_orange"]];
    [self loadNetworkData:@{@"uid":_uid}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAutoLayout];
}



- (void)createAutoLayout{
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.search addTarget:self action:@selector(searchSelected)];
    [self.more addTarget:self action:@selector(moreSelected)];
    
    self.table = [[AlbumClassTable alloc] init];
    self.table.albumDelegage = self;
    [self.view addSubview:self.table];
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .bottomEqualToView(self.view);

    self.moreAlert = [[MoreAlert alloc] init];
    self.moreAlert.mode = PhotosClassModel;
    self.moreAlert.delegate = self;
    [self.view addSubview:self.moreAlert];
    [self.moreAlert setHidden:YES];
    self.moreAlert.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    self.changeAlert = [[ChangeClassAlert alloc] init];
    self.changeAlert.delegate = self;
    [self.view addSubview:self.changeAlert];
    [self.changeAlert setHidden:YES];
    self.changeAlert.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    __weak __typeof(self)weakSelef = self;
    self.table.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [weakSelef loadNetworkData:@{@"uid":_uid}];
    }];
    [self.table.table.mj_header beginRefreshing];
    
}

#pragma mark - OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchSelected{
    
    if(self.editStatu){
        for(AlbumClassTableModel * model in self.dataArray){
            model.edit = NO;
            for(AlbumClassTableSubModel * subModel in model.dataArray){
                subModel.edit = NO;
            }
        }
        [self.more_icon setImage:[UIImage imageNamed:@"add_orange"]];
        [self.search_icon setImage:[UIImage imageNamed:@"search_orange"]];
        self.table.dataArray = self.dataArray;
        self.editStatu = NO;
        return;
    }
    
    SearchAllCtr * search = GETALONESTORYBOARDPAGE(@"SearchAllCtr");
    [self.navigationController pushViewController:search animated:YES];
}
- (void)moreSelected{
    
    if(self.editStatu){
        for(AlbumClassTableModel * model in self.dataArray){
            model.edit = NO;
            for(AlbumClassTableSubModel * subModel in model.dataArray){
                subModel.edit = NO;
            }
        }
        [self.more_icon setImage:[UIImage imageNamed:@"add_orange"]];
        [self.search_icon setImage:[UIImage imageNamed:@"search_orange"]];
        self.table.dataArray = self.dataArray;
        self.editStatu = NO;
        return;
    }
    [self.moreAlert showAlert];
}

#pragma mark - MoreAlertDelegate
- (void)moreAlertSelected:(NSInteger)indexPath{
    if(indexPath == 0){
        // 编辑
        if(self.editStatu){
            NSLog(@"取消");
            for(AlbumClassTableModel * model in self.dataArray){
                model.edit = NO;
                for(AlbumClassTableSubModel * subModel in model.dataArray){
                    subModel.edit = NO;
                }
            }
        }else{
            NSLog(@"编辑");
            for(AlbumClassTableModel * model in self.dataArray){
                model.edit = YES;
                for(AlbumClassTableSubModel * subModel in model.dataArray){
                    subModel.edit = YES;
                }
            }
        }
        
        [self.more_icon setImage:[UIImage imageNamed:@"sure_edit"]];
        [self.search_icon setImage:[UIImage imageNamed:@"cancel_edit"]];
        
        self.table.dataArray = self.dataArray;
        self.editStatu = !self.editStatu;
    }else{
        // 新建分类
        NSLog(@"新建分类");
        CreatePhotoClassCtr * createPhoto = GETALONESTORYBOARDPAGE(@"CreatePhotoClassCtr");
        createPhoto.uid = self.uid;
        [self.navigationController pushViewController:createPhoto animated:YES];
    }
}

#pragma mark - ChangeClassAlertDelegate
- (void)editClassName:(NSString *)name{
    
    if(!name || name.length == 0){
        SPAlert(@"请输入分类名",self);
        return;
    }
    
    if(self.changeAlert.subClass){
        // 子类名称修改
        self.photoSubName = name;
        AlbumClassTableModel * model = [self.dataArray objectAtIndex:self.subEditIndexPath.section];
        AlbumClassTableSubModel * subModel = [model.dataArray objectAtIndex:self.subEditIndexPath.row];
        [self cahngeSubClassName:@{@"name":self.photoSubName,
                                   @"classify_id":[NSString stringWithFormat:@"%ld",model.classID],
                                   @"id":[NSString stringWithFormat:@"%ld",subModel.subClassID],
                                   @"cover":subModel.cover}];
        
    }else{
        // 父类名称修改
        AlbumClassTableModel * model = [self.dataArray objectAtIndex:self.editSection];
        self.photoName = name;
        [self changeClassName:@{@"name":self.photoName,
                                @"id":[NSString stringWithFormat:@"%ld",model.classID]}];
    }
    
    
}

#pragma mark - AlbumClassTableDelegate
- (void)albumClassTableSelected:(NSIndexPath *)indexPath{
    
    AlbumClassTableModel * model = [self.dataArray objectAtIndex:indexPath.section];
    AlbumClassTableSubModel * subModel = [model.dataArray objectAtIndex:indexPath.row];
    AlbumClassTabelCtr * classTable = GETALONESTORYBOARDPAGE(@"AlbumClassTabelCtr");
    classTable.uid = self.photosUserID;
    classTable.subClassID = [NSString stringWithFormat:@"%ld",subModel.subClassID];
    classTable.pageText = subModel.name;
    [self.navigationController pushViewController:classTable animated:YES];
}

- (void)albmClassTableHeadSelectType:(NSInteger)type slectedPath:(NSInteger)section{
    self.editSection = section;
    AlbumClassTableModel * model = [self.dataArray objectAtIndex:self.editSection];
    if(type == 1){
        NSLog(@"head change select %ld",section);
        self.changeAlert.subClass = NO;
        [self.changeAlert setDName:model.name];
        [self.changeAlert showAlert];
    }else{
        NSLog(@"head delete select %ld",section);
        __weak __typeof(self)weakSelef = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除父分类会把当前分类下所有子分类全部删除\n确定删除吗" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [weakSelef deleteClass:@{@"id":[NSString stringWithFormat:@"%ld",model.classID]}];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)albumClassTableSelectType:(NSInteger)type selectPath:(NSIndexPath *)indexPath{
    self.subEditIndexPath = indexPath;
    AlbumClassTableModel * model = [self.dataArray objectAtIndex:self.subEditIndexPath.section];
    AlbumClassTableSubModel * subModel = [model.dataArray objectAtIndex:self.subEditIndexPath.row];
    
    if(type == 1){
        NSLog(@"cell change select %ld - %ld",indexPath.section,indexPath.row);
        self.changeAlert.subClass = YES;
        [self.changeAlert setDName:subModel.name];
         [self.changeAlert showAlert];
    }else{
        NSLog(@"cell delete select %ld - %ld",indexPath.section,indexPath.row);
        [self deleteSubClass:@{@"subclassification_ids":[NSString stringWithFormat:@"%ld",subModel.subClassID]}];
        
    }
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData:(NSDictionary *)data{
    
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.getPhotoClassifies parametric:data succed:^(id responseObject){
       [weakSelef.table.table.mj_header endRefreshing];
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
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.table.table.mj_header endRefreshing];
    }];
}

- (void)deleteSubClass:(NSDictionary *)data{
    
    [self showLoad];
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.deleteSubclassifications parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            AlbumClassTableModel * model = [weakSelef.dataArray objectAtIndex:weakSelef.subEditIndexPath.section];
            [model.dataArray removeObjectAtIndex:weakSelef.subEditIndexPath.row];
            weakSelef.table.dataArray = weakSelef.dataArray;
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)deleteClass:(NSDictionary *)data{
    [self showLoad];
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.deleteClassify parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"删除分类成功"];
            [weakSelef.dataArray removeObjectAtIndex:weakSelef.editSection];
            weakSelef.table.dataArray = weakSelef.dataArray;
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)cahngeSubClassName:(NSDictionary *)data{
    
    [self showLoad];
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.updateSubclassification parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"修改子分类成功"];
            AlbumClassTableModel * model = [weakSelef.dataArray objectAtIndex:weakSelef.subEditIndexPath.section];
            AlbumClassTableSubModel * subModel = [model.dataArray objectAtIndex:weakSelef.subEditIndexPath.row];
            subModel.name = weakSelef.photoSubName;
            
            weakSelef.table.dataArray = weakSelef.dataArray;
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)changeClassName:(NSDictionary *)data{
    
    [self showLoad];
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.updateClassify parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            AlbumClassTableModel * model = [weakSelef.dataArray objectAtIndex:weakSelef.editSection];
            model.name = weakSelef.photoName;
            weakSelef.table.dataArray = weakSelef.dataArray;
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

@end
