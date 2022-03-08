//
//  DAObjectIdentityProvider.m
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import <libkern/OSAtomic.h>

#import "DAObjectIdentityProvider.h"

@interface DASequenceGenerator : NSObject

- (int32_t)nextValue;

@end

@implementation DASequenceGenerator {
    int32_t _value;
}

- (instancetype)init {
    return [self initWithInitialValue:0];
}

- (instancetype)initWithInitialValue:(int32_t)initialValue {
    self = [super init];
    if (self) {
        _value = initialValue;
    }
    
    return self;
}

- (int32_t)nextValue {
    return OSAtomicAdd32(1, &_value);
}

@end

@implementation DAObjectIdentityProvider {
    NSMapTable *_objectToIdentifierMap;
    DASequenceGenerator *_sequenceGenerator;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _objectToIdentifierMap = [NSMapTable weakToStrongObjectsMapTable];
        _sequenceGenerator = [[DASequenceGenerator alloc] init];
    }

    return self;
}

- (NSString *)identifierForObject:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    NSString *identifier = [_objectToIdentifierMap objectForKey:object];
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"$%" PRIi32, [_sequenceGenerator nextValue]];
        [_objectToIdentifierMap setObject:identifier forKey:object];
    }

    return identifier;
}

@end
