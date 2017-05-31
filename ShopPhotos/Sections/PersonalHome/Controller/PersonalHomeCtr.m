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
#import <MJRefresh.h>
#import "PersonalPhotosCtr.h"
#import <MJPhotoBrowser.h>
#import <ShareSDK/ShareSDK.h>
#import "ChattingViewController.h"
#import "SearchAllCtr.h"
#import "PublishPhotoCtr.h"
#import "AlbumPhotosModel.h"
#import "PhotosEditView.h"
#import "AlbumPhotoTableView.h"
#import "AlbumPhotosRequset.h"
#import "DynamicTableView.h"
#import "PersonalClassTable.h"
#import "AllClassifiesRequest.h"
#import "PhotoDetailsCtr.h"
#import "UserInfoDrawerCtr.h"

#import "AlbumPhotosCtr.h"
#import "AllClassModel.h"
#import "PersonalSubClassPhotoViewCtr.h"
#import "PhotoImagesRequset.h"
#import "DynamicImagesModel.h"
#import "ShareContentSelectCtr.h"
#import "DownloadImageCtr.h"
#import "CopyRequset.h"
#import "HasCollectPhotoRequset.h"
#import <ShareSDK/ShareSDK.h>
#import "PhotoImagesModel.h"
#import "SPVideoPlayer.h"
#import "KSPhotoBrowser.h"

@interface PersonalHomeCtr ()<UIScrollViewDelegate,PhotosEditViewDelegate,AlbumPhotoTableViewDelegate,PersonalClassTableDelegate,DynamicTableViewDelegate,UserInfoDrawerDelegate>{
    CGFloat screenWidth;
    NSInteger tabIndex;
    SPVideoPlayer *videoView;
}
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
@property (strong, nonatomic) UILabel *qqText;
@property (weak, nonatomic) IBOutlet UIView *chatView;
@property (strong, nonatomic) UILabel *chatText;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UILabel *recommend;
@property (weak, nonatomic) IBOutlet UILabel *dynamic;
@property (weak, nonatomic) IBOutlet UILabel *photos;
@property (weak, nonatomic) IBOutlet UILabel *photosClass;
@property (strong, nonatomic) NSString * iconURL;
@property (weak, nonatomic) IBOutlet UIView *underBar;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *baseContentView;
@property (weak, nonatomic) IBOutlet UIView *spaceView;
@property (weak, nonatomic) IBOutlet UIImageView *backIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblBack;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *iconSearch;
@property (weak, nonatomic) IBOutlet UIImageView *iconShare;
@property (weak, nonatomic) IBOutlet UIView *search;
@property (weak, nonatomic) IBOutlet UIView *share;
@property (weak, nonatomic) IBOutlet UIScrollView *dataScrollView;
@property (weak, nonatomic) IBOutlet UIView *dataContent;
@property (weak, nonatomic) IBOutlet UIView *recommendView;
@property (weak, nonatomic) IBOutlet UIView *dynamicView;
@property (weak, nonatomic) IBOutlet UIView *albumView;
@property (weak, nonatomic) IBOutlet UIView *albumClassView;
@property (weak, nonatomic) IBOutlet UIView *dataView;

@property (strong, nonatomic) NSMutableArray * recommendDataArray;
@property (strong, nonatomic) NSMutableArray * dynamicDataArray;
@property (strong, nonatomic) NSMutableArray * albumDataArray;
@property (strong, nonatomic) NSMutableArray * personalClassDataArray;

@property (strong, nonatomic) AlbumPhotoTableView * recommendTable;
@property (strong, nonatomic) DynamicTableView * dynamicTable;
@property (strong, nonatomic) AlbumPhotoTableView * albumTable;
@property (strong, nonatomic) PersonalClassTable * personalClassTable;

@property (assign, nonatomic) NSInteger itmeSelectedIndex;
@property (strong, nonatomic) NSMutableArray * imageArray;

@property (assign, nonatomic) NSInteger recommendPage;
@property (assign, nonatomic) NSInteger dynamicPage;
@property (assign, nonatomic) NSInteger albumPage;
@property (assign, nonatomic) NSInteger albumClassPage;

@property (strong, nonatomic) UserInfoDrawerCtr * userInfo;
@property (assign, nonatomic) NSInteger userInfoSelectIndex;
@property (assign, nonatomic) NSInteger shareSelectIndex;
@property (assign, nonatomic) BOOL firstFlag;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dataScrollBottom;
@property (strong, nonatomic) UIView * shareView;
@end

@implementation PersonalHomeCtr
- (NSMutableArray *)imageArray{
    if(!_imageArray) _imageArray = [NSMutableArray array];
    return _imageArray;
}

