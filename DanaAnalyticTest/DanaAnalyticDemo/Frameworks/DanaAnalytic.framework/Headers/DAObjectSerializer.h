//
//  DAObjectSerializer.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAClassDescription;
@class DAObjectSerializerConfig;
@class DAObjectIdentityProvider;

@interface DAObjectSerializer : NSObject

/*
 An array of DAClassDescription instances.
 */
- (instancetype)initWithConfiguration:(DAObjectSerializerConfig *)configuration
               objectIdentityProvider:(DAObjectIdentityProvider *)objectIdentityProvider;

- (NSDictionary *)serializedObjectsWithRootObject:(id)rootObject;

@end
