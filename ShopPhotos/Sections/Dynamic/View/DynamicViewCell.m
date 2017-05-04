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
#import "AlbumPhotosModel.h"
#import "PhotoImagesModel.h"

@interface DynamicViewCell ()
@property (strong, nonatomic) UIView * content;
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UIScrollView *images;
@property (strong, nonatomic) UILabel *text;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UIView * shareView;
@property (strong, nonatomic) UILabel *share;
@property (strong, nonatomic) UIView * line;

@property (strong, nonatomic) UIButton *btn_message;
@property (strong, nonatomic) UIButton *btn_favorite;
@property (strong, nonatomic) UIButton *btn_pyq;
@property (strong, nonatomic) UIButton *btn_delete;

@end

@implementation DynamicViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)createAutoLayout {
    
    for (UIView *subview in self.content.subviews) {
        [subview removeFromSuperview];
    }
    
    self.content = [[UIView alloc] init];
    [self.contentView addSubview:self.content];
    self.content.sd_layout
    .leftSpaceToView (self.contentView,20)
    .rightSpaceToView (self.contentView,20)
    .topSpaceToView(self.contentView,5)
    .bottomSpaceToView(self.contentView,20);
    
    self.icon = [[UIImageView alloc] init];
    [self.icon addTarget:self action:@selector(iconSelected)];
    [self.content addSubview:self.icon];
    self.icon.sd_layout
    .leftSpaceToView(self.content,10)
    .topSpaceToView(self.content,5)
    .widthIs(35)
    .heightIs(35);
    
    self.name = [[UILabel alloc] init];
    [self.name setTextColor:[UIColor blackColor]];
    [self.name setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [self.name addTarget:self action:@selector(nameSelected)];
    [self.content addSubview:self.name];
    self.name.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(self.content,5)
    .rightEqualToView(self.content)
    .heightIs(20);
    
    self.date = [[UILabel alloc] init];
    [self.date setFont:Font(13)];
    [self.date setTextColor:ColorHex(0X808080)];
    [self.content addSubview:self.date];
    self.date.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(self.name,5)
    .rightSpaceToView(self.content,50)
    .heightIs(18);
    
    self.images = [[UIScrollView alloc] init];
    [self.content addSubview:self.images];
    self.images.sd_layout
    .leftEqualToView(self.content)
    .topSpaceToView(self.icon,15)
    .rightEqualToView(self.content)
    .heightIs(100);
    
    UILabel *morePhoto = [[UILabel alloc] init];
    [morePhoto setText:@"详情"];
    [morePhoto setTextColor:ColorHex(0x579bd5)];
    [morePhoto setFont:Font(14)];
    [morePhoto setBackgroundColor:[UIColor clearColor]];
    [morePhoto setTextAlignment:NSTextAlignmentRight];
    [self.content addSubview:morePhoto];
    morePhoto.sd_layout
    .rightEqualToView(self.content)
    .topSpaceToView(self.images,5)
    .heightIs(18);
    //[morePhoto setHidden:YES];
    
    self.text = [[UILabel alloc] init];
    [self.text setFont:Font(15)];
    self.text.numberOfLines = 2;
    [self.text setTextColor:[UIColor darkGrayColor]];
    [self.text setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview:self.text];
    self.text.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(morePhoto,6)
    .heightIs(40);
    
    UILabel *viewAllText = [[UILabel alloc] init];
    [viewAllText setText:@"展开"];
    [viewAllText setTextColor:ColorHex(0x579bd5)];
    [viewAllText setFont:Font(14)];
    [viewAllText setBackgroundColor:[UIColor clearColor]];
    [viewAllText setTextAlignment:NSTextAlignmentRight];
    [self.content addSubview:viewAllText];
    viewAllText.sd_layout
    .rightEqualToView(self.content)
    .topSpaceToView(self.text,3)
    .heightIs(18);
    [viewAllText setHidden:YES];
    
    self.line = [[UIView alloc] init];
    [self.line setBackgroundColor:ColorHex(0Xeeeeee)];
    [self.content addSubview:self.line];
    self.line.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(viewAllText,10)
    .heightIs(1);
    
    self.shareView = [[UIView alloc] init];
    [self.shareView setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview:_shareView];
    self.shareView.sd_layout
    .topEqualToView(self.line)
    .leftSpaceToView(self.content,0)
    .rightSpaceToView(self.content,0)
    .heightIs(50);
    
    if (self.isMyDynamic == NO) {
        _btn_message = [[UIButton alloc] init];
        [_btn_message setBackgroundColor:[UIColor clearColor]];
        [_btn_message setImage:[UIImage imageNamed:@"ico_message"] forState:UIControlStateNormal];
        [_btn_message addTarget:self action:@selector(chatSelected)];
        [self.shareView addSubview:_btn_message];
        _btn_message.sd_layout
        .leftEqualToView(_shareView)
        .topSpaceToView(_shareView,8)
        .widthIs(30)
        .heightIs(30);
        _btn_message.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
        
        _btn_favorite = [[UIButton alloc] init];
        [_btn_favorite setBackgroundColor:[UIColor clearColor]];
        [_btn_favorite setImage:[UIImage imageNamed:@"btn_favorite"] forState:UIControlStateNormal];
        [_btn_favorite addTarget:self action:@selector(collectSelected)];
        [self.shareView addSubview:_btn_favorite];
        _btn_favorite.sd_layout
        .leftSpaceToView(_btn_message,13)
        .topSpaceToView(_shareView,8)
        .widthIs(30)
        .heightIs(30);
        [_btn_favorite setImageEdgeInsets: UIEdgeInsetsMake(7, 7, 7, 7)];
        
        _btn_pyq = [[UIButton alloc] init];
        [_btn_pyq setBackgroundColor:[UIColor clearColor]];
        [_btn_pyq setImage:[UIImage imageNamed:@"btn_pyq_b"] forState:UIControlStateNormal];
        [_btn_pyq addTarget:self action:@selector(pyqSelected)];
        [self.shareView addSubview:_btn_pyq];
        _btn_pyq.sd_layout
        .leftSpaceToView(_btn_favorite,13)
        .topSpaceToView(_shareView,8)
        .widthIs(30)
        .heightIs(30);
        _btn_pyq.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    }
    else {
        _btn_pyq = [[UIButton alloc] init];
        [_btn_pyq setBackgroundColor:[UIColor clearColor]];
        [_btn_pyq setBackgroundImage:[UIImage imageNamed:@"btn_pyq_b"] forState:UIControlStateNormal];
        [_btn_pyq addTarget:self action:@selector(pyqSelected)];
        [self.shareView addSubview:_btn_pyq];
        _btn_pyq.sd_layout
        .leftEqualToView(_shareView)
        .topSpaceToView(_shareView,15)
        .widthIs(16)
        .heightIs(16);
        
        _btn_delete = [[UIButton alloc] init];
        [_btn_delete setBackgroundColor:[UIColor clearColor]];
        [_btn_delete setBackgroundImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        [_btn_delete addTarget:self action:@selector(deleteSelected)];
        [self.shareView addSubview:_btn_delete];
        _btn_delete.sd_layout
        .leftSpaceToView(_btn_pyq,20)
        .topSpaceToView(_shareView,15)
        .widthIs(16)
        .heightIs(16);
    }
    
    
    self.share = [[UILabel alloc] init];
    [self.share setFont:Font(19)];
    [self.share setText:@"..."];
    [self.share addTarget:self action:@selector(shareSelected)];
    self.share.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:self.share];
    self.share.sd_layout
    .rightSpaceToView(self.shareView,2)
    .topSpaceToView(self.shareView,15)
    .widthIs(20)
    .heightIs(20);
    
    UIView *seperate = [[UIView alloc] init];
    [seperate setBackgroundColor:ColorHex(0Xeeeeee)];
    [self.contentView addSubview:seperate];
    seperate.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView(self.content,10)
    .heightIs(10);
}




- (void)setModel:(AlbumPhotosModel *)model{
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[model.user objectForKey:@"avatar"]]];
    self.icon.layer.cornerRadius = _icon.frame.size.width/2;
    self.icon.layer.masksToBounds = TRUE;
    
    [self.name setText:[model.user objectForKey:@"name"]];
    [self.date setText:[NSString stringWithFormat:@"%@ 上传",model.dateDiff]];
    
    if (model.collected == NO) {
        [self.btn_favorite setImage:[UIImage imageNamed:@"btn_favorite_b"] forState:UIControlStateNormal];
    }
    
    self.text.text = model.title;
    // ,model.descriptionText
    [self.images setBackgroundColor:[UIColor whiteColor]];
    if ([model.type isEqualToString:@"photo"]) {
        [self showImages:model.images];
    }
    else if ([model.type isEqualToString:@"video"]) {
        [self showVideoCover:model.cover];
    }
    
    if(self.icon.gestureRecognizers.count == 0){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.icon addTarget:self action:@selector(iconSelected)];
        [self.share addTarget:self action:@selector(shareSelected)];
    }
}

