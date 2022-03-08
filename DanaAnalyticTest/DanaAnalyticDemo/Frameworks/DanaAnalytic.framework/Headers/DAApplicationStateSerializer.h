//
//  DAApplicationStateSerializer.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DAObjectSerializerConfig;
@class DAObjectIdentityProvider;

@interface DAApplicationStateSerializer : NSObject

- (instancetype)initWithApplication:(UIApplication *)application
                      configuration:(DAObjectSerializerConfig *)configuration
             objectIdentityProvider:(DAObjectIdentityProvider *)objectIdentityProvider;

- (UIImage *)screenshotImageForWindow:(UIWindow *)window;

- (NSDictionary *)objectHierarchyForWindow:(UIWindow *)window;

@end
