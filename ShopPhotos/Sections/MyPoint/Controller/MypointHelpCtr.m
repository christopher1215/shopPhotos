//
//  MypointHelpCtr.m
//  ShopPhotos
//
//  Created by Park Jin Hyok on 5/10/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "MypointHelpCtr.h"

@interface MypointHelpCtr ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MypointHelpCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backView addTarget:self action:@selector(goBack)];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"point_help" ofType:@"htm"];
//    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
//    [_webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"point_help" withExtension:@"htm"];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) goBack {
    [self.navigationController popViewControllerAnimated:YES];
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
