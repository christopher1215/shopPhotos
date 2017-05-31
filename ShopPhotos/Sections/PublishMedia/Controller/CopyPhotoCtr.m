//
//  CopyPhotoCtr.m
//  ShopPhotos
//
//  Created by PKJ on 5/10/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "CopyPhotoCtr.h"
#import "AlbumClassCtr.h"
#import "AlbumPhotosRequset.h"
#import "PhotoImagesRequset.h"
#import "PhotoImagesModel.h"
#import "PublishPhotoCtr.h"

@interface CopyPhotoCtr ()
@property (weak, nonatomic) IBOutlet UIView *classView;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (strong, nonatomic) NSString* classify_id;
@property (strong, nonatomic) NSString* subclassification_id;

@end

@implementation CopyPhotoCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.classView addTarget:self action:@selector(selectClass)];
    self.copySuccess = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    if (self.copySuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)copyPhoto:(id)sender {
    
    [self showLoad];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    
    [data setValue:self.srcPhotoId forKey:@"photoId"];
    [data setValue:self.classify_id forKey:@"classifyName"];
    [data setValue:self.subclassification_id forKey:@"subclassName"];
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl :[NSString stringWithFormat:@"%@%@",config.ccopyPhoto,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [weakSelef showToast:@"复制成功"];
            weakSelef.copySuccess = YES;
            
            AlbumPhotosModel *model = [requset.dataArray objectAtIndex:0];
            PhotoImagesRequset * requset = [[PhotoImagesRequset alloc] init];
            [requset analyticInterface:model.images];
            if(requset.status == 0){
                NSMutableArray *imageArray = [NSMutableArray array];
                [imageArray addObjectsFromArray:requset.dataArray];
                NSInteger index = 0;
                for (PhotoImagesModel *imageModel in imageArray) {
                    if (index == 0) {
                        imageModel.isCover = YES;
                    }
                    imageModel.edit = YES;
                    imageModel.isNew = NO;
                    index ++;
                }
                // send photo edit
                PublishPhotoCtr * publish = GETALONESTORYBOARDPAGE(@"PublishPhotoCtr");
                publish.editData = @{@"images":imageArray, @"title":model.title,
                                     @"remarks":model.desc,@"photoId":model.Id,
                                     @"headtitle":model.title,@"parentclass":[model.classify objectForKey:@"name"],
                                     @"subclass":[model.subclass objectForKey:@"name"],@"recommend":[NSNumber numberWithBool:model.recommend]};
                
                publish.isAdd = YES;
                [self.navigationController pushViewController:publish animated:YES];
            }
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) selectClass {
    AlbumClassCtr * albumClass = GETALONESTORYBOARDPAGE(@"AlbumClassCtr");
    albumClass.isSubClass = NO;
    albumClass.uid = self.photosUserID;
    albumClass.isFromCopyPhoto = YES;
    albumClass.fromCtr = self;
    [self.navigationController pushViewController:albumClass animated:YES];
}

- (void)setClassifies:(NSString *)parent subClass:(NSString *)subclass {
    _classify_id = [NSString stringWithString:parent];
    _subclassification_id = [NSString stringWithString:subclass];
    [self.classLabel setText:[NSString stringWithFormat:@"%@/%@",parent,subclass]];
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
