//
//  CrashToolModel.m
//  Crash
//
//  Created by ZYZ on 2018/10/27.
//  Copyright © 2018 ZYZ. All rights reserved.
//

#import "DAExceptionModel.h"
//#import "NSString+MGAdd.h"
//#import "XYCrackify.h"
//#import "UIDevice+XYAbout.h"
@implementation DAExceptionModel


- (instancetype)init {
    
    if (self = [super init]) {
        
//        _uid = [XYPlatform defaultPlatform].XYOpenUID;
//        _client_version = XYAPPVersion;
//        _device_id = [NSString IDFAORSimulateIDFA];
//         NSString *model = [[UIDevice currentDevice] hardwareSimpleDescription];  model = model==nil ? @"": model;
//        _phone_model = model;
//        _mobile_sys = [[UIDevice currentDevice] systemVersion];
//        _dateStr = [NSString convertTimeStrWithFormat:@"yyyy-MM-dd HH:mm:ss" sec:[[NSDate date] timeIntervalSince1970]];
//        
//        NSMutableString *currentIDE = [[NSMutableString alloc] initWithString:@"崩溃详情:"];
//        [currentIDE appendFormat:@"\n时间:%@",_dateStr];
//        [currentIDE appendFormat:@"\n用户:%ld -- 版本号:%@",(long)_uid,XYAPPVersion];
//        [currentIDE appendFormat:@"\n设备号:%@",_device_id];
//        NSString *isBrokenStr = [XYCrackify isJailbroken] ? @"是" : @"否";
//        NSString *networkStr = [UIDevice currentDevice].deviceNettype;
//        [currentIDE appendFormat:@"\n机型:%@ -- 系统:%@ -- 越狱:%@ -- 网络状态:%@",_phone_model,_mobile_sys,isBrokenStr,networkStr];
//        _crash_ide = [currentIDE copy];
    }
    return self;
}

@end