- (NSMutableArray *)recommendDataArray{
    if(!_recommendDataArray) _recommendDataArray = [NSMutableArray array];
    return _recommendDataArray;
}
- (NSMutableArray *)dynamicDataArray{
    if(!_dynamicDataArray) _dynamicDataArray = [NSMutableArray array];
    return _dynamicDataArray;
}
- (NSMutableArray *)albumDataArray{
    if(!_albumDataArray) _albumDataArray = [NSMutableArray array];
    return _albumDataArray;
}
- (NSMutableArray *)personalClassDataArray{
    if(!_personalClassDataArray) _personalClassDataArray = [NSMutableArray array];
    return _personalClassDataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:_baseContentView];
    [self.view bringSubviewToFront:_titleView];
    [self.view bringSubviewToFront:self.userInfo.view];
    [self.view bringSubviewToFront:videoView];
    
    screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    [self setup];
    
    [self loadNetworkData:@{@"uid":self.uid}];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _firstFlag = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.recommendDataArray.count == 0){
        [self.recommendTable.photos.mj_header beginRefreshing];
    }else{
        [self loadNetworkRecommendData];
    }
    
    if(self.dynamicDataArray.count == 0){
        [self.dynamicTable.table.mj_header beginRefreshing];
    }else{
        [self loadNetworkDynamicData];
    }
    if(self.albumDataArray.count == 0){
        [self.albumTable.photos.mj_header beginRefreshing];
    }else{
        [self loadNetworkAlbumData];
    }
    if (_firstFlag) {
        _dataScrollBottom.constant = _baseContentView.height - 80;
        [_contentScrollView updateConstraints];
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_firstFlag) {
        self.underBar.frame = CGRectMake(_recommend.frame.origin.x, self.underBar.frame.origin.y, self.recommend.frame.size.width, self.underBar.frame.size.height);
        [self.underBar setHidden:NO];
        _firstFlag = NO;

    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:_contentScrollView]) {
        
        switch (scrollView.panGestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
                // User began dragging
                [self.view bringSubviewToFront:_contentScrollView];
                [self.view bringSubviewToFront:_titleView];
                [self.view bringSubviewToFront:self.userInfo.view];
                [self.view bringSubviewToFront:videoView];
                [self.view bringSubviewToFront:_shareView];
                
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
    if (scrollView == self.contentScrollView) {
        NSLog(@"%f",scrollView.contentOffset.y);
        if(_contentScrollView == scrollView){
            CGFloat screenHeight = _spaceView.frame.size.height;
            if(0 <= scrollView.contentOffset.y && scrollView.contentOffset.y < screenHeight){
                _dataScrollBottom.constant = _baseContentView.height - 80;
                [_contentScrollView updateConstraints];

                [self.view bringSubviewToFront:_baseContentView];
                [self.view bringSubviewToFront:_titleView];
                [self.view bringSubviewToFront:self.userInfo.view];
                [self.view bringSubviewToFront:videoView];
                [self.view bringSubviewToFront:_shareView];
                
                [_titleView setBackgroundColor:[UIColor clearColor]];
                [self.backIcon setImage:[UIImage imageNamed:@"btn_backwhite"]];
                [self.lblBack setTextColor:[UIColor whiteColor]];
                [self.lblTitle setTextColor:[UIColor whiteColor]];
                [self.iconSearch setImage:[UIImage imageNamed:@"ico_search_w"]];
                [self.iconShare setImage:[UIImage imageNamed:@"btn_share2.png"]];
                [self.lblTitle setText:@""];
            } else {
                _dataScrollBottom.constant = 0;
                [_contentScrollView updateConstraints];

                [self.view bringSubviewToFront:_contentScrollView];
                [self.view bringSubviewToFront:_titleView];
                [self.view bringSubviewToFront:self.userInfo.view];
                [self.view bringSubviewToFront:videoView];
                [self.view bringSubviewToFront:_shareView];
                
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

    } else if (scrollView == self.dataScrollView){
        if(0 <= scrollView.contentOffset.x && scrollView.contentOffset.x < screenWidth){
            [UIView beginAnimations:nil context:nil];//动画开始
            [UIView setAnimationDuration:0.3];
            self.underBar.frame = CGRectMake(_recommend.frame.origin.x, self.underBar.frame.origin.y, self.recommend.frame.size.width, self.underBar.frame.size.height);
            
            [_recommend setTextColor:ThemeColor];
            [_dynamic setTextColor:[UIColor lightGrayColor]];
            [_photos setTextColor:[UIColor lightGrayColor]];
            [_photosClass setTextColor:[UIColor lightGrayColor]];
            tabIndex = 0;
            [UIView commitAnimations];
            
        }else if(screenWidth <= scrollView.contentOffset.x && scrollView.contentOffset.x < screenWidth * 2){
            [UIView beginAnimations:nil context:nil];//动画开始
            [UIView setAnimationDuration:0.3];
            self.underBar.frame = CGRectMake(_dynamic.frame.origin.x, self.underBar.frame.origin.y, self.recommend.frame.size.width, self.underBar.frame.size.height);
            [_recommend setTextColor:[UIColor lightGrayColor]];
            [_dynamic setTextColor:ThemeColor];
            [_photos setTextColor:[UIColor lightGrayColor]];
            [_photosClass setTextColor:[UIColor lightGrayColor]];
            tabIndex = 1;

            [UIView commitAnimations];
            
        }else if(screenWidth * 2 <= scrollView.contentOffset.x && scrollView.contentOffset.x < screenWidth * 3){
            [UIView beginAnimations:nil context:nil];//动画开始
            [UIView setAnimationDuration:0.3];
            self.underBar.frame = CGRectMake(_photos.frame.origin.x, self.underBar.frame.origin.y, self.recommend.frame.size.width, self.underBar.frame.size.height);
            [_recommend setTextColor:[UIColor lightGrayColor]];
            [_dynamic setTextColor:[UIColor lightGrayColor]];
            [_photos setTextColor:ThemeColor];
            [_photosClass setTextColor:[UIColor lightGrayColor]];
            tabIndex = 2;
            [UIView commitAnimations];
            
        }else if(screenWidth * 3 <= scrollView.contentOffset.x && scrollView.contentOffset.x < screenWidth * 4){
            [UIView beginAnimations:nil context:nil];//动画开始
            [UIView setAnimationDuration:0.3];
            self.underBar.frame = CGRectMake(_photosClass.frame.origin.x, self.underBar.frame.origin.y, self.recommend.frame.size.width, self.underBar.frame.size.height);
            [_recommend setTextColor:[UIColor lightGrayColor]];
            [_dynamic setTextColor:[UIColor lightGrayColor]];
            [_photos setTextColor:[UIColor lightGrayColor]];
            [_photosClass setTextColor:ThemeColor];
            tabIndex = 3;
            [UIView commitAnimations];
            
        }
    }
}

- (void)setup {
    [self imageArray];
    [self recommendDataArray];
    [self dynamicDataArray];
    [self albumDataArray];
    [self personalClassDataArray];
    tabIndex = 0;
    [self.back addTarget:self action:@selector(backSelected)];
    [self.headImage addTarget:self action:@selector(iconSelected)];
    self.headImage.cornerRadius = 35.5f;
    self.headImage.layer.borderWidth = 3;
    self.headImage.layer.borderColor = RGBACOLOR(220, 220, 220, 1).CGColor;
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
    [self.search addTarget:self action:@selector(searchSelected)];
    [self.share addTarget:self action:@selector(shareSelected)];
    
    self.qqText = [[UILabel alloc] init];
    self.chatText = [[UILabel alloc] init];
    
    if(self.twoWay){
        [self.attentionLabel setText:@"取消关注"];
        [self.attention setImage:[UIImage imageNamed:@"ico_favorite_done"] forState:UIControlStateNormal];
    }else{
        [self.attentionLabel setText:@"立刻关注"];
        [self.attention setImage:[UIImage imageNamed:@"ico_concern"] forState:UIControlStateNormal];
    }
    self.recommendTable = [[AlbumPhotoTableView alloc] init];
    self.recommendTable.delegate = self;
    self.recommendTable.isVideo = NO;
    [self.recommendView addSubview:self.recommendTable];
    
    __weak __typeof(self)weakSelef = self;
    self.recommendTable.photos.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadNetworkRecommendData];
    }];
    
    self.recommendTable.sd_layout
    .leftEqualToView(self.recommendView)
    .rightEqualToView(self.recommendView)
    .topSpaceToView(self.recommendView,0)
    .bottomSpaceToView(self.recommendView,0);
    
    self.dynamicTable = [[DynamicTableView alloc] init];
    self.dynamicTable.delegate = self;
    self.dynamicTable.isMyDynamic = FALSE;
    [self.dynamicView addSubview:self.dynamicTable];
    
    self.dynamicTable.sd_layout
    .leftEqualToView(self.dynamicView)
    .rightEqualToView(self.dynamicView)
    .topSpaceToView(self.dynamicView,0)
    .bottomSpaceToView(self.dynamicView,0);
    
    self.dynamicTable.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelef loadNetworkDynamicData];
    }];
    [self.dynamicTable.table.mj_header beginRefreshing];
    
    self.albumTable = [[AlbumPhotoTableView alloc] init];
    self.albumTable.delegate = self;
    self.albumTable.isVideo = NO;
    [self.albumView addSubview:self.albumTable];
    
    self.albumTable.photos.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadNetworkAlbumData];
    }];
    
    self.albumTable.sd_layout
    .leftEqualToView(self.albumView)
    .rightEqualToView(self.albumView)
    .topSpaceToView(self.albumView,0)
    .bottomSpaceToView(self.albumView,0);

    self.personalClassTable = [[PersonalClassTable alloc] init];
    self.personalClassTable.delegate = self;
    [self.albumClassView addSubview:self.personalClassTable];
    self.personalClassTable.sd_layout
    .leftEqualToView(self.albumClassView)
    .rightEqualToView(self.albumClassView)
    .topSpaceToView(self.albumClassView,0)
    .bottomEqualToView(self.albumClassView);
    
    self.personalClassTable.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelef loadNetworkAlbumClassData];
    }];
    [self.personalClassTable.table.mj_header beginRefreshing];
    
    self.userInfo = GETALONESTORYBOARDPAGE(@"UserInfoDrawerCtr");
    self.userInfo.delegate = self;
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self.userInfo.view];
    [self.userInfo closeDrawe];
    [self.userInfo.view setHidden:YES];

    videoView = [[SPVideoPlayer alloc] init];
    videoView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
}

