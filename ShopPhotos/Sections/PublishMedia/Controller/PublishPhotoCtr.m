//
//  PublishPhotoCtr.m
//  ShopPhotos
//
//  Created by  on 4/13/17.
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
#import "AlbumPhotosRequset.h"
#import "AlbumPhotosModel.h"
#import "PhotoImagesRequset.h"
#import <UITextView+Placeholder.h>

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
@property (strong, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) UITextView * photoTitle;
@property (strong, nonatomic) UITextField * remarksContent;
@property (strong, nonatomic) NSString* classify_id;
@property (strong, nonatomic) NSString* subclassification_id;
@property (strong, nonatomic) NSMutableArray *addImageArray;
@property (strong, nonatomic) NSString * photoId;

@end

@implementation PublishPhotoCtr

- (NSMutableArray *)imageArray {
    if(!_imageArray)
        _imageArray = [[NSMutableArray alloc] init];
    return _imageArray;
}

- (NSMutableArray *)addImageArray {
    if(!_addImageArray)
        _addImageArray = [[NSMutableArray alloc] init];
    return _addImageArray;
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
    [self addImageArray];
    
    [self createAutoLayout];
    self.classify_id = @"";
    self.subclassification_id = @"";
    
    if (self.isAdd) {
        self.photoId = [self.editData objectForKey:@"photoId"];
        [self.imageArray setArray:[self.editData objectForKey:@"images"]];
        [self.mtitle setText:[self.editData objectForKey:@"headtitle"]];
        [self.photoTitle setText:[self.editData objectForKey:@"title"]];
        [self.remarksContent setText:[self.editData objectForKey:@"remarks"]];
        [self setClassifies:[self.editData objectForKey:@"parentclass"] subClass:[self.editData objectForKey:@"subclass"]];
        [self.clearMessage setHidden:YES];
        [self.recommendSwitch setOn:[[self.editData objectForKey:@"recommend"] boolValue]];
        
        [self.btn_ok setTitle:@"完成" forState:UIControlStateNormal];
    }
    [self drawImages];
}

