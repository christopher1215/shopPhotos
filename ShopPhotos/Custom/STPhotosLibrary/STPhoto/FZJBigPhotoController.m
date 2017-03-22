//
//  FZJBigPhotoController.m
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/13.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJBigPhotoController.h"
#import "FZJBigPhotoCell.h"
#import "STPhotosModel.h"
/**
 * 宏定义间距
 */
#define margin 0
/**
 *  屏幕宽
 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

/**
 *  屏幕高
 */
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface FZJBigPhotoController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
/**
 *  大图展示以供选择
 */
@property(nonatomic,strong)UICollectionView * bigCollect;
/**
 *  中间的标题
 */
@property(nonatomic,strong)UILabel * titleLable;


@end

@implementation FZJBigPhotoController



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:NO];
    CGFloat offset = self.view.frame.size.width * self.select;
    
    [self.bigCollect setContentOffset:CGPointMake(offset, 0)];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self configBigPhotoControllerUI];
}
#pragma mark --
#pragma mark 初始化UI
-(void)configBigPhotoControllerUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-64);
    
    _bigCollect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width , self.view.frame.size.height - 64) collectionViewLayout:flowLayout];
    [_bigCollect registerNib:[UINib nibWithNibName:@"FZJBigPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"BigPhotoCell"];
     _bigCollect.pagingEnabled = YES;
    _bigCollect.dataSource = self;
    _bigCollect.delegate = self;
    [self.view addSubview:_bigCollect];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"所有照片";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.navigationItem.titleView = title;
    
//    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
//    [back setBackgroundImage:[UIImage imageNamed:@"btn_back_black"] forState:UIControlStateNormal];
//    back.frame = CGRectMake(0, 0, 44, 44);
//    UIImageView * imageback = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 28, 28)];
//    [imageback setContentMode:UIViewContentModeScaleAspectFit];
//    [imageback setImage:[UIImage imageNamed:@"btn_back_black"]];
//    [back addSubview:imageback];
//    [back addTarget:self action:@selector(SuperBackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
}

- (void)SuperBackBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- collectionView 代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fetchResult.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FZJBigPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BigPhotoCell" forIndexPath:indexPath];
    cell.ImageView.image = nil;
    STPhotosModel * model = self.fetchResult[indexPath.row];
    PHAsset * asset = model.asset;
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    option.networkAccessAllowed = YES;
    option.synchronous = YES;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        //解析出来的图片
        cell.ImageView.image = image;
    }];
    
    
    cell.ScrollView.delegate = self;
    [self addGestureTapToScrollView:cell.ScrollView];
    return cell;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return scrollView.subviews[0];
}
#pragma mark ---  scrollView 添加手势
-(void)addGestureTapToScrollView:(UIScrollView *)scrollView{
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapOnScrollView:)];
    doubleTap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTap];
}
/**
 *  放大缩小
 *
 *  @param doubleTap 双击
 */
-(void)doubleTapOnScrollView:(UITapGestureRecognizer *)doubleTap{
    
    UIScrollView * scrollView = (UIScrollView *)doubleTap.view;
    CGFloat scale = 1;
    if (scrollView.zoomScale != 3) {
        scale = 3;
    }else{
        scale = 1;
    }
    [self CGRectForScale:scale WithCenter:[doubleTap locationInView:doubleTap.view] ScrollView:scrollView Completion:^(CGRect Rect) {
        [scrollView zoomToRect:Rect animated:YES];
    }];
}
-(void)CGRectForScale:(CGFloat)scale WithCenter:(CGPoint)center ScrollView:(UIScrollView *)scrollView Completion:(void(^)(CGRect Rect))completion{
    CGRect Rect;
    Rect.size.height = scrollView.frame.size.height / scale;
    Rect.size.width  = scrollView.frame.size.width  / scale;
    Rect.origin.x    = center.x - (Rect.size.width  /2.0);
    Rect.origin.y    = center.y - (Rect.size.height /2.0);
    completion(Rect);
}
#pragma mark--
#pragma mark 通知注册及销毁



@end
