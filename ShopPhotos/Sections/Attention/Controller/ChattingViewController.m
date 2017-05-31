//
//  ChattingViewController.m
//  ShopPhotos
//
//  Created by Macbook on 26/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "ChattingViewController.h"
#import "PersonalHomeCtr.h"

@interface ChattingViewController ()<RCChatSessionInputBarControlDelegate>{
    RCConversationViewController *chatVC;
    float posY;
    BOOL firstFlag;
    CGRect oldInputBarFrame;
    CGRect oldMessageCollectionFrame;
}
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *viewChatting;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIView *profile;
@property (weak, nonatomic) IBOutlet UIView *navBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navbarTop;

@end

@implementation ChattingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}
- (void)setup{
    [self.back addTarget:self action:@selector(backSelected)];
    [self.profile addTarget:self action:@selector(profileSelected)];
    self.lblName.text = self.name;
    
    [self.viewChatting setFrame:CGRectMake(0, 0, WindowWidth, WindowHeight)];
    chatVC = [[RCConversationViewController alloc] init];
    
    chatVC.conversationType = self.conversationType;
    chatVC.targetId = self.targetId;
    chatVC.title = self.name;
    [chatVC setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    [chatVC willMoveToParentViewController:self];
//    [chatVC.view  setFrame:CGRectMake(0, 0, self.viewChatting.frame.size.width, self.viewChatting.frame.size.height)];
    [self.viewChatting addSubview:chatVC.view];
    
    [chatVC.conversationMessageCollectionView  setFrame:CGRectMake(0, 44, self.viewChatting.frame.size.width, self.viewChatting.frame.size.height+50)];
    oldInputBarFrame = chatVC.chatSessionInputBarControl.frame;
    oldMessageCollectionFrame = chatVC.conversationMessageCollectionView.frame;
//    chatVC.chatSessionInputBarControl.delegate = nil;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];

    [self addChildViewController:chatVC];
    [chatVC didMoveToParentViewController:self];
    [chatVC.pluginBoardView removeItemAtIndex:3];
    [chatVC.pluginBoardView removeItemAtIndex:2];
    firstFlag = YES;
    
}
- (void)keyboardWillShow:(NSNotification *)notification{
    if (firstFlag) {
        posY = WindowHeight - [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        firstFlag = NO;
    }
    
    _navbarTop.constant = 0;
    [self.navBar updateConstraints];
}
- (void)keyboardWillHide:(NSNotification *)notification{
    chatVC.chatSessionInputBarControl.frame = oldInputBarFrame;
    chatVC.conversationMessageCollectionView.frame = oldMessageCollectionFrame;
    [_navBar setFrame:CGRectMake(0, 0, _navBar.frame.size.width, _navBar.frame.size.height)];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)profileSelected{
    PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
    personalHome.uid = _targetId;
    personalHome.twoWay = _twoWay;
    personalHome.username = _name;
    [self.navigationController pushViewController:personalHome animated:YES];
    
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
