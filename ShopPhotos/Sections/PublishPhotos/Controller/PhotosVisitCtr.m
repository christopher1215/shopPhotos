//
//  PhotosVisitCtr.m
//  ShopPhotos
//
//  Created by addcn on 17/1/3.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "PhotosVisitCtr.h"
#import "DynamicImagesModel.h"
#import <UIImageView+WebCache.h>
#import "STPhotosModel.h"

@interface PhotosVisitCtr ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *deleteBtn;
@property (strong, nonatomic) UIScrollView *content;
@property (strong, nonatomic) NSMutableArray * images;
@property (strong, nonatomic) UILabel * countText;
@property (assign, nonatomic) NSInteger visitIndex;


@end

@implementation PhotosVisitCtr

- (NSMutableArray *)images{
    
    if(!_images) _images = [NSMutableArray array];
    return _images;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}


- (void)setup{
    [self.back addTarget:self action:@selector(backSelected)];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnSelected)];
    
    self.content = [[UIScrollView alloc] init];
    self.content.pagingEnabled = YES;
    self.content.delegate = self;
    [self.content setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.content];
    self.content.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    
    self.countText = [[UILabel alloc] init];
    [self.countText setTextColor:[UIColor whiteColor]];
    [self.countText setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    self.countText.cornerRadius = 5;
    [self.countText setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.countText];
    
    self.countText.sd_layout
    .widthIs(50)
    .heightIs(35)
    .bottomSpaceToView(self.view,10)
    .rightSpaceToView(self.view,(WindowWidth-50)/2);
    
    [self setVisiImage:self.dataArray startIndex:self.startIndex];
}

- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteBtnSelected{
    
    if(self.dataArray.count == 1){
        __weak __typeof(self)weakSelef = self;
        NSString * msg = [NSString stringWithFormat:@"确定删除吗"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [weakSelef.dataArray removeObjectAtIndex:self.visitIndex];
            [weakSelef setVisiImage:self.dataArray startIndex:0];
            [weakSelef.navigationController popViewControllerAnimated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self.dataArray removeObjectAtIndex:self.visitIndex];
        [self setVisiImage:self.dataArray startIndex:0];
        self.visitIndex = 0;
    }
    
    
}

- (void)setVisiImage:(NSArray *)imageArray startIndex:(NSInteger)index{
    
    for(UIView * imageView in self.content.subviews){
        [imageView removeFromSuperview];
    }
    
    NSInteger i = 0;
    [self.images removeAllObjects];
    [self.images addObjectsFromArray:imageArray];
    for(id obj in self.images){
    
        UIImageView * imageView = [[UIImageView alloc] init];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.content addSubview:imageView];
        imageView.sd_layout
        .leftSpaceToView(self.content,i*WindowWidth)
        .topEqualToView(self.content)
        .bottomEqualToView(self.content)
        .widthIs(WindowWidth);
        if([obj isKindOfClass:[UIImage class]]){
            
            UIImage * image = obj;
            [imageView setImage:image];
            
        }else{
            DynamicImagesModel * model = obj;
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.big]];
        }
        
        i++;
    }
    [self.content setContentSize:CGSizeMake(WindowWidth*imageArray.count, 0)];
    [self.content setContentOffset:CGPointMake(WindowWidth*index, 0) animated:NO];
    self.visitIndex = index;
    
    [self.view bringSubviewToFront:self.countText];
    [self.countText setText:[NSString stringWithFormat:@"%ld/%ld",index+1,imageArray.count]];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = (NSInteger)scrollView.contentOffset.x;
    if(index == 0 ||
       index == WindowWidth ||
       index == WindowWidth * 2 ||
       index == WindowWidth * 3 ||
       index == WindowWidth * 4 ||
       index == WindowWidth * 5 ||
       index == WindowWidth * 6 ||
       index == WindowWidth * 7 ||
       index == WindowWidth * 8 ||
       index == WindowWidth * 8 ||
       index == WindowWidth * 9 ){
        self.visitIndex = index/WindowWidth;
        NSInteger offset = scrollView.contentOffset.x/WindowWidth;
        [self.countText setText:[NSString stringWithFormat:@"%ld/%ld",offset+1,self.images.count]];
    }
    
    
}


@end
