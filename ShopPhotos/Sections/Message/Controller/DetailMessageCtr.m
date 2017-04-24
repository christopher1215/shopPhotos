//
//  DetailMessageCtr.m
//  ShopPhotos
//
//  Created by Park Jin Hyok on 4/6/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "DetailMessageCtr.h"
#import <UIImageView+WebCache.h>


@interface DetailMessageCtr ()
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;


@end

@implementation DetailMessageCtr
- (void)viewDidLoad {
    [super viewDidLoad];
    
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

@end
