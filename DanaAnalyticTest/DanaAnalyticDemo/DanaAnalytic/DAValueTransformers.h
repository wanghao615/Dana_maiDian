//
//  DAValueTransformers.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/20/16
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
///  Created by Alex Hofsteede on 5/5/14.
///  Copyright (c) KingNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAPassThroughValueTransformer : NSValueTransformer

@end

@interface DABOOLToNSNumberValueTransformer : NSValueTransformer

@end

@interface DACATransform3DToNSDictionaryValueTransformer : NSValueTransformer

@end

@interface DACGAffineTransformToNSDictionaryValueTransformer : NSValueTransformer

@end

@interface DACGColorRefToNSStringValueTransformer : NSValueTransformer

@end

@interface DACGPointToNSDictionaryValueTransformer : NSValueTransformer

@end

@interface DACGRectToNSDictionaryValueTransformer : NSValueTransformer

@end

@interface DACGSizeToNSDictionaryValueTransformer : NSValueTransformer

@end

@interface DANSAttributedStringToNSDictionaryValueTransformer : NSValueTransformer

@end

@interface DANSNumberToCGFloatValueTransformer : NSValueTransformer

@end

__unused static id transformValue(id value, NSString *toType) {
    assert(value != nil);

    if ([value isKindOfClass:[NSClassFromString(toType) class]]) {
        return [[NSValueTransformer valueTransformerForName:@"DAPassThroughValueTransformer"] transformedValue:value];
    }

    NSString *fromType = nil;
    NSArray *validTypes = @[[NSString class], [NSNumber class], [NSDictionary class], [NSArray class], [NSNull class]];
    for (Class c in validTypes) {
        if ([value isKindOfClass:c]) {
            fromType = NSStringFromClass(c);
            break;
        }
    }

    assert(fromType != nil);
    NSValueTransformer *transformer = nil;
    NSString *forwardTransformerName = [NSString stringWithFormat:@"DA%@To%@ValueTransformer", fromType, toType];
    transformer = [NSValueTransformer valueTransformerForName:forwardTransformerName];
    if (transformer) {
        return [transformer transformedValue:value];
    }

    NSString *reverseTransformerName = [NSString stringWithFormat:@"DA%@To%@ValueTransformer", toType, fromType];
    transformer = [NSValueTransformer valueTransformerForName:reverseTransformerName];
    if (transformer && [[transformer class] allowsReverseTransformation]) {
        return [transformer reverseTransformedValue:value];
    }

    return [[NSValueTransformer valueTransformerForName:@"DAPassThroughValueTransformer"] transformedValue:value];
}
