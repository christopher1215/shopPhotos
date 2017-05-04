//
//  SearchAllCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/26.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "SearchAllCtr.h"
#import "AttentionPhotoSearchCtr.h"
#import "AttentionPersonalSearchCtr.h"
#import "PhotosSearchCtr.h"
#import "AttentionPersonalSearchCell.h"
#import "AttentionPhotoSearchCell.h"
#import "AlbumPhotoTableCell.h"
#import "SearchAllRequset.h"
#import "PersonalHomeCtr.h"
#import "PhotoDetailsCtr.h"
#import "PhotosImageSearchCtr.h"
#import <TOCropViewController.h>
#import "PhotosController.h"
#import <TZImagePickerController.h>
#import "ShareCtr.h"
#import <ShareSDK/ShareSDK.h>
#import "PhotoImagesModel.h"
#import "DynamicImagesModel.h"
#import "ShareContentSelectCtr.h"
#import "DownloadImageCtr.h"
#import "HasCollectPhotoRequset.h"
#import "CopyRequset.h"
#import "PublishPhotoCtr.h"
#import "DynamicQRAlert.h"


@interface SearchAllCtr ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,AttentionPhotoSearchCellDelegate,TOCropViewControllerDelegate,PhotosControllerDelegate,TZImagePickerControllerDelegate,ShareDelegate,AlbumPhotoTableCellDelegate>{
    int currentSection;
}
@property (weak, nonatomic) IBOutlet UIView *titleBackground;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIView *selectOption;
@property (weak, nonatomic) IBOutlet UIView *attentionPhoto;
@property (weak, nonatomic) IBOutlet UIView *attentionPersonal;
@property (weak, nonatomic) IBOutlet UIView *photos;
@property (strong, nonatomic) UICollectionView * table;
@property (strong, nonatomic) NSMutableArray * userArray;
@property (strong, nonatomic) NSMutableArray * photoArray;
@property (strong, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) NSMutableArray * selfPhotoArray;
@property (assign, nonatomic) NSInteger itmeSelectedIndex;
@property (strong, nonatomic) ShareCtr * shareView;
@property (strong, nonatomic) DynamicQRAlert * qrAlert;
@end

@implementation SearchAllCtr

- (NSMutableArray *)userArray{
    
    if(!_userArray) _userArray = [NSMutableArray array];
    return _userArray;
}
- (NSMutableArray *)photoArray{
    
    if(!_photoArray) _photoArray = [NSMutableArray array];
    return _photoArray;
}
- (NSMutableArray *)selfPhotoArray{
    
    if(!_selfPhotoArray) _selfPhotoArray = [NSMutableArray array];
    return _selfPhotoArray;
}
- (NSMutableArray *)imageArray{
    if(!_imageArray) _imageArray = [NSMutableArray array];
    return _imageArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    
}

- (void)setup{
    
    if(!self.uid)self.uid = self.photosUserID;
    self.titleBackground.cornerRadius = 5;
    [self.back addTarget:self action:@selector(backSelected)];
    self.searchText.delegate = self;
    [self.search addTarget:self action:@selector(searchSelected) forControlEvents:UIControlEventTouchUpInside];
    self.search.layer.cornerRadius = 3;
    [self.image addTarget:self action:@selector(imageSelected)];
    [self.attentionPhoto addTarget:self action:@selector(attentionPhotoSelected)];
    [self.attentionPersonal addTarget:self action:@selector(attentionPersonalSelected)];
    [self.photos addTarget:self action:@selector(photosSelected)];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake(WindowWidth, 50.0f);  //设置head大小
    layout.footerReferenceSize = CGSizeMake(WindowWidth, 50.0f);
    self.table = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.table.delegate=self;
    self.table.dataSource=self;
    [self.table setBackgroundColor:ColorHex(0Xffffff)];
    [self.table registerClass:[AttentionPhotoSearchCell class] forCellWithReuseIdentifier:AttentionPhotoSearchCellID];
    [self.table registerClass:[AttentionPersonalSearchCell class] forCellWithReuseIdentifier:AttentionPersonalSearchCellID];
    [self.table registerClass:[AlbumPhotoTableCell class] forCellWithReuseIdentifier:@"AlbumPhotoTableCellID"];
    [self.table registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchAllHeaderView"];
    [self.table registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SearchAllFooterView"];
    [self.view addSubview:self.table];
    
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .bottomEqualToView(self.view);
    self.table.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.table setHidden:YES];
    
    self.shareView = GETALONESTORYBOARDPAGE(@"ShareCtr");
    self.shareView.delegate = self;
    [self.view addSubview:self.shareView.view];
    [self.shareView.view setHidden:YES];
    [self.shareView closeAlert];

}

#pragma mark - 获取相册内所有照片资源
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending
{
    NSMutableArray *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    [result enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        STPhotosModel * model = [[STPhotosModel alloc] init];
        PHAsset *asset = (PHAsset *)obj;
        // printf("%s",[asset valueForKey:@"filename"]);
        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
        model.asset = asset;
        [assets addObject:model];
    }];
    
    NSMutableArray * images = [NSMutableArray array];
    for(NSInteger index =assets.count-1; index >= 0 ; index--){
        [images addObject:assets[index]];
    }
    
    return images;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchText) {
        [self searchSelected];
        return NO;
    }
    return YES;
}
#pragma mark - OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchSelected{
    NSLog(@"搜索");
    [self loadSearchData];
    [self.selectOption setHidden:YES];
    [self.searchText resignFirstResponder];
}