- (void)loadNetworkRecommendData{
    self.recommendPage = 1;
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.recommendPage],
                            @"pageSize":@"30",
                            @"keyWord":@"false"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getRecommendPhotos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        [weakSelef.recommendTable.photos.mj_header endRefreshing];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.recommendPage++;
            weakSelef.recommendTable.photos.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkRecommendMoreData];
            }];
            if(requset.dataArray.count < 30){
                [weakSelef.recommendTable.photos.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.recommendTable.photos.mj_footer setHidden:YES];
            }else{
                [weakSelef.recommendTable.photos.mj_footer resetNoMoreData];
            }
            [weakSelef.recommendDataArray removeAllObjects];
            [weakSelef.recommendDataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.recommendTable loadData:weakSelef.recommendDataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef.recommendTable.photos.mj_header endRefreshing];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)loadNetworkRecommendMoreData{
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.recommendPage],
                            @"pageSize":@"30",
                            @"keyWord":@"false"};
    
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getRecommendPhotos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        [weakSelef.recommendTable.photos.mj_footer endRefreshing];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.recommendPage ++;
            if(requset.dataArray.count < 30){
                [weakSelef.recommendTable.photos.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.recommendTable.photos.mj_footer setHidden:YES];
            }else{
                [weakSelef.recommendTable.photos.mj_footer resetNoMoreData];
            }
            [weakSelef.recommendDataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.recommendTable loadMoreData:requset.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef.recommendTable.photos.mj_footer endRefreshing];
    }];
}

