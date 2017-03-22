//
//  DownloadImageCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/4.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "DownloadImageCtr.h"
#import "ShareContentSelectCell.h"

@interface DownloadImageCtr ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIButton *cancle;
@property (strong, nonatomic)UICollectionView * photos;
@property (weak, nonatomic) IBOutlet UIButton *sure;
@property (strong, nonatomic) NSMutableArray * imageArray;
@property (assign, nonatomic) NSInteger index;
@end

@implementation DownloadImageCtr

- (void)setDataArray:(NSMutableArray *)dataArray{
    
    if(!_dataArray)_dataArray = [NSMutableArray array];
    [_dataArray addObjectsFromArray:dataArray];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createAutoLayout];
}

- (void)createAutoLayout{
    
    self.imageArray = [NSMutableArray array];
    [self.back addTarget:self action:@selector(backSelected)];
    [self.cancle addTarget:self action:@selector(cancelSelcted)];
    [self.sure addTarget:self action:@selector(sureSelected)];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.photos = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.photos.delegate=self;
    self.photos.dataSource=self;
    [self.photos registerClass:[ShareContentSelectCell class] forCellWithReuseIdentifier:ShareContentSelectCellID];
    [self.photos setBackgroundColor:ColorHex(0Xeeeeee)];
    [self.view addSubview:self.photos];
    
    self.photos.sd_layout
    .leftEqualToView(self.view )
    .rightEqualToView(self.view )
    .topSpaceToView(self.view ,64)
    .bottomSpaceToView(self.view,50);
    
}

- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancelSelcted{
    
    if([self.cancle.currentTitle isEqualToString:@"全选"]){
        
        for(DynamicImagesModel * model in self.dataArray){
            model.select = NO;
        }
        [self.cancle setTitle:@"取消" forState:UIControlStateNormal];
        
    }else if([self.cancle.currentTitle isEqualToString:@"取消"]){
        for(DynamicImagesModel * model in self.dataArray){
            model.select = YES;
        }
        [self.cancle setTitle:@"全选" forState:UIControlStateNormal];
    }
    [self.photos reloadData];
}
- (void)sureSelected{
    [self.sure setUserInteractionEnabled:NO];
    [self.imageArray removeAllObjects];
    for(DynamicImagesModel * model in self.dataArray){
        if(!model.select) [self.imageArray addObject:model.big];
    }
    [self showLoad];
    for(NSString * url in self.imageArray){
        [self downLoadImage:url];
    }
}

-(void)downLoadImage:(NSString *)url{
    
    
    __block UIImage * image = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{//提供了一个知道group什么时候结束的点，也可以用dispatch_group_wait(group,DISPATCH_TIME_FOREVER)代替，异曲同工之效
       // self.ImageView.image = image;
        [self loadImageFinished:image];
    });
}

- (void)loadImageFinished:(UIImage *)image
{
   
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
    
    if(self.index == self.imageArray.count - 1){
        [self closeLoad];
        [self showToast:@"下载完成"];
        [self.sure setUserInteractionEnabled:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.index ++;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self closeLoad];
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}


#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = ShareContentSelectCellID;
    ShareContentSelectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WindowWidth-50)/3, (WindowWidth-50)/3);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DynamicImagesModel * model = [self.dataArray objectAtIndex:indexPath.row];
    model.select = !model.select;
    [self.photos reloadData];
    
    NSInteger selectIndex = 0;
    for(DynamicImagesModel * model in self.dataArray){
        if(model.select) selectIndex ++;
    }
    if(selectIndex == self.dataArray.count){
        [self.cancle setTitle:@"全选" forState:UIControlStateNormal];
    }else if(selectIndex == 0){
        [self.cancle setTitle:@"取消" forState:UIControlStateNormal];
    }
}

@end