- (void)imageSelected{
    NSLog(@"相册");
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        SPAlert(@"请允许相册访问",self);
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.showSelectBtn = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto){
        
        if(assets.count > 0){
            PHAsset * asset = [assets objectAtIndex:0];
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
            option.synchronous = YES;
            option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
            option.networkAccessAllowed = YES;
            [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
                if(image){
                    
                    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:image];
                    cropViewController.delegate = self;
                    [self presentViewController:cropViewController animated:YES completion:nil];
                }else{
                    [self showToast:@"无法识别图片"];
                }
            }];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (void)attentionPhotoSelected{
    NSLog(@"关注的相册");
    AttentionPhotoSearchCtr * photo = GETALONESTORYBOARDPAGE(@"AttentionPhotoSearchCtr");
    photo.uid = self.uid;
    [self.navigationController pushViewController:photo animated:YES];
    
}

- (void)attentionPersonalSelected{
    NSLog(@"我关注的人");
    AttentionPersonalSearchCtr * photo = GETALONESTORYBOARDPAGE(@"AttentionPersonalSearchCtr");
    photo.uid = self.uid;
    [self.navigationController pushViewController:photo animated:YES];
}

- (void)photosSelected{
    NSLog(@"自己的相册");
    PhotosSearchCtr * photo = GETALONESTORYBOARDPAGE(@"PhotosSearchCtr");
    photo.uid = self.uid;
    [self.navigationController pushViewController:photo animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setEditing:YES];
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    if(image){
        [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        PhotosImageSearchCtr * phost = GETALONESTORYBOARDPAGE(@"PhotosImageSearchCtr");
        phost.uid = self.uid;
        phost.searchImage = image;
        [self.navigationController pushViewController:phost animated:YES];
    }
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController{
    
}



#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.searchText){
        
        if(textField.text.length == 1 &&
           string.length == 0){
            NSLog(@"没有文字了");
            [self.selectOption setHidden:NO];
            [self.table setHidden:YES];
        }
    }
    
    return YES;
}


