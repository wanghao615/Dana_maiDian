//
//  DAApplicationStateSerializer.m
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DAApplicationStateSerializer.h"
#import "DAClassDescription.h"
#import "DALogger.h"
#import "DAObjectIdentityProvider.h"
#import "DAObjectSerializer.h"
#import "DAObjectSerializerConfig.h"

@implementation DAApplicationStateSerializer {
    DAObjectSerializer *_serializer;
    UIApplication *_application;
}

- (instancetype)initWithApplication:(UIApplication *)application
                      configuration:(DAObjectSerializerConfig *)configuration
             objectIdentityProvider:(DAObjectIdentityProvider *)objectIdentityProvider {
    NSParameterAssert(application != nil);
    NSParameterAssert(configuration != nil);
    
    self = [super init];
    if (self) {
        _application = application;
        _serializer = [[DAObjectSerializer alloc] initWithConfiguration:configuration objectIdentityProvider:objectIdentityProvider];
    }
    
    return self;
}

- (UIImage *)screenshotImageForWindow:(UIWindow *)window {
    UIImage *image = nil;
    
    UIWindow *mainWindow = [self uiMainWindow:window];
    if (mainWindow && !CGRectEqualToRect(mainWindow.frame, CGRectZero)) {
        UIGraphicsBeginImageContextWithOptions(mainWindow.bounds.size, YES, mainWindow.screen.scale);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ([mainWindow respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            if ([mainWindow drawViewHierarchyInRect:mainWindow.bounds afterScreenUpdates:NO] == NO) {
                DAError(@"Unable to get complete screenshot for window at index: %d.", (int)index);
            }
        } else {
            [mainWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
#else
        [mainWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
#endif
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

- (UIWindow *)uiMainWindow:(UIWindow *)window {
    if (window != nil) {
        return window;
    }
    return _application.windows[0];
}

- (NSDictionary *)objectHierarchyForWindow:(UIWindow *)window {
    UIWindow *mainWindow = [self uiMainWindow:window];
    if (mainWindow) {
        return [_serializer serializedObjectsWithRootObject:mainWindow];
    }
    
    return @{};
}

@end
