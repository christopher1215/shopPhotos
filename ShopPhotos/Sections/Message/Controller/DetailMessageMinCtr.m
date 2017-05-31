//
//  DetailMessageMinCtr.m
//  ShopPhotos
//
//  Created by Macbook on 24/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "DetailMessageMinCtr.h"
#import <UIImageView+WebCache.h>

@interface DetailMessageMinCtr ()
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@property (weak, nonatomic) IBOutlet UILabel *mainTitleSec;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatarSec;
@property (weak, nonatomic) IBOutlet UILabel *lblDateSec;
@property (weak, nonatomic) IBOutlet UIView *contentViewSec;
@property (weak, nonatomic) IBOutlet UILabel *lblContentSec;
@property (weak, nonatomic) IBOutlet UILabel *lblAllowState;
@property (weak, nonatomic) IBOutlet UIButton *btnDeny;
@property (weak, nonatomic) IBOutlet UIButton *btnAllow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
@property (weak, nonatomic) IBOutlet UIView *btnTopLine;

@end

@implementation DetailMessageMinCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}
- (void)setup{
    [self.back addTarget:self action:@selector(backSelected)];
    self.mainTitle.text = self.atitle;
    self.mainTitleSec.text = self.atitle;
    self.lblDate.text = self.date;
    [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:[UIImage imageNamed:@"default-avatar.png"]];
    self.imgAvatar.cornerRadius = 25;
    self.contentView.cornerRadius = 15;
    [_lblContent sizeToFit];
    self.lblContent.text = self.content;
    if ([self.type isEqualToString:@"copyRequestReply"]) {
        [_btnDeny setEnabled:NO];
        [_btnAllow setEnabled:NO];
        
        [_btnDeny setHidden:YES];
        [_btnAllow setHidden:YES];
        [_btnTopLine setHidden:YES];
        _btnHeight.constant = 0;
        [_contentView updateConstraints];

    }

    [self.imgAvatarSec sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:[UIImage imageNamed:@"default-avatar.png"]];
    self.imgAvatarSec.cornerRadius = 25;
    self.contentViewSec.cornerRadius = 15;
    [_lblContentSec sizeToFit];
    self.lblContentSec.text = self.content;
    [self setupReply];
}
- (void)setupReply{
    if(self.reply){
        [self.imgAvatarSec setHidden:NO];
        [self.lblDateSec setHidden:NO];
        [self.contentViewSec setHidden:NO];
        if (self.allow) {
            _lblAllowState.text = @"已同意";
        } else {
            _lblAllowState.text = @"已拒绝";
        }
        [_btnDeny setEnabled:NO];
        [_btnAllow setEnabled:NO];
        
        [_btnDeny setHidden:YES];
        [_btnAllow setHidden:YES];
        [_btnTopLine setHidden:YES];
        _btnHeight.constant = 0;
        [_contentView updateConstraints];
    } else {
        [self.imgAvatarSec setHidden:YES];
        [self.lblDateSec setHidden:YES];
        [self.contentViewSec setHidden:YES];
        [_btnDeny setEnabled:YES];
        [_btnAllow setEnabled:YES];
    }

}
- (IBAction)onHandleCopyRequest:(id)sender {
    UIButton *btn = sender;
    NSDictionary * data = @{@"noticeId":[NSString stringWithFormat:@"%d",self.noticeId],
                            @"allow":[NSString stringWithFormat:@"%ld",(long)btn.tag]};
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPUTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.handleCopyRequest,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            weakSelef.reply = YES;
            weakSelef.allow = btn.tag == 1? YES: NO;
            [weakSelef setupReply];
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
    
}

#pragma mark - OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
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
