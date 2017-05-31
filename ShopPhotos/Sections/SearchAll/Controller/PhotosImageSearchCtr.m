//
//  PhotosImageSearchCtr.m
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PhotosImageSearchCtr.h"
#import "AttentionPhotoSearchCell.h"
#import "AlbumPhotosRequset.h"
#import "PhotoDetailsCtr.h"
#import <AFNetworking.h>
#import "HTTPUserAgent.h"
#import "RequestUtil.h"
#import <MJRefresh.h>
#import "PhotosSearchRequset.h"
#import "PersonalHomeCtr.h"
#import <TOCropViewController.h>
#import <TZImagePickerController.h>
#import <Photos/Photos.h>

@interface PhotosImageSearchCtr ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AttentionPhotoSearchCellDelegate,TOCropViewControllerDelegate,TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *photoBtn;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) UICollectionView * photos;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) BOOL searchFlag;
@end

@implementation PhotosImageSearchCtr

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
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.photoBtn addTarget:self action:@selector(photoBtnSelected)];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.photos = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.photos.delegate=self;
    self.photos.dataSource=self;
    [self.photos setBackgroundColor:ColorHex(0XFFFFFF)];
    [self.photos registerClass:[AttentionPhotoSearchCell class] forCellWithReuseIdentifier:AttentionPhotoSearchCellID];
    [self.view addSubview:self.photos];
    
    self.photos.sd_layout
    .leftSpaceToView(self.view,5)
    .rightSpaceToView(self.view,5)
    .topSpaceToView(self.view,69)
    .bottomSpaceToView(self.view,5);
    
    
    if(self.searchImage){
        [self loadSearchData];
    }

}

- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)photoBtnSelected{
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

        [self loadSearchData];
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
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    if(!cell.delegate)cell.delegate = self;
    cell.indexPath = indexPath;
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
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath.row];
    [self.appd showShareview:model.type collected:model.collected model:model from:self];
}

#pragma makr - AFNetworking网络加载
- (void)loadSearchData{
    
    _searchFlag = YES;
    [self showLoad];
    __weak __typeof(self)weakSelf = self;
    NSDictionary * data = @{@"uid":self.uid,
//                            @"loc":@"0,0,0,0",
                            @"resultCount":@"100",
                            @"includeFriends":@"1"};
    NSData * imageData = UIImageJPEGRepresentation(self.searchImage, 0.3);
    [HTTPRequest Manager:self.congfing.useImageSearch Method:nil dic:data file:imageData fileName:@"image" requestSucced:^(id responseObject){
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