- (void)viewDidAppear:(BOOL)animated {
//    [self.content setContentSize:CGSizeMake(0, _photoClassView.top+_photoClassView.height+20)];
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
    
    UIView *line0 = [[UIView alloc]init];
    [line0 setBackgroundColor:ColorHex(0xebebeb)];
    [_content addSubview:line0];
    line0.sd_layout
    .leftEqualToView(_content)
    .rightEqualToView(_content)
    .topSpaceToView(_photoView,7)
    .heightIs(10);
    
    self.photoTitle = [[UITextView alloc] init];
//    self.photoTitle.contentInset = UIEdgeInsetsMake(2,-4,-2,-4);
//    self.photoTitle.delegate = self;
    [self.photoTitle setFont:Font(13)];
//    [self.photoTitle setBorderWidth:1.0];
//    [self.photoTitle setBorderColor:ColorHex(0xe0e0e0)];
    [self.photoTitle setPlaceholder:@"添加相册的描述..."];
    [self.photoTitle setTextColor:[UIColor darkGrayColor]];
    [self.photoTitle setBackgroundColor:[UIColor whiteColor]];
    
    [self.content addSubview:self.photoTitle];
    self.photoTitle.sd_layout
    .leftSpaceToView(_content,Clearance)
    .rightSpaceToView(_content,Clearance+30)
    .topSpaceToView(line0,5)
    .heightIs(60);
    
    UIButton * btnClear = [[UIButton alloc]init];
    [_content addSubview:btnClear];
    [btnClear addTarget:self action:@selector(clearPhotoTitle)];
    [btnClear setBackgroundImage:[UIImage imageNamed:@"btn_close_grey"] forState:UIControlStateNormal];
    btnClear.sd_layout
    .rightSpaceToView(_content,15)
    .bottomEqualToView(_photoTitle)
    .widthIs(25)
    .heightIs(25);
    
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
    .heightIs(90);

    UILabel *reamrksTitle = [[UILabel alloc] init];
    [reamrksTitle setText:@"备注"];
    [reamrksTitle setTextColor:[UIColor blackColor]];
    [reamrksTitle setFont:Font(14)];
    [remarksView addSubview:reamrksTitle];
    reamrksTitle.sd_layout
    .leftSpaceToView(remarksView,Clearance)
    .topSpaceToView(remarksView,20)
    .widthIs(40)
    .heightIs(30);
    
    self.remarksContent = [[UITextField alloc] init];
    //self.remarksContent.delegate = self;
    //self.remarksContent.contentInset = UIEdgeInsetsMake(2,0,2,0);
    [self.remarksContent setBackgroundColor:[UIColor clearColor]];
    [self.remarksContent setFont:Font(13)];
    [self.remarksContent setPlaceholder:@"请输入备注，仅限自己查看"];
    [self.remarksContent setTextColor:[UIColor darkGrayColor]];
    [remarksView addSubview:self.remarksContent];
    self.remarksContent.sd_layout
    .leftSpaceToView(reamrksTitle,15)
    .topSpaceToView(remarksView,15)
    .rightSpaceToView(remarksView,15)
    .heightIs(40);
    
    UIView *line2 = [[UIView alloc]init];
    [line2 setBackgroundColor:ColorHex(0xe0e0e0)];
    [remarksView addSubview:line2];
    line2.sd_layout
    .leftSpaceToView(remarksView,Clearance)
    .rightSpaceToView(remarksView,Clearance)
    .topSpaceToView(_remarksContent,5)
    .heightIs(1);
    
    UILabel *reamrksNote = [[UILabel alloc] init];
    [reamrksNote setText:@"*备注信息仅自己可见"];
    [reamrksNote setTextColor:[UIColor grayColor]];
    [reamrksNote setFont:Font(11)];
    [reamrksNote setTextAlignment:NSTextAlignmentRight];
    [remarksView addSubview:reamrksNote];
    reamrksNote.sd_layout
    .rightSpaceToView(remarksView,Clearance)
    .topSpaceToView(line2,0)
    .widthIs(150)
    .heightIs(40);
    
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
    [photoClassTitle setFont:Font(14)];
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
    
    UIButton *arrow_right = [[UIButton alloc] init];
    [arrow_right setBackgroundImage:[UIImage imageNamed:@"ico_arrow_right"] forState:UIControlStateNormal];
    [arrow_right addTarget:self action:@selector(selectClass)];
    [photoClassContentView addSubview:arrow_right];
    arrow_right.sd_layout
    .rightSpaceToView(photoClassContentView,10)
    .centerYEqualToView(photoClassContentView)
    .widthIs(16)
    .heightIs(16);
    
    _photoClassContent = [[UILabel alloc] init];
//    [_photoClassContent setText:@"耐克/2017新款"];
    [_photoClassContent setTextColor:ColorHex(0x4893d7)];
    [_photoClassContent setFont:Font(14)];
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
    [recommendClassTitle setFont:Font(14)];
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
    [_clearMessage.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.content addSubview:_clearMessage];
    
    _clearMessage.sd_layout
    .leftSpaceToView(self.content,Clearance)
    .rightSpaceToView(self.content,Clearance)
    .topSpaceToView(_photoClassView,20)
    .heightIs(40);
    
    [_clearMessage updateLayout];
//    [self.content setContentSize:CGSizeMake(0, WindowHeight)];
    
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
//        [image.image addTarget:self action:@selector(imageSelected:)];
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
    if (_imageArray.count > button.superview.superview.tag) {
        PhotoImagesModel *imageModel = [_imageArray objectAtIndex:button.superview.superview.tag];
        if (imageModel.Id) {
            [self deletePhotoImage:@{@"imageId":imageModel.Id,@"photoId":self.photoId}];

        } else {
            [_imageArray removeObjectAtIndex:button.superview.superview.tag];
            [self drawImages];
        }
    }
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
    
    [_imageArray removeAllObjects];
    [self drawImages];
    [_photoTitle setText:@""];
    [_remarksContent setText:@""];
    [_photoClassContent setText:@""];
    [_recommendSwitch setOn:NO];
}

