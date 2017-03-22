//
//  TabBarView.m
//  ShopPhotos
//
//  Created by 廖检成 on 16/12/19.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "TabBarView.h"
#import "TabBarItem.h"
#import "TabBarModel.h"

@interface TabBarView ()

@property (strong, nonatomic) TabBarItem * selectTabBar;

@end

@implementation TabBarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createAutoLayout];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,1);
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowRadius = 3;
    }
    return self;
}

- (void)createAutoLayout{
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    TabBarModel * model1 = [[TabBarModel alloc] init];
    model1.defaultImage = @"ico_home_default";
    model1.selectedImage = @"ico_home_selected";
    model1.text = @"主页";
    
    TabBarModel * model2 = [[TabBarModel alloc] init];
    model2.defaultImage = @"ico_feed_default";
    model2.selectedImage = @"ico_feed_selected";
    model2.text = @"动态";
    
    TabBarModel * model3 = [[TabBarModel alloc] init];
    //model3.imageName = @"";
    model3.text = @"";
    
    TabBarModel * model4 = [[TabBarModel alloc] init];
    model4.defaultImage = @"ico_follow_default";
    model4.selectedImage = @"ico_follow_selected";
    model4.text = @"关注";
    
    TabBarModel * model5 = [[TabBarModel alloc] init];
    model5.defaultImage = @"ico_mine_default";
    model5.selectedImage = @"ico_mine_selected";
    model5.text = @"我";
    
    NSArray * tabbarArray = @[model1,model2,model3,model4,model5];
    CGFloat width = WindowWidth/ tabbarArray.count;
    
    for(NSInteger index = 0; index < tabbarArray.count; index++){
        if(index == 2){
            
            UIImageView * item = [[UIImageView alloc] init];
            [item setImage:[UIImage imageNamed:@"btn_publish"]];
            [item addTarget:self action:@selector(tabbarItemSelect:)];
            [self addSubview:item];
            item.tag = index;
            item.sd_layout
            .leftSpaceToView(self,width*index)
            .topEqualToView(self)
            .bottomEqualToView(self)
            .widthIs(width);
            
        }else{
            TabBarItem * item = [[TabBarItem alloc] initWithModel:[tabbarArray objectAtIndex:index]];
            [self addSubview:item];
            [item addTarget:self action:@selector(tabbarItemSelect:)];
            item.tag = index;
            item.sd_layout
            .leftSpaceToView(self,width*index)
            .topEqualToView(self)
            .bottomEqualToView(self)
            .widthIs(width);
            
            if(index == 0){
                [item setStyleSelected];
                self.selectTabBar = item;
            }
        }
    }
}

- (void)tabbarItemSelect:(UITapGestureRecognizer *)tap{
    
    NSInteger tag = tap.view.tag;
    
    if(tag != 2){
        [self.selectTabBar setStyleDefault];
        self.selectTabBar = (TabBarItem *)tap.view;
        [self.selectTabBar setStyleSelected];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(tabbarSelect:)]){
        
        [self.delegate tabbarSelect:tag];
    }
}
@end