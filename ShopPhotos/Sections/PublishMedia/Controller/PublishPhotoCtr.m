//
//  PublishPhotoCtr.m
//  ShopPhotos
//
//  Created by Park Jin Hyok on 4/13/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "PublishPhotoCtr.h"
#import "PhotoDetailsHeadImage.h"
#import <TZImagePickerController.h>
#import "PhotoImagesModel.h"
#import "PostImage.h"
#import "PublishPhoto.h"
#import "AlbumClassCtr.h"
#import <UIImageView+WebCache.h>

//#import <UITextView+Placeholder.h>

@interface PublishPhotoCtr ()<UIScrollViewDelegate,UITextViewDelegate,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mtitle;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_ok;
@property (weak, nonatomic) IBOutlet UIScrollView *content;

@property (strong, nonatomic) UIView * photoClassView;
@property (strong, nonatomic) UILabel * photoClassContent;

@property (strong, nonatomic) UISwitch * recommendSwitch;

@property (strong, nonatomic) UIView *photoView;
@property (strong, nonatomic) UIButton *clearMessage;

@property (strong, nonatomic) NSString *parentClass;
@property (strong, nonatomic) UIButton *subClass;

@property (strong, nonatomic) NSString* classify_id;
@property (strong, nonatomic) NSString* subclassification_id;

@end

@implementation PublishPhotoCtr

