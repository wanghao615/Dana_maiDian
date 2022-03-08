//
//  DADesignerEventBindingMessage.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
///  Created by Amanda Canyon on 11/18/14.
///  Copyright (c) KingNet. All rights reserved.
//

#import "DAAbstractDesignerMessage.h"
#import "DADesignerSessionCollection.h"

# pragma mark -- EventBinding Request

extern NSString *const DADesignerEventBindingRequestMessageType;

@interface DADesignerEventBindingRequestMessage : DAAbstractDesignerMessage

@end

# pragma mark -- EventBinding Response

@interface DADesignerEventBindingResponseMessage : DAAbstractDesignerMessage

+ (instancetype)message;

@property (nonatomic, copy) NSString *status;

@end

# pragma mark -- DebugTrack

@interface DADesignerTrackMessage : DAAbstractDesignerMessage

+ (instancetype)messageWithPayload:(NSDictionary *)payload;

@end

# pragma mark -- EventBinding Collection

@interface DAEventBindingCollection : NSObject<DADesignerSessionCollection>

@property (nonatomic, readonly) NSMutableSet *bindings;

- (instancetype)initWithEvents:(NSMutableSet *)bindings;

- (void)updateBindingsWithPayload:(NSArray *)bindingPayload;

@end
