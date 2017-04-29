//
//  ChattingViewController.m
//  ShopPhotos
//
//  Created by Macbook on 26/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "ChattingViewController.h"
#import "PersonalHomeCtr.h"

@interface ChattingViewController ()
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *viewChatting;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIView *profile;

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
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RCConversationViewController *chatVC = [[RCConversationViewController alloc] init];
//    [chatVC.view setFrame:CGRectMake(0, -64, _viewChatting.frame.size.width, _viewChatting.frame.size.height)];
    chatVC.conversationType = self.conversationType;
    chatVC.targetId = self.targetId;
    chatVC.title = self.name;
    [chatVC setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    [chatVC willMoveToParentViewController:self];
    [self.viewChatting addSubview:chatVC.view];
    [self addChildViewController:chatVC];
    [chatVC didMoveToParentViewController:self];

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
