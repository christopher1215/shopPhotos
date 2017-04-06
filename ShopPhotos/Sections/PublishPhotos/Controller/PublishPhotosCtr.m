//
//  PublishPhotosCtr.m
//  ShopPhotos
//
//  Created by addcn on 17/1/2.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PublishPhotosCtr.h"
#import "AlbumClassModel.h"
#import "PulishClassSelectAlert.h"
#import "CreatePhotosRequset.h"
#import "AddHandleImageNameRequset.h"
#import "PhotosVisitCtr.h"
#import "DynamicImagesModel.h"
#import <UIImageView+WebCache.h>
#import "PublishTask.h"
#import "STPhotosModel.h"
#import "PhotosController.h"
#import <TZImagePickerController.h>
#import "PostImage.h"

#define PublishPhotosPostData @"PublishPhotosPostData"


@interface PublishPhotosCtr ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,PulishClassSelectAlertDelegate,PhotosControllerDelegate,TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UIButton *clear;
@property (weak, nonatomic) IBOutlet UIScrollView *content;
@property (strong, nonatomic) UIView * imageView;
@property (strong, nonatomic) UIView * photoTitleView;
@property (strong, nonatomic) UITextView * photoTitle;
@property (strong, nonatomic) UILabel * photoTitlePlaceholder;
@property (strong, nonatomic) UIImageView * photoTitleClear;
@property (strong, nonatomic) UITextField * remarks;
@property (strong, nonatomic) UITextField * price;
@property (strong, nonatomic) UIView * classSelect;
@property (strong, nonatomic) UIView * fatherClass;
@property (strong, nonatomic) UILabel * fatherClassText;
@property (strong, nonatomic) UIImageView * fatherClassIcon;
@property (strong, nonatomic) UIView * subClass;
@property (strong, nonatomic) UILabel * subClassText;
@property (strong, nonatomic) UIImageView * subClassIcon;
@property (strong, nonatomic) UITextField * subClsssEnter;
@property (strong, nonatomic) UIView * classEnter;
@property (strong, nonatomic) UITextField * faherEnter;
@property (strong, nonatomic) UITextField * subEnter;
@property (strong, nonatomic) UIView * recommend;
@property (strong, nonatomic) UILabel * recommendText;
@property (strong, nonatomic) UISwitch * recommendSwh;
@property (strong, nonatomic) UIButton * publish;
@property (strong, nonatomic) NSMutableArray * images;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) PulishClassSelectAlert * classAlert;
@property (assign, nonatomic) NSInteger fatherClassSelectIndex;
@property (assign, nonatomic) NSInteger subClassSelectIndex;
@property (strong, nonatomic) UIView * line5;
@property (strong, nonatomic) UIView * line6;
@property (strong, nonatomic) UIView * line7;
@property (strong, nonatomic) NSMutableArray * postImageNames;
@property (strong, nonatomic) NSString * postPhotosID;
@property (strong, nonatomic) NSMutableArray * selectArray;
@property (strong, nonatomic) NSMutableString * dataSize;
@property (strong, nonatomic) NSMutableString * imageName;
@property (strong, nonatomic) UITextField * tempTextField;

@end

@implementation PublishPhotosCtr

- (NSMutableArray *)selectArray{
    if(!_selectArray) _selectArray = [NSMutableArray array];
    return _selectArray;
}

- (NSMutableArray *)postImageNames{

    if(!_postImageNames)_postImageNames = [NSMutableArray array];
    return _postImageNames;
}

- (NSMutableArray *)dataArray{
    
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (NSMutableArray *)images{
    
    if(!_images){
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_selectArray)[self createImage];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self createAutoLayout];
    
    [self loadNetworkData:@{@"uid":self.uid}];
}

- (void)setup{
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.clear addTarget:self action:@selector(publishSlected) forControlEvents:UIControlEventTouchUpInside];
    [self.clear setCornerRadius:3];
    self.content.delegate = self;
    self.imageName = [[NSMutableString alloc] init];
    self.dataSize = [[NSMutableString alloc] init];
    if(!self.uid)self.uid = self.photosUserID;
}

