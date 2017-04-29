//
//  PersonalHomeCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/25.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "PersonalHomeCtr.h"
#import "UserInfoModel.h"
#import <UIImageView+WebCache.h>
#import "PersonalPhotosCtr.h"
#import <MJPhotoBrowser.h>
#import <ShareSDK/ShareSDK.h>
#import "ChattingViewController.h"

@interface PersonalHomeCtr ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *uidText;
@property (weak, nonatomic) IBOutlet UIView *uidView;
@property (weak, nonatomic) IBOutlet UIButton *attention;
@property (weak, nonatomic) IBOutlet UIView *ChattingView;
@property (weak, nonatomic) IBOutlet UIView *attentionView;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UIView *qqView;
@property (weak, nonatomic) IBOutlet UILabel *qqText;
@property (weak, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UILabel *chatText;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UILabel *recommend;
@property (weak, nonatomic) IBOutlet UILabel *dynamic;
@property (weak, nonatomic) IBOutlet UILabel *photos;
@property (weak, nonatomic) IBOutlet UILabel *photosClass;
@property (strong, nonatomic) NSString * iconURL;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *baseContentView;
@property (weak, nonatomic) IBOutlet UIView *spaceView;
@property (weak, nonatomic) IBOutlet UIImageView *backIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblBack;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *iconSearch;
@property (weak, nonatomic) IBOutlet UIImageView *iconShare;
@end

@implementation PersonalHomeCtr

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:_baseContentView];
    [self.view bringSubviewToFront:_titleView];

    
    [self setup];
    
    [self loadNetworkData:@{@"uid":self.uid}];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:_contentScrollView]) {
        
        switch (scrollView.panGestureRecognizer.state) {
                
            case UIGestureRecognizerStateBegan:
                
                // User began dragging
                [self.view bringSubviewToFront:_contentScrollView];
                [self.view bringSubviewToFront:_titleView];

                break;
                
            case UIGestureRecognizerStateChanged:
                // User is currently dragging the scroll view
                NSLog(@"%f",scrollView.contentOffset.y);
                [_baseContentView setFrame:CGRectMake(0, - scrollView.contentOffset.y / 2, _baseContentView.frame.size.width, _baseContentView.frame.size.height)];
                [_titleView setBackgroundColor:RGBACOLOR(255, 255, 255, scrollView.contentOffset.y / _spaceView.frame.size.height)];
                break;
            case UIGestureRecognizerStatePossible:
                
                // The scroll view scrolling but the user is no longer touching the scrollview (table is decelerating)
                NSLog(@"%f",scrollView.contentOffset.y);
                break;
                
            default:
                break;
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.y);
    if(_contentScrollView == scrollView){
        CGFloat screenHeight = _spaceView.frame.size.height;
        if(0 <= scrollView.contentOffset.y && scrollView.contentOffset.y < screenHeight){
            [self.view bringSubviewToFront:_baseContentView];
            [self.view bringSubviewToFront:_titleView];
            [_titleView setBackgroundColor:[UIColor clearColor]];
            [self.backIcon setImage:[UIImage imageNamed:@"btn_backwhite"]];
            [self.lblBack setTextColor:[UIColor whiteColor]];
            [self.lblTitle setTextColor:[UIColor whiteColor]];
            [self.iconSearch setImage:[UIImage imageNamed:@"ico_search_w"]];
            [self.iconShare setImage:[UIImage imageNamed:@"btn_share2.png"]];
            [self.lblTitle setText:@""];
        } else {
            [self.view bringSubviewToFront:_contentScrollView];
            [self.view bringSubviewToFront:_titleView];
            [_titleView setBackgroundColor:[UIColor whiteColor]];
            [self.backIcon setImage:[UIImage imageNamed:@"btn_back_black"]];
            [self.lblBack setTextColor:[UIColor blackColor]];
            [self.lblTitle setTextColor:[UIColor blackColor]];
            [self.iconSearch setImage:[UIImage imageNamed:@"ico_search_b"]];
            [self.iconShare setImage:[UIImage imageNamed:@"ico_share.png"]];
            self.lblTitle.text = self.username;
//            [UIView beginAnimations:nil context:nil];//动画开始
//            [UIView setAnimationDuration:0.3];
//            
//            [UIView commitAnimations];
        }
    }
}

