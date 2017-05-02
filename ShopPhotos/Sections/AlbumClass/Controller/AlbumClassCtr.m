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
#import "AlbumPhotosCtr.h"
#import "MoreAlert.h"
#import "SearchAllCtr.h"
#import "ChangeClassAlert.h"
#import "CreatePhotoClassCtr.h"
#import "PhotosEditView.h"
#import "PhotosOptionView.h"
#import <MJRefresh.h>

@interface AlbumClassCtr ()<MoreAlertDelegate,AlbumClassTableDelegate,ChangeClassAlertDelegate,PhotosEditViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *more;
@property (weak, nonatomic) IBOutlet UIImageView *more_icon;
@property (weak, nonatomic) IBOutlet UILabel *ttitle;

@property (weak, nonatomic) IBOutlet UIView *search;
@property (weak, nonatomic) IBOutlet UIImageView *search_icon;
@property (weak, nonatomic) IBOutlet UIButton *order;
@property (weak, nonatomic) IBOutlet UIButton *add;

@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (strong, nonatomic) AlbumClassTable * table;
@property (strong, nonatomic) MoreAlert * moreAlert;
@property (assign, nonatomic) BOOL editStatu;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) NSIndexPath * subEditIndexPath;
@property (assign, nonatomic) NSInteger editSection;
@property (strong, nonatomic) ChangeClassAlert * changeAlert;
@property (strong, nonatomic) NSString * photoName;
@property (strong, nonatomic) NSString * photoSubName;
@property (strong, nonatomic) PhotosEditView * editHead;
@property (strong, nonatomic) UIButton * editOption;
@property (weak, nonatomic) IBOutlet UIView *tool;

@property (assign, nonatomic) BOOL needGoparent;

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
    if (_needGoparent) {
        _needGoparent = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.more_icon setImage:[UIImage imageNamed:@"add_orange"]];
    [self.search_icon setImage:[UIImage imageNamed:@"search_orange"]];
//    [self loadNetworkData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAutoLayout];
}

- (void)createAutoLayout{
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.search addTarget:self action:@selector(searchSelected)];
    [self.order addTarget:self action:@selector(moreSelected)];
    [self.edit addTarget:self action:@selector(editSelected)];
    
    _search.layer.cornerRadius = 15;
    _search.layer.masksToBounds = TRUE;

    self.editHead = [[PhotosEditView alloc] init];
    self.editHead.delegate = self;
    [self.view addSubview:self.editHead];
    [self.editHead setHidden:YES];
    self.editHead.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(64);

    self.editOption = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.editOption setTitle:@"删除" forState:UIControlStateNormal];
    [self.editOption.titleLabel setFont:Font(17)];
    [self.editOption setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.editOption setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.editOption];
    [self.editOption addTarget:self action:@selector(clickOptiontool) forControlEvents:UIControlEventTouchUpInside];
    [self.editOption setHidden:YES];
    self.editOption.sd_layout
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(64);
    
    self.table = [[AlbumClassTable alloc] init];
    self.table.albumDelegage = self;
    [self.view addSubview:self.table];
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,114)
    .bottomEqualToView(self.view);

    self.moreAlert = [[MoreAlert alloc] init];
    self.moreAlert.mode = SortOrder;
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
    
    if (_isSubClass) {
        [_ttitle setText:_parentModel.name];
        [_back setTitle:@"相册分类" forState:UIControlStateNormal];
        _back.sd_layout
        .widthIs(90);
        [_back updateLayout];
    }
    
    if (_isFromUploadPhoto) {
        [_tool setHidden:YES];
        [_edit setHidden:YES];
        if (_isSubClass == NO) {
            [_back setTitle:@"上传相册" forState:UIControlStateNormal];
            _back.sd_layout
            .widthIs(90);
            [_back updateLayout];
        }
        else {
            [self editSelected];
        }
    }
    
    __weak __typeof(self)weakSelef = self;
    self.table.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [weakSelef loadNetworkData];
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

-(void) editSelected {
    [self.editHead setHidden:NO];
    [self.editOption setHidden:NO];
    
    if (_isFromUploadPhoto) {
        [_editOption setTitle:@"选择" forState:UIControlStateNormal];
    }
    
    [_editHead.title setText:_ttitle.text];
    self.table.sd_layout.bottomSpaceToView(self.view,64);
    self.table.isEditMode = YES;
    [self.table updateLayout];
    [self.table.table reloadData];
}

#pragma mark - PhotosEditViewDelegate
- (void)photosEditSelected:(NSInteger)type {
    if (type == 1) {
        if (_isFromUploadPhoto && _isSubClass) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.editHead setHidden:YES];
            [self.editOption setHidden:YES];
            self.table.sd_layout.bottomSpaceToView(self.view,0);
            self.table.isEditMode = NO;
            self.table.isAllSelect = NO;
            [self.table updateLayout];
            [self.table.table reloadData];
        }
    }
    else {
        self.table.isAllSelect = YES;
        [self.table.table reloadData];
    }
    
    if (_isSubClass) {
        for (AlbumClassTableSubModel *subModel in self.dataArray) {
            subModel.delChecked = NO;
        }
    }
    else {
        for (AlbumClassTableModel *model in self.dataArray) {
            model.delChecked = NO;
        }
    }
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
- (void)editClassName:(NSString *)name indexClass:(NSInteger)index{
    
    if(!name || name.length == 0){
        SPAlert(@"请输入分类名",self);
        return;
    }
        // 父类名称修改
    if (_changeAlert.addClass) {
        [self createClass:index className:name];
    }
    else {
        [self changeClassName:index className:name];
    }
}

