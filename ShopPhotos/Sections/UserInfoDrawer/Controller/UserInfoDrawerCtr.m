//
//  UserInfoDrawerCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/20.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "UserInfoDrawerCtr.h"
#import "UserInfoDrawerCell.h"
#import <UIImageView+WebCache.h>
#import "UserInfoDrawerModel.h"

@interface UserInfoDrawerCtr ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentOffset;
@property (weak, nonatomic) IBOutlet UIView *user;
@property (weak, nonatomic) IBOutlet UIImageView *userIocn;
@property (weak, nonatomic) IBOutlet UILabel *userID;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UIView *iconBG;
@property (strong, nonatomic) UserInfoModel * model;

@end

@implementation UserInfoDrawerCtr

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)dataArray{
    
    if(!_dataArray)_dataArray = [NSMutableArray array];
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}

- (void)setup{

    [self.user addTarget:self action:@selector(userSelected)];
    [self.userIocn addTarget:self action:@selector(userIconSelected)];
    self.iconBG.cornerRadius = 5;
    [self.userID addTarget:self action:@selector(userIDSelected)];
    self.table.delegate = self;
    self.table.dataSource = self;
}

- (void)setStyle:(UserInfoModel *)model{
    if(!model) return;
    
    self.model = model;
    [self.dataArray removeAllObjects];
    
    [self.userIocn sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    
    [self.userID setText:[NSString stringWithFormat:@"有图号:%@",model.uid]];
    
    UserInfoDrawerModel * model1 = [[UserInfoDrawerModel alloc] init];
    
    model1.name = [NSString stringWithFormat:@"https://www.uootu.com/%@",model.uid];
    model1.icon = @"drawer_home";
    
    UserInfoDrawerModel * model2 = [[UserInfoDrawerModel alloc] init];
    model2.name = model.name;
    model2.icon = @"drawer_user";
    
    UserInfoDrawerModel * model3 = [[UserInfoDrawerModel alloc] init];
    model3.name = model.wechat;
    model3.icon = @"drawer_chat";
    model3.chat = YES;
    
    
    UserInfoDrawerModel * model4 = [[UserInfoDrawerModel alloc] init];
    model4.name = model.qq;
    model4.icon = @"derwer_qq";
    model4.chat = YES;
    
    [self.dataArray addObject:model1];
    [self.dataArray addObject:model2];
    [self.dataArray addObject:model3];
    [self.dataArray addObject:model4];
    
    [self.table reloadData];
}



#pragma mark - OnTouch
- (void)userSelected{
    [self closeDrawe];
}

- (void)userIconSelected{
    [self closeDrawe];
    if(self.delegate && [self.delegate respondsToSelector:@selector(userInfoDrawerHeadSelected:)]){
        [self.delegate userInfoDrawerHeadSelected:1];
    }
}

- (void)userIDSelected{
    [self closeDrawe];
    if(self.delegate && [self.delegate respondsToSelector:@selector(userInfoDrawerHeadSelected:)]){
        [self.delegate userInfoDrawerHeadSelected:2];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self closeDrawe];
}

#pragma mark - 抽屉显示、关闭
- (void)showDrawe{

    [self.view setHidden:NO];
    self.contentOffset.constant = 0-WindowWidth;
    [self.view layoutIfNeeded];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [UIView animateWithDuration:0.5f animations:^{
    
        self.contentOffset.constant = 0;
        [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [self.view layoutIfNeeded];
    }];
    
    
}
- (void)closeDrawe{

    [UIView animateWithDuration:0.5 animations:^{
    
        self.contentOffset.constant = 0-WindowWidth;
        [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        [self.view setHidden:YES];
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserInfoDrawerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoDrawerCellID"];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(userInfoDrawerCellSelected:WithType:)]){
        [self.delegate userInfoDrawerCellSelected:self.model WithType:indexPath.row];
    }
    [self closeDrawe];
}
@end
