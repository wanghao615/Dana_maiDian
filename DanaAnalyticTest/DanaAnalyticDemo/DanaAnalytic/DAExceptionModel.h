//
//  CrashToolModel.h
//  Crash
//
//  Created by ZYZ on 2018/10/27.
//  Copyright © 2018 ZYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DAExceptionModel : NSObject

@property (nonatomic, copy) NSString  *uid;
@property (nonatomic, copy) NSString  *dateStr;
@property (nonatomic, copy) NSString  *device_id;
@property (nonatomic, copy) NSString  *mobile_sys;
@property (nonatomic, copy) NSString  *phone_model;
@property (nonatomic, copy) NSString  *client_version;

/*
 *服务端用来判断是否是同一类的bug，客户端根据reason或者callstack 转MD5
 */
@property(nonatomic,copy)NSString *crash_md5;

/*
 * crash的发生交换环境，凭借到log中要求
 */
@property(nonatomic,copy)NSString *crash_ide;

/*
 * 最终传过服务器的log
 */
@property(nonatomic,copy)NSString *crash_log;

@end

NS_ASSUME_NONNULL_END
