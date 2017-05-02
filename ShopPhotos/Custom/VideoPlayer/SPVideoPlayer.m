//
//  SPVideoPlayer.m
//  ShopPhotos
//
//  Created by Park Jin Hyok on 4/29/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#import "SPVideoPlayer.h"
#import <CTVideoPlayerView/CTVideoViewCommonHeader.h>

@interface SPVideoPlayer ()

@property (strong, nonatomic) CTVideoView *videoView;

@end

@implementation SPVideoPlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createAutoLayout];
    }
    return self;
}

- (void) createAutoLayout {
    [self setBackgroundColor:[UIColor blackColor]];
    
    _videoView = [[CTVideoView alloc] init];
    _videoView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    [self addSubview:_videoView];
    
    [self addTarget:self action:@selector(closeView:)];
}

- (void) playVideo:(NSString *) videoUrl {
    if (_videoView) {
        _videoView.videoUrl = [NSURL URLWithString:videoUrl]; // mp4 playable
        [_videoView prepare];
        [_videoView play];
    }
}

- (void)closeView:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
}

@end
