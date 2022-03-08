//
//  ObjectSelector.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/20/16
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
///  Created by Alex Hofsteede on 5/5/14.
///  Copyright (c) KingNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAObjectSelector : NSObject

@property (nonatomic, strong, readonly) NSString *string;

+ (DAObjectSelector *)objectSelectorWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;

- (NSArray *)selectFromRoot:(id)root;
- (NSArray *)fuzzySelectFromRoot:(id)root;

- (BOOL)isLeafSelected:(id)leaf fromRoot:(id)root;
- (BOOL)fuzzyIsLeafSelected:(id)leaf fromRoot:(id)root;

- (Class)selectedClass;
- (NSString *)description;

@end
