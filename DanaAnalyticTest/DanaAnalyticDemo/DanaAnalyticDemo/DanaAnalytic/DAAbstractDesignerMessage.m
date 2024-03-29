//
//  DAAbstractDesignerMessage.m
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import "DALFCGzipUtility.h"
#import "NSData+DABase64.h"
#import "DAAbstractDesignerMessage.h"
#import "DALogger.h"

@interface DAAbstractDesignerMessage ()

@property (nonatomic, copy, readwrite) NSString *type;

@end

@implementation DAAbstractDesignerMessage {
    NSMutableDictionary *_payload;
}

+ (instancetype)messageWithType:(NSString *)type payload:(NSDictionary *)payload {
    return [[self alloc] initWithType:type payload:payload];
}

- (instancetype)initWithType:(NSString *)type {
    return [self initWithType:type payload:@{}];
}

- (instancetype)initWithType:(NSString *)type payload:(NSDictionary *)payload {
    self = [super init];
    if (self) {
        _type = type;
        _payload = [payload mutableCopy];
    }

    return self;
}

- (void)setPayloadObject:(id)object forKey:(NSString *)key {
    _payload[key] = object ?: [NSNull null];
}

- (id)payloadObjectForKey:(NSString *)key {
    id object = _payload[key];
    return [object isEqual:[NSNull null]] ? nil : object;
}

- (NSDictionary *)payload {
    return [_payload copy];
}

- (NSData *)JSONData:(BOOL)useGzip {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    
    [jsonObject setObject:_type forKey:@"type"];

    if (useGzip) {
        // 如果使用 GZip 压缩
        NSError *error = nil;
        
        // 1. 序列化 Payload
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[_payload copy] options:0 error:&error];
        NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        // 2. 使用 GZip 进行压缩
        NSData *zippedData = [DALFCGzipUtility gzipData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];

        // 3. Base64 Encode
        NSString *b64String = [zippedData da_base64EncodedString];

        [jsonObject setValue:b64String forKey:@"gzip_payload"];
    } else {
        [jsonObject setValue:[_payload copy] forKey:@"payload"];
    }

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:&error];
    if (jsonData == nil && error) {
        DAError(@"Failed to serialize test designer message: %@", error);
    }

    return jsonData;
}

- (NSOperation *)responseCommandWithConnection:(DADesignerConnection *)connection {
    return nil;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@:%p type='%@'>", NSStringFromClass([self class]), (__bridge void *)self, self.type];
}

@end
