//
//  AlbumClassTable.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PersonalClassTable.h"
#import "HTTPRequest.h"
#import "CongfingURL.h"
#import "NSObject+StoreValue.h"
#import "AllClassModel.h"
#import "PersonalClassTableHead.h"
#import "PersonalClassTableCell.h"

@interface PersonalClassTable ()<UITableViewDelegate,UITableViewDataSource,PersonalClassTableHeadDelegate>

@end

@implementation PersonalClassTable

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
        [self.table registerClass:[PersonalClassTableCell class] forCellReuseIdentifier:PersonalClassTableCellID];
        [self addSubview:self.table];
        
        self.table.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .bottomEqualToView(self);
    }
    return self;
}

#pragma makr - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.dataArray.count > 0){
        AllClassModel * model = [self.dataArray objectAtIndex:section];
        if(model.isOpen){
            return model.subclasses.count;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllClassModel * model = [self.dataArray objectAtIndex:indexPath.section];
    NSDictionary * subModel = [model.subclasses objectAtIndex:indexPath.row];
    
    PersonalClassTableCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalClassTableCellID];
    cell.indexPath = indexPath;
//    if(!cell.delegate)cell.delegate = self;
    cell.model = subModel;
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(self.dataArray.count > 0){
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(self.dataArray.count > 0){
        
        AllClassModel * model = [self.dataArray objectAtIndex:section];
        PersonalClassTableHead * head = [[PersonalClassTableHead alloc] init];
        head.indexPath = section;
        head.tag = section;
        head.delegate = self;
        [head addTarget:self action:@selector(tableViewHeadSelected:)];
        head.sd_layout.heightIs(50);
        head.title.text = model.name;
        head.subclassCount.text = [NSString stringWithFormat:@"%ld",model.subclasses.count];
        
        if(model.isOpen){
            [head openOption];
        }else{
            [head closeOption];
        }

        return head;
    }else{
        return nil;
    }
}

- (void)tableViewHeadSelected:(UITapGestureRecognizer *)tap{
    
    NSInteger section = tap.view.tag;
    AllClassModel * model = [self.dataArray objectAtIndex:section];
    model.isOpen = !model.isOpen;

    //NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    //NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    //[self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.table reloadData];
    if(model.isOpen){
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:section];
        [self.self.table scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
/*
    if(self.delegate && [self.delegate respondsToSelector:@selector(personalClassTableSelected:)]){
        [self.delegate personalClassTableSelected:indexPath];
    }*/
}

#pragma mark - AlbumClassTableHeadDelegate
- (void)personalClassTableHeadSelectType:(NSInteger)type selectedPath:(NSInteger)indexPath{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(personalClassTableHeadSelectType:selectedPath:)]){
        [self.delegate personalClassTableHeadSelectType:type selectedPath:indexPath];
    }
}

@end
