//
//  DAUITableViewBinding.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/20/16
//  Copyright (c) 2016年 KingNet. All rights reserved.
//

#import "DAEventBinding.h"

@interface DAUITableViewBinding : DAEventBinding

- (instancetype)init __unavailable;
- (instancetype)initWithEventName:(NSString *)eventName
                     andTriggerId:(NSInteger)triggerId
                           onPath:(NSString *)path
                       isDeployed:(BOOL)deployed
                     withDelegate:(Class)delegateClass;

@end
