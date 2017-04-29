//
//  AddUserViewController.m
//  ShopPhotos
//
//  Created by Macbook on 24/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "AddUserViewController.h"
#import "QRCodeScanCtr.h"
#import "SearchUserViewController.h"

@interface AddUserViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewUid;
@property (weak, nonatomic) IBOutlet UIView *viewQrCode;
@property (weak, nonatomic) IBOutlet UIView *back;

@end

@implementation AddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}
- (void)setup{
    [self.back addTarget:self action:@selector(backSelected)];
    [self.viewQrCode addTarget:self action:@selector(qrSelected)];
    [self.viewUid addTarget:self action:@selector(searchSelected)];

}
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)qrSelected{
    QRCodeScanCtr * qrCode = [[QRCodeScanCtr alloc] init];
    [self.navigationController pushViewController:qrCode animated:YES];
    
}
- (void)searchSelected{
    SearchUserViewController *vc=[[SearchUserViewController alloc] initWithNibName:@"SearchUserViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
