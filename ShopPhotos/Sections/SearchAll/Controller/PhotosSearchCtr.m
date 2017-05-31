//
//  PhotosSearchCtr.m
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PhotosSearchCtr.h"
#import "AlbumPhotoTableView.h"
#import <MJRefresh.h>
#import "AlbumPhotosRequset.h"
#import "AlbumPhotosModel.h"
#import "PhotoDetailsCtr.h"
#import "PhotosSearchRequset.h"
#import <TOCropViewController.h>
#import "PhotosController.h"
#import <TZImagePickerController.h>
#import "PhotosSearchRequeset.h"
#import "PublishPhotoCtr.h"

#import "PhotoImagesRequset.h"
#import "DynamicImagesModel.h"
#import "ShareContentSelectCtr.h"
#import "DownloadImageCtr.h"
#import "CopyRequset.h"
#import "HasCollectPhotoRequset.h"
#import <ShareSDK/ShareSDK.h>
#import "PhotoImagesModel.h"

@interface PhotosSearchCtr ()<AlbumPhotoTableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate,PhotosControllerDelegate,TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleBackground;

@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (weak, nonatomic) IBOutlet UIImageView *imageSearch;
@property (weak, nonatomic) IBOutlet UIView *viewCaption;

@property (strong, nonatomic) AlbumPhotoTableView * table;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) BOOL searchFlag;
@property (strong, nonatomic) UIImage * searchImage;

@property (assign, nonatomic) NSInteger itmeSelectedIndex;
@property (strong, nonatomic) NSMutableArray * imageArray;
@end

@implementation PhotosSearchCtr

- (NSMutableArray *)dataArray{
    
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
    
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
    [self dataArray];
    [self imageArray];
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
                                @"includeFriends":@"0",
                                //@"excludesUsers":@"",
                                @"page":@"1",
                                @"pageSize":@"30"};
        
        [self loadSearchData:data];
    } else {
        NSDictionary * data = @{@"uid":self.uid,
                                @"includeFriends":@"0",
                                //@"excludesUsers":@"",
                                @"page":@"1",
                                @"pageSize":@"30"};
        
//        [self loadSearchData:data];
    }
    self.table = [[AlbumPhotoTableView alloc] init];
    self.table.delegate = self;
    self.table.isVideo = NO;
    [self.view addSubview:self.table];
    
    self.table.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.viewCaption,0)
    .bottomEqualToView(self.view);

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

- (void)searchSelected{
    [self.searchText resignFirstResponder];
    if(!self.searchText.text ||self.searchText.text.length == 0){
        SPAlert(@"请输入搜索关键字",self);
        return;
    }
    self.pageIndex = 1;

    [self.dataArray removeAllObjects];
    [self.table.photos reloadData];
    self.searchText.text = [self.searchText.text stringByReplacingOccurrencesOfString:@"%" withString:@""];
    NSDictionary * data = @{@"uid":self.uid,
                            @"keyword":self.searchText.text,
                            @"includeFriends":@"0",
                            //@"excludesUsers":@"",
                            @"page":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                            @"pageSize":@"30"};
    [self loadSearchData:data];
    _searchFlag = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setEditing:YES];
}

#pragma mark - Cropper Delegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    if(image){
        [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        self.searchImage = image;
        
        [self.dataArray removeAllObjects];
        [self.table loadData:self.dataArray];
        [self.table.photos reloadData];
        
        [self loadSearchImageData];
    }
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController{
    
}

#pragma mark - AlbumPhotoTableViewDelegate
- (void)albumPhotoSelectPath:(NSInteger)indexPath{
    
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:indexPath];
    PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
    photoDetails.photoId = model.Id;
    [self.navigationController pushViewController:photoDetails animated:YES];
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
        NSLog(@"%@",responseObject);
        [weakSelef closeLoad];
        [weakSelef.table.photos.mj_header endRefreshing];
        
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.pageIndex ++;
            weakSelef.table.photos.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkMoreData];
            }];
            if(requset.dataArray.count < 30){
                [weakSelef.table.photos.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.table.photos.mj_footer setHidden:YES];

//                if(requset.dataArray.count == 0){
//                    [weakSelef.table.photos.mj_footer setHidden:YES];
//                } else {
//                    [weakSelef.table.photos.mj_footer setHidden:NO];
//                    
//                }

            }else{
                [weakSelef.table.photos.mj_footer resetNoMoreData];
            }
            [weakSelef.dataArray removeAllObjects];
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.table loadData:weakSelef.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef.table.photos.mj_header endRefreshing];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)loadNetworkMoreData{
    [self showLoad];
    NSDictionary * data = @{@"uid":self.uid,
                            @"keyword":self.searchText.text,
                            @"includeFriends":@"0",
                            //@"excludesUsers":@"",
                            @"page":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                            @"pageSize":@"30"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.searchPhotos,[self.appd getParameterString]]  parametric:data succed:^(id responseObject){
        NSLog(@"%@",responseObject);
        [weakSelef.table.photos.mj_header endRefreshing];
        [weakSelef closeLoad];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.pageIndex ++;
            if(requset.dataArray.count < 30){
                [weakSelef.table.photos.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.table.photos.mj_footer setHidden:YES];

                if(requset.dataArray.count == 0){
                    [weakSelef showToast:@"未搜索到结果"];
                }
            }else{
                [weakSelef.table.photos.mj_footer resetNoMoreData];
            }
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.table loadData:weakSelef.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef.table.photos.mj_header endRefreshing];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)loadSearchImageData{
    [self showLoad];
    __weak __typeof(self)weakSelf = self;
    NSDictionary * data = @{@"uid":self.uid,
                            @"includeFriends":@"0",
                            //@"excludesUsers[0]":@"12343244",
                            @"resultCount":@"100"};
    NSData * imageData = UIImageJPEGRepresentation(self.searchImage, 0.3);
    [HTTPRequest Manager:self.congfing.useImageSearch Method:nil dic:data file:imageData fileName:@"imageFile" requestSucced:^(id responseObject){
        NSLog(@"%@",responseObject);
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelf.table loadData:requset.dataArray];
            [weakSelf.table.photos reloadData];
            if(requset.dataArray.count == 0){
            [weakSelf showToast:@"未搜索到结果"];
            }
        }
        [weakSelf closeLoad];
    } requestfailure:^(NSError * error){
        [weakSelf closeLoad];
//        [weakSelf showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelf.dataArray removeAllObjects];
        
        [weakSelf.table loadData:weakSelf.dataArray];
        [weakSelf.table.photos reloadData];
    }];
}

- (void)shareClicked:(NSIndexPath *)indexPath {
    self.itmeSelectedIndex = indexPath.row;
    //    [self showLoad];
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
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
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
    
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = model.title;
    ShareContentSelectCtr * shareSelect = GETALONESTORYBOARDPAGE(@"ShareContentSelectCtr");
    shareSelect.dataArray = images;
    [self.navigationController pushViewController:shareSelect animated:YES];
}

- (void)getPhotoImages{
    [_imageArray removeAllObjects];
    AlbumPhotosModel * model = [self.dataArray objectAtIndex:self.itmeSelectedIndex];
    
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

@end