// Target methods
- (void) backSelected {
    if (!_isAdd) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出此次编辑?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
        //    [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (void) publishSelected {
    
    // 上传发布相册
    if(_imageArray.count == 0){
        SPAlert(@"请选择图片",self);
        return;
    }
    
    if (self.classify_id.length == 0) {
        SPAlert(@"请选父分类",self);
        return;
    }
    
    if (self.subclassification_id.length == 0) {
        SPAlert(@"请选子分类",self);
        return;
    }
    
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
            if (self.isAdd) {
                [self updatePhoto];
            }
            else {
                
                [self postImage:self.imageArray];
            }
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if (self.isAdd) {
            [self updatePhoto];
        }
        else {
            
            [self postImage:self.imageArray];
        }
    }
}

- (void)updatePhoto {
    
    [self showLoad];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];

    [data setValue:self.photoId forKey:@"photoId"];
    [data setValue:self.photoTitle.text forKey:@"title"];
    [data setValue:self.remarksContent.text forKey:@"description"];
    [data setValue:self.recommendSwitch.on?@"1":@"0" forKey:@"recommend"];
    
    for (PhotoImagesModel *image in self.imageArray) {
        if (image.isCover) {
            [data setValue:image.Id forKey:@"coverImageId"];
        }
    }
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPUTUrl :[NSString stringWithFormat:@"%@%@",config.updatePhoto,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"更新成功"];
            [weakSelef.navigationController popViewControllerAnimated:YES];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)copyPhoto {
    
    [self showLoad];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    
    [data setValue:self.photoId forKey:@"photoId"];
    [data setValue:self.classify_id forKey:@"classifyName"];
    [data setValue:self.subclassification_id forKey:@"subclassName"];
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl :[NSString stringWithFormat:@"%@%@",config.ccopyPhoto,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"复制成功"];
        }else{
            [weakSelef showToast:model.message];
        }
        [weakSelef.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)postImage:(NSArray *)imageArray{
    // 保存当前信息
    NSMutableDictionary * postData = [[NSMutableDictionary alloc] init];
//    _classify_id = @"父亲_2";
//    _subclassification_id = @"子_22";
    
    NSString * recommendText = _recommendSwitch.on?@"1":@"0";
    
    if (self.isAdd == NO) {
        [postData setValue:recommendText forKey:@"recommend"];
        [postData setValue:_classify_id forKey:@"classifyName"];
        [postData setValue:_subclassification_id forKey:@"subclassName"];
        //if(self.photoTitle.text.length > 0)
            [postData setValue:self.photoTitle.text forKey:@"title"];
        //if(self.remarksContent.text.length > 0)
            [postData setValue:self.remarksContent.text forKey:@"description"];
        [self showToast:@"正在上传,请保存网络通畅"];
    }
    else {
        [postData setValue:self.photoId forKey:@"photoId"];
        [self showToast:@"正在更新,请保存网络通畅"];
    }
    
//    [self clearSelected:NO];
    [self.content setContentOffset:CGPointMake(0, 0) animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray * imageDatas = [NSMutableArray array];
        int index = 0;
        for(PhotoImagesModel * imageModel in imageArray){
            if (imageModel.isNew == YES) {
                NSData *imageData = [self compressOriginalImage:imageModel.photo toMaxDataSizeKBytes:300];
                [imageDatas addObject:imageData];
                NSLog(@"size == %ld",(unsigned long)imageData.length);
                if (imageModel.isCover) {
                    [postData setValue:[NSString stringWithFormat:@"%d",index] forKey:@"idxCover"];
                }
                index ++;
            }
        }
        
        [postData setValue:imageDatas forKey:@"images"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearSelecteds];
        });
        // 耗时的操作
        PublishPhoto * task = [[PublishPhoto alloc] init];
        task.isAdd = self.isAdd;
        [task startTask:postData complete:^(id responseObj){
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，

                if(responseObj != nil){
                    if (self.isAdd == NO) {
                        [self showToast:@"上传成功"];
                    }
                    else {
                        
                        [self showToast:@"更新成功"];
                    }
                } else {
                    if (self.isAdd == NO) {
                        [self showToast:@"上传失败，请检查网络是否通畅，或者重新尝试"];
                    }else{
                        [self showToast:@"更新失败，请检查网络是否通畅，或者重新尝试"];
                    }
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

- (void) clearPhotoTitle {
    [self.photoTitle setText:@""];
}
- (void) selectPhotoClass {}
- (void) selectRecommendSwitch {}

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
    
    [_addImageArray removeAllObjects];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {}];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

//- (void) imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {};
- (void) imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    BOOL fFirst = YES;
    if ( _imageArray && _imageArray.count > 0) {
        fFirst = NO;
    }
    if(assets && assets.count >0) {
        for (UIImage *photo in photos) {
            PhotoImagesModel * imageModel = [[PhotoImagesModel alloc] init];
//            NSLog(@"path: %@",[[info objectForKey:@"PHImageFileURLKey"] absoluteString]);
//            imageModel.photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:[info objectForKey:@"PHImageFileURLKey"]]];
            imageModel.photo = photo;
            imageModel.isCover = NO;
            imageModel.edit = YES;
            imageModel.isNew = YES;
            [_imageArray addObject:imageModel];
        }
    }
    if (fFirst &&  _imageArray && _imageArray.count > 0) {
        int index = 0;
        for (PhotoImagesModel * imageModel in _imageArray) {
            if (imageModel.isCover) { imageModel.isCover = NO; }
            if (index == 0) { imageModel.isCover = YES; }
            index++;
        }

    }

    [self drawImages];
    
    if (self.isAdd == YES) {
        [self postImage:_imageArray];
    }
}

- (void) selectClass {
    
    AlbumClassCtr * albumClass = GETALONESTORYBOARDPAGE(@"AlbumClassCtr");
//    albumClass.parentModel = self.pa
    albumClass.isSubClass = NO;
    albumClass.uid = self.photosUserID;
    albumClass.isFromUploadPhoto = YES;
    albumClass.fromCtr = self;
    [self.navigationController pushViewController:albumClass animated:YES];
}
// AlbumClassCtrDelegate

- (void)setClassifies:(NSString *)parent subClass:(NSString *)subclass {
    _classify_id = [NSString stringWithString:parent];
    _subclassification_id = [NSString stringWithString:subclass];
    [_photoClassContent setText:[NSString stringWithFormat:@"%@/%@",parent,subclass]];
}

- (void) deletePhotoImage:(NSDictionary *)data{
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",self.congfing.deletePhotoImage,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [weakSelef showToast:@"删除成功"];
            [weakSelef loadNetworkData];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)loadNetworkData {
    
    [self showLoad];
    //[self showLoad];
    
    NSDictionary * data = @{@"photoId":self.photoId};
    __weak __typeof(self)weakSelef = self;
    // 获取相册详情内容

    [HTTPRequest requestGETUrl :[NSString stringWithFormat:@"%@%@",self.congfing.getPhoto,[self.appd getParameterString]] parametric:data succed:^(id responseObject) {
        [weakSelef closeLoad];
        NSLog(@"获取相册详情内容 -- >%@",responseObject);
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            AlbumPhotosModel *data = [requset.dataArray objectAtIndex:0];
            PhotoImagesRequset * requset = [[PhotoImagesRequset alloc] init];
            [requset analyticInterface:data.images];
            if(requset.status == 0){
                [self.imageArray removeAllObjects];
                [self.imageArray addObjectsFromArray:requset.dataArray];
                for (PhotoImagesModel *imageModel in self.imageArray) {
                    imageModel.edit = YES;
                    imageModel.isNew = NO;
                }
                [self drawImages];
            }
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

@end
