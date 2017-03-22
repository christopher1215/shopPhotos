//
//  AttentionTableView.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/19.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "AttentionTableView.h"
#import "AttentionTableCell.h"


@interface AttentionTableView ()<UITableViewDelegate,UITableViewDataSource,AttentionTableCellDelegate,UITextFieldDelegate>
@property (strong, nonatomic) NSMutableArray * backupDataArray;
@end

@implementation AttentionTableView

- (NSMutableArray *)backupDataArray{
    if(!_backupDataArray) _backupDataArray = [NSMutableArray array];
    return _backupDataArray;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    
    if(!_dataArray)_dataArray = [NSMutableArray array];
    if(_dataArray.count > 0) [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:dataArray];
    if(self.backupDataArray.count > 0) [self.backupDataArray removeAllObjects];
    [self.backupDataArray addObjectsFromArray:dataArray];
    [self.table reloadData];
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

    UIView * searchView = [[UIView alloc] init];
    [searchView setBackgroundColor:ColorHex(0Xeeeeee)];
    [self addSubview:searchView];
    
    self.search = [[UITextField alloc] init];
    self.search.placeholder = @"请输入用户昵称搜索";
    self.search.font = Font(13);
    self.search.delegate = self;
    self.search.keyboardType = UIKeyboardTypeWebSearch;
    [searchView addSubview:self.search];
    
    self.table = [[UITableView alloc] init];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.table registerClass:[AttentionTableCell class] forCellReuseIdentifier:AttentionTableCellID];
    [self addSubview:self.table];
    
    
    searchView.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .rightEqualToView(self)
    .heightIs(50);
    
    self.search.sd_layout
    .leftSpaceToView(searchView,10)
    .topSpaceToView(searchView,10)
    .bottomSpaceToView(searchView,10)
    .rightSpaceToView(searchView,10);
    
    self.table.sd_layout
    .leftEqualToView(self)
    .topSpaceToView(searchView,0)
    .rightEqualToView(self)
    .bottomEqualToView(self);
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (NSMutableArray *)getSearchData:(NSString *)key{
    
    NSMutableArray * array = [NSMutableArray array];
    for(AttentionModel * model in self.backupDataArray){
        
        NSRange range = [model.name rangeOfString:key options:NSCaseInsensitiveSearch];
        
        if(range.length > 0){
            [array addObject:model];
        }
    }
    
    return array;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self.dataArray removeAllObjects];
    NSMutableString * text = [[NSMutableString alloc] initWithString:textField.text];
    if(textField.text.length <= 1 &&
       string.length == 0){
        NSLog(@"没有数据");
        [self.dataArray addObjectsFromArray:self.backupDataArray];
    }else{
        
        NSLog(@"有数据");
        if(string && string.length > 0){
            [text appendString:string];
        }else{
            if(text.length > 0){
              [text deleteCharactersInRange:NSMakeRange(text.length-1, 1)];
            }
        }
        [self.dataArray addObjectsFromArray:[self getSearchData:text]];
    }
    [self.table reloadData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.dataArray removeAllObjects];
    
    if(textField.text.length == 0){
        [self.dataArray addObjectsFromArray:self.backupDataArray];
    }else{
        
        
        [self.dataArray addObjectsFromArray:[self getSearchData:textField.text]];
    }
    [self.table reloadData];
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AttentionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:AttentionTableCellID];
    cell.attentionStatu = self.attentionStatu;
    cell.indexPath = indexPath;
    if(!cell.delegate) cell.delegate = self;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.search resignFirstResponder];
    AttentionModel * model = [self.dataArray objectAtIndex:indexPath.row];
    if(self.delegate && [self.delegate respondsToSelector:@selector(attentionTableSelect: WithTwoWay:)]){
        [self.delegate attentionTableSelect:model.uid WithTwoWay:model.twoWay];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self endEditing:YES];
}

#pragma mark - AttentionTableCellDelegate
- (void)attentionSelected:(NSIndexPath *)indexPath{
    [self.search resignFirstResponder];
    AttentionModel * model = [self.dataArray objectAtIndex:indexPath.row];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(attentionSelected:)]){
        [self.delegate attentionSelected:model];
    }
    
}

@end