- (void)loadNetworkDynamicData {
    self.dynamicPage= 1;
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.dynamicPage],
                            @"pageSize":@"20"};
    NSLog(@"%@",data);
    __weak __typeof(self)weakSelef = self;
    
    NSString *serverApi = @"";
    serverApi = self.congfing.getUserDynamics;
    
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        [weakSelef.dynamicTable.table.mj_header endRefreshing];
        //        DynamicRequset * requset = [[DynamicRequset alloc] init];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.dynamicPage ++;
            weakSelef.dynamicTable.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkDynamicMoreData];
            }];
            
            if(requset.dataArray.count == 20){
                [weakSelef.dynamicTable.table.mj_footer resetNoMoreData];
            }else{
                [weakSelef.dynamicTable.table.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.dynamicTable.table.mj_footer setHidden:YES];
            }
            [weakSelef.dynamicDataArray removeAllObjects];
            [weakSelef.dynamicDataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.dynamicTable loadData:weakSelef.dynamicDataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef.dynamicTable.table.mj_header endRefreshing];
    }];
}

- (void)loadNetworkDynamicMoreData{
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.dynamicPage],
                            @"pageSize":@"20"};
    NSLog(@"%@",data);
    __weak __typeof(self)weakSelef = self;
    
    NSString *serverApi = @"";
    serverApi = self.congfing.getUserDynamics;
    
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        [weakSelef.dynamicTable.table.mj_footer endRefreshing];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        
        //        DynamicRequset * requset = [[DynamicRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.dynamicPage ++;
            if(requset.dataArray.count == 20){
                [weakSelef.dynamicTable.table.mj_footer resetNoMoreData];
            }else{
                [weakSelef.dynamicTable.table.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.dynamicTable.table.mj_footer setHidden:YES];
            }
            [weakSelef.dynamicDataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.dynamicTable loadMoreData:requset.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
    } failure:^(NSError *error){
        [weakSelef.dynamicTable.table.mj_footer endRefreshing];
    }];
}

- (void)loadNetworkAlbumData{
    self.albumPage = 1;
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.albumPage],
                            @"pageSize":@"30",
                            @"keyWord":@"false"};
    //                            @"subclassification_id":@"0"};
    __weak __typeof(self)weakSelef = self;
    
    NSString *serverApi = @"";
    serverApi = self.congfing.getUserPhotos;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        NSLog(@"1  %@",responseObject);
        
        [weakSelef.albumTable.photos.mj_header endRefreshing];
        
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.albumPage ++;
            weakSelef.albumTable.photos.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelef loadNetworkAlbumMoreData];
            }];
            if(requset.dataArray.count < 30){
                [weakSelef.albumTable.photos.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.albumTable.photos.mj_footer setHidden:YES];
            }else{
                [weakSelef.albumTable.photos.mj_footer resetNoMoreData];
            }
            [weakSelef.albumDataArray removeAllObjects];
            [weakSelef.albumDataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.albumTable loadData:weakSelef.albumDataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef.albumTable.photos.mj_header endRefreshing];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)loadNetworkAlbumMoreData{
    
    NSDictionary * data = @{@"uid":self.uid,
                            @"page":[NSString stringWithFormat:@"%ld",self.albumPage],
                            @"pageSize":@"30",
                            @"keyWord":@"false",
                            @"subclassification_id":@"0"};
    
    __weak __typeof(self)weakSelef = self;
    NSString *serverApi = @"";
    serverApi = self.congfing.getUserPhotos;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",serverApi,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        
        [weakSelef.albumTable.photos.mj_footer endRefreshing];
        AlbumPhotosRequset * requset = [[AlbumPhotosRequset alloc] init];
        [requset analyticInterface:responseObject];
        if(requset.status == 0){
            weakSelef.albumPage ++;
            if(requset.dataArray.count < 30){
                [weakSelef.albumTable.photos.mj_footer endRefreshingWithNoMoreData];
                [weakSelef.albumTable.photos.mj_footer setHidden:YES];
            }else{
                [weakSelef.albumTable.photos.mj_footer resetNoMoreData];
            }
            [weakSelef.albumDataArray addObjectsFromArray:requset.dataArray];
            [weakSelef.albumTable loadMoreData:requset.dataArray];
        }else{
            [weakSelef showToast:requset.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef.albumTable.photos.mj_footer endRefreshing];
    }];
}

