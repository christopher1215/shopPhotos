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
    self.lblDate.text = self.date;
    [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:[UIImage imageNamed:@"default-avatar.png"]];
    self.imgAvatar.cornerRadius = 25;
    self.contentView.cornerRadius = 15;
    [_lblContent sizeToFit];
    self.lblContent.text = self.content;
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