- (NSMutableArray *)imageArray{
    if(!_imageArray)
        _imageArray = [NSMutableArray array];
    return _imageArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btn_cancel addTarget:self action:@selector(backSelected)];
    [self.btn_ok addTarget:self action:@selector(publishSelected)];
    self.content.delegate = self;
    [self imageArray];
    [self createAutoLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.content setContentSize:CGSizeMake(0, _photoClassView.top+_photoClassView.height+20)];
    NSLog(@"%f", _photoClassView.top);
}
- (void)createAutoLayout {
    
    _photoView = [[UIView alloc] init];
    [self.content addSubview:_photoView];
    _photoView.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(self.content,Clearance)
    .topSpaceToView(self.content,Clearance)
    .heightIs((WindowWidth-40)/3);
    
    self.photoTitle = [[UITextView alloc] init];
    self.photoTitle.contentInset = UIEdgeInsetsMake(2,-4,-2,-4);
    self.photoTitle.delegate = self;
    [self.photoTitle setFont:Font(15)];
    [self.photoTitle setBorderWidth:1.0];
    [self.photoTitle setBorderColor:ColorHex(0xe0e0e0)];
    [self.photoTitle setTextColor:[UIColor darkGrayColor]];
    [self.photoTitle setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:self.photoTitle];
    self.photoTitle.sd_layout
    .leftSpaceToView(_content,Clearance)
    .rightSpaceToView(_content,Clearance+30)
    .topSpaceToView(_photoView,5)
    .heightIs(60);
    
    UIButton * btnClear = [[UIButton alloc]init];
    [_content addSubview:btnClear];
    [btnClear addTarget:self action:@selector(clearPhotoTitle)];
    [btnClear setBackgroundImage:[UIImage imageNamed:@"btn_close_grey"] forState:UIControlStateNormal];
    btnClear.sd_layout
    .rightSpaceToView(_content,15)
    .bottomEqualToView(_photoTitle)
    .widthIs(16)
    .heightIs(16);
    
    UIView *line1 = [[UIView alloc]init];
    [line1 setBackgroundColor:ColorHex(0xebebeb)];
    [_content addSubview:line1];
    line1.sd_layout
    .leftEqualToView(_content)
    .rightEqualToView(_content)
    .topSpaceToView(_photoTitle,15)
    .heightIs(10);
    
    UIView *remarksView = [[UIView alloc] init];
    [self.content addSubview:remarksView];
    remarksView.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topEqualToView(line1)
    .heightIs(120);

    UILabel *reamrksTitle = [[UILabel alloc] init];
    [reamrksTitle setText:@"备注"];
    [reamrksTitle setTextColor:[UIColor blackColor]];
    [reamrksTitle setFont:Font(17)];
    [remarksView addSubview:reamrksTitle];
    reamrksTitle.sd_layout
    .leftSpaceToView(remarksView,Clearance)
    .topSpaceToView(remarksView,20)
    .widthIs(40)
    .heightIs(30);
    
    self.remarksContent = [[UITextView alloc] init];
    self.remarksContent.delegate = self;
    self.remarksContent.contentInset = UIEdgeInsetsMake(2,0,2,0);
    [self.remarksContent setBackgroundColor:[UIColor clearColor]];
    [self.remarksContent setFont:Font(15)];
    [self.remarksContent setTextColor:[UIColor darkGrayColor]];
    [remarksView addSubview:self.remarksContent];
    self.remarksContent.sd_layout
    .leftSpaceToView(reamrksTitle,15)
    .topSpaceToView(remarksView,20)
    .rightSpaceToView(remarksView,15)
    .heightIs(50);
    
    UIView *line2 = [[UIView alloc]init];
    [line2 setBackgroundColor:ColorHex(0xe0e0e0)];
    [remarksView addSubview:line2];
    line2.sd_layout
    .leftSpaceToView(remarksView,Clearance)
    .rightSpaceToView(remarksView,Clearance)
    .topSpaceToView(_remarksContent,15)
    .heightIs(1);
    
    UILabel *reamrksNote = [[UILabel alloc] init];
    [reamrksNote setText:@"*备注信息仅自己可见"];
    [reamrksNote setTextColor:[UIColor grayColor]];
    [reamrksNote setFont:Font(15)];
    [reamrksNote setTextAlignment:NSTextAlignmentRight];
    [remarksView addSubview:reamrksNote];
    reamrksNote.sd_layout
    .rightSpaceToView(remarksView,Clearance)
    .topSpaceToView(line2,10)
    .widthIs(150)
    .heightIs(30);
    
    UIView *line3 = [[UIView alloc]init];
    [line3 setBackgroundColor:ColorHex(0xebebeb)];
    [_content addSubview:line3];
    line3.sd_layout
    .leftEqualToView(_content)
    .rightEqualToView(_content)
    .topSpaceToView(remarksView,15)
    .heightIs(10);
    
    _photoClassView = [[UIView alloc] init];
    [self.content addSubview:_photoClassView];
    _photoClassView.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(line3,0)
    .heightIs(100);
    
    UILabel *photoClassTitle = [[UILabel alloc] init];
    [photoClassTitle setText:@"选择分类"];
    [photoClassTitle setTextColor:[UIColor blackColor]];
    [photoClassTitle setFont:Font(17)];
    [_photoClassView addSubview:photoClassTitle];
    photoClassTitle.sd_layout
    .leftSpaceToView(_photoClassView,Clearance)
    .topSpaceToView(_photoClassView,10)
    .widthIs(100)
    .heightIs(30);
    
    UIView *photoClassContentView = [[UIView alloc]init];
    [_photoClassView addSubview:photoClassContentView];
    [photoClassContentView addTarget:self action:@selector(selectClass)];
    photoClassContentView.sd_layout
    .rightEqualToView(_photoClassView)
    .topEqualToView(_photoClassView)
    .leftSpaceToView(photoClassTitle,20)
    .heightIs(50);
    [photoClassContentView addTarget:self action:@selector(selectPhotoClass)];
    
    UIButton *arrow_right = [[UIButton alloc] init];
    [arrow_right setBackgroundImage:[UIImage imageNamed:@"ico_arrow_right"] forState:UIControlStateNormal];
    [photoClassContentView addSubview:arrow_right];
    arrow_right.sd_layout
    .rightSpaceToView(photoClassContentView,10)
    .centerYEqualToView(photoClassContentView)
    .widthIs(16)
    .heightIs(16);
    
    _photoClassContent = [[UILabel alloc] init];
//    [_photoClassContent setText:@"耐克/2017新款"];
    [_photoClassContent setTextColor:ColorHex(0x4893d7)];
    [_photoClassContent setFont:Font(18)];
    [_photoClassContent setTextAlignment:NSTextAlignmentRight];
    [_photoClassContent addTarget:self action:@selector(selectClass)];
    [photoClassContentView addSubview:_photoClassContent];
    _photoClassContent.sd_layout
    .leftEqualToView(photoClassContentView)
    .rightSpaceToView(arrow_right,5)
    .centerYEqualToView(photoClassContentView)
    .heightIs(20);
    
    UIView *line4 = [[UIView alloc]init];
    [line4 setBackgroundColor:ColorHex(0xe0e0e0)];
    [_photoClassView addSubview:line4];
    line4.sd_layout
    .leftSpaceToView(_photoClassView,Clearance)
    .rightSpaceToView(_photoClassView,Clearance)
    .topSpaceToView(photoClassContentView,0)
    .heightIs(1);
    
    UILabel *recommendClassTitle = [[UILabel alloc] init];
    [recommendClassTitle setText:@"是否推荐"];
    [recommendClassTitle setTextColor:[UIColor blackColor]];
    [recommendClassTitle setFont:Font(17)];
    [_photoClassView addSubview:recommendClassTitle];
    recommendClassTitle.sd_layout
    .leftSpaceToView(_photoClassView,Clearance)
    .topSpaceToView(line4,10)
    .widthIs(100)
    .heightIs(30);
   
    _recommendSwitch = [[UISwitch alloc] init];
    [_photoClassView addSubview:_recommendSwitch];
    _recommendSwitch.sd_layout
    .rightSpaceToView(_photoClassView,Clearance)
    .topSpaceToView(line4,10)
    .widthIs(52)
    .heightIs(30);
    /*
    _recommendSwitch = [[UIImageView alloc] init];
    [_recommendSwitch setImage:[UIImage imageNamed:@"switch_off"]];
    [_photoClassView addSubview:_recommendSwitch];
    _recommendSwitch.sd_layout
    .rightSpaceToView(_photoClassView,Clearance)
    .topSpaceToView(line4,10)
    .widthIs(52)
    .heightIs(30);
    [_recommendSwitch addTarget:self action:@selector(selectRecommendSwitch)];
    */
    
    _clearMessage = [UIButton buttonWithType:UIButtonTypeSystem];
    [_clearMessage setTitle:@"清空信息" forState:UIControlStateNormal];
    [_clearMessage setBackgroundColor:ColorHex(0x388ed0)];
    _clearMessage.cornerRadius = 5;
    [_clearMessage addTarget:self action:@selector(clearSelecteds) forControlEvents:UIControlEventTouchUpInside];
    [_clearMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.content addSubview:_clearMessage];
    
    _clearMessage.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(self.content,Clearance)
    .topSpaceToView(_photoClassView,20)
    .heightIs(40);
    
    [_clearMessage updateLayout];
    [self.content setContentSize:CGSizeMake(0, WindowHeight)];
    [self drawImages];
}

