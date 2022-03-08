//
//  DADesignerConnection.,
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import "DADesignerConnection.h"
#import "DADesignerDeviceInfoMessage.h"
#import "DADesignerDisconnectMessage.h"
#import "DADesignerEventBindingMessage.h"
#import "DADesignerMessage.h"
#import "DADesignerSnapshotMessage.h"
#import "DADesignerSessionCollection.h"
#import "DALogger.h"
#import "DanaAnalyticsSDK.h"

@interface DADesignerConnection () <DAWebSocketDelegate>

@end

@implementation DADesignerConnection {
    /* The difference between _open and _connected is that open
     is set when the socket is open, and _connected is set when
     we actually have started sending/receiving messages from
     the server. A connection can become _open/not _open in quick
     succession if the websocket proxy rejects the request, but
     we will only try and reconnect if we were actually _connected.
     */
    BOOL _open;
    BOOL _connected;

    NSURL *_url;
    NSMutableDictionary *_session;
    NSDictionary *_typeToMessageClassMap;
    DAWebSocket *_webSocket;
    NSOperationQueue *_commandQueue;
    UIView *_recordingView;
    void (^_connectCallback)();
    void (^_disconnectCallback)();
}

- (instancetype)initWithURL:(NSURL *)url
                 keepTrying:(BOOL)keepTrying
            connectCallback:(void (^)())connectCallback
         disconnectCallback:(void (^)())disconnectCallback {
    self = [super init];
    if (self) {
        _typeToMessageClassMap = @{
            DADesignerDeviceInfoRequestMessageType : [DADesignerDeviceInfoRequestMessage class],
            DADesignerDisconnectMessageType : [DADesignerDisconnectMessage class],
            DADesignerEventBindingRequestMessageType : [DADesignerEventBindingRequestMessage class],
            DADesignerSnapshotRequestMessageType : [DADesignerSnapshotRequestMessage class],
        };

        _open = NO;
        _connected = NO;
        _sessionEnded = NO;
        _useGzip = NO;
        _session = [[NSMutableDictionary alloc] init];
        _url = url;
        _connectCallback = connectCallback;
        _disconnectCallback = disconnectCallback;

        _commandQueue = [[NSOperationQueue alloc] init];
        _commandQueue.maxConcurrentOperationCount = 1;
        _commandQueue.suspended = YES;

        if (keepTrying) {
            [self open:YES maxInterval:15 maxRetries:999];
        } else {
            [self open:YES maxInterval:0 maxRetries:0];
        }
    }

    return self;
}

- (instancetype)initWithURL:(NSURL *)url {
    return [self initWithURL:url keepTrying:NO connectCallback:nil disconnectCallback:nil];
}


- (void)open:(BOOL)initiate maxInterval:(int)maxInterval maxRetries:(int)maxRetries {
    static int retries = 0;
    BOOL inRetryLoop = retries > 0;

    
    DADebug(@"In open. initiate = %d, retries = %d, maxRetries = %d, maxInterval = %d, connected = %d", initiate, retries, maxRetries, maxInterval, _connected);

    if (self.sessionEnded || _connected || (inRetryLoop && retries >= maxRetries) ) {
        // break out of retry loop if any of the success conditions are met.
        retries = 0;
    } else if (initiate ^ inRetryLoop) {
        // If we are initiating a new connection, or we are already in a
        // retry loop (but not both). Then open a socket.
        if (!_open) {
            DADebug(@"Attempting to open WebSocket to: %@, try %d/%d ", _url, retries, maxRetries);
            _open = YES;
            _webSocket = [[DAWebSocket alloc] initWithURL:_url];
            _webSocket.delegate = self;
            [_webSocket open];
        }
        if (retries < maxRetries) {
            __weak DADesignerConnection *weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(maxInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                DADesignerConnection *strongSelf = weakSelf;
                [strongSelf open:NO maxInterval:maxInterval maxRetries:maxRetries];
            });
            retries++;
        }
    }
}

- (void)close {
    [_webSocket close];
    for (NSString *key in [_session keyEnumerator]) {
        id value = [_session valueForKey:key];
        if ([value conformsToProtocol:@protocol(DADesignerSessionCollection)]) {
            [value cleanup];
        }
    }
    _session = [[NSMutableDictionary alloc] init];
}

- (void)dealloc {
    _webSocket.delegate = nil;
    [self close];
}

- (void)setSessionObject:(id)object forKey:(NSString *)key {
    NSParameterAssert(key != nil);

    @synchronized (_session) {
        _session[key] = object ?: [NSNull null];
    }
}

