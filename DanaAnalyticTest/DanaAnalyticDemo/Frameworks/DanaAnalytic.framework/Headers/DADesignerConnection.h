//
//  DADesignerConnection.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAWebSocket.h"

@protocol DADesignerMessage;

@interface DADesignerConnection : NSObject

@property (nonatomic, readonly) BOOL connected;
@property (nonatomic, assign) BOOL sessionEnded;
@property (nonatomic, assign) BOOL useGzip;

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURL:(NSURL *)url keepTrying:(BOOL)keepTrying connectCallback:(void (^)())connectCallback disconnectCallback:(void (^)())disconnectCallback;

- (void)setSessionObject:(id)object forKey:(NSString *)key;
- (id)sessionObjectForKey:(NSString *)key;
- (void)sendMessage:(id<DADesignerMessage>)message;
- (void)close;

@end