- (void)setup{
    
    [self.back addTarget:self action:@selector(backSelected)];
    [self.headImage addTarget:self action:@selector(iconSelected)];
    self.headImage.cornerRadius = 35.5f;
    self.headImage.layer.borderWidth = 3;
    self.headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImage.layer.masksToBounds = YES;
    [self.attention addTarget:self action:@selector(attentionSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.attentionView addTarget:self action:@selector(attentionSelected)];
    [self.ChattingView addTarget:self action:@selector(chattingSelected:)];
    [self.qqView addTarget:self action:@selector(qqSelected:)];
    [self.chatView addTarget:self action:@selector(chatSelected:)];
    [self.recommend addTarget:self action:@selector(recommendSelected)];
    [self.dynamic addTarget:self action:@selector(dynamicSelected)];
    [self.photos addTarget:self action:@selector(photosSelected)];
    [self.photosClass addTarget:self action:@selector(photosClassSelected)];
    
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effectview.alpha = 0.95;
//    [self.head addSubview:effectview];
//    effectview.sd_layout
//    .leftEqualToView(self.head)
//    .rightEqualToView(self.head)
//    .topEqualToView(self.head)
//    .bottomEqualToView(self.head);
    
    if(self.twoWay){
        [self.attentionLabel setText:@"取消关注"];
        [self.attention setImage:[UIImage imageNamed:@"ico_favorite_done"] forState:UIControlStateNormal];
    }else{
        [self.attentionLabel setText:@"立刻关注"];
        [self.attention setImage:[UIImage imageNamed:@"ico_concern"] forState:UIControlStateNormal];
    }
}

#pragma mark -OnClick
- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)iconSelected{
    
    NSMutableArray *photos = [NSMutableArray array];
    MJPhoto *photo = [[MJPhoto alloc] init];
    if(self.iconURL){
        photo.url = [NSURL URLWithString:self.iconURL];
        [photos addObject:photo];
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0;
        browser.photos = photos;
        [browser show];
    }
}

