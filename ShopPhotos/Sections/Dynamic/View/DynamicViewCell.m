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
{
    AlbumPhotosModel * _cellModel;
}

@property (strong, nonatomic) UIView * content;
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *name;
//@property (strong, nonatomic) UIScrollView *images;
@property (strong, nonatomic) UIView *images;
@property (strong, nonatomic) UILabel *text;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UIView * shareView;
@property (strong, nonatomic) UILabel *share;
@property (strong, nonatomic) UIView * line;

@property (strong, nonatomic) UIButton *btn_message;
@property (strong, nonatomic) UIButton *btn_favorite;
@property (strong, nonatomic) UIButton *btn_pyq;
@property (strong, nonatomic) UIButton *btn_delete;
@property (strong, nonatomic) UIButton *btn_expand;
@property (strong, nonatomic) UIButton *btn_expandText;

@property (strong, nonatomic) UILabel *morePhoto;
@end

#define IMG_WIDTH ((WindowWidth - 14 * 2 - (Clearance*2))/3)

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
    .leftSpaceToView (self.contentView,14)
    .rightSpaceToView (self.contentView,14)
    .topSpaceToView(self.contentView,14)
    .bottomSpaceToView(self.contentView,10*(WindowWidth/375));
    
    self.icon = [[UIImageView alloc] init];
    [self.icon addTarget:self action:@selector(iconSelected)];
    [self.content addSubview:self.icon];
    self.icon.sd_layout
    .leftSpaceToView(self.content,0)
    .topSpaceToView(self.content,0)
    .widthIs(42)
    .heightIs(42);
    
    self.name = [[UILabel alloc] init];
    [self.name setTextColor:[UIColor blackColor]];
    [self.name setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [self.name addTarget:self action:@selector(nameSelected)];
    [self.content addSubview:self.name];
    self.name.sd_layout
    .leftSpaceToView(self.icon,9)
    .topSpaceToView(self.content,2)
    .rightEqualToView(self.content)
    .heightIs(18);
    
    self.date = [[UILabel alloc] init];
    [self.date setFont:Font(11)];
    [self.date setTextColor:ColorHex(0X808080)];
    [self.content addSubview:self.date];
    self.date.sd_layout
    .leftSpaceToView(self.icon,10)
    .topSpaceToView(self.name,4)
    .rightSpaceToView(self.content,0)
    .heightIs(13);
    
    //self.images = [[UIScrollView alloc] init];
    self.images = [[UIView alloc] init];
    [self.content addSubview:self.images];
    self.images.sd_layout
    .leftEqualToView(self.content)
    .topSpaceToView(self.icon,13)
    .rightEqualToView(self.content)
    .heightIs(IMG_WIDTH);
    self.images.clipsToBounds = YES;
    
    _btn_expand = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btn_expand setTitle:@"展开" forState:UIControlStateNormal];
    [_btn_expand.titleLabel setFont:Font(13)];
    [self.content addSubview:_btn_expand];
    _btn_expand.sd_layout
    .rightEqualToView(self.content)
    .topSpaceToView(self.images,4)
    .widthIs(40)
    .heightIs(0);
    [_btn_expand addTarget:self action:@selector(expandSelected)];
    
    _morePhoto = [[UILabel alloc] init];
    [_morePhoto setText:@"详情"];
    [_morePhoto setTextColor:ColorHex(0x579bd5)];
    [_morePhoto setFont:Font(14)];
    [_morePhoto setBackgroundColor:[UIColor clearColor]];
    [_morePhoto setTextAlignment:NSTextAlignmentRight];
    [self.content addSubview:_morePhoto];
    _morePhoto.sd_layout
    .rightEqualToView(self.content)
    .topSpaceToView(self.images,20)
    .heightIs(40);
    [_morePhoto setHidden:YES];
    
    _btn_expandText = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btn_expandText setTitle:@"更多" forState:UIControlStateNormal];
    [_btn_expandText.titleLabel setFont:Font(13)];
    [self.content addSubview:_btn_expandText];
    _btn_expandText.sd_layout
    .rightEqualToView(self.content)
    .topSpaceToView(self.btn_expand,14)
    .widthIs(40)
    .heightIs(0);
    [_btn_expandText addTarget:self action:@selector(expandTextSelected)];
    [_btn_expandText setHidden:YES];
    
    self.text = [[UILabel alloc] init];
    [self.text setFont:Font(13)];
    [self.text setTextColor:[UIColor darkGrayColor]];
    [self.text setBackgroundColor:[UIColor clearColor]];
    self.text.numberOfLines = 0;
    [self.text sizeToFit];
    [self.content addSubview:self.text];
    self.text.sd_layout
    .leftEqualToView(self.content)
    .rightSpaceToView(self.btn_expandText,4)
    .topSpaceToView(self.btn_expand,4)
    .heightIs(33);
    
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
    .topSpaceToView(self.text,10 * WindowWidth / 375)
    .heightIs(1);
    
    self.shareView = [[UIView alloc] init];
    [self.shareView setBackgroundColor:[UIColor clearColor]];
    [self.content addSubview:_shareView];
    self.shareView.sd_layout
    .topEqualToView(self.line)
    .leftSpaceToView(self.content,0)
    .rightSpaceToView(self.content,0)
    .heightIs(46);
    
    NSInteger ico_w = 36;
    if (self.isMyDynamic == NO) {
        _btn_message = [[UIButton alloc] init];
        [_btn_message setBackgroundColor:[UIColor clearColor]];
        [_btn_message setImage:[UIImage imageNamed:@"ico_message"] forState:UIControlStateNormal];
        [_btn_message addTarget:self action:@selector(chatSelected)];
        [self.shareView addSubview:_btn_message];
        _btn_message.sd_layout
        .leftEqualToView(_shareView)
        .topSpaceToView(_shareView,5)
        .widthIs(ico_w)
        .heightIs(ico_w);
        _btn_message.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _btn_favorite = [[UIButton alloc] init];
        [_btn_favorite setBackgroundColor:[UIColor clearColor]];
        [_btn_favorite setImage:[UIImage imageNamed:@"btn_favorite"] forState:UIControlStateNormal];
        [_btn_favorite addTarget:self action:@selector(collectSelected)];
        [self.shareView addSubview:_btn_favorite];
        _btn_favorite.sd_layout
        .leftSpaceToView(_btn_message,8)
        .topSpaceToView(_shareView,5)
        .widthIs(ico_w)
        .heightIs(ico_w);
        [_btn_favorite setImageEdgeInsets: UIEdgeInsetsMake(7, 7, 7, 7)];
        
        _btn_pyq = [[UIButton alloc] init];
        [_btn_pyq setBackgroundColor:[UIColor clearColor]];
        [_btn_pyq setImage:[UIImage imageNamed:@"btn_pyq_b"] forState:UIControlStateNormal];
        [_btn_pyq addTarget:self action:@selector(pyqSelected)];
        [self.shareView addSubview:_btn_pyq];
        _btn_pyq.sd_layout
        .leftSpaceToView(_btn_favorite,8)
        .topSpaceToView(_shareView,5)
        .widthIs(ico_w)
        .heightIs(ico_w);
        _btn_pyq.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    }
    else {
        _btn_pyq = [[UIButton alloc] init];
        [_btn_pyq setBackgroundColor:[UIColor clearColor]];
        [_btn_pyq setImage:[UIImage imageNamed:@"btn_pyq_b"] forState:UIControlStateNormal];
        [_btn_pyq addTarget:self action:@selector(pyqSelected)];
        _btn_pyq.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
        
        [self.shareView addSubview:_btn_pyq];
        _btn_pyq.sd_layout
        .leftEqualToView(_shareView)
        .topSpaceToView(_shareView,5)
        .widthIs(ico_w)
        .heightIs(ico_w);
        
        _btn_delete = [[UIButton alloc] init];
        [_btn_delete setBackgroundColor:[UIColor clearColor]];
        [_btn_delete setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        [_btn_delete addTarget:self action:@selector(deleteSelected)];
        [self.shareView addSubview:_btn_delete];
        _btn_delete.sd_layout
        .leftSpaceToView(_btn_pyq,8)
        .topSpaceToView(_shareView,5)
        .widthIs(ico_w)
        .heightIs(ico_w);
    }
    
    self.share = [[UILabel alloc] init];
    [self.share setFont:Font(22)];
    [self.share setText:@"..."];
    [self.share setTextColor:[UIColor darkGrayColor]];
    [self.share addTarget:self action:@selector(shareSelected)];
    self.share.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:self.share];
    self.share.sd_layout
    .rightSpaceToView(self.shareView,0)
    .topSpaceToView(self.shareView,0)
    .widthIs(40)
    .heightIs(32);
    
    UIView *seperate = [[UIView alloc] init];
    [seperate setBackgroundColor:ColorHex(0Xeeeeee)];
    [self.contentView addSubview:seperate];
    seperate.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView(self.content,0)
    .heightIs(10 * WindowWidth / 375);
}