- (void)loadNetworkAlbumClassData {
    
    NSDictionary *data = @{@"uid":self.uid};
    NSString *url = nil;
    CongfingURL * config = [self getValueWithKey:ShopPhotosApi];
    url = config.getAllClassifies;

    __weak __typeof(self)weakSelef = self;
    
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",url,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef.personalClassTable.table.mj_header endRefreshing];
        NSLog(@"%@",responseObject);
        AllClassifiesRequest * model = [[AllClassifiesRequest alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef.personalClassDataArray removeAllObjects];
            [weakSelef.personalClassDataArray addObjectsFromArray:model.dataArray];
            weakSelef.personalClassTable.dataArray = weakSelef.personalClassDataArray;
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef.personalClassTable.table.mj_header endRefreshing];
    }];
}

#pragma mark -OnClick

- (void)backSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) shareSelected {
    [self.appd showShare2view:self];
}

- (void)searchSelected{
    SearchAllCtr * search = GETALONESTORYBOARDPAGE(@"SearchAllCtr");
    search.uid = self.photosUserID;
    [self.navigationController pushViewController:search animated:YES];

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
        return;
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
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    self.underBar.frame = CGRectMake(_recommend.frame.origin.x, self.underBar.frame.origin.y, self.recommend.frame.size.width, self.underBar.frame.size.height);
    
    [_recommend setTextColor:ThemeColor];
    [_dynamic setTextColor:[UIColor lightGrayColor]];
    [_photos setTextColor:[UIColor lightGrayColor]];
    [_photosClass setTextColor:[UIColor lightGrayColor]];
    [_dataScrollView setContentOffset:CGPointMake(0, 0)];
    tabIndex = 0;
    [UIView commitAnimations];
    
}
- (void)dynamicSelected{
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    self.underBar.frame = CGRectMake(_dynamic.frame.origin.x, self.underBar.frame.origin.y, self.recommend.frame.size.width, self.underBar.frame.size.height);
    [_recommend setTextColor:[UIColor lightGrayColor]];
    [_dynamic setTextColor:ThemeColor];
    [_photos setTextColor:[UIColor lightGrayColor]];
    [_photosClass setTextColor:[UIColor lightGrayColor]];
    [_dataScrollView setContentOffset:CGPointMake(screenWidth, 0)];
    tabIndex = 1;
    [UIView commitAnimations];
    
}
- (void)photosSelected{
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    self.underBar.frame = CGRectMake(_photos.frame.origin.x, self.underBar.frame.origin.y, self.recommend.frame.size.width, self.underBar.frame.size.height);
    [_recommend setTextColor:[UIColor lightGrayColor]];
    [_dynamic setTextColor:[UIColor lightGrayColor]];
    [_photos setTextColor:ThemeColor];
    [_photosClass setTextColor:[UIColor lightGrayColor]];
    [_dataScrollView setContentOffset:CGPointMake(screenWidth * 2, 0)];
    tabIndex = 2;
    [UIView commitAnimations];
}
- (void)photosClassSelected{
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    self.underBar.frame = CGRectMake(_photosClass.frame.origin.x, self.underBar.frame.origin.y, self.recommend.frame.size.width, self.underBar.frame.size.height);
    [_recommend setTextColor:[UIColor lightGrayColor]];
    [_dynamic setTextColor:[UIColor lightGrayColor]];
    [_photos setTextColor:[UIColor lightGrayColor]];
    [_photosClass setTextColor:ThemeColor];
    [_dataScrollView setContentOffset:CGPointMake(screenWidth * 3, 0)];
    tabIndex = 3;
    [UIView commitAnimations];
}

#pragma mark - 修改样式
- (void)setStyle:(UserInfoModel *)model{
    
//    [self.head sd_setImageWithURL:[NSURL URLWithString:model.bg_image] placeholderImage:[UIImage imageNamed:@"personal_back.png"]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"default-avatar.png"]];
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
        str = [NSString stringWithFormat:@""];
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
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
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
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
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
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
        [weakSelef closeLoad];
    }];
    
}

