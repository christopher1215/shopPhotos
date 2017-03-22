//
//  DynamicViewCell.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/19.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "DynamicViewCell.h"
#import <UIImageView+WebCache.h>
#import "DynamicImagesModel.h"


@interface DynamicViewCell ()
@property (strong, nonatomic) UIView * content;
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UIScrollView *images;
@property (strong, nonatomic) UILabel *text;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UIView * shareView;
@property (strong, nonatomic) UIImageView *share;
@property (strong, nonatomic) UIView * line;
@end

@implementation DynamicViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createAutoLayout];
    }
    
    return self;
}

- (void)createAutoLayout{
    
    self.content = [[UIView alloc] init];
    [self.contentView addSubview:self.content];
    
    self.icon = [[UIImageView alloc] init];
    [self.icon addTarget:self action:@selector(iconSelected)];
    [self.content addSubview:self.icon];
    
    self.name = [[UILabel alloc] init];
    [self.name setTextColor:ColorHex(0XFF500D)];
    [self.name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [self.name addTarget:self action:@selector(nameSelected)];
    [self.content addSubview:self.name];
    
    self.images = [[UIScrollView alloc] init];
    [self.content addSubview:self.images];

    self.text = [[UILabel alloc] init];
    [self.text setFont:Font(13)];
    self.text.numberOfLines = 2;
    [self.text setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview:self.text];
    
    self.date = [[UILabel alloc] init];
    [self.date setFont:Font(12)];
    [self.date setTextColor:ColorHex(0X808080)];
    [self.content addSubview:self.date];
    
    self.shareView = [[UIView alloc] init];
    [self.shareView setBackgroundColor:[UIColor clearColor]];
    [self.shareView addTarget:self action:@selector(shareSelected)];
    [self.contentView addSubview:self.shareView];
    
    self.share = [[UIImageView alloc] init];
    [self.share setImage:[UIImage imageNamed:@"ico_dynamic_more"]];
    [self.share setContentMode:UIViewContentModeScaleAspectFit];
    [self.shareView addSubview:self.share];
    
    self.line = [[UIView alloc] init];
    [self.line setBackgroundColor:ColorHex(0Xeeeeee)];
    [self.contentView addSubview:self.line];
    
    self.content.sd_layout
    .leftSpaceToView (self.contentView,20)
    .rightSpaceToView (self.contentView,20)
    .topSpaceToView(self.contentView,5)
    .bottomSpaceToView(self.contentView,20);
    
    self.icon.sd_layout
    .leftEqualToView(self.content)
    .topEqualToView(self.content)
    .widthIs(35)
    .heightIs(35);
    
    self.name.sd_layout
    .leftSpaceToView(self.icon,10)
    .topEqualToView(self.content)
    .rightEqualToView(self.content)
    .heightIs(35);
    
    self.images.sd_layout
    .leftEqualToView(self.content)
    .topSpaceToView(self.icon,6)
    .rightEqualToView(self.content)
    .heightIs(100);
    
    self.text.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.images,6)
    .heightIs(40);
    
    self.shareView.sd_layout
    .rightSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,15)
    .widthIs(50)
    .heightIs(50);
    
    
    self.share.sd_layout
    .topSpaceToView(self.shareView,25)
    .bottomSpaceToView(self.shareView,5)
    .leftSpaceToView(self.shareView,15)
    .rightSpaceToView(self.shareView,0);
    
    self.date.sd_layout
    .leftEqualToView(self.content)
    .topSpaceToView(self.text,3)
    .rightSpaceToView(self.content,50)
    .heightIs(30);
    
    self.line.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(15);
}




- (void)setModel:(DynamicModel *)model{
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[model.user objectForKey:@"icon"]]];
    
    [self.name setText:[model.user objectForKey:@"name"]];
    
    //NSString *
    if(!model.showPrice){
        //NSMutableAttributedString * attrText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.title]];
        self.text.text = model.title ;
    }else{
        NSMutableAttributedString * attrText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@  %@",model.price,model.title]];
        
        [attrText addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"Helvetica-Bold" size:17]
                         range:NSMakeRange(0, model.price.length+1)];
        [attrText addAttribute:NSForegroundColorAttributeName
                         value:ColorHex(0XFF500D)
                         range:NSMakeRange(0, model.price.length+1)];
        
        self.text.attributedText = attrText ;
    }
    
    
    [self.date setText:[NSString stringWithFormat:@"%@  %@",model.date,model.descriptionText]];
    [self.images setBackgroundColor:[UIColor whiteColor]];
    [self showImages:model.images];
    
    if(self.icon.gestureRecognizers.count == 0){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.icon addTarget:self action:@selector(iconSelected)];
        [self.share addTarget:self action:@selector(shareSelected)];
    }
    
}

- (void)showImages:(NSArray *)imageArray{
    
    for(UIView * view in self.images.subviews){
        [view removeFromSuperview];
    }
    
    for(NSInteger index = 0; index<imageArray.count;index++){
        
        UIImageView * image = [[UIImageView alloc] init];
        [image setBackgroundColor:ColorHex(0Xeeeeee)];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        image.tag = 100+index;
        [image addTarget:self action:@selector(imageSelected:)];
        [self.images addSubview:image];
        DynamicImagesModel * model = [imageArray objectAtIndex:index];
        
        [image sd_setImageWithURL:[NSURL URLWithString:model.thumbnails]];
        image.sd_layout
        .leftSpaceToView(self.images,index*110)
        .topEqualToView(self.images)
        .widthIs(100)
        .heightIs(100);
    }
    
    [self.images setContentSize:CGSizeMake(110*imageArray.count,0)];
}

- (void)iconSelected{
    [self useDeleagate:1];
}

- (void)shareSelected{
    [self useDeleagate:2];
}

- (void)nameSelected{
    [self useDeleagate:3];
}

- (void)imageSelected:(UITapGestureRecognizer *)tap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cellImageSelected:TabelViewCellIndexPath:)]){
        [self.delegate cellImageSelected:tap.view.tag-100 TabelViewCellIndexPath:self.indexPath];
    }
}

- (void)useDeleagate:(NSInteger)type{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(cellSelectType:tableViewCelelIndexPath:)]){
        
        [self.delegate cellSelectType:type tableViewCelelIndexPath:self.indexPath];
    }
}

@end