- (void)setModel:(AlbumPhotosModel *)model{
    
    _cellModel = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[model.user objectForKey:@"avatar"]]];
    self.icon.layer.cornerRadius = _icon.frame.size.width/2;
    self.icon.layer.masksToBounds = TRUE;
    
    [self.name setText:[model.user objectForKey:@"name"]];
    [self.date setText:[NSString stringWithFormat:@"%@ 上传",model.createdAt]];
    
    if (model.collected == NO) {
        [self.btn_favorite setImage:[UIImage imageNamed:@"btn_favorite_b"] forState:UIControlStateNormal];
    }
    
    self.text.text = model.title;
    // ,model.descriptionText
    [self.images setBackgroundColor:[UIColor whiteColor]];
    if ([model.type isEqualToString:@"photo"]) {
        //[self showImages:model.images];
        [self showImageGrid:model.images];
    }
    else if ([model.type isEqualToString:@"video"]) {
        [self showVideoCover:model.cover];
        [_morePhoto setHidden:YES];
        [_btn_expand setHidden:YES];
    }
    
    if(_cellModel.textLines > 2)
    {
        _btn_expandText.sd_layout.heightIs(27);
        [_btn_expandText setHidden:NO];
        
        if(_cellModel.extraHeight > 0)
        {
            self.text.numberOfLines = 0;
            self.text.sd_layout.heightIs(self.text.font.lineHeight * _cellModel.textLines);
            [_btn_expandText setTitle:@"隐藏" forState:UIControlStateNormal];
        }
        else
        {
            self.text.numberOfLines = 2;
            self.text.sd_layout.heightIs(self.text.font.lineHeight * 2);
            [_btn_expandText setTitle:@"更多" forState:UIControlStateNormal];
        }
    }
    else if (_cellModel.textLines <= 2)
    {
        self.text.numberOfLines = 0;
        [self.text sizeToFit];
        //self.text.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [self.text sizeThatFits:CGSizeMake(WindowWidth - 28 - 44, CGFLOAT_MAX)];
        NSLog(@"item size = %f x %f (line = %f)", size.width, size.height, self.text.font.lineHeight);
        _cellModel.textLines = MAX((int)(size.height / self.text.font.lineHeight), 0);
        if(_cellModel.textLines > 2)
        {
            [_btn_expandText setHidden:NO];
            _btn_expandText.sd_layout.heightIs(27);
            _cellModel.extraHeight = -(size.height - 2 * self.text.font.lineHeight);
        }
        self.text.numberOfLines = 2;
        self.text.sd_layout.heightIs(self.text.font.lineHeight * 2);
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
    .widthIs(IMG_WIDTH)
    .heightIs(IMG_WIDTH);
    
    UIButton *videoPlayButton = [[UIButton alloc] initWithFrame:CGRectMake(image.frame.size.width/4, image.frame.size.height/4, image.frame.size.width/2, image.frame.size.height/2)];
    [self.images addSubview:videoPlayButton];
    [videoPlayButton setBackgroundImage:[UIImage imageNamed:@"btn_movie"] forState:UIControlStateNormal];
    videoPlayButton.sd_cornerRadius = [NSNumber numberWithDouble:5.0];
    [videoPlayButton addTarget:self action:@selector(videoSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.images setContentSize:CGSizeMake(110,0)];
}

- (void)showImageGrid:(NSArray *)imageArray {
    
    for(UIView * subView in self.images.subviews){
        [subView removeFromSuperview];
    }
    
    CGFloat width = (WindowWidth - 10 * 2 - (Clearance*2))/3;
    NSInteger index = 0;
    for(int i = 0; i<3; i++){
        for(int j = 0; j<3; j++){
            if(index >= imageArray.count) break;
            UIView * content = [[UIView alloc] init];
            [content setBackgroundColor:[UIColor whiteColor]];
            [self.images addSubview:content];
            
            content.sd_layout
            .leftSpaceToView(self.images,j*width)
            .topSpaceToView(self.images,i*width)
            .widthIs(width)
            .heightIs(width);
            
            UIImageView * image = [[UIImageView alloc] init];
            [image setBackgroundColor:ColorHex(0Xeeeeee)];
            [image setContentMode:UIViewContentModeScaleAspectFit];
            image.tag = 100+index;
            [image addTarget:self action:@selector(imageSelected:)];
            [self.content addSubview:image];
            NSDictionary * model = [imageArray objectAtIndex:index];
            [image sd_setImageWithURL:[NSURL URLWithString:[model objectForKey:@"thumbnailUrl"]]];
            image.layer.cornerRadius = 5;
            image.layer.masksToBounds = TRUE;
            image.sd_layout
            .leftSpaceToView(content,2.5)
            .topSpaceToView(content,2.5)
            .widthIs(width-5)
            .heightIs(width-5);
            [content addSubview:image];
            
            index++;
        }
    }

    if( _cellModel.imageRows > 0)
    {
        NSInteger imageCount = _cellModel.images.count;
        CGFloat height  = imageCount/3*width;
        if(imageCount % 3 >0){
            height+=width;
        }
        
        [_btn_expand setTitle:@"收起" forState:UIControlStateNormal];
        self.images.sd_layout.heightIs(height);
    }
    else
    {
        [_btn_expand setTitle:@"展开" forState:UIControlStateNormal];
    }
    
    [self.btn_expand setHidden:(imageArray.count <= 3) ? YES:NO];
    if (!self.btn_expand.isHidden)
        self.btn_expand.sd_layout.heightIs(27);
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
    
    //[self.images setContentSize:CGSizeMake(110*imageArray.count,0)];
}

- (void) expandTextSelected {
    _cellModel.extraHeight = -_cellModel.extraHeight;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(rowExpanded)]){
        [self.delegate rowExpanded];
    }
}

- (void) expandSelected {
    
    if(_cellModel.imageRows > 0)
    {
        _cellModel.imageRows = 0;
    }
    else
    {
        _cellModel.imageRows = ceil(_cellModel.images.count/3.f);
    }
    _cellModel.isExpend = !_cellModel.isExpend;
    if(self.delegate && [self.delegate respondsToSelector:@selector(rowExpanded)]){
        [self.delegate rowExpanded];
    }
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
