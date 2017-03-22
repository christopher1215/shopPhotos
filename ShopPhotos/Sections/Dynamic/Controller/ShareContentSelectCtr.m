//
//  ShareContentSelectCtr.m
//  ShopPhotos
//
//  Created by addcn on 17/1/3.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "ShareContentSelectCtr.h"
#import "ShareContentSelectCell.h"
#import "SharedItem.h"

@interface ShareContentSelectCtr ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (strong, nonatomic)UICollectionView * photos;
@property (weak, nonatomic) IBOutlet UIButton *sure;
@property (strong, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation ShareContentSelectCtr

- (void)setDataArray:(NSMutableArray *)dataArray{
    
    if(!_dataArray)_dataArray = [NSMutableArray array];
    [_dataArray addObjectsFromArray:dataArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [NSMutableArray array];
    [self.back addTarget:self action:@selector(backSelected)];
    [self.cancel addTarget:self action:@selector(cancelSelcted)];
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
    
    if([self.cancel.currentTitle isEqualToString:@"全选"]){
    
        for(DynamicImagesModel * model in self.dataArray){
            model.select = NO;
        }
        [self.cancel setTitle:@"取消" forState:UIControlStateNormal];
        
    }else if([self.cancel.currentTitle isEqualToString:@"取消"]){
        for(DynamicImagesModel * model in self.dataArray){
            model.select = YES;
        }
        [self.cancel setTitle:@"全选" forState:UIControlStateNormal];
    }
    [self.photos reloadData];
}

- (void)sureSelected{
    
    
    [self.imageArray removeAllObjects];
    NSMutableArray * datas = [NSMutableArray array];
    for(DynamicImagesModel * model in self.dataArray){
        if(!model.select) [self.imageArray addObject:model.big];
    }
    
    
    
    if(self.imageArray.count == 0){
        ShowAlert(@"请选择图片");
        return;
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.text = NSLocalizedString(@"标题已复制，长按即可粘贴", @"HUD loading title");
    
     __block NSInteger count = 0;
    
    for(NSString * url in self.imageArray){
        NSLog(@"%@",url);
        
        dispatch_queue_t queue =dispatch_queue_create("loadImage",NULL);
        dispatch_async(queue, ^{
            
            NSData *resultData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            count ++;
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(resultData){
                   [datas addObject:resultData];
                }else{
                    NSLog(@"------ >%@",url);
                    //[datas addObject:resultData];
                }
                
                if(count == self.imageArray.count){
                    
                    [self post:datas];
                }
            });
        });
    }
}

- (void)post:(NSArray *)array{
    //[self closeLoad];
    [self.hud hideAnimated:YES];
    NSMutableArray *arrays = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<array.count; i++) {
        UIImage *imagerang = [UIImage imageWithData:array[i]];
        if(imagerang){
            NSString *path_sandox = NSHomeDirectory();
            NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/ShareWX%d.jpg",i]];
            [UIImagePNGRepresentation(imagerang) writeToFile:imagePath atomically:YES];
            
            NSURL *shareobj = [NSURL fileURLWithPath:imagePath];
            
            SharedItem *item = [[SharedItem alloc] initWithData:imagerang andFile:shareobj];
            
            [arrays addObject:item];
        }
       
    }
    

    //SharedItem *item = [[SharedItem alloc] initWithData:nil andFile:[NSURL URLWithString:@"http://h.hiphotos.baidu.com/zhidao/pic/item/3bf33a87e950352a310076d35143fbf2b3118b8c.jpg"]];
    
    //[arrays addObject:item];
    
    
    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:arrays applicationActivities:nil];
    
//    UIPopoverPresentationController *popover = activityViewController.popoverPresentationController;
//    if (popover) {
//        //popover.sourceView = self.activityButton;
//        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
//    }
    
    //尽量不显示其他分享的选项内容
    //activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    
    //activityViewController.excludedActivityTypes =@[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
    //activityViewController.excludedActivityTypes = @[ UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
    
    if (activityViewController) {
        [self presentViewController:activityViewController animated:TRUE completion:nil];
    }else{
        [self showToast:@"抱歉您的系统暂不支持"];
    }
    
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
        [self.cancel setTitle:@"全选" forState:UIControlStateNormal];
    }else if(selectIndex == 0){
        [self.cancel setTitle:@"取消" forState:UIControlStateNormal];
    }
}


@end
