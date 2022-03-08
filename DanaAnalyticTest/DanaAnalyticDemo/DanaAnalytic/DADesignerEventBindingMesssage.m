//
//  DADesignerEventBindingMessage.m
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
///  Created by Amanda Canyon on 11/18/14.
///  Copyright (c) KingNet. All rights reserved.
//

#import "DADesignerConnection.h"
#import "DADesignerEventBindingMessage.h"
#import "DAEventBinding.h"
#import "DAObjectSelector.h"
#import "DALogger.h"
#import "DASwizzler.h"
#import "DanaAnalyticsSDK.h"

# pragma mark -- EventBinding Request

NSString *const DADesignerEventBindingRequestMessageType = @"event_binding_request";

@implementation DADesignerEventBindingRequestMessage

+ (instancetype)message {
    return [(DADesignerEventBindingRequestMessage *)[self alloc] initWithType:@"event_binding_request"];
}

- (NSOperation *)responseCommandWithConnection:(DADesignerConnection *)connection {
    __weak DADesignerConnection *weak_connection = connection;
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        DADesignerConnection *conn = weak_connection;

        dispatch_sync(dispatch_get_main_queue(), ^{
            DADebug(@"Loading event bindings:\n%@",[self payload][@"events"]);
            NSArray *payload = [self payload][@"events"];
            DAEventBindingCollection *bindingCollection = [conn sessionObjectForKey:@"event_bindings"];
            if (!bindingCollection || ![bindingCollection isKindOfClass:[DAEventBindingCollection class]]) {
                bindingCollection = [[DAEventBindingCollection alloc] init];
                [conn setSessionObject:bindingCollection forKey:@"event_bindings"];
            }
            [bindingCollection updateBindingsWithPayload:payload];
        });

        DADesignerEventBindingResponseMessage *changeResponseMessage = [DADesignerEventBindingResponseMessage message];
        changeResponseMessage.status = @"OK";
        [conn sendMessage:changeResponseMessage];
    }];

    return operation;
}

@end

# pragma mark -- EventBinding Response

@implementation DADesignerEventBindingResponseMessage

+ (instancetype)message {
    return [(DADesignerEventBindingResponseMessage *)[self alloc] initWithType:@"event_binding_response"];
}

- (void)setStatus:(NSString *)status {
    [self setPayloadObject:status forKey:@"status"];
}

- (NSString *)status {
    return [self payloadObjectForKey:@"status"];
}

@end


# pragma mark -- DebugTrack

@implementation DADesignerTrackMessage {
    NSDictionary *_payload;
}

+ (instancetype)messageWithPayload:(NSDictionary *)payload {
    return[[self alloc] initWithType:@"debug_track" payload:payload];
}

@end

# pragma mark -- DAEventBindingCollection

@interface DAEventBindingCollection()

@property (nonatomic) NSMutableSet *bindings;

@end

@implementation DAEventBindingCollection

- (instancetype)initWithEvents:(NSMutableSet *)bindings {
    if (self = [super init]) {
        self.bindings = bindings;
    }
    return self;
}

- (void)updateBindingsWithPayload:(NSArray *)bindingPayload {
    NSMutableSet *newBindings = [[NSMutableSet alloc] init];
    for (NSDictionary *bindingInfo in bindingPayload) {
        DAEventBinding *binding = [DAEventBinding bindingWithJSONObject:bindingInfo];
        if (binding != nil) {
            [newBindings addObject:binding];
        }
    }
    
    [self updateBindingsWithEvents:newBindings];
}

- (void)updateBindingsWithEvents:(NSMutableSet *)newBindings {
    [self cleanup];
    
    self.bindings = newBindings;
    for (DAEventBinding *newBinding in self.bindings) {
        [newBinding execute];
    }
}

- (void)cleanup {
    if (self.bindings) {
        for (DAEventBinding *oldBinding in self.bindings) {
            [oldBinding stop];
        }
    }
    self.bindings = nil;
}

@end


