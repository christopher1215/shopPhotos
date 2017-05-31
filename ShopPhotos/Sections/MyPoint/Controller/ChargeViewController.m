//
//  ChargeViewController.m
//  ShopPhotos
//
//  Created by Macbook on 08/04/2017.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "ChargeViewController.h"
#import "ProductRequest.h"
#import "ProductModel.h"
#import "PaymentRequest.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "Order.h"
#import "DataSigner.h"
#import "ChargeResultViewController.h"

@interface ChargeViewController (){
    int productIndex;
}
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIView *wechatPay;
@property (weak, nonatomic) IBOutlet UIView *alipay;
@property (weak, nonatomic) IBOutlet UIImageView *ico_wechat;
@property (weak, nonatomic) IBOutlet UIImageView *ico_alipay;
@property (strong, nonatomic) NSString *payMethod;
@property (strong, nonatomic) NSMutableArray *productArray;
@property (weak, nonatomic) IBOutlet UIView *productView;
@property (weak, nonatomic) IBOutlet UIView *product1;
@property (weak, nonatomic) IBOutlet UIView *product2;
@property (weak, nonatomic) IBOutlet UIView *product3;
@property (weak, nonatomic) IBOutlet UIView *product4;
@property (weak, nonatomic) IBOutlet UIView *product5;
@property (weak, nonatomic) IBOutlet UIView *product6;

@end

@implementation ChargeViewController
- (NSMutableArray *)productArray{
    
    if(!_productArray) _productArray = [NSMutableArray array];
    return _productArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.back addTarget:self action:@selector(backSelected)];
    [self.wechatPay addTarget:self action:@selector(wechatSelected)];
    [self.alipay addTarget:self action:@selector(aliSelected)];
    [self.product1 addTarget:self action:@selector(product1Selected)];
    [self.product2 addTarget:self action:@selector(product2Selected)];
    [self.product3 addTarget:self action:@selector(product3Selected)];
    [self.product4 addTarget:self action:@selector(product4Selected)];
    [self.product5 addTarget:self action:@selector(product5Selected)];
    [self.product6 addTarget:self action:@selector(product6Selected)];
    [self product1Selected];
    [self wechatSelected];
    self.lblPoint.text = [NSString stringWithFormat:@"%d积分", _currentPoint];
    self.lblAccount.text = self.photosUserName;
    [self productArray];
    [self loadNetworkData];
}
- (void)backSelected{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)product1Selected{
    self.product1.borderColor = [UIColor redColor];
    self.product2.borderColor = [UIColor lightGrayColor];
    self.product3.borderColor = [UIColor lightGrayColor];
    self.product4.borderColor = [UIColor lightGrayColor];
    self.product5.borderColor = [UIColor lightGrayColor];
    self.product6.borderColor = [UIColor lightGrayColor];
    productIndex = 0;
}
- (void)product2Selected{
    self.product2.borderColor = [UIColor redColor];
    self.product1.borderColor = [UIColor lightGrayColor];
    self.product3.borderColor = [UIColor lightGrayColor];
    self.product4.borderColor = [UIColor lightGrayColor];
    self.product5.borderColor = [UIColor lightGrayColor];
    self.product6.borderColor = [UIColor lightGrayColor];
    productIndex = 1;
}
- (void)product3Selected{
    self.product3.borderColor = [UIColor redColor];
    self.product2.borderColor = [UIColor lightGrayColor];
    self.product1.borderColor = [UIColor lightGrayColor];
    self.product4.borderColor = [UIColor lightGrayColor];
    self.product5.borderColor = [UIColor lightGrayColor];
    self.product6.borderColor = [UIColor lightGrayColor];
    productIndex = 2;
}
- (void)product4Selected{
    self.product4.borderColor = [UIColor redColor];
    self.product2.borderColor = [UIColor lightGrayColor];
    self.product3.borderColor = [UIColor lightGrayColor];
    self.product1.borderColor = [UIColor lightGrayColor];
    self.product5.borderColor = [UIColor lightGrayColor];
    self.product6.borderColor = [UIColor lightGrayColor];
    productIndex = 3;
}
- (void)product5Selected{
    self.product5.borderColor = [UIColor redColor];
    self.product2.borderColor = [UIColor lightGrayColor];
    self.product3.borderColor = [UIColor lightGrayColor];
    self.product4.borderColor = [UIColor lightGrayColor];
    self.product1.borderColor = [UIColor lightGrayColor];
    self.product6.borderColor = [UIColor lightGrayColor];
    productIndex = 4;
}
- (void)product6Selected{
    self.product6.borderColor = [UIColor redColor];
    self.product2.borderColor = [UIColor lightGrayColor];
    self.product3.borderColor = [UIColor lightGrayColor];
    self.product4.borderColor = [UIColor lightGrayColor];
    self.product5.borderColor = [UIColor lightGrayColor];
    self.product1.borderColor = [UIColor lightGrayColor];
    productIndex = 5;
}

