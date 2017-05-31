//
//  PublishVideo.h
//  ShopPhotos
//
//  Created by  on 4/28/17.
//  Copyright © 2017 addcn. All rights reserved.
//

#ifndef PublishVideo_h
#define PublishVideo_h

#import <Foundation/Foundation.h>

typedef void(^CompletePulish)(BOOL statu);

@interface PublishVideo : NSObject

- (void)startTask:(NSDictionary *)data complete:(CompletePulish)completeStatu;
@end

#endif /* PublishVideo_h */