- (id)sessionObjectForKey:(NSString *)key {
    NSParameterAssert(key != nil);

    @synchronized (_session) {
        id object = _session[key];
        return [object isEqual:[NSNull null]] ? nil : object;
    }
}

- (void)sendMessage:(id<DADesignerMessage>)message {
    if (_connected) {
    
        NSString *jsonString = [[NSString alloc] initWithData:[message JSONData:_useGzip] encoding:NSUTF8StringEncoding];
//        DADebug(@"%@ VTrack sending message: %@", self, [message description]);
        [_webSocket send:jsonString];
    } else {
        DADebug(@"Not sending message as we are not connected: %@", [message debugDescription]);
    }
}

- (id <DADesignerMessage>)designerMessageForMessage:(id)message {
    NSParameterAssert([message isKindOfClass:[NSString class]] || [message isKindOfClass:[NSData class]]);

    id <DADesignerMessage> designerMessage = nil;

    NSData *jsonData = [message isKindOfClass:[NSString class]] ? [(NSString *)message dataUsingEncoding:NSUTF8StringEncoding] : message;
//    DADebug(@"%@ VTrack received message: %@", self, [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *messageDictionary = (NSDictionary *)jsonObject;
        NSString *type = messageDictionary[@"type"];
        NSDictionary *payload = messageDictionary[@"payload"];

        designerMessage = [_typeToMessageClassMap[type] messageWithType:type payload:payload];
    } else {
        DAError(@"Badly formed socket message expected JSON dictionary: %@", error);
    }

    return designerMessage;
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        DADebug(@"Canceled to connect VTrack ...");
        _sessionEnded = YES;
        [self close];
    } else {
        DADebug(@"Confirmed to connect VTrack ...");
    }
}

#pragma mark - DAWebSocketDelegate Methods

- (void)handleMessage:(id)message {
    id<DADesignerMessage> designerMessage = [self designerMessageForMessage:message];
    NSOperation *commandOperation = [designerMessage responseCommandWithConnection:self];
    if (commandOperation) {
        [_commandQueue addOperation:commandOperation];
    }
}

- (void)webSocket:(DAWebSocket *)webSocket didReceiveMessage:(id)message {
    if (!_connected) {
        _connected = YES;
        
        NSString *alertTitle = @"Connecting to VTrack";
        NSString *alertMessage = @"正在连接到 Dana Analytics 可视化埋点管理界面...";
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            UIWindow *mainWindow = [DanaAnalyticsSDK sharedInstance].vtrackWindow;
            if (mainWindow == nil) {
                mainWindow = [[UIApplication sharedApplication] delegate].window;
            }
            if (mainWindow == nil) {
                return;
            }
            
            UIAlertController *connectAlert = [UIAlertController
                                               alertControllerWithTitle:alertTitle
                                               message:alertMessage
                                               preferredStyle:UIAlertControllerStyleAlert];
            
            [connectAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                DADebug(@"Canceled to connect VTrack ...");
                
                _sessionEnded = YES;
                [self close];
            }]];
            
            [connectAlert addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                DADebug(@"Confirmed to connect VTrack ...");
                
                _connected = YES;
                
                if (_connectCallback) {
                    _connectCallback();
                }
                
                [self handleMessage:message];
            }]];
            
            [[mainWindow rootViewController] presentViewController:connectAlert animated:YES completion:nil];
        } else {
            _connected = YES;
            
            if (_connectCallback) {
                _connectCallback();
            }
            
            [self handleMessage:message];

            UIAlertView *connectAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
            [connectAlert show];
        }
    } else {
        [self handleMessage:message];
    }
}

- (void)webSocketDidOpen:(DAWebSocket *)webSocket {
    _commandQueue.suspended = NO;
}

- (void)webSocket:(DAWebSocket *)webSocket didFailWithError:(NSError *)error {
    _commandQueue.suspended = YES;
    [_commandQueue cancelAllOperations];
    _open = NO;
    if (_connected) {
        _connected = NO;
        [self open:YES maxInterval:15 maxRetries:999];
        if (_disconnectCallback) {
            _disconnectCallback();
        }
    }
}

- (void)webSocket:(DAWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    DADebug(@"WebSocket did close with code '%d' reason '%@'.", (int)code, reason);
    _commandQueue.suspended = YES;
    [_commandQueue cancelAllOperations];
    _open = NO;
    if (_connected) {
        _connected = NO;
        [self open:YES maxInterval:15 maxRetries:999];
        if (_disconnectCallback) {
            _disconnectCallback();
        }
    }
}

@end