- (void)createAutoLayout{
    
    self.imageView = [[UIView alloc] init];
    [self.imageView setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:self.imageView];
    self.imageView.sd_layout
    .leftSpaceToView(self.content,20)
    .rightSpaceToView(self.content,20)
    .topSpaceToView(self.content,10)
    .heightIs((WindowWidth-40)/3);
    
    CGFloat width = (WindowWidth-40)/3;
    
    UIImageView * image = [[UIImageView alloc] init];
    [image setBackgroundColor:ColorHex(0XEEEEEE)];
    [image setImage:[UIImage imageNamed:@"addgray"]];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    [image addTarget:self action:@selector(addPublishImage:)];
    image.tag = 0;
    [self.imageView addSubview:image];
    image.sd_layout
    .leftSpaceToView(self.imageView,0)
    .topSpaceToView(self.imageView,0)
    .widthIs(width-10)
    .heightIs(width-10);

    
    UIView * line1 = [[UIView alloc] init];
    [line1 setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.content addSubview:line1];
    line1.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.imageView,5)
    .heightIs(15);
    
    self.photoTitleView = [[UIView alloc] init];
    [self.photoTitleView setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:self.photoTitleView];
    self.photoTitleView.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(line1,0)
    .heightIs(100);
    
    self.photoTitle = [[UITextView alloc] init];
    [self.photoTitle setFont:Font(13)];
    self.photoTitle.delegate = self;
    [self.photoTitle setBackgroundColor:[UIColor whiteColor]];
    [self.photoTitleView addSubview:self.photoTitle];
    self.photoTitle.sd_layout
    .leftSpaceToView(self.photoTitleView,10)
    .topSpaceToView(self.photoTitleView,0)
    .bottomSpaceToView(self.photoTitleView,0)
    .rightSpaceToView(self.photoTitleView,30);
    
    
    self.photoTitlePlaceholder = [[UILabel alloc] init];
    [self.photoTitlePlaceholder setText:@"添加相册的描述...."];
    [self.photoTitlePlaceholder setFont:Font(13)];
    [self.photoTitlePlaceholder setTextColor:ColorHex(0XCCCCCC)];
    [self.photoTitle addSubview:self.photoTitlePlaceholder];
    self.photoTitlePlaceholder.sd_layout
    .leftSpaceToView(self.photoTitle,5)
    .topSpaceToView(self.photoTitle,4)
    .widthIs(200)
    .heightIs(25);

    
    self.photoTitleClear = [[UIImageView alloc] init];
    [self.photoTitleClear addTarget:self action:@selector(photoTitleClearSelected)];
    [self.photoTitleClear setBackgroundColor:[UIColor whiteColor]];
    [self.photoTitleClear setContentMode:UIViewContentModeScaleAspectFit];
    [self.photoTitleClear setImage:[UIImage imageNamed:@"clear"]];
    [self.photoTitleView addSubview:self.photoTitleClear];
    self.photoTitleClear.sd_layout
    .rightSpaceToView(self.photoTitleView,5)
    .bottomSpaceToView(self.photoTitleView,5)
    .widthIs(25)
    .heightIs(25);
    
    UIView * line2 = [[UIView alloc] init];
    [line2 setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.content addSubview:line2];
    line2.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.photoTitleView,0)
    .heightIs(1);
    
    self.remarks = [[UITextField alloc] init];
    self.remarks.delegate = self;
    [self.remarks setPlaceholder:@"请输入备注，仅限自己查看"];
    [self.remarks setFont:Font(13)];
    [self.remarks setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:self.remarks];
    self.remarks.sd_layout
    .leftSpaceToView(self.content,10)
    .rightSpaceToView(self.content,10)
    .topSpaceToView(line2,5)
    .heightIs(40);
    
    UIView * line3 = [[UIView alloc] init];
    [line3 setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.content addSubview:line3];
    line3.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.remarks,5)
    .heightIs(1);
    
    self.price = [[UITextField alloc] init];
    [self.price setPlaceholder:@"请输入价格"];
    self.price.delegate = self;
    [self.price setFont:Font(13)];
    self.price.keyboardType = UIKeyboardTypeDecimalPad;
    [self.content addSubview:self.price];
    self.price.sd_layout
    .leftSpaceToView(self.content,10)
    .rightSpaceToView(self.content,10)
    .topSpaceToView(line3,5)
    .heightIs(40);
    
    UIView * line4 = [[UIView alloc] init];
    [line4 setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.content addSubview:line4];
    line4.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.price,5)
    .heightIs(1);
    
    self.classSelect = [[UIView alloc] init];
    [self.classSelect setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:self.classSelect];
    self.classSelect.sd_layout
    .leftSpaceToView(self.content,0)
    .rightSpaceToView(self.content,0)
    .topSpaceToView(line4,0)
    .heightIs(104);
    
    self.fatherClass = [[UIView alloc] init];
    [self.fatherClass addTarget:self action:@selector(fatherClassSelected)];
    [self.fatherClass setBackgroundColor:[UIColor whiteColor]];
    [self.classSelect addSubview:self.fatherClass];
    self.fatherClass.sd_layout
    .leftSpaceToView(self.classSelect,10)
    .rightSpaceToView(self.classSelect,10)
    .topSpaceToView(self.classSelect,0)
    .heightIs(50);
    
    self.fatherClassText = [[UILabel alloc] init];
    [self.fatherClassText setText:@"新建父分类"];
    [self.fatherClassText setTextColor:ThemeColor];
    [self.fatherClassText setFont:Font(13)];
    [self.fatherClassText setBackgroundColor:[UIColor whiteColor]];
    [self.fatherClass addSubview:self.fatherClassText];
    self.fatherClassText.sd_layout
    .leftEqualToView(self.fatherClass)
    .topEqualToView(self.fatherClass)
    .rightSpaceToView(self.fatherClass,30)
    .bottomEqualToView(self.fatherClass);
    
    self.fatherClassIcon = [[UIImageView alloc] init];
    [self.fatherClassIcon setContentMode:UIViewContentModeScaleAspectFit];
    [self.fatherClassIcon setImage:[UIImage imageNamed:@"ico_triangle"]];
    [self.fatherClass addSubview:self.fatherClassIcon];
    self.fatherClassIcon.sd_layout
    .rightSpaceToView(self.fatherClass,0)
    .topEqualToView(self.fatherClass)
    .bottomEqualToView(self.fatherClass)
    .widthIs(15);
    
    self.line5 = [[UIView alloc] init];
    [self.line5 setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.classSelect addSubview:self.line5];
    self.line5.sd_layout
    .leftEqualToView(self.classSelect)
    .rightEqualToView(self.classSelect)
    .topSpaceToView(self.fatherClass,0)
    .heightIs(1);
    
    self.subClass = [[UIView alloc] init];
    [self.subClass setBackgroundColor:[UIColor whiteColor]];
    [self.subClass addTarget:self action:@selector(subClassSelected)];
    [self.classSelect addSubview:self.subClass];
    self.subClass.sd_layout
    .leftSpaceToView(self.classSelect,10)
    .rightSpaceToView(self.classSelect,10)
    .topSpaceToView(self.line5,0)
    .heightIs(50);
    
    
    self.subClassText = [[UILabel alloc] init];
    [self.subClassText setText:@"新建子分类"];
    [self.subClassText setTextColor:ThemeColor];
    [self.subClassText setFont:Font(13)];
    [self.subClass addSubview:self.subClassText];
    self.subClassText.sd_layout
    .leftEqualToView(self.subClass)
    .topEqualToView(self.subClass)
    .rightSpaceToView(self.subClass,30)
    .bottomEqualToView(self.subClass);
    
    self.subClassIcon = [[UIImageView alloc] init];
    [self.subClassIcon setBackgroundColor:[UIColor whiteColor]];
    [self.subClassIcon setContentMode:UIViewContentModeScaleAspectFit];
    [self.subClassIcon setImage:[UIImage imageNamed:@"ico_triangle"]];
    [self.subClass addSubview:self.subClassIcon];
    self.subClassIcon.sd_layout
    .rightSpaceToView(self.subClass,0)
    .topEqualToView(self.subClass)
    .bottomEqualToView(self.subClass)
    .widthIs(15);
    
    self.line6 = [[UIView alloc] init];
    [self.line6 setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.classSelect addSubview:self.line6];
    self.line6.sd_layout
    .leftEqualToView(self.classSelect)
    .rightEqualToView(self.classSelect)
    .topSpaceToView(self.subClass,0)
    .heightIs(1);
    
    self.subClsssEnter = [[UITextField alloc] init];
    self.subClsssEnter.delegate = self;
    [self.subClsssEnter setPlaceholder:@"请输入子分类名称"];
    [self.subClsssEnter setFont:Font(13)];
    [self.classSelect addSubview:self.subClsssEnter];
    self.subClsssEnter.sd_layout
    .leftSpaceToView(self.classSelect,10)
    .rightSpaceToView(self.classSelect,10)
    .topSpaceToView(self.line6,5)
    .heightIs(40);
    
    self.line7 = [[UIView alloc] init];
    [self.line7 setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.classSelect addSubview:self.line7];
    self.line7.sd_layout
    .leftEqualToView(self.classSelect)
    .rightEqualToView(self.classSelect)
    .topSpaceToView(self.subClsssEnter,5)
    .heightIs(3);

    self.classEnter = [[UIView alloc] init];
    [self.classEnter setBackgroundColor:[UIColor whiteColor]];
    [self.classSelect addSubview:self.classEnter];
    self.classEnter.sd_layout
    .leftEqualToView(self.classSelect)
    .rightEqualToView(self.classSelect)
    .bottomSpaceToView(self.classSelect,0)
    .heightIs(50);
    
    self.faherEnter = [[UITextField alloc] init];
    self.faherEnter.delegate = self;
    [self.faherEnter setPlaceholder:@"请输入父分类名称"];
    [self.faherEnter setFont:Font(13)];
    [self.classEnter addSubview:self.faherEnter];
    self.faherEnter.sd_layout
    .leftSpaceToView(self.classEnter,10)
    .topSpaceToView(self.classEnter,5)
    .bottomSpaceToView(self.classEnter,5)
    .widthIs((WindowWidth-20)/2);
    
    UIView * line10 = [[UIView alloc] init];
    [line10 setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.classEnter addSubview:line10];
    line10.sd_layout
    .leftSpaceToView(self.faherEnter,5)
    .topSpaceToView(self.classEnter,5)
    .bottomSpaceToView(self.classEnter,5)
    .widthIs(2);
    
    self.subEnter = [[UITextField alloc] init];
    [self.subEnter setFont:Font(13)];
    self.subEnter.delegate = self;
    [self.subEnter setPlaceholder:@"请输入子分类名称"];
    [self.classEnter addSubview:self.subEnter];
    self.subEnter.sd_layout
    .leftSpaceToView(line10,10)
    .topSpaceToView(self.classEnter,5)
    .bottomSpaceToView(self.classEnter,5)
    .rightSpaceToView(self.classEnter,10);
    
    UIView * line8 = [[UIView alloc] init];
    [line8 setBackgroundColor:ColorHex(0XEEEEEE)];
    [self.classSelect addSubview:line8];
    line8.sd_layout
    .leftEqualToView(self.classSelect)
    .rightEqualToView(self.classSelect)
    .topSpaceToView(self.classEnter,0)
    .heightIs(1);
    
    
    self.recommend = [[UIView alloc] init];
    [self.recommend setBackgroundColor:[UIColor whiteColor]];
    [self.content addSubview:self.recommend];
    self.recommend.sd_layout
    .leftEqualToView(self.content)
    .rightEqualToView(self.content)
    .topSpaceToView(self.classSelect,2)
    .heightIs(50);
    
    self.recommendText = [[UILabel alloc] init];
    [self.recommendText setText:@"设为推荐"];
    [self.recommendText setFont:Font(13)];
    [self.recommend addSubview:self.recommendText];
    self.recommendText.sd_layout
    .leftSpaceToView(self.recommend,10)
    .rightSpaceToView(self.recommend,60)
    .topEqualToView(self.recommend)
    .bottomEqualToView(self.recommend);
    
    self.recommendSwh = [[UISwitch alloc] init];
    [self.recommend addSubview:self.recommendSwh];
    self.recommendSwh.sd_layout
    .rightSpaceToView(self.recommend,10)
    .topSpaceToView(self.recommend,8);
    
    self.publish = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.publish setTitle:@"清空信息" forState:UIControlStateNormal];
    [self.publish setBackgroundColor:ThemeColor];
    self.publish.cornerRadius = 5;
    [self.publish addTarget:self action:@selector(clearSelecteds) forControlEvents:UIControlEventTouchUpInside];
    [self.publish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.content addSubview:self.publish];
    
    self.publish.sd_layout
    .leftSpaceToView(self.content,80)
    .rightSpaceToView(self.content,80)
    .topSpaceToView(self.recommend,20)
    .heightIs(40);
    
    [self.publish updateLayout];
    [self.content setContentSize:CGSizeMake(0, WindowHeight)];
    
    self.classAlert = [[PulishClassSelectAlert alloc] init];
    self.classAlert.delegate = self;
    [self.view addSubview:self.classAlert];
    self.classAlert.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view)
    .rightEqualToView(self.view);
    [self.classAlert setHidden:YES];
    
    if(self.is_copy){
        [self.pageTitle setText:@"复制到我的相册"];
        [self.clear setTitle:@"复制" forState:UIControlStateNormal];
        //[self.publish setHidden:YES];
        [self.photoTitle setText:self.photoTitleText];
        [self.photoTitlePlaceholder setHidden:YES];
        for(DynamicImagesModel * model in self.imageCopy){
            [self.selectArray addObject:model];
        }
    }
}


