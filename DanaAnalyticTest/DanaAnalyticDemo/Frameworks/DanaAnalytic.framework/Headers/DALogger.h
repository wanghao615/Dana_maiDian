//
//  DALogger.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 15/7/6.
//  Copyright (c) 2015年 KingNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef __DanaAnalyticsSDK__SALogger__
#define __DanaAnalyticsSDK__SALogger__

static inline void DALog(NSString *format, ...) {
    __block va_list arg_list;
    va_start (arg_list, format);
    NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:arg_list];
    va_end(arg_list);
    NSLog(@"[DanaAnalytics] %@", formattedString);
}

#define DAError(...) DALog(__VA_ARGS__)

#if (defined DEBUG) && (defined SENSORS_ANALYTICS_ENABLE_LOG)
#define DADebug(...) DALog(__VA_ARGS__)
#else
#define DADebug(...)
#endif

#endif /* defined(__DanaAnalyticsSDK__SALogger__) */
