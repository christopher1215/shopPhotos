//
//  DynamicTableView.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/25.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "DynamicTableView.h"
#import "DynamicViewCell.h"
#import "AlbumPhotosModel.h"

@interface DynamicTableView ()<UITableViewDelegate,UITableViewDataSource,DynamicViewCellDelegate>
@property (strong, nonatomic) NSMutableArray * dataArray;
@end

@implementation DynamicTableView

- (NSMutableArray *)dataArray{
    
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createAutoLayout];
    }
    return self;
}

- (void)createAutoLayout{
    
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.table registerClass:[DynamicViewCell class] forCellReuseIdentifier:CellID];
    [self addSubview:self.table];
    
    self.table.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
}

- (void)loadData:(NSArray *)dataArray{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:dataArray];
    [self.table reloadData];
    
}
- (void)loadMoreData:(NSArray *)dataArray{
    
    [self.dataArray addObjectsFromArray:dataArray];
    [self.table reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DynamicViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    if(!cell.delegate)cell.delegate = self;
    cell.indexPath = indexPath;
    cell.isMyDynamic = self.isMyDynamic;
    [cell createAutoLayout];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumPhotosModel *model = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat width = ((WindowWidth - 14 * 2 - (Clearance*2))/3);
//    NSInteger height = (model.isExpend? 33:0) + 125 + 28 * (WindowWidth / 375) + (model.imageRows > 0 ? model.imageRows : 1) * width + ((model.imageRows > 0 ? model.imageRows : 1) - 1) * Clearance;
    NSInteger height = 27 + 125 + 20 * (WindowWidth / 375) + (model.imageRows > 0 ? model.imageRows : 1) * width + ((model.imageRows > 0 ? model.imageRows : 1) - 1) * Clearance;
    if(ceil(model.images.count/3.f) > 1)
        height += 27;
    if(model.extraHeight < 0)
        height += 0;
    else if(model.extraHeight > 0)
        height += (0 + model.extraHeight);
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumPhotosModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if([model.type isEqualToString:@"photo"]){
        if(self.delegate && [self.delegate respondsToSelector:@selector(dynamicTableCellSelected:)]){
            [self.delegate dynamicTableCellSelected:indexPath];
        }
    }
}

#pragma mark - DynamicViewCellDelegate
- (void)cellSelectType:(NSInteger)type tableViewCelelIndexPath:(NSIndexPath *)indexPath{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(cellSelectType:tableViewCelelIndexPath:)]){
        [self.delegate cellSelectType:type tableViewCelelIndexPath:indexPath];
    }
}

- (void)cellImageSelected:(NSInteger)tag TabelViewCellIndexPath:(NSIndexPath *)indexPath{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(cellImageSelected:TabelViewCellIndexPath:)]){
        [self.delegate cellImageSelected:tag TabelViewCellIndexPath:indexPath];
    }
}

- (void)rowExpanded
{
    [self.table reloadData];
    [self.table beginUpdates];
    [self.table endUpdates];
    
}

@end