- (void)createImage{
    
    for(UIView * image in self.imageView.subviews){
        [image removeFromSuperview];
    }

    NSInteger index = 0;
    for(id obj in self.selectArray){
        if(index >=9)return;
        CGFloat x = index%3;
        CGFloat y = index/3;
        CGFloat width = (WindowWidth-40)/3;
        UIImageView * imageIcon = [[UIImageView alloc] init];
        [imageIcon setBackgroundColor:ColorHex(0XEEEEEE)];
        [imageIcon setContentMode:UIViewContentModeScaleAspectFit];
        [imageIcon addTarget:self action:@selector(addPublishImage:)];
        imageIcon.tag = index;
        [self.imageView addSubview:imageIcon];
        imageIcon.sd_layout
        .leftSpaceToView(self.imageView,x*width)
        .topSpaceToView(self.imageView,y*width)
        .widthIs(width-10)
        .heightIs(width-10);
        
        if([obj isKindOfClass:[UIImage class]]){
            UIImage * image = obj;
            [imageIcon setImage:image];;
        }else{
            DynamicImagesModel * model  = obj;
            [imageIcon sd_setImageWithURL:[NSURL URLWithString:model.big]];
        }
        index++;
    }
    
    
    if(index < 9){
        CGFloat x = (index)%3;
        CGFloat y = (index)/3;
        CGFloat width = (WindowWidth-40)/3;
        PostImage * image = [[PostImage alloc] init];
        [image setBackgroundColor:ColorHex(0XEEEEEE)];
        [image setImage:[UIImage imageNamed:@"addgray"]];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [image addTarget:self action:@selector(addPublishImage:)];
        image.tag = index;
        [self.imageView addSubview:image];
        image.sd_layout
        .leftSpaceToView(self.imageView,x*width)
        .topSpaceToView(self.imageView,y*width)
        .widthIs(width-10)
        .heightIs(width-10);
    }
    
    NSInteger  count = self.imageView.subviews.count;
    CGFloat x = count%3;
    CGFloat y = count/3;
    CGFloat width = (WindowWidth-40)/3;
    if(x>1)x=1;
    self.imageView.sd_layout.heightIs(y*width+x*width);
    [self.imageView updateLayout];
    CGFloat offset = self.publish.top+self.publish.height + 50;
    if(offset<WindowHeight)offset = WindowHeight+10;
    [self.content setContentSize:CGSizeMake(0, offset)];
    [self.content updateLayout];
    
}

- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    
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

- (void)addPublishImage:(UITapGestureRecognizer *)tap{
    
    UIImageView * imageViews = (UIImageView *)tap.view;
    if([UIImagePNGRepresentation(imageViews.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"addgray"])]){
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            SPAlert(@"请允许相册访问",self);
            return;
        }
        
        NSInteger count = 9 - self.selectArray.count;
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.photoWidth = 960;
        imagePickerVc.photoPreviewMaxWidth = 960;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto){
            if(assets && assets.count >0){
                [self.selectArray addObjectsFromArray:photos];
            }
            [self createImage];
            
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else{
        PhotosVisitCtr * visit = GETALONESTORYBOARDPAGE(@"PhotosVisitCtr");
        visit.dataArray = self.selectArray;
        visit.startIndex = tap.view.tag;
        [self.navigationController pushViewController:visit animated:YES];
        
    }
}

- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clearSelecteds{
    
    [self clearSelected:YES];
}

- (void)clearSelected:(BOOL)cleare{

    
    [self.selectArray removeAllObjects];
    [self createImage];
    
    if(cleare){
        [self.photoTitle setText:@""];
        [self.photoTitlePlaceholder setHidden:NO];
        [self.remarks setText:@""];
        [self.price setText:@""];
        [self.fatherClassText setText:@"新建父分类"];
        self.fatherClassSelectIndex = 0;
        [self ftherClassSelected:0];
        [self.subClassText setText:@"新建子分类"];
        self.subClassSelectIndex = 0;
        [self.subClsssEnter setText:@""];
        [self.subEnter setText:@""];
        [self.faherEnter setText:@""];
        [self.recommendSwh setOn:NO animated:YES];
    }
    
    
}
- (void)photoTitleClearSelected{
    [self.photoTitle setText:@""];
    [self.photoTitlePlaceholder setHidden:NO];
}

