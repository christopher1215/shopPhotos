//
//  SPVideoPlayer.h
//  ShopPhotos
//
//  Created by  on 4/29/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#ifndef SPVideoPlayer_h
#define SPVideoPlayer_h

#import "BaseView.h"

@interface SPVideoPlayer : BaseView

@property (assign, nonatomic) NSString * videoUrl;

- (void) playVideo:(NSString *) videoUrl;

@end

#endif /* SPVideoPlayer_h */
