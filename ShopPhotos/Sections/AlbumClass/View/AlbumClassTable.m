//
//  AlbumClassTable.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AlbumClassTable.h"
#import "HTTPRequest.h"
#import "CongfingURL.h"
#import "NSObject+StoreValue.h"
#import "AlbumClassModel.h"
#import "AlbumClassTableModel.h"
#import "AlbumClassTableHead.h"
#import "AlbumClassTableCell.h"
#import "AlbumClassTableSubModel.h"

@interface AlbumClassTable ()<UITableViewDelegate,UITableViewDataSource,AlbumClassTableHeadDelegate,AlbumClassTableCellDelegate>

@end

@implementation AlbumClassTable

- (void)setDataArray:(NSMutableArray *)dataArray{
    
    if(dataArray){
        if(!_dataArray) _dataArray = [NSMutableArray array];
        if(_dataArray.count > 0) [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:dataArray];
        [self.table reloadData];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = ColorHex(0Xeeeeee);
        self.table = [[UITableView alloc] init];
        [self.table setBackgroundColor:ColorHex(0Xeeeeee)];
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.table registerClass:[AlbumClassTableCell class] forCellReuseIdentifier:AlbumClassTableCellID];
        [self addSubview:self.table];
        
        self.table.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .bottomEqualToView(self);
        
        _isEditMode = NO;
        _isAllSelect = NO;
        _isSubClass = NO;
    }
    return self;
}

#pragma makr - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    BOOL isOpen = NO;
    if(self.dataArray.count > 0) {
        if (_isSubClass) {
            AlbumClassTableSubModel * subModel = [self.dataArray objectAtIndex:section];
            isOpen = subModel.open;
        }
        else {
            AlbumClassTableModel * model = [self.dataArray objectAtIndex:section];
            isOpen = model.open;
        }
    }
    
    if(isOpen) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    AlbumClassTableModel * model = [self.dataArray objectAtIndex:indexPath.section];
    AlbumClassTableCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumClassTableCellID];
    cell.indexPath = indexPath;
    [cell createAutoLayout:_isSubClass];
    
    if(!cell.delegate) cell.delegate = self;
/*
    if (model.dataArray.count > 0) {
        AlbumClassTableSubModel * subModel = [model.dataArray objectAtIndex:indexPath.row];
        cell.model = subModel;
    }
  */
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(self.dataArray.count > 0){
        return 55;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(self.dataArray.count > 0) {
        BOOL isOpen = NO;
        BOOL isChecked = NO;
        BOOL isVideo = NO;
        
        if (_isSubClass) {
            AlbumClassTableSubModel *subModel = [self.dataArray objectAtIndex:section];
            isChecked = subModel.delChecked;
        }
        else {
            AlbumClassTableModel *model = [self.dataArray objectAtIndex:section];
            isChecked = model.delChecked;
        }
        
        AlbumClassTableHead * head = [[AlbumClassTableHead alloc] init];
        BOOL editModeFlag;
        if (_isSubClass) {
            editModeFlag = _isEditMode;
        } else {
            AlbumClassTableModel * model = [self.dataArray objectAtIndex:section];
            editModeFlag = (!model.isVideo) && _isEditMode;
        }
        [head creteAutoLayout:editModeFlag selected:_isAllSelect?YES:isChecked];
        head.section = section;
        head.tag = section;
        head.delegate = self;
        [head addTarget:self action:@selector(tableViewHeadSelected:)];
        head.sd_layout.heightIs(50);

        if (_isSubClass) {
            AlbumClassTableSubModel * subModel = [self.dataArray objectAtIndex:section];
            isOpen = subModel.open;
            head.title.text = [NSString stringWithFormat:@"%@",subModel.name] ;
            head.subNums.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)subModel.photoCount];
        }
        else {
            AlbumClassTableModel * model = [self.dataArray objectAtIndex:section];
            isOpen = model.open;
            isVideo = model.isVideo;
            if (model.isVideo == NO) {
                head.title.text = [NSString stringWithFormat:@"%@",model.name];
                head.subNums.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)model.subclassCount];
            }
            else {
                head.title.text = [NSString stringWithFormat:@"%@ (%lu)",@"视频",(unsigned long)model.videosCount];
            }
        }
        
        if (isVideo) {
            [head videoFolder];
        }
        else {
            if(isOpen){
                [head openOption];
            }else{
                [head closeOption];
            }
        }
        return head;
        
    } else {
        return nil;
    }
}

- (void)tableViewHeadSelected:(UITapGestureRecognizer *)tap{
    
    NSInteger section = tap.view.tag;

    if(self.albumDelegage && [self.albumDelegage respondsToSelector:@selector(albumClassTableHeadSelected:)]){
        [self.albumDelegage albumClassTableHeadSelected:section];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.albumDelegage && [self.albumDelegage respondsToSelector:@selector(albumClassTableSelected:)]){
        [self.albumDelegage albumClassTableSelected:indexPath];
    }
}

- (void)albumClassTableSelectType:(NSInteger)type selectPath:(NSIndexPath*)indexPath{
    
    if(self.albumDelegage && [self.albumDelegage respondsToSelector:@selector(albumClassTableSelectType:selectPath:)]){
        [self.albumDelegage albumClassTableSelectType:type selectPath:indexPath];
    }
}

#pragma mark - AlbumClassTableHeadDelegate
- (void)albumClassTableHeadShowRow:(NSInteger)index{
    [self albumClassTableSelectType:1 selectPath:[NSIndexPath indexPathForRow:0 inSection:index]];
//    BOOL isOpen = NO;
//    
//    if (_isSubClass) {
//        AlbumClassTableSubModel * subModel = [self.dataArray objectAtIndex:index];
//        subModel.open = !subModel.open;
//        isOpen = subModel.open;
//    }
//    else{
//        AlbumClassTableModel * model = [self.dataArray objectAtIndex:index];
//        model.open = !model.open;
//        isOpen = model.open;
//    }
//    
//    [self.table reloadData];
//    if(isOpen){
//        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:index];
//        [self.table scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
}
- (void)albumClassTableHeadSelectCheck:(BOOL)isChecked selectedPath:(NSInteger)index {
    if(self.albumDelegage && [self.albumDelegage respondsToSelector:@selector(albumClassTableHeadSelectCheck:selectedPath:)]){
        [self.albumDelegage albumClassTableHeadSelectCheck:isChecked selectedPath:index];
    }
    
}

@end
