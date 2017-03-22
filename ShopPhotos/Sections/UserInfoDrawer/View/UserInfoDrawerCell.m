//
//  UserInfoDrawerCell.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/20.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "UserInfoDrawerCell.h"

@interface UserInfoDrawerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIImageView *caht;

@end

@implementation UserInfoDrawerCell

- (void)setModel:(UserInfoDrawerModel *)model{
    
    [self.icon setImage:[UIImage imageNamed:model.icon]];
    [self.text setText:model.name];
    if(model.chat){
        [self.caht setHidden:NO];
    }else{
        [self.caht setHidden:YES];
    }
}
@end
