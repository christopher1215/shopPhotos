//
//  ShareCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/22.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "ShareCtr.h"

@interface ShareCtr ()
@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UIImageView *close;
@property (weak, nonatomic) IBOutlet UIView *wixin;
@property (weak, nonatomic) IBOutlet UIView *qq;
@property (weak, nonatomic) IBOutlet UIView *pyq;
@property (weak, nonatomic) IBOutlet UIView *photoCopy;
@property (weak, nonatomic) IBOutlet UIView *linkCopy;
@property (weak, nonatomic) IBOutlet UIView *titleCopy;
@property (weak, nonatomic) IBOutlet UIView *lookQR;
@property (weak, nonatomic) IBOutlet UIView *favarite;
@property (weak, nonatomic) IBOutlet UIView *download;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertOffset;

@end

@implementation ShareCtr

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setup];
    
}

- (void)setup{
    
    [self.close addTarget:self action:@selector(closeAlert)];
    [self.view addTarget:self action:@selector(closeAlert)];
    
    [self.wixin addTarget:self action:@selector(weixinSelected)];
    [self.qq addTarget:self action:@selector(qqSelected)];
    [self.pyq addTarget:self action:@selector(pyqSelected)];
    [self.photoCopy addTarget:self action:@selector(photoCopySelcted)];
    [self.linkCopy addTarget:self action:@selector(linkCopySlected)];
    [self.titleCopy addTarget:self action:@selector(titleCopySelected)];
    [self.lookQR addTarget:self action:@selector(lookQRSelected)];
    [self.favarite addTarget:self action:@selector(favariteSelected)];
    [self.download addTarget:self action:@selector(downloadSelected)];
    
    
    
}

- (void)weixinSelected{
    [self useDelegate:1];
}

- (void)pyqSelected{
    [self useDelegate:2];
}


- (void)qqSelected{
    [self useDelegate:3];
}


- (void)photoCopySelcted{
    [self useDelegate:4];
}

- (void)linkCopySlected{
    [self useDelegate:5];
}

- (void)titleCopySelected{
    [self useDelegate:6];
}

- (void)lookQRSelected{
    [self useDelegate:7];
}

- (void)favariteSelected{
    [self useDelegate:8];
}

- (void)downloadSelected{
    [self useDelegate:9];
}

- (void)useDelegate:(NSInteger)type{
    [self closeAlert];
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareSelected:)]){
        [self.delegate shareSelected:type];
    }
}

- (void)showAlert{
    [self.view setHidden:NO];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    [UIView animateWithDuration:0.5 animations:^{
    
        self.alertOffset.constant = 0;
        [self.view layoutIfNeeded];
        [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.45]];
        
    }];
}


- (void)closeAlert{

    
    [UIView animateWithDuration:0.5 animations:^{
    
        [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        self.alertOffset.constant = -360;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished){
        [self.view setHidden:YES];
    }];
    
}


@end
