//
//  ChargeResultViewController.m
//  ShopPhotos
//
//  Created by Macbook on 13/05/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "ChargeResultViewController.h"
#import "MypointViewController.h"
@interface ChargeResultViewController (){
    NSInteger integral;
}
@property (weak, nonatomic) IBOutlet UILabel *back;
@property (weak, nonatomic) IBOutlet UILabel *lblPoint;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@property (weak, nonatomic) IBOutlet UIImageView *imgResult;

@end

@implementation ChargeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.back addTarget:self action:@selector(backSelected)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successNoti:) name:@"successNoti" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failNoti:) name:@"failNoti" object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self successNoti:nil];
}
-(void)successNoti:(NSNotification *)noti
{
    NSDictionary * data = @{
                            @"orderId":self.orderId
                            };
    __weak __typeof(self)weakSelef = self;
    
    NSString *serverApi = self.congfing.checkOrderState;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"1  %@",responseObject);
        
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            NSDictionary *recvData = [RequestErrorGrab getDicwitKey:@"data" toTarget:responseObject];
            BOOL paid = [RequestErrorGrab getBooLwitKey:@"paid" toTarget:recvData];
            integral = [RequestErrorGrab getIntegetKey:@"integral" toTarget:recvData];
            if (paid) {
                [self.back setHidden:NO];
                self.back.text = @"完成";
                [self.lblPoint setHidden:NO];
                self.lblPoint.text = [NSString stringWithFormat:@"%ld积分", integral];
                self.lblResult.text = @"充值成功";
                [self.lblResult setTextColor:ThemeColor];
                [self.imgResult setImage:[UIImage imageNamed:@"successIcon.png"]];
            } else {
                [self.back setHidden:NO];
                self.back.text = @"取消";
            }
            
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
    
}
-(void)failNoti:(NSNotification *)noti
{
    NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
    strMsg = @"支付失败！";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *vc in viewControllers)
    {
        if([vc isKindOfClass:[MypointViewController class]])
        {
            MypointViewController *vvcc = (MypointViewController *)vc;
            vvcc.currentPoint = integral;
            [self.navigationController popToViewController:vvcc animated:NO];
            break;
        }
    }
}

- (void)backSelected{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *vc in viewControllers)
    {
        if([vc isKindOfClass:[MypointViewController class]])
        {
            
            MypointViewController *vvcc = (MypointViewController *)vc;
            vvcc.currentPoint = integral;
            [self.navigationController popToViewController:vvcc animated:NO];
            break;
        }
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
