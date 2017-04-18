//
//  MypointViewController.m
//  ShopPhotos
//
//  Created by Macbook on 08/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "MypointViewController.h"
#import "ChargeViewController.h"

@interface MypointViewController ()

@end

@implementation MypointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)gotoExplain:(id)sender {
    ChargeViewController *vc=[[ChargeViewController alloc] initWithNibName:@"ChargeViewController" bundle:nil];
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