#pragma mark - AlbumPhotoTableViewDelegate
- (void)albumPhotoSelectPath:(NSInteger)indexPath{
    if (tabIndex == 0) {
        AlbumPhotosModel * model = [self.recommendDataArray objectAtIndex:indexPath];
        PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
        photoDetails.photoId = model.Id;
        [self.navigationController pushViewController:photoDetails animated:YES];

    } else if (tabIndex == 2) {
        AlbumPhotosModel * model = [self.albumDataArray objectAtIndex:indexPath];
        PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
        photoDetails.photoId = model.Id;
        [self.navigationController pushViewController:photoDetails animated:YES];
        
    }
}

#pragma mark - UserInfoDrawerDelegate
- (void)userInfoDrawerHeadSelected:(NSInteger)type{
    if (tabIndex == 1) {
        if(type == 1){
            //        DynamicModel * model = [self.dataArray objectAtIndex:self.userInfoSelectIndex];
            AlbumPhotosModel * model = [self.recommendDataArray objectAtIndex:self.userInfoSelectIndex];
            NSMutableArray *photos = [NSMutableArray array];
            MJPhoto * photo = [[MJPhoto alloc] init];
            if([model.user objectForKey:@"icon"]){
                photo.url = [NSURL URLWithString:[model.user objectForKey:@"icon"]];
                [photos addObject:photo];
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.currentPhotoIndex = 0;
                browser.photos = photos;
                [browser show];
            }
        }

    }
}
- (void)userInfoDrawerCellSelected:(UserInfoModel *)model WithType:(NSInteger)type{
    
    NSLog(@"--%@ -- %@",model.wechat,model.qq);
    
    if(type == 0){
        
        PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
        personalHome.uid = model.uid;
        personalHome.twoWay = YES;
        [self.navigationController pushViewController:personalHome animated:YES];
        
    }else if(type == 1){
    }else if(type == 2){
        
        NSString * chatStr = model.wechat;
        if(chatStr && chatStr.length > 0){
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = chatStr;
        }else{
            [self showToast:@"微信号为空"];
        }
        __weak __typeof(self)weakSelef = self;
        NSString * msg = [NSString stringWithFormat:@"微信号已复制，可以进入微信粘贴"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"打开微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"] options:@{} completionHandler:nil];
            }else{
                [weakSelef showToast:@"您没有安装微信"];
            }
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if(type == 3){
        
        NSString * qqStr = model.qq;
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
        [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"打开QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mqq://"] options:@{} completionHandler:nil];
            }else{
                [weakSelef showToast:@"您没有安装QQ"];
            }
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)shareClicked:(NSIndexPath *)indexPath {
    self.itmeSelectedIndex = indexPath.row;
    //    [self showLoad];
    [self getPhotoImages];
    
    AlbumPhotosModel * model = [[AlbumPhotosModel alloc] init];
    if (tabIndex == 0) {
        model = [self.recommendDataArray objectAtIndex:self.itmeSelectedIndex];
    } else if (tabIndex == 2) {
        model = [self.albumDataArray objectAtIndex:self.itmeSelectedIndex];
    }

    self.shareView = [self.appd showShareview:model.type collected:model.collected model:model from:self];
}
- (void)pyqClicked:(NSIndexPath *)indexPath {
    self.itmeSelectedIndex = indexPath.row;
    //    [self showLoad];
    [self getPhotoImages];
    NSMutableArray * images = [NSMutableArray array];
    for(PhotoImagesModel * imageModel in _imageArray){
        DynamicImagesModel * model = [[DynamicImagesModel alloc] init];
        model.bigImageUrl = imageModel.bigImageUrl;
        model.thumbnailUrl = imageModel.thumbnailUrl;
        [images addObject:model];
    }
    AlbumPhotosModel * model = [[AlbumPhotosModel alloc] init];
    if (tabIndex == 0) {
        model = [self.recommendDataArray objectAtIndex:self.itmeSelectedIndex];
    } else if (tabIndex == 2) {
        model = [self.albumDataArray objectAtIndex:self.itmeSelectedIndex];
    }
    
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = model.title;
    ShareContentSelectCtr * shareSelect = GETALONESTORYBOARDPAGE(@"ShareContentSelectCtr");
    shareSelect.dataArray = images;
    [self.navigationController pushViewController:shareSelect animated:YES];
}

