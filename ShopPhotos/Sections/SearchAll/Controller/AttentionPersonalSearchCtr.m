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
#import "AlbumPhotosRequset.h"

@interface AttentionPersonalSearchCtr ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *titleBackground;
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIView *search;
@property (weak, nonatomic) IBOutlet UIView *viewCaption;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) UICollectionView * photos;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) BOOL searchFlag;

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
    _searchFlag = NO;
    
}

- (void)setup{
    self.titleBackground.cornerRadius = 5;

    [self.back addTarget:self action:@selector(backSelected)];
    [self.search addTarget:self action:@selector(searchSelected)];
    if(self.searchKey && self.searchKey.length > 0){
        [self.searchText setText:self.searchKey];
        self.searchText.text = [self.searchText.text stringByReplacingOccurrencesOfString:@"%" withString:@""];

        NSDictionary * data = @{
                                @"type":@"concerns",
                                @"keyword":self.searchText.text};
        
        [self loadSearchData:data];
    } else {
        NSDictionary * data = @{
                                @"type":@"concerns"};
        
//        [self loadSearchData:data];
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
    self.searchText.text = [self.searchText.text stringByReplacingOccurrencesOfString:@"%" withString:@""];
    self.pageIndex = 1;

    NSDictionary * data = @{
                            @"type":@"concerns",
                            @"keyword":self.searchText.text};

    [self loadSearchData:data];
    _searchFlag = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setEditing:YES];
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.dataArray.count == 0 && _searchFlag)
    {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"没有找到你需要的哦！";
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:18];
        [messageLabel sizeToFit];
        collectionView.backgroundView = messageLabel;
    }
    else
    {
        collectionView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AttentionPersonalSearchModel * model = [self.dataArray objectAtIndex:indexPath.row];
    PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
    personalHome.uid = model.uid;
    personalHome.twoWay =YES;
    [self.navigationController pushViewController:personalHome animated:YES];

}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
#pragma makr - AFNetworking网络加载
- (void)loadSearchData:(NSDictionary *)data{
    if (data[@"keyword"]) {
        if ([[data objectForKey:@"keyword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 0) {
            [self showToast:@"请输入关键字"];
            return;
        }

    }
    
    
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
                //[weakSelef showToast:@"未搜索到结果"];
                
            }
            
        }else{
            [weakSelef showToast:requset.message];
        }
        
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

@end
