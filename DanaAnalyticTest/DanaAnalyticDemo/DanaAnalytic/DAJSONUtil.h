//
//  DAJSONUtil.h
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 15/7/7.
//  Copyright (c) 2015年 KingNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAJSONUtil : NSObject

/**
 *  @abstract
 *  把一个Object转成Json字符串
 *
 *  @param obj 要转化的对象Object
 *
 *  @return 转化后得到的字符串
 */
- (NSData *)JSONSerializeObject:(id)obj;

/**
 *  初始化
 *
 *  @return 初始化后的对象
 */
- (id) init;


/**
 *  @abstract
 *  把一个Json字符串转成Object
 *
 *  @param str 要转化的对象Object字符
 *
 *  @return 字符串转化后得到的object 为空为nil
 */
+ (id)returnObjectWithJsonStr:(NSString *)str;
@end