- (void) drawImages {
    for(UIView * subView in _photoView.subviews){
        [subView removeFromSuperview];
    }
    [_photoView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat width = (WindowWidth - (Clearance*2))/3;
    NSInteger index = 0;
    for(index = 0; index<_imageArray.count; index++){
        if(index >= 9) break;
        
        CGFloat x = index%3;
        CGFloat y = index/3;

        UIView * content = [[UIView alloc] init];
        [content setBackgroundColor:[UIColor whiteColor]];
        [_photoView addSubview:content];
        
        content.sd_layout
        .leftSpaceToView(self,x*width)
        .topSpaceToView(self,y*width)
        .widthIs(width)
        .heightIs(width);
        
        PhotoImagesModel * imageModel = [[PhotoImagesModel alloc] init];
        PhotoDetailsHeadImage * image = [[PhotoDetailsHeadImage alloc] init];
        [content addSubview:image];
        imageModel = [_imageArray objectAtIndex:index];
        
        if (!imageModel.photo) {
            [image.image sd_setImageWithURL:[NSURL URLWithString:imageModel.thumbnailUrl]];
        }
        else{
            [image.image setImage:imageModel.photo];
        }
        [image setBackgroundColor:ColorHex(0xEEEEEE)];
        image.sd_layout
        .leftSpaceToView(content,2.5)
        .topSpaceToView(content,2.5)
        .widthIs(width-5)
        .heightIs(width-5);
        image.layer.cornerRadius = 5.0f;
        image.layer.masksToBounds = TRUE;
        
        image.tag = index;
        [image setImageCover:imageModel.isCover];
        [image setEditStyle:imageModel.edit];
        [image.deleteBtn addTarget:self action:@selector(deleteSelected:) forControlEvents:UIControlEventTouchUpInside];
        [image.settingBtn addTarget:self action:@selector(settingSelected:) forControlEvents:UIControlEventTouchUpInside];
        [image.image addTarget:self action:@selector(imageSelected:)];
    }
    
    if (index < 9) {
        CGFloat x = (index)%3;
        CGFloat y = (index)/3;

        UIView * content = [[UIView alloc] init];
        [content setBackgroundColor:[UIColor whiteColor]];
        [content addTarget:self action:@selector(addPublishImage)];
        [_photoView addSubview:content];
        content.sd_layout
        .leftSpaceToView(self,x*width)
        .topSpaceToView(self,y*width)
        .widthIs(width)
        .heightIs(width);
        content.layer.borderColor = ColorHex(0xEEEEEE).CGColor;
        content.layer.borderWidth = 1.0;
        content.layer.cornerRadius = 5.0f;
        content.layer.masksToBounds = YES;

        PostImage * image = [[PostImage alloc] init];
        [image setImage:[UIImage imageNamed:@"ico_add"]];
        [image addTarget:self action:@selector(addPublishImage)];
        image.tag = index;
        [content addSubview:image];
        image.sd_layout
        .centerXEqualToView(content)
        .centerYEqualToView(content)
        .widthIs(20)
        .heightIs(20);
    }
    
    NSInteger  count = _photoView.subviews.count;
    CGFloat x = count%3;
    CGFloat y = count/3;
    if(x>1)x=1;
    _photoView.sd_layout.heightIs(y*width+x*width);
    [_photoView updateLayout];
    CGFloat offset = _clearMessage.top+_clearMessage.height + 50;
    if(offset<WindowHeight)offset = WindowHeight+10;
    [self.content setContentSize:CGSizeMake(0, offset)];
    [self.content updateLayout];
}


- (void)deleteSelected:(UIButton *)button{
    NSLog(@"%ld",button.superview.superview.tag);
    [_imageArray removeObjectAtIndex:button.superview.superview.tag];
    [self drawImages];
}

- (void)settingSelected:(UIButton *)button{
    NSLog(@"%ld",button.superview.superview.tag);
    NSInteger idxsel = button.superview.superview.tag;
    
    int index = 0;
    for (PhotoImagesModel * imageModel in _imageArray) {
        if (imageModel.isCover) { imageModel.isCover = NO; }
        if (index == idxsel) { imageModel.isCover = YES; }
        index++;
    }
    [self drawImages];
}

- (void)imageSelected:(UIButton *)button{
    NSLog(@"%ld",button.superview.superview.tag);
}
- (void)clearSelecteds {
}

// Target methods
- (void) backSelected {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) publishSelected {
    
    // 上传发布相册
    if(_imageArray.count == 0){
        SPAlert(@"请选择图片",self);
        return;
    }
    /*
    if(self.fatherClassSelectIndex == 0){
        
        if(self.faherEnter.text.length == 0){
            SPAlert(@"请输入主分类",self);
            return;
        }
        if(self.subEnter.text.length == 0){
            SPAlert(@"请输入子分类",self);
            return;
        }
    }else{
        
        if(self.subClassSelectIndex == 0){
            if(self.subClsssEnter.text.length == 0){
                SPAlert(@"请输入子分类",self);
                return;
            }
        }
    }
    */
    
    NSMutableString * msg = [NSMutableString string];
    
    if(self.photoTitle.text.length == 0){
        [msg appendString:@" 描述 "];
    }
    
    if(self.remarksContent.text.length == 0){
        [msg appendString:@" 备注 "];
    }
    if(msg.length > 0){
        NSString * str = [NSString stringWithFormat:@"您还有'%@'未填写 是否继续上传",msg];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self postImage];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self postImage];
    }
}