- (void)fatherClassSelected{
    if(self.dataArray.count == 0) return;
    [self.classAlert showFtherAlert:self.dataArray];
}

- (void)subClassSelected{
    if(self.dataArray.count > self.fatherClassSelectIndex){
         AlbumClassTableModel * model = [self.dataArray objectAtIndex:self.fatherClassSelectIndex];
        if(model && model.dataArray.count > 0){
            AlbumClassTableSubModel * subModel = [model.dataArray objectAtIndex:0];
            if(!subModel.severData){
                AlbumClassTableSubModel * m = [[AlbumClassTableSubModel alloc] init];
                m.name = @"创建子分类";
                m.severData = YES;
                [model.dataArray insertObject:m atIndex:0];
            }
            [self.classAlert showSubAlert:model.dataArray];
        }
    }
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (void)publishSlected{
    
    [self.view endEditing:YES];
    
    NSMutableArray * images = [NSMutableArray array];
    
    for(UIImageView * imageViews in self.imageView.subviews){
        if(![imageViews isKindOfClass:[PostImage class]]){
            if(imageViews.image){
                [images addObject:imageViews.image];
            }
            
        }
    }
    // 上传发布相册
    if(images.count == 0){
        SPAlert(@"请选择图片",self);
        return;
    }
    
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
    
    NSMutableString * msg = [NSMutableString string];
    
    if(self.photoTitle.text.length == 0){
        [msg appendString:@" 描述 "];
    }
    if(self.price.text.length == 0 || ![self isPureInt:self.price.text]){
        [self.price setText:@""];
        [msg appendString:@" 价格 "];
    }
    if(self.remarks.text.length == 0){
        [msg appendString:@" 备注 "];
    }
    if(msg.length > 0){
        
        NSString * str = [NSString stringWithFormat:@"您还有'%@'未填写 是否继续上传",msg];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self postImage:images];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self postImage:images];
    }
}

