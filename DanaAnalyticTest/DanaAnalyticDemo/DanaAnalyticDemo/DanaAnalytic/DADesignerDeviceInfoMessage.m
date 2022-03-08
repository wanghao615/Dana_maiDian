//
//  DADesignerDeviceInfoMessage.m
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 1/18/16.
//  Copyright (c) 2016年 KingNet. All rights reserved.
//
/// Copyright (c) KingNet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DADesignerConnection.h"
#import "DADesignerDeviceInfoMessage.h"
#import "DanaAnalyticsSDK.h"
#import "DAUUID.h"

#pragma mark -- DeviceInfo Request

NSString *const DADesignerDeviceInfoRequestMessageType = @"device_info_request";

@implementation DADesignerDeviceInfoRequestMessage

+ (instancetype)message {
    return [(DADesignerDeviceInfoRequestMessage *)[self alloc] initWithType:DADesignerDeviceInfoRequestMessageType];
}

+ (NSString *)defaultDeviceId{
    // 优先使用IDFV
    if (NSClassFromString(@"UIDevice")) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    // 没有IDFV，则肯定有UUID，此时使用UUID
    return [[NSUUID UUID] UUIDString];
}

- (NSOperation *)responseCommandWithConnection:(DADesignerConnection *)connection {
    __weak DADesignerConnection *weak_connection = connection;
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        __strong DADesignerConnection *conn = weak_connection;
        
        DADesignerDeviceInfoResponseMessage *deviceInfoResponseMessage = [DADesignerDeviceInfoResponseMessage message];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // 服务端是否支持 Payload 压缩
            id supportGzip = [self payloadObjectForKey:@"support_gzip"];
            conn.useGzip = (supportGzip == nil) ? NO : [supportGzip boolValue];
            
            UIDevice *currentDevice = [UIDevice currentDevice];
            struct CGSize size = [UIScreen mainScreen].bounds.size;
            
            deviceInfoResponseMessage.libName = @"iOS";
            deviceInfoResponseMessage.libVersion = [[DanaAnalyticsSDK sharedInstance] libVersion];
            deviceInfoResponseMessage.systemName = currentDevice.systemName;
            deviceInfoResponseMessage.systemVersion = currentDevice.systemVersion;
            deviceInfoResponseMessage.screenHeight = [NSString stringWithFormat:@"%ld", (long)size.height];
            deviceInfoResponseMessage.screenWidth = [NSString stringWithFormat:@"%ld", (long)size.width];
            deviceInfoResponseMessage.mainBundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
            deviceInfoResponseMessage.deviceId = [[self class] defaultDeviceId];
            deviceInfoResponseMessage.deviceName = currentDevice.name;
            deviceInfoResponseMessage.deviceModel = currentDevice.model;
            deviceInfoResponseMessage.appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
            
            deviceInfoResponseMessage.did = [DAUUID getUUID];
            deviceInfoResponseMessage.ouid = @"testouid";
            deviceInfoResponseMessage.project = @"testproject";

        });
        
        [conn sendMessage:deviceInfoResponseMessage];
    }];
    
    return operation;
}

@end

#pragma mark -- DeviceInfo Response

@implementation DADesignerDeviceInfoResponseMessage

+ (instancetype)message {
    return [(DADesignerDeviceInfoResponseMessage *)[self alloc] initWithType:@"device_info_response"];
}

- (NSString *)libName {
    return [self payloadObjectForKey:@"_lib"];
}

- (void)setLibName:(NSString *) libName {
    [self setPayloadObject:libName forKey:@"_lib"];
}

- (NSString *)systemName {
    return [self payloadObjectForKey:@"_os"];
}

- (void)setSystemName:(NSString *)systemName {
    [self setPayloadObject:systemName forKey:@"_os"];
}

- (NSString *)systemVersion {
    return [self payloadObjectForKey:@"_osver"];
}

- (void)setSystemVersion:(NSString *)systemVersion {
    [self setPayloadObject:systemVersion forKey:@"_osver"];
}

- (NSString *)appVersion {
    return [self payloadObjectForKey:@"_appver"];
}

- (void)setAppVersion:(NSString *)appVersion {
    [self setPayloadObject:appVersion forKey:@"_appver"];
}

- (NSString *)deviceId {
    return [self payloadObjectForKey:@"$device_id"];
}

- (void)setDeviceId:(NSString *)deviceId {
    [self setPayloadObject:deviceId forKey:@"$device_id"];
}

- (NSString *)deviceName {
    return [self payloadObjectForKey:@"$device_name"];
}

- (void)setDeviceName:(NSString *)deviceName {
    [self setPayloadObject:deviceName forKey:@"$device_name"];
}

- (NSString *)libVersion {
    return [self payloadObjectForKey:@"_sdkver"];
}

- (void)setLibVersion:(NSString *)libVersion {
    [self setPayloadObject:libVersion forKey:@"_sdkver"];
}

- (NSString *)deviceModel {
    return [self payloadObjectForKey:@"$device_model"];
}

- (void)setDeviceModel:(NSString *)deviceModel {
    [self setPayloadObject:deviceModel forKey:@"$device_model"];
}

- (NSString *)mainBundleIdentifier {
    return [self payloadObjectForKey:@"$main_bundle_identifier"];
}

- (void)setMainBundleIdentifier:(NSString *)mainBundleIdentifier {
    [self setPayloadObject:mainBundleIdentifier forKey:@"$main_bundle_identifier"];
}

- (NSString *)screenHeight {
    return [self payloadObjectForKey:@"_screen_height"];
}

- (void)setScreenHeight:(NSString *)screenHeight {
    [self setPayloadObject:screenHeight forKey:@"_screen_height"];
}

- (NSString *)screenWidth {
    return [self payloadObjectForKey:@"_screen_width"];
}

- (void)setScreenWidth:(NSString *)screenWidth {
    [self setPayloadObject:screenWidth forKey:@"_screen_width"];
}

- (NSString *)did {
    return [self payloadObjectForKey:@"did"];
}

- (void)setDid:(NSString *)did {
    [self setPayloadObject:did forKey:@"did"];
}

- (NSString *)ouid {
    return [self payloadObjectForKey:@"ouid"];
}

- (void)setOuid:(NSString *)ouid {
    [self setPayloadObject:ouid forKey:@"ouid"];
}

- (NSString *)project {
    return [self payloadObjectForKey:@"project"];
}

- (void)setProject:(NSString *)project {
    [self setPayloadObject:project forKey:@"project"];
}

@end
