//
//  DAObjectSerializerConfig.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAEnumDescription;
@class DAClassDescription;
@class DATypeDescription;

@interface DAObjectSerializerConfig : NSObject

@property (nonatomic, readonly) NSArray *classDescriptions;
@property (nonatomic, readonly) NSArray *enumDescriptions;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (DATypeDescription *)typeWithName:(NSString *)name;
- (DAEnumDescription *)enumWithName:(NSString *)name;
- (DAClassDescription *)classWithName:(NSString *)name;

@end