- (IBAction)chattingSelected:(id)sender {
    ChattingViewController *conversationVC = [[ChattingViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = self.uid;
    conversationVC.name = self.username;
    conversationVC.twoWay = _twoWay;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
- (void)attentionSelected{
    
    if(self.twoWay){
        
        __weak __typeof(self)weakSelef = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要取消关注吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [weakSelef cancelConcernUser:@{@"uid":weakSelef.uid}];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        [self concernUser:@{@"uid":self.uid}];
    }
}
- (IBAction)qqSelected:(id)sender{
    
    NSString * qqStr = self.qqText.text;
    if(qqStr && qqStr.length >0){
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = qqStr;
    }else {
        [self showToast:@"QQ号为空"];
        return;
    }
    
    __weak __typeof(self)weakSelef = self;
    NSString * msg = [NSString stringWithFormat:@"QQ号已复制，可以进入QQ粘贴"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"打开QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mqq://"] options:@{} completionHandler:nil];
        }else{
            [weakSelef showToast:@"您没有安装QQ"];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (IBAction)chatSelected:(id)sender{
    
    NSString * chatStr = self.chatText.text;
    if(chatStr && chatStr.length > 0){
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = chatStr;
    }else{
        [self showToast:@"微信号为空"];
    }
    __weak __typeof(self)weakSelef = self;
    NSString * msg = [NSString stringWithFormat:@"微信号已复制，可以进入微信粘贴"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"打开微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
    
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"] options:@{} completionHandler:nil];
        }else{
            [weakSelef showToast:@"您没有安装微信"];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void) openAnotherAppInThisApp:(NSString *)strIdentifier{

    
    
}

- (void)recommendSelected{
 
    PersonalPhotosCtr * personalPhotos = GETALONESTORYBOARDPAGE(@"PersonalPhotosCtr");
    personalPhotos.pageTitleText = self.name.text;
    personalPhotos.uid = self.uid;
    personalPhotos.twoWay = self.twoWay;
    personalPhotos.initialType = 100;
    [self.navigationController pushViewController:personalPhotos animated:YES];
    
}
- (void)dynamicSelected{
    PersonalPhotosCtr * personalPhotos = GETALONESTORYBOARDPAGE(@"PersonalPhotosCtr");
    personalPhotos.pageTitleText = self.name.text;
    personalPhotos.uid = self.uid;
    personalPhotos.initialType = 101;
    personalPhotos.twoWay = self.twoWay;
    [self.navigationController pushViewController:personalPhotos animated:YES];
    
}
- (void)photosSelected{
    PersonalPhotosCtr * personalPhotos = GETALONESTORYBOARDPAGE(@"PersonalPhotosCtr");
    personalPhotos.pageTitleText = self.name.text;
    personalPhotos.uid = self.uid;
    personalPhotos.initialType = 102;
    personalPhotos.twoWay = self.twoWay;
    [self.navigationController pushViewController:personalPhotos animated:YES];
}
- (void)photosClassSelected{
    PersonalPhotosCtr * personalPhotos = GETALONESTORYBOARDPAGE(@"PersonalPhotosCtr");
    personalPhotos.pageTitleText = self.name.text;
    personalPhotos.uid = self.uid;
    personalPhotos.initialType = 103;
    personalPhotos.twoWay = self.twoWay;
    [self.navigationController pushViewController:personalPhotos animated:YES];
}

#pragma mark - 修改样式
- (void)setStyle:(UserInfoModel *)model{
    
    [self.head sd_setImageWithURL:[NSURL URLWithString:model.bg_image]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.iconURL = model.avatar;
    [self.name setText:model.name];
//    [self.lblTitle setText:model.name];
    self.username = model.name;
    self.uidText.text = [NSString stringWithFormat:@"有图号:%@", model.uid];
//    if(model.uid && model.uid.length > 0){
//        NSMutableAttributedString * qqText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",model.uid]];
//        NSTextAttachment * qqIocn = [[NSTextAttachment alloc] init];
//        qqIocn.image = [UIImage imageNamed:@"uid_icon_white"];
//        qqIocn.bounds = CGRectMake(0, -2, 11, 13);
//        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:qqIocn];
//        [qqText insertAttributedString:string atIndex:0];
//        [self.uidText setAttributedText:qqText];
//        [self.uidText setTextAlignment:NSTextAlignmentCenter];
//    }else{
//        NSMutableAttributedString * qqText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
//        NSTextAttachment * qqIocn = [[NSTextAttachment alloc] init];
//        qqIocn.image = [UIImage imageNamed:@"uid_icon_white"];
//        qqIocn.bounds = CGRectMake(5, -2, 11, 13);
//        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:qqIocn];
//        [qqText insertAttributedString:string atIndex:0];
//        [self.uidText setAttributedText:qqText];
//        [self.uidText setTextAlignment:NSTextAlignmentLeft];
//    }
    
    if(model.qq && model.qq.length > 0){
        NSString * qqs = model.qq;
        if(qqs.length >11){
            qqs = [qqs substringToIndex:11];
        }
        NSMutableAttributedString * qqText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",qqs]];
        NSTextAttachment * qqIocn = [[NSTextAttachment alloc] init];
        qqIocn.image = [UIImage imageNamed:@"qq_icon_white"];
        qqIocn.bounds = CGRectMake(0, -2, 13, 13);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:qqIocn];
        [qqText insertAttributedString:string atIndex:0];
        
        [self.qqText setAttributedText:qqText];
        [self.qqText setTextAlignment:NSTextAlignmentCenter];
    }else{
        NSMutableAttributedString * qqText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
        NSTextAttachment * qqIocn = [[NSTextAttachment alloc] init];
        qqIocn.image = [UIImage imageNamed:@"qq_icon_white"];
        qqIocn.bounds = CGRectMake(5, -2, 13, 13);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:qqIocn];
        [qqText insertAttributedString:string atIndex:0];
        
        [self.qqText setAttributedText:qqText];
        [self.qqText setTextAlignment:NSTextAlignmentLeft];
    }
    
    if(model.wechat && model.wechat.length >0){
        
        NSString * qqs = model.wechat;
        if(qqs.length >11){
            qqs = [qqs substringToIndex:11];
            NSString * qqr = [NSString stringWithFormat:@"%@..",qqs];
            qqs = qqr;
        }
        NSMutableAttributedString * chatText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",qqs]];
        NSTextAttachment * chatIocn = [[NSTextAttachment alloc] init];
        chatIocn.image = [UIImage imageNamed:@"wexin_icon_white"];
        chatIocn.bounds = CGRectMake(0, -3, 15, 13);
        NSAttributedString *chatIocnStr = [NSAttributedString attributedStringWithAttachment:chatIocn];
        [chatText insertAttributedString:chatIocnStr atIndex:0];
        [self.chatText setAttributedText:chatText];
        [self.chatText setTextAlignment:NSTextAlignmentCenter];
    }else{
        NSMutableAttributedString * chatText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
        NSTextAttachment * chatIocn = [[NSTextAttachment alloc] init];
        chatIocn.image = [UIImage imageNamed:@"wexin_icon_white"];
        chatIocn.bounds = CGRectMake(5, -3, 15, 13);
        NSAttributedString *chatIocnStr = [NSAttributedString attributedStringWithAttachment:chatIocn];
        [chatText insertAttributedString:chatIocnStr atIndex:0];
        [self.chatText setAttributedText:chatText];
        [self.chatText setTextAlignment:NSTextAlignmentLeft];
    }
    NSString * str = @"";
    if(model.signature && model.signature.length > 0){
        str = [NSString stringWithFormat:@"%@",model.signature];
        //[self.signature setText:];
    }else{
        str = [NSString stringWithFormat:@"这个人很懒什么都没有留下"];
        //[self.signature setText:];
    }
    
   // NSString * sign = [NSString stringWithFormat:@"个性签名:%@",model.signature];
    [self.signature setText:str];
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 3;// 字体的行间距
//    
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraphStyle};
//    self.signature.attributedText = [[NSAttributedString alloc] initWithString:str attributes:attributes];
}

#pragma makr - AFNetworking网络加载
- (void)loadNetworkData:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getUserInfo,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        
        UserInfoModel * infoModel = [[UserInfoModel alloc] init];
        [infoModel analyticInterface:responseObject];
        if(infoModel.status == 0){
            [weakSelef setStyle:infoModel];
            if(weakSelef.caan){
               [weakSelef concernUser:@{@"uid":weakSelef.uid}];
            }
        }else{
            [weakSelef showToast:infoModel.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)cancelConcernUser:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",self.congfing.cancelConcernUser,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"关注取消成功"];
            [weakSelef.attentionLabel setText:@"立刻关注"];
            [weakSelef.attention setImage:[UIImage imageNamed:@"ico_concern"] forState:UIControlStateNormal];
            weakSelef.twoWay = NO;
        }else{
            [self showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

- (void)concernUser:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.concernUser,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef.attentionLabel setText:@"取消关注"];
            [weakSelef.attention setImage:[UIImage imageNamed:@"ico_favorite_done"] forState:UIControlStateNormal];
            weakSelef.twoWay = YES;
            [weakSelef showToast:@"关注成功"];
            //                [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [weakSelef showToast:model.message];
            //            [weakSelef showToast:model.message];
        }
    } failure:^(NSError * error){
        [weakSelef showToast:NETWORKTIPS];
        [weakSelef closeLoad];
    }];
    
}

@end
