//
//  PublishTask.h
//  ShopPhotos
//
//  Created by 廖检成 on 17/1/7.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import <Foundation/Foundation.h>

#define imagesKey @"images"
#define photosIDKey @"photosID"
#define recommendSwhKey @"recommendSwh"
#define subEnterTextKey @"subEnterText"
#define faherEnterTextKey @"faherEnterText"
#define classify_idKey @"classify_id"
#define subclassification_idKey @"subclassification_id"
#define imageNameKey @"imageName"
#define dataSizeKey @"dataSize"
#define priceKey @"price"
#define publishNameKey @"publishName"
#define descriptionKey @"description"

typedef void(^CompletePublish)(id responseObj);

@interface PublishPhoto : NSObject

@property (assign, nonatomic) BOOL isAdd;
- (void)startTask:(NSDictionary *)data complete:(CompletePublish)completeStatu;

@end
