//
//  AlbumClassTableCell.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PersonalClassTableCell.h"

@interface PersonalClassTableCell ()

@property (strong, nonatomic) UILabel * title;
@property (strong, nonatomic) UIView * line;
@property (strong, nonatomic) UILabel * photoCount;

@end

@implementation PersonalClassTableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createAutoLayout];
    }
    
    return self;
}

- (void)createAutoLayout{
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.title = [[UILabel alloc] init];
    [self.title setFont:Font(13)];
    [self.title setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.title];
    
    self.photoCount = [[UILabel alloc] init];
    [self.photoCount setFont:Font(13)];
    [self.photoCount setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.photoCount];
    
    self.line = [[UIView alloc] init];
    [self addSubview:self.line];
    [self.line setBackgroundColor:ColorHex(0Xdedede)];
    
    self.title.sd_layout
    .leftSpaceToView(self,70)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0);

    self.photoCount.sd_layout
    .rightSpaceToView(self,30)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0);
    
    self.line.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(1);
    
}

- (void)setModel:(NSDictionary *)model{
    
    [self.title setText:[model objectForKey:@"name"]];
    
    [self.photoCount setText:[[model objectForKey:@"photoCounts"] stringValue]];
}


@end