#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(section == 0){
        return self.userArray.count;
    }else if(section == 1){
        return self.photoArray.count;
    }else{
        return self.selfPhotoArray.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
    
        static NSString * CellIdentifier = AttentionPersonalSearchCellID;
        AttentionPersonalSearchCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.model = [self.userArray objectAtIndex:indexPath.row];
        if (indexPath.row == _userArray.count - 1) {
            [cell.line setHidden:YES];
        }
        return cell;
        
    }else if(indexPath.section == 1){
        static NSString * CellIdentifier = AttentionPhotoSearchCellID;
        AttentionPhotoSearchCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.model = [self.photoArray objectAtIndex:indexPath.row];
        if(!cell.delegate)cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }else{
        static NSString * CellIdentifier = AlbumPhotoTableCellID;
        
        AlbumPhotoTableCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.showPrice = YES;
        cell.model = [self.selfPhotoArray objectAtIndex:indexPath.row];
        if(!cell.delegate)cell.delegate = self;
        return cell;
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return CGSizeMake(WindowWidth, 60);    
    }else if(indexPath.section == 1){
        return CGSizeMake((WindowWidth - 15)/2, 70 + (WindowWidth - 15)/2);
    }else{
        return CGSizeMake((WindowWidth - 15)/2, 70 + (WindowWidth - 15)/2);
    }
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if(section == 0){
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else if(section == 1){
        return UIEdgeInsetsMake (5, 0, 5, 0);
    }else{
        return UIEdgeInsetsMake(5, 0, 5, 0);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 5;
}
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchAllHeaderView" forIndexPath:indexPath];
        for(UIView * view in headerView.subviews){
            [view removeFromSuperview];
        }
        UILabel * label = [[UILabel alloc] init];
        [label setTextColor:[UIColor darkGrayColor]];
        [label setFont:[UIFont systemFontOfSize:13]];
        if(indexPath.section == 0){
            [label setText:@"我关注的人"];
        }else if(indexPath.section == 1){
            [label setText:@"我关注的相册"];
        }else{
            [label setText:@"自己的相册"];
        }
        label.tag = indexPath.section;
        [headerView addSubview:label];
        label.sd_layout
        .leftSpaceToView(headerView,16)
        .topEqualToView(headerView)
        .rightSpaceToView(headerView,16)
        .bottomEqualToView(headerView);
        
        UIView * line = [[UIView alloc] init];
        [line setBackgroundColor:ColorHex(0XEEEEEE)];
        [headerView addSubview:line];
        line.sd_layout
        .leftSpaceToView(headerView,0)
        .rightSpaceToView(headerView,0)
        .bottomEqualToView(headerView)
        .heightIs(1);
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SearchAllFooterView" forIndexPath:indexPath];
        for(UIView * view in footerview.subviews){
            [view removeFromSuperview];
        }
        
        UILabel * label = [[UILabel alloc] init];
        [label setText:@"查看全部"];
        [label setFont:Font(13)];
        [label setTextColor:[UIColor darkGrayColor]];
        [label setTextAlignment:NSTextAlignmentCenter];

        
        label.tag = indexPath.section;
        [label addTarget:self action:@selector(footerSelected:)];
        [footerview addSubview:label];
        reusableview = footerview;
        label.sd_layout
        .leftSpaceToView(footerview,10)
        .topEqualToView(footerview)
        .rightSpaceToView(footerview,10)
        .heightIs(50);
        
        
        
        UIView * line = [[UIView alloc] init];
        [line setBackgroundColor:ColorHex(0XEEEEEE)];
        [footerview addSubview:line];
        line.sd_layout
        .leftSpaceToView(footerview,0)
        .rightSpaceToView(footerview,0)
        .topEqualToView(footerview)
        .heightIs(1);
        
        UIView * line2 = [[UIView alloc] init];
        [line2 setBackgroundColor:ColorHex(0XEEEEEE)];
        [footerview addSubview:line2];
        line2.sd_layout
        .leftEqualToView(footerview)
        .rightEqualToView(footerview)
        .bottomEqualToView(footerview)
        .heightIs(10);
        
        if(indexPath.section == 0 && self.userArray.count == 0){
            [label setText:@"没有搜索到结果"];
            [label setTextColor:[UIColor blackColor]];
            [label setUserInteractionEnabled:NO];
        }else if(indexPath.section == 1 && self.photoArray.count == 0){
            [label setText:@"没有搜索到结果"];
            [label setTextColor:[UIColor blackColor]];
            [label setUserInteractionEnabled:NO];
        }else if(indexPath.section == 2 && self.selfPhotoArray.count == 0){
            [label setText:@"没有搜索到结果"];
            [label setTextColor:[UIColor blackColor]];
            [label setUserInteractionEnabled:NO];
        }
        
    }
    
    reusableview.backgroundColor = [UIColor whiteColor];
    return reusableview;
}


-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    CGSize size = CGSizeMake(WindowWidth, 50);
    return size;
//    if(section == 0){
//        if(self.userArray.count == 0){
//            size.height = 0;
//        }else{
//            size.height = 50;
//        }
//    }else if(section == 1){
//        if(self.photoArray.count == 0){
//            size.height = 0;
//        }else{
//            size.height = 50;
//        }
//    }else{
//        if(self.selfPhotoArray.count == 0){
//            size.height = 0;
//        }else{
//            size.height = 50;
//        }
//    }
//    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size = CGSizeMake(WindowWidth, 60);
    return size;
