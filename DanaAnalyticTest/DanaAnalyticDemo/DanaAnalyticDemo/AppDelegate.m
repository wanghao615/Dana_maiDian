//
//  AppDelegate.m
//  DanaAnalyticDemo
//
//  Created by xiongsh on 2017/4/10.
//  Copyright © 2017年 xiongsh. All rights reserved.
//

#import "AppDelegate.h"
#import "DanaAnalytic.h"
#import "DAXXTEA.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //初始化配置文件 DAConf.plist文件   需要事先在plist文件中配置好相关参数
    [DanaAnalyticsSDK sharedInstanceWithConf];
    
//    [[DanaAnalyticsSDK sharedInstance] openclientWithReftype:@"1" AndIsvisitor:YES];
    //是否需要自动记录和传送打开app和退出app的事件 startapp  endapp
    [[DanaAnalyticsSDK sharedInstance] enableAutoTrack];
    
    [DanaAnalyticsSDK sharedInstance].logSwitch = YES;
    
    //(开放平台提供，MG平台用，其他游戏接入时不填)
    //[[DanaAnalyticsSDK sharedInstance] Dnan_Appid:@"203" appver:@"2.8.3"];
    //添加启动事件
    [[DanaAnalyticsSDK sharedInstance] Dana_Activation];
    //MG平台SDK版本(或自己平台的SDK版本，或为空字符串)

    NSString *jsonString = [DAXXTEA encryptStringToBase64String:@"abc" stringKey:@"b0b13e619be39ba3de3b457ceaa500a9"];
    NSLog(@"%@",jsonString);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
