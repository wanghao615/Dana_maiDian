//
//  DADesignerSnapshotMessage.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DAAbstractDesignerMessage.h"

@class DAObjectSerializerConfig;

extern NSString *const DADesignerSnapshotRequestMessageType;

#pragma mark -- Snapshot Request

@interface DADesignerSnapshotRequestMessage : DAAbstractDesignerMessage

+ (instancetype)message;

@property (nonatomic, readonly) DAObjectSerializerConfig *configuration;

@end

#pragma mark -- Snapshot Response

@interface DADesignerSnapshotResponseMessage : DAAbstractDesignerMessage

+ (instancetype)message;

@property (nonatomic, strong) UIImage *screenshot;
@property (nonatomic, copy) NSDictionary *serializedObjects;
@property (nonatomic, strong) NSString *imageHash;

@end
