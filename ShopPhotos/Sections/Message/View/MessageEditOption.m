//
//  MessageEditOption.m
//  ShopPhotos
//
//  Created by addcn on 16/12/28.
//  Copyright © 2016年 addcn. All rights reserved.
//

#import "MessageEditOption.h"



@implementation MessageEditOption

- (instancetype)init
{
    self = [super init];
    if (self) {
    
        [self createAutoLayout];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)createAutoLayout{
    
    UIButton * allSelect = [UIButton buttonWithType:UIButtonTypeSystem];
    [allSelect setBackgroundColor:[UIColor whiteColor]];
    [allSelect setTitle:@"全选" forState:UIControlStateNormal];
    allSelect.tag = 111;
    [allSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allSelect addTarget:self action:@selector(editSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:allSelect];
    
    UIView * line1 = [[UIView alloc] init];
    [line1 setBackgroundColor:ColorHex(0XEEEEEE)];
    [self addSubview:line1];
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setBackgroundColor:[UIColor whiteColor]];
    deleteBtn.tag = 112;
    [deleteBtn addTarget:self action:@selector(editSelected:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:deleteBtn];
    
    UIView * line2 = [[UIView alloc] init];
    [line2 setBackgroundColor:ColorHex(0XEEEEEE)];
    [self addSubview:line2];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    cancelBtn.tag = 113;
    [cancelBtn addTarget:self action:@selector(editSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:cancelBtn];
    
    UIView * line3 = [[UIView alloc] init];
    [line3 setBackgroundColor:ColorHex(0XEEEEEE)];
    [self addSubview:line3];
    
    allSelect.sd_layout
    .leftSpaceToView(self,5)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs((WindowWidth-30)/3);
    
    line1.sd_layout
    .leftSpaceToView(allSelect,4)
    .topSpaceToView(self,5)
    .bottomSpaceToView(self,5)
    .widthIs(2);
    
    deleteBtn.sd_layout
    .leftSpaceToView(line1,4)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs((WindowWidth-30)/3);
    
    line2.sd_layout
    .leftSpaceToView(deleteBtn,4)
    .topSpaceToView(self,5)
    .bottomSpaceToView(self,5)
    .widthIs(2);
    
    cancelBtn.sd_layout
    .leftSpaceToView(line2,4)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs((WindowWidth-30)/3);
    
    line3.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .heightIs(1);
}

- (void)setAllSelect:(BOOL)allSelect{
    _allSelect = allSelect;
    UIButton * button = [self viewWithTag:111];
    if(_allSelect){
        [button setTitle:@"清除" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"全选" forState:UIControlStateNormal];
    }
}

- (void)editSelected:(UIButton *)button{
    
    NSInteger type = button.tag - 110;
    if(self.delegate && [self.delegate respondsToSelector:@selector(messageEditOptionSelected:)]){
        [self.delegate messageEditOptionSelected:type];
    }
    
}


- (void)setDeleteCount:(NSInteger)count{
    
    UIButton * button = [self viewWithTag:112];
    NSString * title = @"删除";
    if(count > 0){
        title = [NSString stringWithFormat:@"删除(%ld)",count];
    }
    [button setTitle:title forState:UIControlStateNormal];
}

@end
