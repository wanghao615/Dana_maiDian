# DanaSDK 
一、导入DanaAnalytic.framework  ==（注意区分IDFA版本和非IDFA版本）== 和相关的依赖库文件 libicucore、libsqlite3 和 libz。 

二、配置SDK使用参数  

1、需要在DAConf.plist配置 danabaseurl、version、topic、token、project参数，数据由数据中心统一分配。  

2、Other Linker Flags  添加 -ObjC 标识。


## 使用例子
一、初始化SDK
````````
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化数据统计配置DAConf.plist文件
    [DanaAnalyticsSDK sharedInstanceWithConf];
    
    //是否需要自动记录和传送打开app和退出app的事件 startapp  endapp，最好在 didFinishLaunchingWithOptions 里面调用，记录到更精确的启动app的事件启动到关闭的事件长度
    [[DanaAnalyticsSDK sharedInstance] enableAutoTrack];  (方法调用后开启)
    
    return YES;
}

   
````````
二、记录统计事件
````````
- (IBAction)payClick:(id)sender {
    NSLog(@"pay click");
	
    //投递数据    应用使用
    [[DanaAnalyticsSDK sharedInstance] track:@"payevent" withProperties:@{@"paykey": @"¥6"}];
    
    //投递数据    U3d游戏使用
    [[DanaAnalyticsSDK sharedInstance] track:@"payevent" withPropertiesToJson:@"{\"paykey\":\"¥6\"}"];
}


````````
三、应用自动记录页面进出事件和停留时长


实现统一记录页面的访问，要自动统计VC的话分两步。

1、在要统计的UIViewController中添加这个协议  UIViewController<DAAutoTracker>

2、实现DAAutoTracker协议中的方法

````````
-(NSDictionary *)getTrackProperties {
    return @{@"window":@"功能位详情页面",@"windowtype":@"功能位分类详情",@"text":@"详情内容"}; //可少传 
}

````````
必须实现上面两步才能统计到你要统计的页面。 页面停留的时长timecount是SDK自动统计的
 

## 详情见相关demo



