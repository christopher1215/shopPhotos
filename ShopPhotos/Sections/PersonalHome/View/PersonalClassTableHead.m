//
//  AlbumClassTableHead.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PersonalClassTableHead.h"

@implementation PersonalClassTableHead

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creteAutoLayout];
    }
    return self;
}

- (void)creteAutoLayout{
    [self setBackgroundColor:[UIColor whiteColor]];
    self.icon = [[UIImageView alloc] init];
    [self.icon setImage:[UIImage imageNamed:@"ico_triangle2"]];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.icon setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.icon];
    
    self.title = [[UILabel alloc] init];
    [self.title setTextColor:ThemeColor];
    [self.title setFont:Font(13)];
    [self addSubview:self.title];
    
    self.subclassCount = [[UILabel alloc] init];
    [self.subclassCount setFont:Font(13)];
    [self.subclassCount setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.subclassCount];
    
    UIView * line = [[UIView alloc] init];
    [line setBackgroundColor:ColorHex(0Xeeeeee)];
    [self addSubview:line];
    
    self.icon.sd_layout
    .leftSpaceToView(self,10)
    .topSpaceToView(self,18)
    .bottomSpaceToView(self,18)
    .widthIs(14);
    
    self.subclassCount.sd_layout
    .rightSpaceToView(self, 10)
    .widthIs(40)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0);
    
    self.title.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .rightSpaceToView(self,120);
    
    line.sd_layout
    .leftEqualToView(self)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .heightIs(1);
}

- (void)openOption{
    [self.icon setImage:[UIImage imageNamed:@"ico_triangle2_down"]];
}

- (void)closeOption{
    [self.icon setImage:[UIImage imageNamed:@"ico_triangle2"]];
}
@end
