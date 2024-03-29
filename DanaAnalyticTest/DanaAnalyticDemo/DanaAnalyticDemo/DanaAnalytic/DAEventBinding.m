//
//  DAEventBinding.m
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/20/16
//  Copyright (c) 2016年 KingNet. All rights reserved.
//

#import "DAEventBinding.h"
#import "DALogger.h"
#import "DAUIControlBinding.h"
#import "DAUITableViewBinding.h"
#import "DanaAnalyticsSDK.h"

@implementation DAEventBinding

+ (DAEventBinding *)bindingWithJSONObject:(NSDictionary *)object {
    if (object == nil) {
        DAError(@"must supply an JSON object to initialize from");
        return nil;
    }

    NSString *bindingType = object[@"event_type"];
    Class klass = [self subclassFromString:bindingType];
    return [klass bindingWithJSONObject:object];
}

+ (Class)subclassFromString:(NSString *)bindingType {
    NSDictionary *classTypeMap = @{
                                   [DAUIControlBinding typeName] : [DAUIControlBinding class],
                                   [DAUITableViewBinding typeName] : [DAUITableViewBinding class]
                                   };
    return[classTypeMap valueForKey:bindingType] ?: [DAUIControlBinding class];
}

- (void)track:(NSString *)event withProperties:(NSDictionary *)properties {
    NSMutableDictionary *bindingProperties = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              [NSString stringWithFormat: @"%ld", (long)self.triggerId], @"$from_vtrack",
                                              @(self.triggerId), @"$binding_trigger_id",
                                              self.path.string, @"$binding_path",
                                              self.deployed ? @YES : @NO, @"$binding_depolyed",
                                              nil];
    
    if (properties != nil) {
        [bindingProperties addEntriesFromDictionary:properties];
    }
    
    [[DanaAnalyticsSDK sharedInstance] track:event withProperties:bindingProperties];
}

- (instancetype)initWithEventName:(NSString *)eventName
                     andTriggerId:(NSInteger)triggerId
                           onPath:(NSString *)path
                       isDeployed:(BOOL)deployed {
    if (self = [super init]) {
        self.triggerId = triggerId;
        self.deployed = deployed;
        self.eventName = eventName;
        self.path = [[DAObjectSelector alloc] initWithString:path];
        self.name = [[NSUUID UUID] UUIDString];
        self.running = NO;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Event Binding base class: '%@' for '%@'", [self eventName], [self path]];
}

#pragma mark -- Method stubs

+ (NSString *)typeName {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)execute {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)stop {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark -- NSCoder

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSInteger triggerId = [aDecoder decodeIntegerForKey:@"triggerId"];
    BOOL deployed = [aDecoder decodeBoolForKey:@"deployed"];
    NSString *path = [aDecoder decodeObjectForKey:@"path"];
    NSString *eventName = [aDecoder decodeObjectForKey:@"eventName"];
    if (self = [self initWithEventName:eventName andTriggerId:triggerId onPath:path isDeployed:deployed]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.swizzleClass = NSClassFromString([aDecoder decodeObjectForKey:@"swizzleClass"]);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_triggerId forKey:@"triggerId"];
    [aCoder encodeBool:_deployed forKey:@"deployed"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_path.string forKey:@"path"];
    [aCoder encodeObject:_eventName forKey:@"eventName"];
    [aCoder encodeObject:NSStringFromClass(_swizzleClass) forKey:@"swizzleClass"];
}

@end