- (void)showVideoCover:(NSString *)coverUrl {
    for(UIView * view in self.images.subviews){
        [view removeFromSuperview];
    }
    
    UIImageView * image = [[UIImageView alloc] init];
    [image setBackgroundColor:ColorHex(0Xeeeeee)];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    image.tag = 100;
    [self.images addSubview:image];
    
    [image sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
    image.layer.cornerRadius = 5;
    image.layer.masksToBounds = TRUE;
    image.sd_layout
    .leftSpaceToView(self.images,0)
    .topEqualToView(self.images)
    .widthIs(100)
    .heightIs(100);
    
    UIButton *videoPlayButton = [[UIButton alloc] initWithFrame:CGRectMake(image.frame.size.width/4, image.frame.size.height/4, image.frame.size.width/2, image.frame.size.height/2)];
    [self.images addSubview:videoPlayButton];
    [videoPlayButton setBackgroundImage:[UIImage imageNamed:@"btn_movie"] forState:UIControlStateNormal];
    videoPlayButton.sd_cornerRadius = [NSNumber numberWithDouble:5.0];
    [videoPlayButton addTarget:self action:@selector(videoSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.images setContentSize:CGSizeMake(110,0)];
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
        NSDictionary * model = [imageArray objectAtIndex:index];
        
        [image sd_setImageWithURL:[NSURL URLWithString:[model objectForKey:@"thumbnailUrl"]]];
        image.layer.cornerRadius = 5;
        image.layer.masksToBounds = TRUE;
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

- (void)collectSelected {
    [self useDeleagate:4];
}

- (void)chatSelected {
    [self useDeleagate:5];
}

- (void)pyqSelected {
    [self useDeleagate:6];
}

- (void)deleteSelected {
    [self useDeleagate:7];
}

- (void)imageSelected:(UITapGestureRecognizer *)tap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cellImageSelected:TabelViewCellIndexPath:)]){
        [self.delegate cellImageSelected:tap.view.tag-100 TabelViewCellIndexPath:self.indexPath];
    }
}

- (void)videoSelected:(UIButton *)_sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(cellImageSelected:TabelViewCellIndexPath:)]){
        [self.delegate cellImageSelected:-1 TabelViewCellIndexPath:self.indexPath];
    }
}

- (void)useDeleagate:(NSInteger)type{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(cellSelectType:tableViewCelelIndexPath:)]){
        [self.delegate cellSelectType:type tableViewCelelIndexPath:self.indexPath];
    }
}

@end
