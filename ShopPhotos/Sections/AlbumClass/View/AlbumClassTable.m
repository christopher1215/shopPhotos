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
    }
    return self;
}

#pragma makr - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.dataArray.count > 0) {
        AlbumClassTableModel * model = [self.dataArray objectAtIndex:section];
        if(model.open) {
//            return model.dataArray.count;
            return 1;
        }else{
            return 0;
        }
    } else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumClassTableModel * model = [self.dataArray objectAtIndex:indexPath.section];
    AlbumClassTableSubModel * subModel = [model.dataArray objectAtIndex:indexPath.row];
    
    AlbumClassTableCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumClassTableCellID];
    cell.indexPath = indexPath;
    [cell createAutoLayout:FALSE];
    
    if(!cell.delegate) cell.delegate = self;
    cell.model = subModel;
    
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
        AlbumClassTableModel * model = [self.dataArray objectAtIndex:section];
        AlbumClassTableHead * head = [[AlbumClassTableHead alloc] init];
        [head creteAutoLayout:_isEditMode selected:_isAllSelect];
        head.indexPath = section;
        head.tag = section;
        head.delegate = self;
        [head addTarget:self action:@selector(tableViewHeadSelected:)];
        head.sd_layout.heightIs(50);
        head.title.text = [NSString stringWithFormat:@"%@(%lu)",model.name,(unsigned long)model.dataArray.count] ;
        
        if(model.open){
            [head openOption];
        }else{
            [head closeOption];
        }
        
        return head;
    } else {
        return nil;
    }
}

- (void)tableViewHeadSelected:(UITapGestureRecognizer *)tap{
    
    /*
    NSInteger section = tap.view.tag;
    AlbumClassTableModel * model = [self.dataArray objectAtIndex:section];
    model.open = !model.open;

   // NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
   // NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
   //[self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.table reloadData];
    if(model.open){
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:section];
        [self.table scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.albumDelegage && [self.albumDelegage respondsToSelector:@selector(albumClassTableSelected:)]){
        [self.albumDelegage albumClassTableSelected:indexPath];
    }
}

- (void)albumClassTableSelectType:(NSInteger)type selectPath:(NSIndexPath *)indexPath{
    
    if(self.albumDelegage && [self.albumDelegage respondsToSelector:@selector(albumClassTableSelectType:selectPath:)]){
        [self.albumDelegage albumClassTableSelectType:type selectPath:indexPath];
    }
}

#pragma mark - AlbumClassTableHeadDelegate
- (void)albmClassTableHeadSelectType:(NSInteger)type slectedPath:(NSInteger)indexPath{
    
    AlbumClassTableModel * model = [self.dataArray objectAtIndex:indexPath];
    model.open = !model.open;
    
    // NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    // NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    //[self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.table reloadData];
    if(model.open){
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:indexPath];
        [self.table scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    /*
    if(self.albumDelegage && [self.albumDelegage respondsToSelector:@selector(albmClassTableHeadSelectType:slectedPath:)]){
        [self.albumDelegage albmClassTableHeadSelectType:type slectedPath:indexPath];
    }
     */
}

- (void)albmClassTableHeadSelectCheck:(BOOL)type slectedPath:(NSInteger)indexPath {
}

@end
