//
//  SearchUserViewController.m
//  ShopPhotos
//
//  Created by Macbook on 24/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "SearchUserViewController.h"
#import "ErrMsgViewController.h"

@interface SearchUserViewController (){
    ErrMsgViewController *popupErrVC;

}
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *searchBar;
@property (weak, nonatomic) IBOutlet UIView *btnOk;
@property (weak, nonatomic) IBOutlet UITextField *txtUid;

@end

@implementation SearchUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}
- (void)setup{
    [self.back addTarget:self action:@selector(backSelected)];
    [self.btnOk addTarget:self action:@selector(okSelected)];
    self.searchBar.cornerRadius = 5;
    popupErrVC = [[ErrMsgViewController alloc] initWithNibName:@"ErrMsgViewController" bundle:nil];
}
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)okSelected{
    if (_txtUid.text.length == 8) {
        [self showLoad];
        NSDictionary *data = @{@"uid":_txtUid.text};
        __weak __typeof(self)weakSelef = self;
        [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.concernUser,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
            [weakSelef closeLoad];
            BaseModel * model = [[BaseModel alloc] init];
            [model analyticInterface:responseObject];
            if(model.status == 0){
                
                [weakSelef showToast:@"关注成功"];
//                [self.navigationController popViewControllerAnimated:YES];

            }else{
                
                [popupErrVC showInView:self animated:YES type:@"error" message:model.message];
                //            [weakSelef showToast:model.message];
            }
        } failure:^(NSError * error){
            //[weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
            [weakSelef closeLoad];
            [popupErrVC showInView:self animated:YES type:@"error" message:[NSString stringWithFormat:@"找不到有图号为%@的用户",_txtUid.text]];
        }];

    } else {
        [popupErrVC showInView:self animated:YES type:@"error" message:@"有图号必须8位"];
    }
}
- (void)closePopupErr {
    [popupErrVC removeAnimate];
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