//    if(section == 0){
//        if(self.userArray.count == 0){
//            size.height = 0;
//        }else{
//            
//        }
//    }else if(section == 1){
//        if(self.photoArray.count == 0){
//            size.height = 0;
//        }else{
//            size.height = 70;
//        }
//    }else{
//        if(self.selfPhotoArray.count == 0){
//            size.height = 0;
//        }else{
//            size.height = 70;
//        }
//    }
//    return 70;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
        AttentionPersonalSearchModel * model = [self.userArray objectAtIndex:indexPath.row];
        PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
        personalHome.uid = model.uid;
        personalHome.twoWay = YES;
        [self.navigationController pushViewController:personalHome animated:YES];
        
    }else if(indexPath.section == 1){
        AlbumPhotosModel * model = [self.photoArray objectAtIndex:indexPath.row];
        PhotoDetailsCtr * details = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
        details.photoId = model.Id;
        [self.navigationController pushViewController:details animated:YES];
    }else{
        AlbumPhotosModel * model = [self.selfPhotoArray objectAtIndex:indexPath.row];
        PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
        photoDetails.photoId = model.Id;
        [self.navigationController pushViewController:photoDetails animated:YES];
    }
}
-(void)footerSelected:(UITapGestureRecognizer *)tap{
    NSLog(@"foot -- %ld",tap.view.tag);
    if(tap.view.tag == 0){
        AttentionPersonalSearchCtr * photo = GETALONESTORYBOARDPAGE(@"AttentionPersonalSearchCtr");
        photo.searchKey = self.searchText.text;
        photo.uid = self.uid;
        [self.navigationController pushViewController:photo animated:YES];
    }else if(tap.view.tag == 1){
        AttentionPhotoSearchCtr * photo = GETALONESTORYBOARDPAGE(@"AttentionPhotoSearchCtr");
        photo.uid = self.uid;
        photo.searchKey = self.searchText.text;
        [self.navigationController pushViewController:photo animated:YES];
    }else{
        PhotosSearchCtr * photo = GETALONESTORYBOARDPAGE(@"PhotosSearchCtr");
        photo.uid = self.uid;
        photo.searchKey = self.searchText.text;
        [self.navigationController pushViewController:photo animated:YES];
    }
}

- (void)userContenSelected:(NSIndexPath *)indexPath{
    AlbumPhotosModel * model = [self.photoArray objectAtIndex:indexPath.row];
    NSDictionary * user = model.user;
    if(user && user.count > 0){
        NSString * uid = [user objectForKey:@"uid"];
        if(uid){
            PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
            personalHome.uid = uid;
            personalHome.twoWay = YES;
            [self.navigationController pushViewController:personalHome animated:YES];
        }
    }
}
- (void)shareClicked:(NSIndexPath *)indexPath {
    self.itmeSelectedIndex = indexPath.row;
    currentSection = indexPath.section;
    [self getPhotoImages];
    [self.shareView showAlert];
}

