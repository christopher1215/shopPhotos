//
//  AttentionPersonalSearchCtr.m
//  ShopPhotos
//
//  Created by addcn on 17/1/1.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "AttentionPersonalSearchCtr.h"
#import "AttentionPersonalSearchCell.h"
#import "AttentionPersonalSearchRequset.h"
#import "AttentionPersonalSearchModel.h"
#import "PersonalHomeCtr.h"


@interface AttentionPersonalSearchCtr ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *titleBackground;
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIView *search;
@property (weak, nonatomic) IBOutlet UIView *viewCaption;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) UICollectionView * photos;
@property (assign, nonatomic) NSInteger pageIndex;


@end

@implementation AttentionPersonalSearchCtr

- (NSMutableArray *)dataArray{
    if(!_dataArray) _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}

- (void)setup{
    self.titleBackground.cornerRadius = 5;

    [self.back addTarget:self action:@selector(backSelected)];
    [self.search addTarget:self action:@selector(searchSelected)];
    if(self.searchKey && self.searchKey.length > 0){
        [self.searchText setText:self.searchKey];
        [self loadSearchData];
    }
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.photos = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.photos.delegate=self;
    self.photos.dataSource=self;
    [self.photos setBackgroundColor:ColorHex(0Xeeeeee)];
    [self.photos registerClass:[AttentionPersonalSearchCell class] forCellWithReuseIdentifier:AttentionPersonalSearchCellID];
    [self.view addSubview:self.photos];
    
    self.photos.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.viewCaption,0)
    .bottomEqualToView(self.view);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchText) {
        [self searchSelected];
        return NO;
    }
    return YES;
}

#pragma mark - OnClick
- (void)backSelected{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)searchSelected{
    [self.searchText resignFirstResponder];
    if(!self.searchText.text ||self.searchText.text.length == 0){
        SPAlert(@"请输入搜索关键字",self);
        return;
    }
    
    [self.dataArray removeAllObjects];
    [self.photos reloadData];
    
    [self loadSearchData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setEditing:YES];
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = AttentionPersonalSearchCellID;
    AttentionPersonalSearchCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WindowWidth, 60);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AttentionPersonalSearchModel * model = [self.dataArray objectAtIndex:indexPath.row];
    PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
    personalHome.uid = model.uid;
    personalHome.twoWay =YES;
    [self.navigationController pushViewController:personalHome animated:YES];

}

#pragma makr - AFNetworking网络加载
- (void)loadSearchData{
    
    self.pageIndex = 1;
    NSDictionary * data = @{
                            @"type":@"concerns",
                            @"keyword":self.searchText.text};
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.searchUsers,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        
        AttentionPersonalSearchRequset * requset = [[AttentionPersonalSearchRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            [weakSelef.dataArray removeAllObjects];
            [weakSelef.dataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.photos reloadData];
            if(requset.dataArray.count == 0){
                [weakSelef showToast:@"未搜索到结果"];
            }
            
        }else{
            [weakSelef showToast:requset.message];
        }
        
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:NETWORKTIPS];
    }];
}

@end
