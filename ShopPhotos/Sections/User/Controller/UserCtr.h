//
//  UserCtr.h
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/18.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "BaseViewCtr.h"

@interface UserCtr : BaseViewCtr
@property (weak, nonatomic) IBOutlet UILabel *lblNameHead;
@property (weak, nonatomic) IBOutlet UILabel *lblUid;
@property (weak, nonatomic) IBOutlet UIImageView *edit;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *head;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *qrView;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *signatureText;
@property (weak, nonatomic) IBOutlet UILabel *qqText;
@property (weak, nonatomic) IBOutlet UILabel *chatText;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *locationText;
@property (weak, nonatomic) IBOutlet UILabel *homeText;
@property (weak, nonatomic) IBOutlet UIImageView *home;
@property (weak, nonatomic) IBOutlet UIView *feedback;
@property (assign, nonatomic) BOOL changeStatu;
@property (weak, nonatomic) IBOutlet UIButton *loginOut;
@property (strong, nonatomic) NSString * iconURL;
@property (strong, nonatomic) UITextField * tempTextField;
@property (weak, nonatomic) IBOutlet UIView *viewName;
@property (weak, nonatomic) IBOutlet UIView *viewSign;
@property (weak, nonatomic) IBOutlet UIView *viewQQ;
@property (weak, nonatomic) IBOutlet UIView *viewWechat;
@property (weak, nonatomic) IBOutlet UIView *viewPhone;
@property (weak, nonatomic) IBOutlet UIView *viewAddress;
@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@end
