//
//  DADesignerSnapshotMessage.m
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSData+DABase64.h"
#import "DADesignerSnapshotMessage.h"
#import "DAApplicationStateSerializer.h"
#import "DAObjectIdentityProvider.h"
#import "DAObjectSerializerConfig.h"
#import "DADesignerConnection.h"
#import "DanaAnalyticsSDK.h"

#pragma mark -- Snapshot Request

NSString * const DADesignerSnapshotRequestMessageType = @"snapshot_request";

static NSString * const kSnapshotSerializerConfigKey = @"snapshot_class_descriptions";
static NSString * const kObjectIdentityProviderKey = @"object_identity_provider";

@implementation DADesignerSnapshotRequestMessage

+ (instancetype)message {
    return [(DADesignerSnapshotRequestMessage *)[self alloc] initWithType:DADesignerSnapshotRequestMessageType];
}

- (DAObjectSerializerConfig *)configuration {
    NSDictionary *config = [self payloadObjectForKey:@"config"];
    return config ? [[DAObjectSerializerConfig alloc] initWithDictionary:config] : nil;
}

- (NSOperation *)responseCommandWithConnection:(DADesignerConnection *)connection {
    __block DAObjectSerializerConfig *serializerConfig = self.configuration;
    __block NSString *imageHash = [self payloadObjectForKey:@"last_image_hash"];

    __weak DADesignerConnection *weak_connection = connection;
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        __strong DADesignerConnection *conn = weak_connection;
        
        // Update the class descriptions in the connection session if provided as part of the message.
        if (serializerConfig) {
            [connection setSessionObject:serializerConfig forKey:kSnapshotSerializerConfigKey];
        } else if ([connection sessionObjectForKey:kSnapshotSerializerConfigKey]){
            // Get the class descriptions from the connection session store.
            serializerConfig = [connection sessionObjectForKey:kSnapshotSerializerConfigKey];
        } else {
            // If neither place has a config, this is probably a stale message and we can't create a snapshot.
            return;
        }

        // Get the object identity provider from the connection's session store or create one if there is none already.
        DAObjectIdentityProvider *objectIdentityProvider = [[DAObjectIdentityProvider alloc] init];

        DAApplicationStateSerializer *serializer = [[DAApplicationStateSerializer alloc] initWithApplication:[UIApplication sharedApplication]
                                                                                               configuration:serializerConfig
                                                                                      objectIdentityProvider:objectIdentityProvider];

        DADesignerSnapshotResponseMessage *snapshotMessage = [DADesignerSnapshotResponseMessage message];
        __block UIImage *screenshot = nil;
        __block NSDictionary *serializedObjects = nil;

        dispatch_sync(dispatch_get_main_queue(), ^{
            screenshot = [serializer screenshotImageForWindow:[[DanaAnalyticsSDK sharedInstance] vtrackWindow]];
        });
        snapshotMessage.screenshot = screenshot;

        if (imageHash && [imageHash isEqualToString:snapshotMessage.imageHash]) {
            [conn sendMessage:[DADesignerSnapshotResponseMessage message]];
            return;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            serializedObjects = [serializer objectHierarchyForWindow:[[DanaAnalyticsSDK sharedInstance] vtrackWindow]];
        });
        [connection setSessionObject:serializedObjects forKey:@"snapshot_hierarchy"];
        snapshotMessage.serializedObjects = serializedObjects;

        [conn sendMessage:snapshotMessage];
    }];

    return operation;
}

@end

#pragma mark -- Snapshot Response

@implementation DADesignerSnapshotResponseMessage

+ (instancetype)message {
    return [(DADesignerSnapshotResponseMessage *)[self alloc] initWithType:@"snapshot_response"];
}

- (void)setScreenshot:(UIImage *)screenshot {
    id payloadObject = nil;
    id imageHash = nil;
    if (screenshot) {
        NSData *jpegSnapshotImageData = UIImageJPEGRepresentation(screenshot, 0.5);
        if (jpegSnapshotImageData) {
            payloadObject = [jpegSnapshotImageData da_base64EncodedString];
            imageHash = [self getImageHash:jpegSnapshotImageData];
        }
    }
    
    _imageHash = imageHash;
    [self setPayloadObject:(payloadObject ?: [NSNull null]) forKey:@"screenshot"];
    [self setPayloadObject:(imageHash ?: [NSNull null]) forKey:@"image_hash"];
}

- (UIImage *)screenshot {
    NSString *base64Image = [self payloadObjectForKey:@"screenshot"];
    NSData *imageData = [NSData da_dataFromBase64String:base64Image];
    
    return imageData ? [UIImage imageWithData:imageData] : nil;
}

- (void)setSerializedObjects:(NSDictionary *)serializedObjects {
    [self setPayloadObject:serializedObjects forKey:@"serialized_objects"];
}

- (NSDictionary *)serializedObjects {
    return [self payloadObjectForKey:@"serialized_objects"];
}

- (NSString *)getImageHash:(NSData *)imageData {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(imageData.bytes, (uint)imageData.length, result);
    NSString *imageHash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]];
    return imageHash;
}

@end



