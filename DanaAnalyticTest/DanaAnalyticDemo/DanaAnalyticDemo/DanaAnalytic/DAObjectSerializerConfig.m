//
//  DAObjectSerializerConfig.m
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import "DAClassDescription.h"
#import "DAEnumDescription.h"
#import "DAObjectSerializerConfig.h"
#import "DATypeDescription.h"

@implementation DAObjectSerializerConfig {
    NSDictionary *_classes;
    NSDictionary *_enums;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSMutableDictionary *classDescriptions = [[NSMutableDictionary alloc] init];
        for (NSDictionary *d in dictionary[@"classes"]) {
            NSString *superclassName = d[@"superclass"];
            DAClassDescription *superclassDescription = superclassName ? classDescriptions[superclassName] : nil;
            DAClassDescription *classDescription = [[DAClassDescription alloc] initWithSuperclassDescription:superclassDescription
                                                                                                  dictionary:d];

            classDescriptions[classDescription.name] = classDescription;
        }

        NSMutableDictionary *enumDescriptions = [[NSMutableDictionary alloc] init];
        for (NSDictionary *d in dictionary[@"enums"]) {
            DAEnumDescription *enumDescription = [[DAEnumDescription alloc] initWithDictionary:d];
            enumDescriptions[enumDescription.name] = enumDescription;
        }

        _classes = [classDescriptions copy];
        _enums = [enumDescriptions copy];
    }

    return self;
}

- (NSArray *)classDescriptions {
    return [_classes allValues];
}

- (DAEnumDescription *)enumWithName:(NSString *)name {
    return _enums[name];
}

- (DAClassDescription *)classWithName:(NSString *)name {
    return _classes[name];
}

- (DATypeDescription *)typeWithName:(NSString *)name {
    DAEnumDescription *enumDescription = [self enumWithName:name];
    if (enumDescription) {
        return enumDescription;
    }

    DAClassDescription *classDescription = [self classWithName:name];
    if (classDescription) {
        return classDescription;
    }

    return nil;
}

@end
