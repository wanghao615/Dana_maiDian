//
//  UUID.m
//  UUID
//
//  Created by Kingnet on 16/4/11.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "DAUUID.h"
#import "DAKeyChainStore.h"
//#import <AdSupport/ASIdentifierManager.h>
@implementation DAUUID

+(NSString *)getUUID
{
    NSString * strUUID = (NSString *)[DAKeyChainStore load:KEYDAUUID];
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);

        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));

        //将该uuid保存到keychain
        [DAKeyChainStore save:KEYDAUUID data:strUUID];
    }
    return strUUID;
//    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

//+(NSString *)getIDFA {
//    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//}

+(NSString *)getIDFA {
    return @"";
}
@end
