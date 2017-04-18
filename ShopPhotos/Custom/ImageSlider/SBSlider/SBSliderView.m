//
//  SBSliderView.m
//  ImageSlider
//
//  Created by Soumalya Banerjee on 22/07/15.
//  Copyright (c) 2015 Soumalya Banerjee. All rights reserved.
//

#import "SBSliderView.h"
#import "DDKit.h"

@implementation SBSliderView {
    NSArray *imagesArray;
    BOOL autoSrcollEnabled;
    
    NSTimer *activeTimer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//    }
//    return self;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if(self) {
//        [self setup];
//    }
//    return self;
//}
//
//- (void)setup {
//    [[NSBundle mainBundle] loadNibNamed:@"SBSliderView" owner:self options:nil];
////    [self addSubview:self.view];
//}

#pragma mark - Create Slider with images

- (void)createSliderWithImages:(NSArray *)images WithAutoScroll:(BOOL)isAutoScrollEnabled inView:(UIView *)parentView {
    
    imagesArray = [NSArray arrayWithArray:images];
    autoSrcollEnabled = isAutoScrollEnabled;

    _sliderMainScroller.pagingEnabled = YES;
    _sliderMainScroller.delegate = self;
    _pageIndicator.numberOfPages = [imagesArray count];
    _sliderMainScroller.frame = self.frame;
    _sliderMainScroller.backgroundColor = [UIColor blackColor];
    if(imagesArray.count > 1)
    {
//        _sliderMainScroller.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width * [imagesArray count] * 3), self.frame.size.height);
        _sliderMainScroller.contentSize = CGSizeMake((self.frame.size.width * [imagesArray count]), self.frame.size.height);
    }
    else
    {
//        _sliderMainScroller.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width), self.frame.size.height);
        _sliderMainScroller.contentSize = CGSizeMake((self.frame.size.width), self.frame.size.height);
    }
    int mainCount = 0;

    if([imagesArray count] == 0)
    {
        UIImageView *imageV = [[UIImageView alloc] init];
        CGRect frameRect;
        frameRect.origin.y = 0.0f;
        frameRect.size.width = self.frame.size.width;//[UIScreen mainScreen].bounds.size.width;
        frameRect.size.height = self.frame.size.height;//[UIScreen mainScreen].bounds.size.width / 16 * 9;
        frameRect.origin.x = (frameRect.size.width * mainCount);
        imageV.frame = frameRect;
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.image = [UIImage imageNamed:@"noImage.png"];
        [_sliderMainScroller addSubview:imageV];
        imageV.clipsToBounds = YES;
        imageV.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapOnImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImage:)];
        tapOnImage.delegate = self;
        tapOnImage.numberOfTapsRequired = 1;
        [imageV addGestureRecognizer:tapOnImage];
    }
    else
    {
        for (int x = 0; x < 3; x++) {

            for (int i=0; i < [imagesArray count]; i++) {

                UIImageView *imageV = [[UIImageView alloc] init];
                CGRect frameRect;
                frameRect.origin.y = 0.0f;
                frameRect.size.width = self.frame.size.width;//[UIScreen mainScreen].bounds.size.width;
                frameRect.size.height = self.frame.size.height;//[UIScreen mainScreen].bounds.size.width / 16 * 9;
                NSLog(@"imageView : %f",frameRect.size.height);
                frameRect.origin.x = (frameRect.size.width * mainCount);
                imageV.frame = frameRect;
//                imageV.contentMode = UIViewContentModeScaleAspectFill;
                
                NSString *imageUrl = [imagesArray objectAtIndex:i];
                if([imageUrl containsString:@"http:"])
                {
    //                imageV.image = [UIImage imageWithData:
    //                           [NSData dataWithContentsOfURL:
    //                            [NSURL URLWithString:imageUrl]]];
    //commented and added by csh
                    [imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImageScale:[UIImage imageNamed:@"noImage.png"]];
                }
                else
                {
                    imageV.image = [UIImage imageNamed:(NSString *)[imagesArray objectAtIndex:i]];
                }
                [_sliderMainScroller addSubview:imageV];
                imageV.clipsToBounds = YES;
                imageV.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tapOnImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImage:)];
                tapOnImage.delegate = self;
                tapOnImage.numberOfTapsRequired = 1;
                [imageV addGestureRecognizer:tapOnImage];
                
                mainCount++;
            }
            
        }
        CGFloat startX = 0;
        [_sliderMainScroller setContentOffset:CGPointMake(startX, 0) animated:NO];
        
        if (([imagesArray count] > 1) && (isAutoScrollEnabled)) {
            [self startTimerThread];
        }
    }
}

#pragma mark end -


#pragma mark - GestureRecognizer delegate

- (void)tapOnImage:(UITapGestureRecognizer *)gesture {
    
    UIImageView *targetView = (UIImageView *)gesture.view;
    [_delegate sbslider:self didTapOnImage:targetView.image andParentView:targetView indAdvert:_pageIndicator.currentPage];
    
}

#pragma mark end -

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
    NSInteger moveToPage = page;
    
    if (moveToPage < [imagesArray count]) {
        _pageIndicator.currentPage = moveToPage;
    } else {
        
        moveToPage = moveToPage % [imagesArray count];
        _pageIndicator.currentPage = moveToPage;
    }
    if (([imagesArray count] > 1) && (autoSrcollEnabled)) {
        [self startTimerThread];
    }
    [_delegate sbslider:self didScrolledPage:moveToPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
    NSInteger moveToPage = page;
    
    if (moveToPage < [imagesArray count]) {
        _pageIndicator.currentPage = moveToPage;
    } else {
        
        moveToPage = moveToPage % [imagesArray count];
        _pageIndicator.currentPage = moveToPage;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (activeTimer) {
        [activeTimer invalidate];
        activeTimer = nil;
    }
}

#pragma mark end -

- (void)slideImage {
    CGFloat startX = 0.0f;
    CGFloat width = _sliderMainScroller.frame.size.width;
    NSInteger page = (_sliderMainScroller.contentOffset.x + (0.5f * width)) / width;
    NSInteger nextPage = page + 1;
    startX = (CGFloat)nextPage * width;
    //    [_sliderMainScroller scrollRectToVisible:CGRectMake(startX, 0, width, _sliderMainScroller.frame.size.height) animated:YES];
    [_sliderMainScroller setContentOffset:CGPointMake(startX, 0) animated:YES];
}

-(void)startTimerThread
{
    if (activeTimer) {
        [activeTimer invalidate];
        activeTimer = nil;
    }
    activeTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(slideImage) userInfo:nil repeats:YES];
}

-(void)startAutoPlay
{
    autoSrcollEnabled = YES;
    if (([imagesArray count] > 1) && (autoSrcollEnabled)) {
        [self startTimerThread];
    }
}

-(void)stopAutoPlay
{
    autoSrcollEnabled = NO;
    if (activeTimer) {
        [activeTimer invalidate];
        activeTimer = nil;
    }
}

@end
