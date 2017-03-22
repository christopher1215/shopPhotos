//
//  PhotoClassSelectAlertCell.m
//  ShopPhotos
//
//  Created by addcn on 16/12/30.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PhotoClassSelectAlertCell.h"

@interface PhotoClassSelectAlertCell ()

@property (strong, nonatomic) UILabel * text;

@end

@implementation PhotoClassSelectAlertCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.text = [[UILabel alloc] init];
        [self.text addTarget:self action:@selector(textSelcted)];
        [self.contentView addSubview:self.text];
        
        self.text.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .rightSpaceToView(self.contentView,10);
    }
    
    return self;
}

- (void)setModel:(AlbumClassTableModel *)model{
    [self.text setText:model.name];
}

- (void)textSelcted{
    if(self.delegate && [self.delegate respondsToSelector:@selector(photoClassSelectAlertCellSelected:)]){
        [self.delegate photoClassSelectAlertCellSelected:self.indexPath];
    }
}

@end