- (void)collectPhoto:(NSDictionary *)data{
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.collectPhoto,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"收藏成功"];
            if (tabIndex == 0)
                [weakSelef loadNetworkRecommendData];
            else if (tabIndex == 1)
                [weakSelef loadNetworkDynamicData];
            else if (tabIndex == 2)
                [weakSelef loadNetworkAlbumData];
        }else{
            [weakSelef showToast:model.message];
        }
        
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}
- (void)collectVideo:(NSDictionary *)data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestPOSTUrl:[NSString stringWithFormat:@"%@%@",self.congfing.collectVideo,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        [model analyticInterface:responseObject];
        if(model.status == 0){
            [weakSelef showToast:@"收藏成功"];
            [weakSelef loadNetworkDynamicData];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)cancelCollectPhotos:(NSDictionary * )data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",self.congfing.cancelCollectPhotos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [weakSelef showToast:@"取消收藏成功"];
            if (tabIndex == 0)
                [weakSelef loadNetworkRecommendData];
            else if (tabIndex == 1)
                [weakSelef loadNetworkDynamicData];
            else if (tabIndex == 2)
                [weakSelef loadNetworkAlbumData];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}

- (void)cancelCollectVideos:(NSDictionary * )data{
    
    [self showLoad];
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestDELETEUrl:[NSString stringWithFormat:@"%@%@",self.congfing.cancelCollectVideos,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        [weakSelef closeLoad];
        NSLog(@"%@",responseObject);
        BaseModel * model = [[BaseModel alloc] init];
        if(model.status == 0){
            [weakSelef showToast:@"取消收藏成功"];
            [weakSelef loadNetworkDynamicData];
        }else{
            [weakSelef showToast:model.message];
        }
    } failure:^(NSError *error){
        [weakSelef closeLoad];
        [weakSelef showToast:[NSString stringWithFormat:@"%@", error]];//NETWORKTIPS];
    }];
}


- (void)getPhotoImages{
    [_imageArray removeAllObjects];
    AlbumPhotosModel * model = [[AlbumPhotosModel alloc] init];
    if (tabIndex == 0) {
        model = [self.recommendDataArray objectAtIndex:self.itmeSelectedIndex];
    } else if (tabIndex == 1) {
        model = [self.dynamicDataArray objectAtIndex:self.itmeSelectedIndex];
    } else if (tabIndex == 2) {
        model = [self.albumDataArray objectAtIndex:self.itmeSelectedIndex];
    }
    for(NSDictionary * image in model.images){
        PhotoImagesModel * model = [[PhotoImagesModel alloc] init];
        model.Id = [NSString stringWithFormat:@"%ld",(long)[RequestErrorGrab getIntegetKey:@"id" toTarget:image]];
        //                model.imageLink_id = [NSString stringWithFormat:@"%ld",[RequestErrorGrab getIntegetKey:@"imageLink_id" toTarget:images]];
        model.thumbnailUrl = [RequestErrorGrab getStringwitKey:@"thumbnailUrl" toTarget:image];
        model.bigImageUrl = [RequestErrorGrab getStringwitKey:@"bigImageUrl" toTarget:image];
        model.srcUrl = [RequestErrorGrab getStringwitKey:@"srcUrl" toTarget:image];
        model.isCover = [RequestErrorGrab getBooLwitKey:@"isCover" toTarget:image];
        if (model.isCover) {
            [_imageArray insertObject:model atIndex:0];
        }else{
            [_imageArray addObject:model];
        }
    }

}

- (void)loadUserNetworkData:(NSDictionary *)data{
    __weak __typeof(self)weakSelef = self;
    [HTTPRequest requestGETUrl:[NSString stringWithFormat:@"%@%@",self.congfing.getUserInfo,[self.appd getParameterString]] parametric:data succed:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        
        UserInfoModel * infoModel = [[UserInfoModel alloc] init];
        [infoModel analyticInterface:responseObject];
        if(infoModel.status == 0){
            PersonalHomeCtr * personalHome = GETALONESTORYBOARDPAGE(@"PersonalHomeCtr");
            personalHome.uid = infoModel.uid;
            personalHome.twoWay = YES;
            [self.navigationController pushViewController:personalHome animated:YES];

//            [weakSelef.userInfo setStyle:infoModel];
//            [weakSelef.userInfo showDrawe];
        }else{
            [self showToast:infoModel.message];
        }
    } failure:nil];
}

