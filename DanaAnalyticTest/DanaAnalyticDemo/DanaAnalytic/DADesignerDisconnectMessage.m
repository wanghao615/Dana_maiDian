//
//  DADesignerDisconnectMessage.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/28/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//

#import "DADesignerConnection.h"
#import "DADesignerDisconnectMessage.h"

NSString *const DADesignerDisconnectMessageType = @"disconnect";

@implementation DADesignerDisconnectMessage

+ (instancetype)message {
    return [(DADesignerDisconnectMessage *)[self alloc] initWithType:@"disconnect"];
}

- (NSOperation *)responseCommandWithConnection:(DADesignerConnection *)connection {
    __weak DADesignerConnection *weak_connection = connection;
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        DADesignerConnection *conn = weak_connection;
        
        conn.sessionEnded = YES;
        [conn close];
    }];
    return operation;
}

@end
