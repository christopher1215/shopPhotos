//
//  ProvisionCtr.m
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/8.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "ProvisionCtr.h"

@interface ProvisionCtr ()
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UITextView *text;

@end

@implementation ProvisionCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString * textStr = @"有图相册使用协议 \n\n厦门市眼镜狗网络科技有限公司（以下简称眼镜狗公司）将本软件程序的最终使用许可权授予您。但您必须向眼镜狗公司作出以下保证：\n\n请仔细阅读以下使用许可, 如果您不同意以下任何一点, 请立即停止使用此软件。\n\n有图相册（以下称“有图”）是一个向广大用户提供上传空间和技术的信息存储空间服务平台，通过云存储技术为用户提供基础的在线存储及其他各类互联网在线服务。有图相册本身不直接上传、提供内容，对用户传输内容不做任何修改或编辑。\n\n本《用户使用协议》(以下简称《协议》)是您(个人或单一机构团体)与上述 有图 软件(以下称\"软件\"或\"有图\")版权所有人眼镜狗公司之间的法律协议。在您使用本软件产品之前,请务必阅读此《协议》, 任何与《协议》有关的软件、电子文档等都应是按本协议的条款而授予您的, 同时本《协议》亦适用于任何有关本软件产品的后期发行和升级。您一旦安装、复制、下载、访问或以其它方式使用本软件产品, 即表示您同意接受本《协议》各项条款的约束。如您不同意本《协议》的条款, 那么, 版权所有人眼镜狗公司则不予将本软件产品的使用权授予您。在这种情况下, 您不得使用、复制或传播本软件产品。\n\n本软件产品受著作权法及国际著作权条约和其它知识产权法及条约的保护。本软件产品只许可使用, 而不出售。不得用于商业目的的活动之中。\n\n一、软件产品保护条款\n1.许可证的授予：本《协议》授予您下列权利安装和使用：您可安装无限制数量的本软件产品来使用。复制、分发和传播：您可以复制、分发和传播无限制数量的软件产品, 但您必须保证每一份复制、分发和传播都必须是完整和真实的, 包括所有有关本软件产品的软件、电子文档, 版权和商标宣言, 亦包括本协议。本软件可以独立分发亦可随同其他软件一起分发, 但如因此而引起任何问题, 版权人将不予承担任何责任。\n2.其它权利和限制说明禁止反向工程、反向编译和反向汇编：您不得对本软件产品进行反向工程、反向编译和反向汇编, 同时不得改动编译在程序文件内部的任何资源。除非适用法律明文允许上述活动, 否则您必须遵守此协议限制。组件的分隔：本软件产品是被当成一个单一产品而被授予许可使用, 不得将各个部分分开用于任何目的行动。终止：如您未遵守本《协议》的各项条件, 在不损害其它权利的情况下, 版权人可将本《协议》终止，并保留通过法律手段追究责任的权力。如发生此种情况, 则您必须销毁\"软件产品\"及其各部分的所有副本。商标：本《协议》不授予您由版权人厦门市眼镜狗网络科技有限公司所拥有的任何商标或服务商标有关的任何权利。个别授权：如有任何组织或个人利用本软件以任何方式为公众服务并同时满足其自身特定目的而分发、复制和传播本软件产品, 均须得到版权人授权同意后方可进行, 否则视为侵权。\n3.版权\n本软件产品(包括但不限于本软件产品中所含的任何图象、照片、动画、文字和附加程序(applets))、随附的印刷材料、及本软件产品的任何副本的一切所有权和知识产权, 均由版权人厦门市眼镜狗网络科技有限公司拥有。通过使用本\"软件产品\"可访问的内容的一切所有权和知识产权均属于各自内容的所有者拥有并可能受适用著作权或其它知识产权法律和条约的保护。本《协议》不授予您使用这些内容的权利。\n4.有限保证\n无保证：\n使用本软件产品涉及到Internet服务，可能会受到各个环节不稳定因素的影响，因此服务存在不可抗力、计算机病毒、黑客攻击、系统不稳定、用户所在位置、用户关机、及其他任何技术、互联网络、通信线路原因等造成的服务中断或不能满足用户要求的风险。用户须承担以上风险，厦门市眼镜狗网络科技有限公司不承诺对因此导致用户不能搜索和下载文件、发送和接收信息等各项 有图 提供的服务承担任何的责任，使用本软件产品由用户自己承担风险,在适用法律允许的最大范围内, 眼镜狗公司在任何情况下不就因使用或者不能使用本软件产品所发生的特殊的、意外的非直接或者间接的损失承担赔偿责任，即使已实现被告知此事件发生的可能性。\n对造成损失无责任：\n在使用本软件产品存在有来自任何他人的包括威胁性、亵渎性、令人反感的、侵害个人隐私权、版权、或者非法的内容或者行为，或对他人权利的侵犯（包括知识产权）的匿名或者署名的信息的风险。用户须承担以上风险，眼镜狗公司对有图服务不作任何类型的担保和承诺，不论是明确的或者隐含的，包括所有有关信息的真实性、适用性、适于某一特定用途、所有权和非侵权的默示担保和条件，对因此导致任何因用户不正当或非法使用服务产生的直接、间接、偶然、特殊、及后续的损害，不承担任何的责任。\n\n二、用户使用须知\n特别提醒用户，使用互联网必须遵守国家有关的政策和法律，如刑法、国家安全法、保密法、计算机信息系统安全保护条例，保护国家利益;保护国家安全。对于违法或者不当使用互联网络而引起的一切责任，由用户负全部责任。\n1.用户不得使用有图发送或者传播敏感信息或者违反国家法律制度的信息；用户不得使用有图发送或者传播虚假、骚扰性、侮辱性、恐吓性、伤害性、挑衅性、庸俗性、淫秽色情性信息；\n2.有图和大多数因特网软件一样，易受到各种安全问题的困挠，包括：\n透露详细个人资料，被不法分子利用，造成现实生活中的骚扰；哄骗、破译密码；下载安装的其他软件或者文件中含有各种病毒，威胁到个人计算机上信息和数据的安全，进而威胁有图软件的使用。\n3.用户应加强个人资料保护意识，以免对个人生活和正常使用有图服务造成不必要的影响；\n4.盗取他人用户帐号,共享和传播非法和不良信息、文件，或利用网络通讯骚扰他人，均属于违法行为；\n5.青少年上网应该在父母和老师的指导下，正确学习使用网络，青少年应避免沉迷于网络虚拟世界及各种网络不良、非法信息和内容影响正常的学习和生活；\n6.用户注册有图帐号后，如果长期不使用，眼镜狗公司有权收回号码，以免造成资源浪费；\n7.用户应规范合法地使用有图,如骚扰、欺骗其他用户，本公司有权回收其帐号；\n8.用户不应散布对眼镜狗公司不利言论和诋毁眼镜狗形象的行为， 情节恶劣者可以予以封ID处罚，本公司有权回收其帐号；\n9.用户不得利用有图进行违反国家法律的活动，如有发现，眼镜狗公司会应公安部门的要求，全力协助调查工作。\n10.用户选择同意协议并打勾，即表示用户愿意接受厦门市眼镜狗网络科技有限公司发出的相关群发邮件。此群发邮件的解释权归厦门市眼镜狗网络科技有限公司所有。\n\n三、特别提醒用户注意，为了保证业务发展调整的自主权利，眼镜狗公司拥有随时修改或者中断服务而不需要通知用户的权利，本公司行使修改或者中断服务的权利不需对用户或者第三方负责，用户必须在同意本条款的前提下，本软件才开始对用户提供服务。\n\n四、有图软件中涉及的宽带娱乐服务内容的所有权界定\n厦门市眼镜狗网络科技有限公司仅提供有图软件，内容搜索于互联网中同意本协议的个人用户终端，下载的音乐仅做试听，用户必须在23小时内删除，版权归属唱片公司所有，请购买正版唱片。软件中的涉及的所有宽频娱乐服务内容与厦门市眼镜狗网络科技有限公司无关，其所有权归各影音内容提供商，该所有权受法律的保护，所以，用户只能在影音内容提供商的正式授权下才能使用这些内容，而不能擅自复制、链接、再造、非法传播这些内容、或创造与内容有关的派生产品，不得以任何方式建立镜像站点，否则，用户应赔偿由此给影音内容提供商和厦门市眼镜狗网络科技有限公司造成的损失。\n厦门市眼镜狗网络科技有限公司对他人权利的侵犯（包括知识产权）不承担责任，且对任何第三方通过服务发送或在服务中包含的任何内容不承担责任。\n\n五、法律适用\n本协议条款应符合中华人民共和国法律法规的规定，用户和厦门市眼镜狗网络科技有限公司一致同意接受中华人民共和国法律的管辖。当本协议条款与中华人民共和国法律相抵触时，则这些条款将完全按法律规定重新解释或重新修订，而其它条款则依旧对厦门市眼镜狗网络科技有限公司及用户产生法律效力。\n\n六、协议条款和资费标准的修改\n厦门市眼镜狗网络科技有限公司有权在必要时修改本协议条款的内容和服务资费标准，且该修改以符合国家法律法规的规定，并不侵害用户的合法权益为必要前提。\n厦门市眼镜狗网络科技有限公司协议条款一旦发生变动，将会在重要页面上提示修改内容。用户若不同意厦门市眼镜狗网络科技有限公司改动的内容，可以主动取消所申请的网络服务，并可按照厦门市眼镜狗网络科技有限公司当时已经公布的收费办法办理相关退费手续；若用户继续享用厦门市眼镜狗网络科技有限公司网络服务，则厦门市眼镜狗网络科技有限公司有权视为该用户已接受该协议条款的变动并原意受变动后协议条款的约束。\n\n七、协议生效\n用户选择同意协议并打勾，则本协议即时生效。\n\n八、厦门市眼镜狗网络科技有限公司拥有对以上各项条款和内容的最终解释权。";
    
    [self.back addTarget:self action:@selector(backSelected)];
    self.text.editable = NO;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle};
    self.text.attributedText = [[NSAttributedString alloc] initWithString:textStr attributes:attributes];
}

- (void)backSelected{
    
    [self.navigationController popViewControllerAnimated:YES];
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
