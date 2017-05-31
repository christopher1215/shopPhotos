//
//  CreatePhotoClassCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "CreatePhotoClassCtr.h"
#import "PhotoClassCreate.h"
#import "PhotoClassSelectAlert.h"
#import "AlbumClassTableModel.h"
#import "AlbumClassModel.h"

@interface CreatePhotoClassCtr ()<PhotoClassCreateDelegate,PhotoClassSelectAlertDelegate>
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIButton *complete;
@property (strong, nonatomic) PhotoClassCreate * classCreate;
@property (strong, nonatomic) UIView * alertBG;
@property (strong, nonatomic) PhotoClassSelectAlert * alert;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (assign, nonatomic) NSInteger  selecClass;
@end

@implementation CreatePhotoClassCtr

- (NSMutableArray *)dataArray{
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self loadNetworkData:@{@"uid":self.uid}];
}

- (void)setup{
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.complete addTarget:self action:@selector(completeSelected) forControlEvents:UIControlEventTouchUpInside];
    self.classCreate = [[PhotoClassCreate alloc] init];
    self.classCreate.delegate = self;
    [self.view addSubview:self.classCreate];
    self.classCreate.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .bottomEqualToView(self.view);
    
    AlbumClassTableModel * model  = [[AlbumClassTableModel alloc] init];
    model.name = @"新建父分类";
    [self.dataArray addObject:model];
}

- (void)createAlet{
    self.alertBG = [[UIView alloc] init];
    [self.alertBG setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self.alertBG addTarget:self action:@selector(alertBGSelected)];
    self.alertBG.cornerRadius = 3;
    [self.view addSubview:self.alertBG];
    
    self.alertBG.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view)
    .rightEqualToView(self.view);
    
    self.alert = [[PhotoClassSelectAlert alloc] init];
    [self.alert addTarget:self action:@selector(alertSelected)];
    self.alert.delegate = self;
    [self.alertBG addSubview:self.alert];
    if(self.dataArray && self.dataArray.count > 0){
        self.alert.dataArray = self.dataArray;
        
        CGFloat offset = WindowHeight - 140 -(self.dataArray.count *44);
        if(offset < 0){
            self.alert.sd_layout
            .leftSpaceToView(self.alertBG,30)
            .rightSpaceToView(self.alertBG,30)
            .centerYIs(WindowHeight/2)
            .heightIs(WindowHeight-140);
            
        }else{
            self.alert.sd_layout
            .leftSpaceToView(self.alertBG,30)
            .rightSpaceToView(self.alertBG,30)
            .centerYIs(WindowHeight/2)
            .heightIs(44*self.dataArray.count);
        }
        
    }
    [self.alertBG setHidden:YES];
}

#pragma mark - OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completeSelected{
    NSDictionary * data = [self.classCreate getClassifiesName];
    if(data){
        
        NSString * name = [data objectForKey:@"name"];
        NSString * subName = [data objectForKey:@"subName"];
        NSLog(@"name --- > %@   subName --> %@",name,subName);
        
        if(self.selecClass == 0){
            
            if(!name || name.length == 0){
                [self showToast:@"分类名未填写"];
                return;
            }
            
            if(!subName || subName.length == 0){
                [self showToast:@"您还有子分类名未填写"];
                return;
            }
            // 创建
            NSDictionary * data = @{@"classifyId":@"0",
                                    @"newClassifyName":name,
                                    @"subclassifications":subName};
            [self createClassData:data];
            
        }else{
        
            if(!subName || subName.length == 0){
                [self showToast:@"您还有子分类名未填写"];
                return;
            }
            // 创建
            
            AlbumClassTableModel * model = [self.dataArray objectAtIndex:self.selecClass];
            NSDictionary * data = @{@"classifyId":[NSString stringWithFormat:@"%ld",(long)model.Id],
                                    @"newClassifyName":@"",
                                    @"subclassifications":subName};
            [self createClassData:data];
        }
    }
}

- (void)alertBGSelected{
    [UIView animateWithDuration:0.5 animations:^{
        [self.alertBG setAlpha:0];
    } completion:^(BOOL finished){
        [self.alertBG setHidden:YES];
    }];
}
- (void)alertSelected{
    
    
    
}

#pragma mark - PhotoClassCreateDelegate
- (void)photoSelectedClass{
    [self.alertBG setHidden:NO];
    [self.alertBG setAlpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [self.alertBG setAlpha:1];
    }];
}

#pragma mark - PhotoClassSelectAlertDelegate
- (void)photoClassSelectAlert:(NSIndexPath *)indexPath{
    [self alertBGSelected];
    if(indexPath.row == 0){
        [self.classCreate setStyleView:YES];
    }else{
        [self.classCreate setStyleView:NO];
    }
    self.selecClass = indexPath.row;
    AlbumClassTableModel * model = [self.dataArray objectAtIndex:indexPath.row];
    [self.classCreate setSelectedTitle:model.name];
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData:(NSDictionary *)data{
    
    [self showLoad];
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.getClassifies parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        AlbumClassModel * model = [[AlbumClassModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef.dataArray addObjectsFromArray:model.dataArray];
            [weakSelef createAlet];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)createClassData:(NSDictionary *)data{
    
    [self showLoad];
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.createClassify parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"创建成功"];
            [weakSelef.navigationController popViewControllerAnimated:YES];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

@end
