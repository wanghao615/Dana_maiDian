//
//  DADesignerDeviceInfoMessage.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAAbstractDesignerMessage.h"

#pragma mark -- DeviceInfo Request

extern NSString *const DADesignerDeviceInfoRequestMessageType;

@interface DADesignerDeviceInfoRequestMessage : DAAbstractDesignerMessage

@end

#pragma mark -- DeviceInfo Response

@interface DADesignerDeviceInfoResponseMessage : DAAbstractDesignerMessage

+ (instancetype)message;

@property (nonatomic, copy) NSString *libName;
@property (nonatomic, copy) NSString *systemName;
@property (nonatomic, copy) NSString *systemVersion;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceModel;
@property (nonatomic, copy) NSString *libVersion;
@property (nonatomic, copy) NSString *mainBundleIdentifier;
@property (nonatomic, copy) NSString *screenHeight;
@property (nonatomic, copy) NSString *screenWidth;


@property (nonatomic, copy) NSString *did;
@property (nonatomic, copy) NSString *ouid;
@property (nonatomic, copy) NSString *project;

@end
