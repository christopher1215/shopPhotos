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
#import <ShareSDK/ShareSDK.h>
#import "PhotoImagesModel.h"
#import "DynamicImagesModel.h"
#import "ShareContentSelectCtr.h"
#import "DownloadImageCtr.h"
#import "HasCollectPhotoRequset.h"
#import "CopyRequset.h"
#import "PublishPhotoCtr.h"
#import "StaticCollectionViewCell.h"


@interface SearchAllCtr ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,AttentionPhotoSearchCellDelegate,TOCropViewControllerDelegate,PhotosControllerDelegate,TZImagePickerControllerDelegate,AlbumPhotoTableCellDelegate,StaticCollectionViewCellDelegate>{
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
@property (strong, nonatomic) UILabel * tableFooter;
@property (strong, nonatomic) NSMutableArray * userArray;
@property (strong, nonatomic) NSMutableArray * photoArray;
@property (strong, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) NSMutableArray * selfPhotoArray;
@property (assign, nonatomic) NSInteger itmeSelectedIndex;
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
    [self imageArray];
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
    [self.table registerClass:[StaticCollectionViewCell class] forCellWithReuseIdentifier:AlbumPhotoTableCellID];
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
    
    self.tableFooter = [[UILabel alloc] init];
    [self.tableFooter setText:@"没有找到你需要的哦！"];
    [self.tableFooter setFont:Font(15)];
    [self.tableFooter setTextColor:[UIColor darkGrayColor]];
    [self.tableFooter setTextAlignment:NSTextAlignmentCenter];
    [self.tableFooter setHidden:YES];
    [self.table addSubview:self.tableFooter];
    self.tableFooter.sd_layout
    .leftEqualToView(self.table)
    .rightEqualToView(self.table)
    .bottomSpaceToView(self.table, 30)
    .heightIs(40);

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

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text = @"";
    [textField resignFirstResponder];
    [self.selectOption setHidden:NO];
    [self.table setHidden:YES];
    return NO;
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
        
        StaticCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        [cell createAutoLayout:NO cellType:1];
        cell.indexPath = indexPath;
        if(!cell.delegate)cell.delegate = self;
        cell.model = [self.selfPhotoArray objectAtIndex:indexPath.row];
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
        .leftSpaceToView(headerView,10)
        .topEqualToView(headerView)
        .rightSpaceToView(headerView,10)
        .bottomEqualToView(headerView);
        
        UIView * line = [[UIView alloc] init];
        [line setBackgroundColor:ColorHex(0XEEEEEE)];
        [headerView addSubview:line];
        line.sd_layout
        .leftSpaceToView(headerView,10)
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
        [label setTextAlignment:NSTextAlignmentLeft];

        
        label.tag = indexPath.section;
        [label addTarget:self action:@selector(footerSelected:)];
        [footerview addSubview:label];
        reusableview = footerview;
        label.sd_layout
        .leftSpaceToView(footerview,10)
        .topEqualToView(footerview)
        .rightSpaceToView(footerview,10)
        .heightIs(50);
        
        UIView * line2 = [[UIView alloc] init];
        [line2 setBackgroundColor:ColorHex(0XEEEEEE)];
        [footerview addSubview:line2];
        line2.sd_layout
        .leftEqualToView(footerview)
        .rightEqualToView(footerview)
        .bottomEqualToView(footerview)
        .heightIs(10);
        