- (void)wechatSelected{
    
    [self.ico_alipay setImage:[UIImage imageNamed:@"icon_unchecked.png"]];
    [self.ico_wechat setImage:[UIImage imageNamed:@"icon_checked.png"]];
    _payMethod = @"wechat";
    
}
- (void)aliSelected{
    
    [self.ico_alipay setImage:[UIImage imageNamed:@"icon_checked.png"]];
    [self.ico_wechat setImage:[UIImage imageNamed:@"icon_unchecked.png"]];
    _payMethod = @"alipay";
}

- (void)loadNetworkData{
    NSDictionary * data = @{
                            };
    __weak __typeof(self)weakSelef = self;
    
    NSString *serverApi = self.congfing.getProducts;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"1  %@",responseObject);
        
        ProductRequest * request = [[ProductRequest alloc] init];
        [request analyticInterface:responseObject];
        if(request.status == 0){
            [weakSelef.productArray removeAllObjects];
            [weakSelef.productArray addObjectsFromArray:request.dataArray];
            NSLog(@"2  %@",weakSelef.productArray);
            [weakSelef setStyle];
        }else{
            [weakSelef showToast:request.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

-(void)setStyle{
    int cnt = 0;
    for (ProductModel * product in self.productArray) {
        if (cnt < 6) {
            UIView *view = (UIView *)[self.productView viewWithTag:1000 + cnt];
            [view setHidden: NO];
            view.borderWidth = 1;
            UILabel *price = (UILabel *)[view viewWithTag:100];
            price.text = [NSString stringWithFormat:@"%@元", product.price];
            
            UILabel *title = (UILabel *)[view viewWithTag:101];
            title.text = product.name;
        }
        cnt ++;
    }
}
- (IBAction)onPay:(id)sender {
    ProductModel * model = [self.productArray objectAtIndex:productIndex];
    NSDictionary * data = @{
                            @"productId":[NSString stringWithFormat:@"%d",model.productId],
                            @"channel":_payMethod
                            };
    __weak __typeof(self)weakSelef = self;
    [self showLoad];
    NSString *serverApi = self.congfing.createOrder;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"1  %@",responseObject);
        [weakSelef closeLoad];
        PaymentRequest * request = [[PaymentRequest alloc] init];
        [request analyticInterface:responseObject];
        if(request.status == 0){
            if ([_payMethod isEqualToString:@"wechat"]) {
                [WXApi registerApp:[request.config objectForKey:@"appid"]];
                if ([WXApi isWXAppInstalled])
                {
    
                     //调起微信支付
                     PayReq* req             = [[PayReq alloc] init];
                     
                     req.partnerId           = [request.config objectForKey:@"partnerid"];
                     req.prepayId            = [request.config objectForKey:@"prepayid"];
                     req.nonceStr            = [request.config objectForKey:@"noncestr"];
                     req.timeStamp           = [[request.config objectForKey:@"timestamp"] intValue];
                     req.package             = [request.config objectForKey:@"package"];
                     req.sign                = [request.config objectForKey:@"sign"];
                     [WXApi sendReq:req];
                     //日志输出
                     NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[request.config objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                    
                    ChargeResultViewController *vc=[[ChargeResultViewController alloc] initWithNibName:@"ChargeResultViewController" bundle:nil];
                    vc.orderId = request.orderId;
                    [self.navigationController pushViewController:vc animated:YES];

                } else
                {
                    NSString *myHTMLSource = @"itunesurl://itunes.apple.com/cn/app/微信/id414478124?mt=8";
                    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:myHTMLSource]options:@{} completionHandler:nil];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myHTMLSource] options:@{} completionHandler:nil];
                }
            } else if ([_payMethod isEqualToString:@"alipay"]){
                  NSString *appScheme = @"alipay201705041335564089630173";

                  // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
                  NSString *orderString = request.configStr;
                
                  // NOTE: 调用支付结果开始支付
                  [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                      NSLog(@"reslut = %@",resultDic);
                      //                              [self gotoOrderViewer:2];
//                      NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
//                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:[resultDic objectForKey:@"memo"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                      [alert show];
                      if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000) {
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"successNoti" object:@{}];
                      } else {
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"failNoti" object:@{}];
                      }
                      
                  }];
                ChargeResultViewController *vc=[[ChargeResultViewController alloc] initWithNibName:@"ChargeResultViewController" bundle:nil];
                vc.orderId = request.orderId;
                [self.navigationController pushViewController:vc animated:YES];

//                }

            }
        }else{
            [weakSelef showToast:request.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
    
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
