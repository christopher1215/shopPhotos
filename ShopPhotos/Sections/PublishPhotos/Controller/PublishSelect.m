//
//  PublishSelect.m
//  ShopPhotos
//
//  Created by Park Jin Hyok on 4/17/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "PublishSelect.h"
#import "PublishPhotoCtr.h"

@interface PublishSelect ()

@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *publishPhoto;
@property (weak, nonatomic) IBOutlet UIButton *publishVideo;

@end

@implementation PublishSelect

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setHidden:NO];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.45]];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (IBAction)cancelSelected:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)publishPhotoSelected:(id)sender {

    PublishPhotoCtr * pulish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
    pulish.imageArray = nil;
    [self presentViewController:pulish animated:YES completion:nil];
//    [self dismissViewControllerAnimated:NO completion:Nil];
}

- (IBAction)publishVideoSelected:(id)sender {
}

@end