        if(indexPath.section == 0){
            if (self.userArray.count == 0){
                [label setText:@"没有搜索到我关注的人"];
                [label setTextColor:[UIColor darkGrayColor]];
                [label setUserInteractionEnabled:NO];
            } else {
                UIView * line = [[UIView alloc] init];
                [line setBackgroundColor:ColorHex(0XEEEEEE)];
                [footerview addSubview:line];
                line.sd_layout
                .leftSpaceToView(footerview,10)
                .rightSpaceToView(footerview,0)
                .topEqualToView(footerview)
                .heightIs(1);

            }
        }else if(indexPath.section == 1){
            if(self.photoArray.count == 0){
                [label setText:@"没有搜索到关注的相册"];
                [label setTextColor:[UIColor darkGrayColor]];
                [label setUserInteractionEnabled:NO];
            } else {
                UIView * line = [[UIView alloc] init];
                [line setBackgroundColor:ColorHex(0XEEEEEE)];
                [footerview addSubview:line];
                line.sd_layout
                .leftSpaceToView(footerview,10)
                .rightSpaceToView(footerview,0)
                .topEqualToView(footerview)
                .heightIs(1);
            }
        }else if(indexPath.section == 2){
            if(self.selfPhotoArray.count == 0){
                [label setText:@"没有搜索到自己的相册"];
                [label setTextColor:[UIColor darkGrayColor]];
                [label setUserInteractionEnabled:NO];
            } else {
                UIView * line = [[UIView alloc] init];
                [line setBackgroundColor:ColorHex(0XEEEEEE)];
                [footerview addSubview:line];
                line.sd_layout
                .leftSpaceToView(footerview,10)
                .rightSpaceToView(footerview,0)
                .topEqualToView(footerview)
                .heightIs(1);
            }
        }
        if (self.userArray.count > 0 || self.photoArray.count > 0 || self.selfPhotoArray.count > 0) {
            [self.tableFooter setHidden:YES];
        } else {
            if (indexPath.section == 2) {
                if (self.userArray.count == 0 && self.photoArray.count == 0 && self.selfPhotoArray.count == 0) {
                    [self.tableFooter setHidden:NO];
                } else {
                    [self.tableFooter setHidden:YES];
                }
            }
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
    AlbumPhotosModel * model = [currentSection == 1 ? self.photoArray : self.selfPhotoArray objectAtIndex:self.itmeSelectedIndex];
    [self.appd showShareview:model.type collected:model.collected model:model from:self];
}
- (void)pyqClicked:(NSIndexPath *)indexPath {
    self.itmeSelectedIndex = indexPath.row;
    //    [self showLoad];
    [self getPhotoImages];
    NSMutableArray * images = [NSMutableArray array];
    for(PhotoImagesModel * imageModel in _imageArray){
        DynamicImagesModel * model = [[DynamicImagesModel alloc] init];
        model.bigImageUrl = imageModel.bigImageUrl;
        model.thumbnailUrl = imageModel.thumbnailUrl;
        [images addObject:model];
    }
    AlbumPhotosModel * model = [self.selfPhotoArray objectAtIndex:self.itmeSelectedIndex];
    
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = model.title;
    ShareContentSelectCtr * shareSelect = GETALONESTORYBOARDPAGE(@"ShareContentSelectCtr");
    shareSelect.dataArray = images;
    [self.navigationController pushViewController:shareSelect animated:YES];
}

- (void)getPhotoImages{
    [_imageArray removeAllObjects];
    AlbumPhotosModel * model = [self.selfPhotoArray objectAtIndex:self.itmeSelectedIndex];
    
    for(NSDictionary * image in model.images){
        PhotoImagesModel * model = [[PhotoImagesModel alloc] init];
        model.Id = [NSString stringWithFormat:@"%ld",(long)[RequestErrorGrab getIntegetKey:@"id" toTarget:image]];
        //                model.imageLink_id = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"imageLink_id" toTarget:images]];
        model.thumbnailUrl = [RequestErrorGrab getStringwitKey:@"thumbnailUrl" toTarget:image];
        model.bigImageUrl = [RequestErrorGrab getStringwitKey:@"bigImageUrl" toTarget:image];
        model.srcUrl = [RequestErrorGrab getStringwitKey:@"srcUrl" toTarget:image];
        model.isCover = [RequestErrorGrab getBooLwitKey:@"isCover" toTarget:image];
        if (model.isCover) {
            [_imageArray insertObject:model atIndex:0];
        }else{
            [_imageArray addObject:model];
        }
    }
}

- (void)loadSearchData{
    if ([self.searchText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 0) {
        [self showToast:@"请输入关键字"];
        return;
    }
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
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
    
}
@end