- (void)getPhotoImages{
    NSDictionary * model = [currentSection == 1 ? self.photoArray : self.selfPhotoArray objectAtIndex:self.itmeSelectedIndex];
    self.imageArray = [RequestErrorGrab getArrwitKey:@"images" toTarget:model];
}
#pragma mark - ShareDelegate
- (void)shareSelected:(NSInteger)type{
    
    AlbumPhotosModel * model = [currentSection == 1 ? self.photoArray : self.selfPhotoArray objectAtIndex:self.itmeSelectedIndex];
    NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.uid,model.Id];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:nil
                                        url:nil
                                      title:text
                                       type:SSDKContentTypeAuto];
    
    switch (type) {
        case 1: //微信好友
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
            }];
        }
            break;
        case 2:// 朋友圈
        {
            
            NSMutableArray * images = [NSMutableArray array];
            for(PhotoImagesModel * imageModel in self.imageArray){
                DynamicImagesModel * model = [[DynamicImagesModel alloc] init];
                model.bigImageUrl = imageModel.bigImageUrl;
                model.thumbnailUrl = imageModel.thumbnailUrl;
                [images addObject:model];
            }
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = model.title;
            ShareContentSelectCtr * shareSelect = GETALONESTORYBOARDPAGE(@"ShareContentSelectCtr");
            shareSelect.dataArray = images;
            [self.navigationController pushViewController:shareSelect animated:YES];
        }
            break;
        case 3:// QQ好友
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error){
            }];
        }
            
            break;
        case 4:// 复制相册
        {
            
            NSString * uid = self.uid;
            if(uid && uid.length > 0){
                if([self.photosUserID isEqualToString:uid]){
                    [self showToast:@"不能复制自己的相册"];
                    break;
                }
                
                [self getAllowPurview:@{@"uid":self.uid}];
            }
        }
            break;
        case 5:// 复制链接
        {
            NSString * text = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.uid,model.Id];
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [self showToast:@"复制成功"];
        }
            
            break;
        case 6:// 复制标题
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = model.title;
            [self showToast:@"复制成功"];
        }
            break;
        case 7:// 查看二维码
        {
            self.qrAlert.titleText = model.title;
            self.qrAlert.contentText = [NSString stringWithFormat:@"%@%@/photo/detail/%@",URLHead,self.uid,model.title];
            [self.qrAlert showAlert];
        }
            
            break;
        case 8:// 收藏相册
        {
            NSString * uid = self.uid;
            if(uid && uid.length > 0){
                if([self.photosUserID isEqualToString:uid]){
                    [self showToast:@"不能收藏自己的相册"];
                    break;
                }
            }
            
            [self hasCollectPhoto:@{@"photoId":model.Id}];
        }
            break;
        case 9:// 下载图片
        {
            NSMutableArray * images = [NSMutableArray array];
            for(PhotoImagesModel * imageModel in self.imageArray){
                DynamicImagesModel * model = [[DynamicImagesModel alloc] init];
                model.bigImageUrl = imageModel.bigImageUrl;
                model.thumbnailUrl = imageModel.thumbnailUrl;
                [images addObject:model];
            }
            
            DownloadImageCtr * shareSelect = GETALONESTORYBOARDPAGE(@"DownloadImageCtr");
            shareSelect.dataArray = images;
            [self.navigationController pushViewController:shareSelect animated:YES];
            
        }
            break;
    }
}
- (void)sendCopyRequest:(NSDictionary *)data{
    
    NSLog(@"1--- %@",data);
    
    NSLog(@"2--- %@",self.congfing.sendCopyRequest);
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.sendCopyRequest parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"发送成功，请耐心等待"];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)hasCollectPhoto:(NSDictionary *)data{
    
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.hasCollectPhoto parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        HasCollectPhotoRequset * requset = [[HasCollectPhotoRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            
            if(requset.hasCollect){
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已经收藏该相册，是否取消收藏" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                    
                    [weakSelef cancelCollectPhotos:@{@"photosId":[NSString stringWithFormat:@"%@,",[data objectForKey:@"photoId"]]}];
                }]];
                
                [weakSelef presentViewController:alert animated:YES completion:nil];
            }else{
                [weakSelef collectPhoto:data];
            }
            
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)collectPhoto:(NSDictionary *)data{
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.collssssCopy parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [weakSelef showToast:@"收藏成功"];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)cancelCollectPhotos:(NSDictionary * )data{
    
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.cancelCollectPhotos parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [weakSelef showToast:@"取消收藏成功"];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)getAllowPurview:(NSDictionary *)data{
    
    //[self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:self.congfing.isAllow parametric:data succed:^(id responseObject){
        //[weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        CopyRequset * model = [[CopyRequset alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            
            if(model.allow){
                PublishPhotoCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
                AlbumPhotosModel * albumModel = [currentSection == 1 ? self.photoArray : self.selfPhotoArray objectAtIndex:self.itmeSelectedIndex];
                /*
                 pulish.is_copy = YES;
                 pulish.photoTitleText = albumModel.title;
                 pulish.photoTitleText = @"";
                 pulish.imageCopy = [[NSMutableArray alloc] initWithArray:self.imageArray];*/
                [weakSelef.navigationController pushViewController:pulish animated:YES];
            }else{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"对方设置了限制复制，是否发送请求复制" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                    
                    [weakSelef sendCopyRequest:data];
                    
                }]];
                
                [weakSelef presentViewController:alert animated:YES completion:nil];
            }
            
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        //[weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)loadSearchData{
    
    [self showLoad];
    NSDictionary * data = @{@"keyword":self.searchText.text, @"limit":@"20"};
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.advancedSearch,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        SearchAllRequset * requset = [[SearchAllRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [weakSelef.userArray removeAllObjects];
            [weakSelef.photoArray removeAllObjects];
            [weakSelef.selfPhotoArray removeAllObjects];
            [weakSelef.userArray addObjectsFromArray:requset.users];
            [weakSelef.photoArray addObjectsFromArray:requset.photos];
            [weakSelef.selfPhotoArray addObjectsFromArray:requset.selfPhotos];
        }else{
            [weakSelef showToast:requset.message];
        }
        [weakSelef.table reloadData];
        [weakSelef.table setHidden:NO];
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
    
}
@end
