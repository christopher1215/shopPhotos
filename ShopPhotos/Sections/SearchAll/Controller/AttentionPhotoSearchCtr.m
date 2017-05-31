//
//  AttentionPhotoSearchCtr.m
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "AttentionPhotoSearchCtr.h"
#import "AlbumPhotosRequset.h"
#import "AttentionPhotoSearchCell.h"
#import <MJRefresh.h>
#import "PhotoDetailsCtr.h"
#import "PhotosSearchRequset.h"
#import <TOCropViewController.h>
#import "PhotosController.h"
#import <TZImagePickerController.h>
#import "PersonalHomeCtr.h"

@interface AttentionPhotoSearchCtr ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate,PhotosControllerDelegate,TZImagePickerControllerDelegate,AttentionPhotoSearchCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleBackground;
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (weak, nonatomic) IBOutlet UIImageView *imageSearch;
@property (weak, nonatomic) IBOutlet UIView *viewCaption;

@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) UICollectionView * photos;
@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) UIImage * searchImage;
@property (assign, nonatomic) BOOL searchFlag;

@end

@implementation AttentionPhotoSearchCtr

- (NSMutableArray *)dataArray{
    
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    _searchFlag = NO;
    
}

- (void)setup{
    self.titleBackground.cornerRadius = 5;

    [self.back addTarget:self action:@selector(backSelected)];
    [self.search addTarget:self action:@selector(searchSelected)];
    [self.imageSearch addTarget:self action:@selector(imageSearchSelected)];
    self.search.cornerRadius = 3;
    if(self.searchKey && self.searchKey.length > 0){
        [self.searchText setText:self.searchKey];
        self.searchText.text = [self.searchText.text stringByReplacingOccurrencesOfString:@"%" withString:@""];
        
        NSDictionary * data = @{@"uid":self.uid,
                                @"keyword":self.searchText.text,
                                @"includeFriends":@"1",
                                @"excludesUsers[0]":self.uid,
                                @"page":@"1",
                                @"pageSize":@"30"};
        
        [self loadSearchData:data];
    } else {
        NSDictionary * data = @{@"uid":self.uid,
                                
                                @"includeFriends":@"1",
                                @"excludesUsers[0]":self.uid,
                                @"page":@"1",
                                @"pageSize":@"30"};
        
//        [self loadSearchData:data];
    }
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.photos = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.photos.delegate=self;
    self.photos.dataSource=self;
    [self.photos setBackgroundColor:ColorHex(0Xffffff)];
    [self.photos registerClass:[AttentionPhotoSearchCell class] forCellWithReuseIdentifier:AttentionPhotoSearchCellID];
    [self.view addSubview:self.photos];
    
    self.photos.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.viewCaption,0)
    .bottomEqualToView(self.view);
    self.photos.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
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
- (void)shareClicked:(NSIndexPath *)indexPath {
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    [self.appd showShareview:model.type collected:model.collected model:model from:self];
}

- (void)searchSelected{
    [self.searchText resignFirstResponder];
    if(!self.searchText.text ||self.searchText.text.length == 0){
        SPAlert(@"请输入搜索关键字",self);
        return;
    }
    
    [self.dataArray removeAllObjects];
    [self.photos reloadData];
    
    self.searchText.text = [self.searchText.text stringByReplacingOccurrencesOfString:@"%" withString:@""];
    self.pageIndex = 1;

    NSDictionary * data = @{@"uid":self.uid,
                            @"keyword":self.searchText.text,
                            @"includeFriends":@"1",
                            @"excludesUsers[0]":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                            @"pageSize":@"30"};
    
    [self loadSearchData:data];
    _searchFlag = YES;
}

- (void)imageSearchSelected{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        SPAlert(@"请允许相册访问",self);
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.maxImagesCount = 1;
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


#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    if(image){
        [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        self.searchImage = image;
        
        [self.dataArray removeAllObjects];
        [self.photos reloadData];
        
        [self loadSearchImageData];
    }
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController{
    
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.dataArray.count == 0 && _searchFlag)
    {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"没有找到你需要的哦！";
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:18];
        [messageLabel sizeToFit];
        collectionView.backgroundView = messageLabel;
    }
    else
    {
        collectionView.backgroundView = nil;
    }
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = AttentionPhotoSearchCellID;
    AttentionPhotoSearchCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell.delegate)cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WindowWidth-15)/2, 70 + (WindowWidth - 15)/2);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 0, 5, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    PhotoDetailsCtr * details = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
    details.photoId = model.Id;
    [self.navigationController pushViewController:details animated:YES];
}

- (void)userContenSelected:(NSIndexPath *)indexPath{
   AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
    personalHome.uid = [model.user objectForKey:@"uid"];
    personalHome.twoWay =YES;
    [self.navigationController pushViewController:personalHome animated:YES];
}

#pragma makr - AFNetworking网络加载
- (void)loadSearchData:(NSDictionary *)data{
    if (data[@"keyword"]) {
        if ([[data objectForKey:@"keyword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 0) {
            [self showToast:@"请输入关键字"];
            return;
        }
        
    }
    
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.searchPhotos,[self.appd getParameterString]]  parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.pageIndex ++;
            weakSelef.photos.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkMoreData];
            }];
            if(requset.dataArray.count < 30){
                [weakSelef.photos.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.photos.mj_footer setHidden:YES];
//                if(requset.dataArray.count == 0){
//                    [weakSelef.photos.mj_footer setHidden:YES];
//                } else {
//                    [weakSelef.photos.mj_footer setHidden:NO];
//                    
//                }
            }else{
                [weakSelef.photos.mj_footer resetNoMoreData];
            }
            [weakSelef.dataArray removeAllObjects];
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.photos reloadData];
        }
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)loadNetworkMoreData{
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"keyword":self.searchText.text,
                            @"includeFriends":@"1",
                            @"excludesUsers[0]":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                            @"pageSize":@"30"};
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.searchPhotos,[self.appd getParameterString]]  parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.pageIndex ++;
            weakSelef.photos.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkMoreData];
            }];
            if(requset.dataArray.count < 30){
                [weakSelef.photos.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.photos.mj_footer setHidden:YES];
            }else{
                 [weakSelef.photos.mj_footer resetNoMoreData];
            }
            
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.photos reloadData];
        }
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}


- (void)loadSearchImageData{
    
    
    [self showLoad];
    __weak __typeof(self)weakSelf = self;
    NSDictionary * data = @{@"uid":self.uid,
                            @"includeFriends":@"1",
                            @"excludesUsers[0]":self.uid,
                            @"resultCount":@"100"};
    NSData * imageData = UIImageJPEGRepresentation(self.searchImage, 0.3);
    [HTTPRequest Manager:[NSString stringWithFormat:@"%@%@",self.congfing.useImageSearch,[self.appd getParameterString]] Method:nil dic:data file:imageData fileName:@"image" requestSucced:^(id responseObject){
        NSLog(@"%@",responseObject);
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelf.photos reloadData];
            if(requset.dataArray.count == 0){
                [weakSelf showToast:@"未搜索到结果"];
            }
        }
        [weakSelf closeLoad];
    } requestfailure:^(NSError * error){
        [weakSelf closeLoad];
        [weakSelf showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

@end