- (void)postImage:(NSArray *)images{
    // 保存当前信息
    NSMutableDictionary * postData = [[NSMutableDictionary alloc] init];
    
    NSString * classify_id = @"";
    NSString * subclassification_id = @"";
    
    if(self.fatherClassSelectIndex != 0){
        AlbumClassTableModel * model = [self.dataArray objectAtIndex:self.fatherClassSelectIndex];
        classify_id = [NSString stringWithFormat:@"%ld",model.classID];
    }
    if(self.subClassSelectIndex != 0){
        AlbumClassTableModel * model = [self.dataArray objectAtIndex:self.fatherClassSelectIndex];
        AlbumClassTableSubModel * subModel = [model.dataArray objectAtIndex:self.subClassSelectIndex];
        subclassification_id = [NSString stringWithFormat:@"%ld",(long)subModel.subClassID];
    }
    NSString * recommendText = self.recommendSwh.on?@"true":@"false";
    [postData setValue:recommendText forKey:recommendSwhKey];
    [postData setValue:self.subEnter.text forKey:subEnterTextKey];
    [postData setValue:self.faherEnter.text forKey:faherEnterTextKey];
    [postData setValue:classify_id forKey:classify_idKey];
    [postData setValue:subclassification_id forKey:subclassification_idKey];
    [postData setValue:self.price.text forKey:priceKey];
    [postData setValue:self.photoTitle.text forKey:publishNameKey];
    [postData setValue:self.remarks.text forKey:descriptionKey];

    
    [self clearSelected:NO];
    [self showToast:@"正在上传,请保存网络通畅"];
    [self.content setContentOffset:CGPointMake(0, 0) animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray * imageDatas = [NSMutableArray array];
        for(UIImage * image in images){
            NSData *imageData =  [self compressOriginalImage:image toMaxDataSizeKBytes:300];
            [imageDatas addObject:imageData];
            NSLog(@"size == %ld",imageData.length);
        }
        
        
        [postData setValue:imageDatas forKey:imagesKey];
        
        // 耗时的操作
        PublishTask * task = [[PublishTask alloc] init];
        [task startTask:postData complete:^(BOOL stuta){
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                if(stuta){
                    [self showToast:@"上传成功"];
                }else{
                    [self showToast:@"上传失败，请检查网络是否通畅，或者重新尝试"];
                }
            });
        }];
    });
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.tempTextField = textField;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if(textView.text.length > 0){
        [self.photoTitlePlaceholder setHidden:YES];
    }else{
        [self.photoTitlePlaceholder setHidden:NO];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == self.price){
        
        if([self isPureInt:string]){
            
            return YES;
        }else{
            [self showToast:@"您输入价格不正确"];
            return NO;
        }
    }
    
    
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    NSLog(@"scrollViewWillBeginDragging");
}

