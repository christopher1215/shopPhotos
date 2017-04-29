//
//  ChatListViewController.m
//  ShopPhotos
//
//  Created by Macbook on 26/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChattingViewController.h"

@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                              @(ConversationType_DISCUSSION),
                                              @(ConversationType_CHATROOM),
                                              @(ConversationType_GROUP),
                                              @(ConversationType_APPSERVICE),
                                              @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                                @(ConversationType_GROUP)]];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    [self.conversationListTableView setTableFooterView:v];
}
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ChattingViewController *conversationVC = [[ChattingViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.name = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    RCConversationCell *customCell = (RCConversationCell *)cell;
    customCell.portraitStyle = RC_USER_AVATAR_CYCLE;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