#pragma mark - AlbumClassTableDelegate
- (void)albumClassTableSelected:(NSIndexPath *)indexPath {
}

// edit, add, del classfiy
- (void)albumClassTableSelectType:(NSInteger)type selectPath:(NSIndexPath *)indexPath {
    if(type == 1){ // change
        NSString *className = nil;
        if (_isSubClass) {
            AlbumClassTableModel * model = [self.dataArray objectAtIndex:indexPath.section];
            className = model.name;
        }
        else{
            AlbumClassTableSubModel * subModel = [self.dataArray objectAtIndex:indexPath.section];
            className = subModel.name;
        }
        _changeAlert.addClass = NO;
        _changeAlert.index = indexPath.section;
        _changeAlert.dName = className;
        _changeAlert.subClass = _isSubClass;
         [_changeAlert showAlert];
    }else if(type == 2){ //delete
        NSLog(@"cell delete select %ld - %ld",indexPath.section,indexPath.row);
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除?" message:@"删除父分类会将此父分\n类下所有子分类 全部" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self deleteClass:indexPath];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (type == 3) { //add subclass
        NSLog(@"cell add subClass select %ld - %ld",indexPath.section,indexPath.row);
//        _editSection = indexPath.section;
        _changeAlert.addClass = YES;
        _changeAlert.subClass = YES;
        _changeAlert.index = indexPath.section;
        [_changeAlert showAlert];
    }
}

- (void)albumClassTableHeadSelected:(NSInteger )index {
    AlbumClassTableModel * model = [self.dataArray objectAtIndex:index];
    if (_isSubClass == NO) {
        if (model.isVideo) {
            AlbumPhotosCtr * albumPhotos = GETALONESTORYBOARDPAGE(@"AlbumPhotosCtr");
            albumPhotos.type = @"video";
            albumPhotos.uid = _uid;
            albumPhotos.subClassid = -1;
            albumPhotos.ptitle = @"视频列表";
            [self.navigationController pushViewController:albumPhotos animated:YES];
        }
        else{
            AlbumClassCtr * albumClass = GETALONESTORYBOARDPAGE(@"AlbumClassCtr");
            albumClass.isSubClass = YES;
            albumClass.uid = _uid;
            albumClass.parentModel = model;
            albumClass.isFromUploadPhoto = _isFromUploadPhoto;
            albumClass.publish = _publish;
            if (_isFromUploadPhoto) {
                //            _needGoparent = YES;
            }
            [self.navigationController pushViewController:albumClass animated:YES];
        }
    }
    else {
        AlbumPhotosCtr * albumPhotos = GETALONESTORYBOARDPAGE(@"AlbumPhotosCtr");
        albumPhotos.type = @"photo";
        albumPhotos.uid = _uid;
        albumPhotos.subClassid = model.Id;
        albumPhotos.ptitle = model.name;
        [self.navigationController pushViewController:albumPhotos animated:YES];
    }
}

//- (void)albumClassTableHeadSelectType:(NSInteger)type selectedPath:(NSInteger)section{}
- (void)albumClassTableHeadSelectCheck:(BOOL)isChecked selectedPath:(NSInteger)index {
    if (_isSubClass) {
        AlbumClassTableSubModel *subModel = [self.dataArray objectAtIndex:index];
        subModel.delChecked = isChecked;
        if (_isFromUploadPhoto && isChecked == YES) {
            for (int idx=0; idx<self.dataArray.count; idx++){
                if (idx != index) {
                    AlbumClassTableSubModel *sm = [self.dataArray objectAtIndex:idx];
                    sm.delChecked = NO;
                }
            }
        }
    }
    else {
        AlbumClassTableModel *model = [self.dataArray objectAtIndex:index];
        model.delChecked = isChecked;
    }
    
    self.table.dataArray = self.dataArray;
    [self.table.table reloadData];
    
    NSLog(@"del index %ld", index);
}