#pragma mark - PulishClassSelectAlertDelegate
- (void)ftherClassSelected:(NSInteger)indexPath{
    self.fatherClassSelectIndex = indexPath;
    AlbumClassTableModel * model = [self.dataArray objectAtIndex:indexPath];
    [self.fatherClassText setText:model.name];
    if(indexPath == 0){
        [self.subClass setHidden:YES];
        [self.subClsssEnter setHidden:YES];
        [self.classEnter setHidden:NO];
        self.classSelect.sd_layout.heightIs(104);
        [self.classSelect updateLayout];
    }else{
        [self.subClass setHidden:NO];
        [self.subClsssEnter setHidden:NO];
        [self.classEnter setHidden:YES];
        self.classSelect.sd_layout.heightIs(155);
        [self.classSelect updateLayout];
        self.subClassSelectIndex = 0;
        [self.subClassText setText:@"新建子分类"];
    
    }
    
    [self.content setContentSize:CGSizeMake(0, self.publish.top+self.publish.height + 100)];
    [self.content updateLayout];
}

- (void)subClassSelected:(NSInteger)indexPath{
    self.subClassSelectIndex = indexPath;
    AlbumClassTableModel * model = [self.dataArray objectAtIndex:self.fatherClassSelectIndex];
    AlbumClassTableSubModel * subModel = [model.dataArray objectAtIndex:indexPath];
    [self.subClassText setText:subModel.name];
    if(indexPath == 0){
        
        //[self.subEnter setHidden:NO];
        self.classSelect.sd_layout.heightIs(155);
        [self.classSelect updateLayout];
    }else{
        //[self.subEnter setHidden:YES];
        self.classSelect.sd_layout.heightIs(101);
        [self.classSelect updateLayout];
    }
}



#pragma makr - AFNetworking网络加载
- (void)loadNetworkData:(NSDictionary *)data{
    
    [self showLoad];
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.getPhotoClassifies parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        AlbumClassModel * model = [[AlbumClassModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef.dataArray removeAllObjects];
            if(model.dataArray.count == 0)return ;
            AlbumClassTableModel * fisetModel = [[AlbumClassTableModel alloc] init];
            fisetModel.name = @"上传到新建分类";
            [weakSelef.dataArray addObject:fisetModel];
            [weakSelef.dataArray addObjectsFromArray:model.dataArray];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}




- (void)addHandleImageName:(NSDictionary *)data{
    
    //[self showLoad];
    CongfingURL * congfing = [self getValueWithKey:ShopPhotosApi];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:congfing.handleImagesName parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        AddHandleImageNameRequset * requset = [[AddHandleImageNameRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            
//            NSDictionary * postDat = @{@"token":requset.uploadToken, @"key":requset.images};
            //[self postImageToQiniu:postDat];
            
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}






@end
