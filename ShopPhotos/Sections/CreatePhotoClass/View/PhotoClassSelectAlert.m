//
//  PhotoClassSelectAlert.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/29.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PhotoClassSelectAlert.h"
#import "PhotoClassSelectAlertCell.h"

@interface PhotoClassSelectAlert ()<UITableViewDelegate,UITableViewDataSource,PhotoClassSelectAlertCellDelegate>

@property (strong, nonatomic) UITableView * table;

@end

@implementation PhotoClassSelectAlert

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    if(!_dataArray)_dataArray = [NSMutableArray array];
    if(_dataArray.count > 0) [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:dataArray];
    
    if(!self.table){
        self.table = [[UITableView alloc] init];
        self.table.delegate = self;
        self.table.dataSource = self;
        [self.table registerClass:[PhotoClassSelectAlertCell class] forCellReuseIdentifier:PhotoClassSelectAlertCellID];
        [self addSubview:self.table];
        
        self.table.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .bottomEqualToView(self);
    }
    
    [self.table reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoClassSelectAlertCell * cell = [tableView dequeueReusableCellWithIdentifier:PhotoClassSelectAlertCellID forIndexPath:indexPath];
    AlbumClassTableModel * model = [self.dataArray objectAtIndex:indexPath.row];
    if(!cell.delegate) cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = model;
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)photoClassSelectAlertCellSelected:(NSIndexPath *)indexPath{
    NSLog(@"2343");
    if(self.delegate && [self.delegate respondsToSelector:@selector(photoClassSelectAlert:)]){
        [self.delegate photoClassSelectAlert:indexPath];
    }
}
@end