#pragma mark - DynamicViewCellDelegate
- (void)cellSelectType:(NSInteger)type tableViewCelelIndexPath:(NSIndexPath *)indexPath{
    
    AlbumPhotosModel * model = [self.dynamicDataArray objectAtIndex:indexPath.row];
    
    if(type == 1){
        self.userInfoSelectIndex = indexPath.row;
        NSString * uid = [model.user objectForKey:@"uid"];
        if(uid && uid.length > 0){
            [self loadUserNetworkData:@{@"uid":uid}];
        }
    }
    else if(type == 2){
        self.itmeSelectedIndex = indexPath.row;
        [self.appd showShareview:model.type collected:model.collected model:model from:self];
    }
    else if(type == 3){
        self.userInfoSelectIndex = indexPath.row;
        NSString * uid = [model.user objectForKey:@"uid"];
        if(uid && uid.length > 0){
            [self loadUserNetworkData:@{@"uid":uid}];
        }
    }
    else if (type == 4) { // collect
        if ([self.photosUserID isEqualToString:[model.user objectForKey:@"uid"]]) {
            [self showToast:@"can't collect your photos"];
        }
        else {
            if (model.collected == YES) {
                // cancel collect
                if ([model.type isEqualToString:@"photo"]) [self cancelCollectPhotos:@{@"photosId[0]":model.Id}];
                if ([model.type isEqualToString:@"video"]) [self cancelCollectVideos:@{@"videosId[0]":model.Id}];
                
            }
            else {
                // add collect
                if ([model.type isEqualToString:@"photo"]) [self collectPhoto:@{@"photoId":model.Id}];
                if ([model.type isEqualToString:@"video"]) [self collectVideo:@{@"videoId":model.Id}];
            }
        }
    }
    else if (type == 5) { // chat
        NSLog(@"%ld", type);
        NSString * uid = [model.user objectForKey:@"uid"];
        if ([self.photosUserID isEqualToString:uid]) {
            [self showToast:@""];
        }
        else {
            if(uid && uid.length > 0){
                ChattingViewController *conversationVC = [[ChattingViewController alloc]init];
                conversationVC.conversationType = ConversationType_PRIVATE;
                conversationVC.targetId = uid;
                conversationVC.name = [model.user objectForKey:@"name"];
                conversationVC.twoWay = _twoWay;
                [self.navigationController pushViewController:conversationVC animated:YES];
            }
        }
    }
    else if (type == 6) { // pengyou qiu
        NSLog(@"%ld", type);
        NSMutableArray * images = [NSMutableArray array];
        for (NSDictionary * dict in model.images) {
            DynamicImagesModel * dynamic = [[DynamicImagesModel alloc] init];
            dynamic.Id = [[dict objectForKey:@"id"] integerValue];
            dynamic.bigImageUrl = [dict objectForKey:@"bigImageUrl"];
            dynamic.thumbnailUrl = [dict objectForKey:@"thumbnailUrl"];
            dynamic.select = NO;
            
            [images addObject:dynamic];
        }
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = model.title;
        ShareContentSelectCtr * shareSelect = GETALONESTORYBOARDPAGE(@"ShareContentSelectCtr");
        shareSelect.dataArray = images;
        [self.navigationController pushViewController:shareSelect animated:YES];
    }
    else if (type == 7) { // delete
//        if ([model.type isEqualToString:@"photo"]) [self deleteMyPhotos:@{@"photosId[0]":model.Id}];
//        if ([model.type isEqualToString:@"video"]) [self deleteMyVideos:@{@"videosId[0]":model.Id}];
    }
}

- (void)cellImageSelected:(NSInteger)tag TabelViewCellIndexPath:(NSIndexPath *)indexPath{
    
    if (tag > -1) {
        AlbumPhotosModel * model = [self.dynamicDataArray objectAtIndex:indexPath.row];
        NSInteger count = model.images.count;
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            NSDictionary * imageModel = [model.images objectAtIndex:i];
            NSString * url = [imageModel objectForKey:@"bigImageUrl"];
            UIImageView * imageView = [[UIImageView alloc] init];
            KSPhotoItem * item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
            [photos addObject:item];
        }
        
        if(photos.count > 0){
            KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:photos selectedIndex:tag];
            [browser showFromViewController:self];
        }
    }
    else {
        // click video
        videoView = [[SPVideoPlayer alloc] init];
        videoView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
        [self.view addSubview:videoView];
        [self.view bringSubviewToFront:videoView];
        
        AlbumPhotosModel * model = [self.dynamicDataArray objectAtIndex:indexPath.row];
        [videoView playVideo:model.video];
    }
}

- (void)dynamicTableCellSelected:(NSIndexPath *)indexPath{
    AlbumPhotosModel * model = [self.dynamicDataArray objectAtIndex:indexPath.row];
    NSString * uid = [model.user objectForKey:@"uid"];
    
    PhotoDetailsCtr * photoDetails = GETALONESTORYBOARDPAGE(@"PhotoDetailsCtr");
    photoDetails.photoId = model.Id;
    if(uid && ![uid isEqualToString:self.photosUserID]){
        photoDetails.persona = YES;
    }
    
    [self.navigationController pushViewController:photoDetails animated:YES];
}

#pragma mark - PersonalClassTableDelegate
- (void)personalClassTableSelected:(NSIndexPath *)indexPath{
    
    AllClassModel *classModel = [self.personalClassDataArray objectAtIndex:indexPath.section];
    
    
    PersonalSubClassPhotoViewCtr * subClassPhotos = [[PersonalSubClassPhotoViewCtr alloc] initWithNibName:@"PersonalSubClassPhotoViewCtr" bundle:nil];
    subClassPhotos.uid = self.photosUserID;
    subClassPhotos.subClassid = [[[classModel.subclasses objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    subClassPhotos.strTitle = [[classModel.subclasses objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:subClassPhotos animated:YES];
}

- (void)personalClassTableHeadSelectType:(NSInteger)type slectedPath:(NSInteger)section{}
- (void)personalClassTableSelectType:(NSInteger)type selectPath:(NSIndexPath *)indexPath{}

@end