- (void)postImage{
    // 保存当前信息
    NSMutableDictionary * postData = [[NSMutableDictionary alloc] init];
    
//    _classify_id = @"父亲_2";
//    _subclassification_id = @"子_22";
    
    NSString * recommendText = _recommendSwitch.on?@"1":@"0";
    [postData setValue:recommendText forKey:@"recommend"];
    [postData setValue:_classify_id forKey:@"classifyName"];
    [postData setValue:_subclassification_id forKey:@"subclassName"];
    [postData setValue:self.photoTitle.text forKey:@"title"];
    [postData setValue:self.remarksContent.text forKey:@"description"];
    
//    [self clearSelected:NO];
    [self showToast:@"正在上传,请保存网络通畅"];
    [self.content setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [self showLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray * imageDatas = [NSMutableArray array];
        int index = 0;
        for(PhotoImagesModel * imageModel in _imageArray){
            NSData *imageData =  [self compressOriginalImage:imageModel.photo toMaxDataSizeKBytes:300];
            [imageDatas addObject:imageData];
            NSLog(@"size == %ld",imageData.length);
            if (imageModel.isCover) {
                [postData setValue:[NSString stringWithFormat:@"%d",index] forKey:@"idxCover"];
            }
            index ++;
        }
        
        [postData setValue:imageDatas forKey:@"images"];
        
        // 耗时的操作
        PublishPhoto * task = [[PublishPhoto alloc] init];
        
        [task startTask:postData complete:^(BOOL stuta){
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self closeLoad];
                if(stuta){
                    [self showToast:@"上传成功"];
                }else{
                    [self showToast:@"上传失败，请检查网络是否通畅，或者重新尝试"];
                }
            });
        }];
    });
}