- (IBAction)addClassify:(id)sender {
    _changeAlert.addClass = YES;
    if (_isSubClass) {
        _changeAlert.index = _parentModel.Id;
    }
    else {
        _changeAlert.index = -1;
    }
    _changeAlert.subClass = _isSubClass;
    
    [_changeAlert showAlert];
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData {

    NSDictionary *data = nil;
    NSString *url = nil;
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    if (_isSubClass) {
        data = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",_parentModel.Id],@"classifyId",@"desc",@"order",@"updated_at",@"orderBy", nil];
        url = config.getSubclasses;
    }
    else {
        data = [NSDictionary dictionaryWithObjectsAndKeys:_uid,@"uid",@"desc",@"order",@"updated_at",@"orderBy", nil];
        url = config.getClassifies;
    }
    
    __weak __typeof(self)weakSelef = self;
    
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",url,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
       [weakSelef.table.table.mj_header endRefreshing];
        NSLog(@"%@",responseObject);
        AlbumClassModel * model = [[AlbumClassModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef.dataArray removeAllObjects];
            [weakSelef.dataArray addObjectsFromArray:model.dataArray];
            weakSelef.table.isSubClass = weakSelef.isSubClass;
            weakSelef.table.dataArray = weakSelef.dataArray;
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef.table.table.mj_header endRefreshing];
    }];
}

- (void)createClass:(NSInteger)index className:(NSString *)name {
    
    [self showLoad];
    
    NSDictionary *data = nil;
    NSString *url = nil;
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    
    if (_isSubClass) { // sub class
        data = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",[NSString stringWithFormat:@"%ld",index],@"classifyId", nil];
        url = config.createSubclass;
    }
    else { // parent class
        if (index == -1) {
            data = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name", nil];
            url = config.createClassify;
        }
        else {
            AlbumClassTableModel * model = [self.dataArray objectAtIndex:index];
            data = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",[NSString stringWithFormat:@"%ld",model.Id],@"classifyId", nil];
            url = config.createSubclass;
        }
    }
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl :[NSString stringWithFormat:@"%@%@",url,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"创建成功"];
            [weakSelef.table.table.mj_header beginRefreshing];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void) clickOptiontool {
    
    if ([_editOption.titleLabel.text isEqualToString:@"选择"]) {
        NSMutableString *subClass = [[NSMutableString alloc]init];
        NSMutableString *parentClass = [[NSMutableString alloc] init];
        if (_isSubClass && _isFromUploadPhoto) {
            for (AlbumClassTableSubModel *subModel in _dataArray) {
                if (subModel.delChecked) {
                    [subClass setString:subModel.name];
                    [parentClass setString:_parentModel.name];
                    break;
                }
            }
        }
        
        [_publish setClassifies:parentClass subClass:subClass];
        [self backSelected];
    }
    else {
        [self deleteClasses];
    }
}

- (void)deleteClasses{
    
    [self showLoad];
    
    NSString *url = nil;
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    NSInteger index = 0;
    if (_isSubClass) {
        for(AlbumClassTableSubModel * subModel in self.dataArray) {
            if (subModel.delChecked) {
                [data setValue:[NSString stringWithFormat:@"%ld",subModel.Id] forKey:[NSString stringWithFormat:@"subclassesId[%ld]",index]];
            }
            index++;
        }
        url = config.deleteSubclasses;
    }
    else {
        for(AlbumClassTableModel * model in self.dataArray) {
            if (model.delChecked) {
                [data setValue:[NSString stringWithFormat:@"%ld",model.Id] forKey:[NSString stringWithFormat:@"classifiesId[%ld]",index]];
            }
            index++;
        }
        url = config.deleteClassifies;
    }
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",url,[self.appd getParameterString]] parametric:data succed:^(id responseObject) {
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

- (void)deleteClass:(NSIndexPath *)indexPath {
    
    [self showLoad];
    
    NSDictionary *data = nil;
    NSString *url = nil;
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    
    if (_isSubClass) {
        AlbumClassTableSubModel * subModel = [self.dataArray objectAtIndex:indexPath.section];
        data = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",subModel.Id],@"subclassId", nil];
        url = config.deleteSubclass;
    }
    else {
        AlbumClassTableModel * model = [self.dataArray objectAtIndex:indexPath.section];
        data = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",model.Id],@"classifyId", nil];
        url = config.deleteClassify;
    }
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",url,[self.appd getParameterString]] parametric:data succed:^(id responseObject) {
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"删除分类成功"];
            [weakSelef.dataArray removeObjectAtIndex:indexPath.section];
            weakSelef.table.dataArray = weakSelef.dataArray;
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)changeClassName:(NSInteger)index className:(NSString *)name {
    
    [self showLoad];
    NSDictionary *data = nil;
    NSString *url = nil;
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    
    if (_isSubClass == NO) { // parent class
        AlbumClassTableModel * model = [self.dataArray objectAtIndex:index];
        data = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",[NSString stringWithFormat:@"%ld",model.Id],@"classifyId", nil];
        url = config.updateClassify;
    }
    else { // sub class
        AlbumClassTableSubModel * model = [self.dataArray objectAtIndex:index];
        data = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",[NSString stringWithFormat:@"%ld",model.Id],@"classifyId", nil];
        url = config.updateSubclass;
    }
    __weak __typeof(self)weakSelef = self;
    
    [HTTPRequest requestPUTUrl :[NSString stringWithFormat:@"%@%@",url,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            if (_isSubClass) {
                AlbumClassTableSubModel * subModel = [weakSelef.dataArray objectAtIndex:index];
                subModel.name = name;
            }else{
                AlbumClassTableModel * model = [weakSelef.dataArray objectAtIndex:index];
                model.name = name;
            }
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
