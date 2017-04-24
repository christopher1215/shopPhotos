//
//  GuideViewController.m
//  ShopPhotos
//
//  Created by Macbook on 07/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "GuideViewController.h"
#import "UserModel.h"
#import "LoginCtr.h"
#import "TabBarCtr.h"
#import "SBSliderView.h"
#import "AppDelegate.h"
#import "DDKit.h"
#import "BaseNavigationCtr.h"

@interface GuideViewController ()<SBSliderDelegate>{
    NSMutableArray *guideImgArrs;
    SBSliderView *slider;
//    AppDelegate *appd;
}

@end

@implementation GuideViewController

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    appd = (AppDelegate*)[UIApplication sharedApplication].delegate;
    guideImgArrs = [[NSMutableArray alloc] init];
    
    _btnFinish.cornerRadius = 20;
    _btnFinish.borderColor = RGBACOLOR(141, 166, 228, 1);
    _btnFinish.borderWidth = 1.0;
    slider = [[[NSBundle mainBundle] loadNibNamed:@"SBSliderView" owner:self.view options:nil] firstObject];
    [slider.pageIndicator setHidden:NO];
    slider.delegate = self;
    [self.sliderView addSubview:slider];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    slider.frame = CGRectMake(0, 0, self.sliderView.frame.size.width,self.sliderView.frame.size.height);
    [self getInfo];
    
    if([self getValueWithKey:CacheUserModel]){
        // 已登入
        TabBarCtr * tabbar = [[TabBarCtr alloc] init];
        [self.appd setStartViewController:tabbar];
        
    }else{
        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
        [self.appd setStartViewController:login];
    }
}
- (IBAction)gotoBase:(id)sender {
    if([self getValueWithKey:CacheUserModel]){
        // 已登入
        TabBarCtr * tabbar = [[TabBarCtr alloc] init];
        [self.appd setStartViewController:tabbar];
        
    }else{
        LoginCtr * login = GETALONESTORYBOARDPAGE(@"LoginCtr");
        [self.appd setStartViewController:login];
    }
}
- (void)getInfo
{
    [guideImgArrs removeAllObjects];
//    NSDictionary *data=@{};
//    [self showLoad];
//    __weak __typeof(self)weakSelef = self;
//    [HTTPRequest requestPOSTUrl:self.congfing.resetPassword2 parametric:data succed:^(id responseObject){
//        [weakSelef closeLoad];
//        NSLog(@"%@",responseObject);
//        BaseModel * model = [[BaseModel alloc] init];
//        [model analyticInterface:responseObject];
//        if(model.status == 0){
//            if (latestLoans.count > 0) {
//                for (NSDictionary *latestloan in latestLoans) {
//                    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",IMAGE_URL_GUIDE,[latestloan objectForKey:@"imgUrl"]];
//                    [guideImgArrs addObject:imgUrl];
//                }
//            }
//            UIImage* guideImage = [UIImage imageWithData:
//                                   [NSData dataWithContentsOfURL:
//                                    [NSURL URLWithString:guideImgArrs[0]]]];
//            [UserInfoKit sharedKit].guideImgUrl = guideImgArrs[0];
//            if(guideImage != nil)
//                [splashImgView setImage:guideImage];
//            else
//                [splashImgView setImage:[UIImage imageNamed:@"noImage.png"]];
            guideImgArrs = [NSArray arrayWithObjects:@"guide1.jpg", @"guide2.jpg", @"guide3.jpg", nil];
            [slider createSliderWithImages:guideImgArrs WithAutoScroll:0 inView:self.sliderView];
            
//        }else{
//            [weakSelef showToast:model.message];
//        }
//        
//    } failure:^(NSError * error){
//        [weakSelef showToast:NETWORKTIPS];
//        [weakSelef closeLoad];
//    }];
    
    
}
- (void)sbslider:(SBSliderView *)sbslider didTapOnImage:(UIImage *)targetImage andParentView:(UIImageView *)targetView indAdvert:(int)index{
}
- (void)sbslider:(SBSliderView *)sbslider didScrolledPage:(int)index{
    if (index == 2) {
        [_btnFinish setHidden:NO];
        [_btnSkip setHidden:YES];
        [slider.pageIndicator setHidden:YES];
    } else {
        [_btnFinish setHidden:YES];
        [_btnSkip setHidden:NO];
        [slider.pageIndicator setHidden:NO];
    }
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