- (NSData *) compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size {
    
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

- (void) clearPhotoTitle {}
- (void) selectPhotoClass {}
- (void) selectRecommendSwitch {}

#pragma makr - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)addPublishImage {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        SPAlert(@"请允许相册访问",self);
        return;
    }
    
    NSInteger count = 9 - _imageArray.count;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.photoWidth = 960;
    imagePickerVc.photoPreviewMaxWidth = 960;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        if(assets && assets.count >0) {
            for (UIImage *image in photos) {
                PhotoImagesModel * imageModel = [[PhotoImagesModel alloc] init];
                imageModel.photo = image;
                imageModel.isCover = NO;
                imageModel.edit= YES;
                [_imageArray addObject:imageModel];
            }
        }
        [self drawImages];
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void) selectClass {
    
    AlbumClassCtr * albumClass = GETALONESTORYBOARDPAGE(@"AlbumClassCtr");
    albumClass.isSubClass = NO;
    albumClass.uid = self.photosUserID;
    albumClass.isFromUploadPhoto = YES;
    albumClass.publish = self;
    [self.navigationController pushViewController:albumClass animated:YES];
}
// AlbumClassCtrDelegate

- (void)setClassifies:(NSString *)parent subClass:(NSString *)subclass {
    _classify_id = [NSString stringWithString:parent];
    _subclassification_id = [NSString stringWithString:subclass];
    [_photoClassContent setText:[NSString stringWithFormat:@"%@/%@",parent,subclass]];
}

@end
