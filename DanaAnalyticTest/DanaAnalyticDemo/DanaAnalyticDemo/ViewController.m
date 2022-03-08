//
//  ViewController.m
//  DanaAnalyticDemo
//
//  Created by xiongsh on 2017/4/10.
//  Copyright © 2017年 xiongsh. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DanaAnalytic.h"
#import "DAJSONUtil.h"
#import "DetailViewController.h"
#import "TestInwinowViewController.h"
static NSString *cellId =@"ViewController";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, AVCaptureVideoDataOutputSampleBufferDelegate,CLLocationManagerDelegate>
{
    AVCaptureSession * _session;
}
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) CMMotionManager  *cmmotionManager;
@property (nonatomic, strong) NSString *accemeter;  //加速度
@property (nonatomic, strong) NSString *magfield;  //磁力
@property (nonatomic, strong) NSString *orient;  //方向
@property (nonatomic, strong) NSString *gyros;  //陀螺仪
@property (nonatomic, strong) NSString *light;  //光线感应
@property (nonatomic, strong) NSString *press;  //压力
@property (nonatomic, strong) NSString *tempera; //温度
@property (nonatomic, strong) NSString *prox;  //距离感应
@property (nonatomic, strong) NSString *grav;
@property (nonatomic, strong) NSString *lineacce;
@property (nonatomic, strong) NSString *rota;
@property (nonatomic, strong) NSString *gps;
@property (nonatomic, strong) DetailViewController *detailVC;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *did = [[DanaAnalyticsSDK sharedInstance] getDanaDid];
    
    NSLog(@"%@",did);
    [self setData];
    
    [self setSubviews];
    
    [self startWork];
    
    self.detailVC = [[DetailViewController alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",[DanaAnalyticsSDK sharedInstance].automaticProperties);
}

- (void)startWork {
    self.cmmotionManager.accelerometerUpdateInterval = 0.3;
    [self.cmmotionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]  withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"出错了 %@",error);
            return;
        }
        self.accemeter =[NSString stringWithFormat:@"%.6f,%.6f,%.6f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z];
    }];
    
    
    
    self.cmmotionManager.magnetometerUpdateInterval = 0.3;
    [self.cmmotionManager startMagnetometerUpdatesToQueue:[NSOperationQueue currentQueue]  withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"出错了 %@",error);
            return;
        }
        self.magfield =[NSString stringWithFormat:@"%.6f,%.6f,%.6f",magnetometerData.magneticField.x,magnetometerData.magneticField.y,magnetometerData.magneticField.z];
        
    }];
    
    self.cmmotionManager.gyroUpdateInterval = 0.3;
    [self.cmmotionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]  withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        self.gyros =[NSString stringWithFormat:@"%.6f,%.6f,%.6f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z];
    }];
    
    [self distanceSensor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

- (void)setSubviews {
    self.title =@"主页";
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    self.table.rowHeight =100.0f;
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"detail" style:UIBarButtonItemStylePlain target:self action:@selector(rightItem:)];
}
- (void)rightItem:(id)sender {
    TestInwinowViewController *vc =[[TestInwinowViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)setData {
    
    self.accemeter = @"";
    self.magfield = @"";
    self.orient = @"";
    self.gyros = @"";
    self.light = @"";
    self.press = @"";
    self.tempera = @"";
    self.prox = @"";
    self.grav = @"";
    self.lineacce = @"";
    self.rota = @"";
    self.gps = @"";
    
    self.dataList =[[NSMutableArray alloc] init];
    
    NSDictionary *dic0 =[NSDictionary dictionaryWithObjectsAndKeys:@"SDK激活",@"title",@"hotend",@"event",nil];
    [self.dataList addObject:dic0];
    
    NSDictionary *dic1 =[NSDictionary dictionaryWithObjectsAndKeys:@"注册事件",@"title",@"register",@"event", nil];
    [self.dataList addObject:dic1];
    
    NSDictionary *dic2 =[NSDictionary dictionaryWithObjectsAndKeys:@"登录事件",@"title",@"login",@"event", nil];
    [self.dataList addObject:dic2];
    
    NSDictionary *dic3 =[NSDictionary dictionaryWithObjectsAndKeys:@"创角",@"title",@"create",@"event",nil];
    [self.dataList addObject:dic3];
    
    NSDictionary *dic4 =[NSDictionary dictionaryWithObjectsAndKeys:@"角色登录",@"title",@"rolelogin",@"event",nil];
    [self.dataList addObject:dic4];
    
    NSDictionary *dic5 =[NSDictionary dictionaryWithObjectsAndKeys:@"订单",@"title",@"order",@"event",nil];
    [self.dataList addObject:dic5];
    
    NSDictionary *dic6 =[NSDictionary dictionaryWithObjectsAndKeys:@"热更开始",@"title",@"hotstart",@"event",nil];
    [self.dataList addObject:dic6];
    
    NSDictionary *dic7 =[NSDictionary dictionaryWithObjectsAndKeys:@"热更结束",@"title",@"hotend",@"event",nil];
    [self.dataList addObject:dic7];
    
//    NSDictionary *dic8 =[NSDictionary dictionaryWithObjectsAndKeys:@"分享 （附加参数  分享内容 ：content ）",@"title",@"share",@"event", nil];
//    [self.dataList addObject:dic8];
//
//    NSDictionary *dic9 =[NSDictionary dictionaryWithObjectsAndKeys:@"购买道具 （附加参数  价格 ：price  id：goodsId）",@"title",@"pay",@"event", nil];
//    [self.dataList addObject:dic9];
//
//    NSDictionary *dic10 =[NSDictionary dictionaryWithObjectsAndKeys:@"测试点击后立即将数据上报 （附加参数  key1: vaule1）",@"title",@"test",@"event", nil];
//    [self.dataList addObject:dic10];
//
//    NSDictionary *dic11 =[NSDictionary dictionaryWithObjectsAndKeys:@"登出 （将用户SDK中的ouid登出，系统会将ouid设置为-1）",@"title",@"logout",@"event", nil];
//    [self.dataList addObject:dic11];
//
//    NSDictionary *dic12 =[NSDictionary dictionaryWithObjectsAndKeys:@"测试自定义的计时时件且不是用event当key  假设是用要统计一个商品支付到成功购买的流程   testPayKey",@"title", nil];
//    [self.dataList addObject:dic12];
//
//    NSDictionary *dic13 =[NSDictionary dictionaryWithObjectsAndKeys:@"对应上面的记录这个paypay事件添加时长的一个属性 用这个：testPayKey去获取记录这个事件的时长",@"title",@"paypay",@"event", nil];
//    [self.dataList addObject:dic13];
//
//    NSDictionary *dic14 =[NSDictionary dictionaryWithObjectsAndKeys:@"加速度、磁力、方向等设备数据等（光感，GPS的功能有权限就有值）",@"title",@"devicePrames",@"event", nil];
//    [self.dataList addObject:dic14];
    
    NSDictionary *dic8 =[NSDictionary dictionaryWithObjectsAndKeys:@"闪退",@"title",@"hotend",@"event",nil];
    [self.dataList addObject:dic8];
    
//    NSDictionary *dic10 =[NSDictionary dictionaryWithObjectsAndKeys:@"加速度、磁力、方向等设备数据等（添加光感）",@"title",@"devicePrames",@"event", nil];
//    [self.dataList addObject:dic10];
//
//    NSDictionary *dic11 =[NSDictionary dictionaryWithObjectsAndKeys:@"加速度、磁力、方向等设备数据等（添加GPS的功能）",@"title",@"devicePrames",@"event", nil];
//    [self.dataList addObject:dic11];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[self.table dequeueReusableCellWithIdentifier:cellId];
    NSDictionary *dic =[self.dataList objectAtIndex:indexPath.row];
    cell.textLabel.text =[dic objectForKey:@"title"];
    cell.textLabel.numberOfLines =3;
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CMMotionManager *)cmmotionManager {
    if (_cmmotionManager == nil) {
        _cmmotionManager = [[CMMotionManager alloc] init];
    }
    return _cmmotionManager;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
//    self.cmmotionManager.accelerometerUpdateInterval = 0.3;
//    [self.cmmotionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]  withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
//        if (error != nil) {
//            NSLog(@"出错了 %@",error);
//            return;
//        }
//        NSLog(@"加速度：%@",[NSString stringWithFormat:@"%.6f,%.6f,%.6f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z]);
//    }];
//
//
//
//    self.cmmotionManager.magnetometerUpdateInterval = 0.3;
//    [self.cmmotionManager startMagnetometerUpdatesToQueue:[NSOperationQueue currentQueue]  withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
//        if (error != nil) {
//            NSLog(@"出错了 %@",error);
//            return;
//        }
//        NSLog(@"磁力：%@",[NSString stringWithFormat:@"%.6f,%.6f,%.6f",magnetometerData.magneticField.x,magnetometerData.magneticField.y,magnetometerData.magneticField.z]);
//
//        NSLog(@"方向：%@", [NSString stringWithFormat:@"%li", [[UIDevice currentDevice] orientation]]);
//
//
//
//
//
//    }];
//
//    self.cmmotionManager.gyroUpdateInterval = 0.3;
//    [self.cmmotionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]  withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
//        CMGyroData *newestAccel = gyroData;
//        double rotationRateX = newestAccel.rotationRate.x;
//        double rotationRateY = newestAccel.rotationRate.y;
//        double rotationRateZ = newestAccel.rotationRate.z;
//        NSLog(@"陀螺仪：%@",[NSString stringWithFormat:@"%.6f,%.6f,%.6f",rotationRateX,rotationRateY,rotationRateZ]);
//    }];

    
    NSDictionary *dic =[self.dataList objectAtIndex:indexPath.row];
    #warning postbody数据会在DEBUG环境中打印在控制台的，正式发布环境不会打印。  返回data0 就是数据上报成功
    if (indexPath.section ==0) {
        DAJSONUtil *jsonUtil =[[DAJSONUtil alloc] init];
//        switch (indexPath.row) {
//            case 0:
//                //注册不带参数   不带参数 传 "" 、nil、"{}"都可以
//
//                [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withPropertiesToJson:[[NSString alloc] initWithData:[jsonUtil JSONSerializeObject:nil] encoding:NSUTF8StringEncoding]];
//                break;
//
//            case 1:
//                //登录不带参数，登录成功后设置ouid。 SDK用户登出事件
//
//                [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withPropertiesToJson:[[NSString alloc] initWithData:[jsonUtil JSONSerializeObject:nil] encoding:NSUTF8StringEncoding]];
//
//                //登录成功后 去设置ouid  SDK用户登入设置，后续记录的事件会把用户数据带入
//                [[DanaAnalyticsSDK sharedInstance] login:@"545726267"];
//                break;
//            case 2:
//                //分享添加content 内容参数
//
//                [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withPropertiesToJson:[[NSString alloc] initWithData:[jsonUtil JSONSerializeObject:[NSDictionary dictionaryWithObjectsAndKeys:@"分享的内容",@"content", nil]] encoding:NSUTF8StringEncoding]];
//                break;
//            case 3:
//                //购买道具 添加价格和id
//
//                [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withPropertiesToJson:[[NSString alloc] initWithData:[jsonUtil JSONSerializeObject:[NSDictionary dictionaryWithObjectsAndKeys:@"¥6.00",@"price",@"666",@"goodId", nil]] encoding:NSUTF8StringEncoding]];
//
//                break;
//            case 4:
//                //测试  附加参数  key1: vaule1  立即将数据上报
//                [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withPropertiesToJson:[[NSString alloc] initWithData:[jsonUtil JSONSerializeObject:[NSDictionary dictionaryWithObjectsAndKeys:@"vaule1",@"key1", nil]] encoding:NSUTF8StringEncoding]];
//
//                //立即上报数据
//                [[DanaAnalyticsSDK sharedInstance] flush];
//
//                break;
//            case 5:
//                //SDK用户登出事件
//                [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withPropertiesToJson:[[NSString alloc] initWithData:[jsonUtil JSONSerializeObject:nil] encoding:NSUTF8StringEncoding]];
//                //SDK用户登出
//                [[DanaAnalyticsSDK sharedInstance] logout];
//                break;
//            default:
//                break;
//        }
//
//    }
//    else {
        switch (indexPath.row) {
            case 0://sdk激活
                [[DanaAnalyticsSDK sharedInstance] Dana_Dupgrade];
                break;
            case 1://注册事件
                [[DanaAnalyticsSDK sharedInstance] Dana_RegisterWithType:@"1" ouid:@"test0123456" ad_id:@"123"];
                break;
            case 2:
                //登录事件
                [[DanaAnalyticsSDK sharedInstance] Dana_LoginWithType:@"1" ouid:@"test0123456" ad_id:@"123"];
                break;
            
            case 3: //创角
                [[DanaAnalyticsSDK sharedInstance] Dana_CreateWithOuid:@"test0123456" ad_id:@"123" roleid:@"456" rolename:@"haha" serverid:@"25"];
                break;
                
            case 4://角色登录
                [[DanaAnalyticsSDK sharedInstance] Dana_RoleLoginWithOuid:@"test0123456" ad_id:@"123" roleid:@"456" rolename:@"haha" serverid:@"25"];
                break;
            case 5://订单
                [[DanaAnalyticsSDK sharedInstance] Dana_OrderWithOuid:@"test0123456" ad_id:@"123" roleid:@"456" rolename:@"haha" serverid:@"25" order_id:@"test987654321" pay_amount:@"6"];
                break;
            case 6://热更新开始
                [[DanaAnalyticsSDK sharedInstance] Dana_HotsStartWithAd_id:@"123"];
                break;
            case 7://热更新结束
                [[DanaAnalyticsSDK sharedInstance] Dana_HotsEndWithAd_id:@"123"];
                break;
//            case 8:
//                //分享添加content 内容参数
//                [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"分享的内容",@"content", nil] withReduceBaseProperty:YES];
//                break;
//            case 9:
//                //购买道具 添加价格和id
//                [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"¥6.00",@"price",@"666",@"goodId", nil] withReduceBaseProperty:YES];
//
//                break;
//            case 10:
//                //测试  附加参数  key1: vaule1  立即将数据上报
//                [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"vaule1",@"key1", nil] withReduceBaseProperty:NO];
//
//                //立即上报数据
//                [[DanaAnalyticsSDK sharedInstance] flush];
//                break;
//            case 11:
//                //SDK用户登出事件
//                [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:nil withReduceBaseProperty:YES];
//                //SDK用户登出
//                [[DanaAnalyticsSDK sharedInstance] logout];
//                break;
//            case 12:
//                //立即上报数据
//                [[DanaAnalyticsSDK sharedInstance] trackTimer:@"paypay"];
//                break;
//            case 13:
//
//                [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"vaule123",@"key111", nil] withTrackTimer:@"paypay" withReduceBaseProperty:YES];
//                break;
//            case 14:
//
//                [self.navigationController pushViewController:self.detailVC animated:YES];
//
//                DetailViewController *vc =[[DetailViewController alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
//                 [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:[NSDictionary dictionaryWithObjectsAndKeys:self.accemeter,@"accemeter",self.magfield,@"magfield",[NSString stringWithFormat:@"%li",[[UIDevice currentDevice] orientation]],@"orient",self.gyros,@"gyros",self.press,@"press",self.tempera,@"tempera",self.prox,@"prox",self.grav,@"grav",self.lineacce,@"lineacce",self.rota,@"rota", nil]];
//                break;
            case 8:     //闪退
                [self apperror];
                break;
//            case 16:
//                [self startGetUserLocation];
//                break;
            default:
                break;
        }
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section ==0) {
//        return @"游戏：事件参数传json字符";
//    }
    return @"应用：事件参数传dic";
}

- (NSString *)apperror{
    NSArray *arr = @[@"1"];
    return  arr[2];
}

//是否有访问📷的权限
-(BOOL)DevicePhoto {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"无法使用相机" message:[NSString stringWithFormat:@"请在iPhone的\"设置－隐私－相机\"中允许%@访问您的相机。",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else {
        return YES;
    }
}

//利用摄像头获取环境光感参数 比如拍照时光线暗的时候闪光灯自动打开
- (void)lightSensitive {
    
    // 1.获取硬件设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device == nil) {
        NSLog(@"该换肾了");
        return;
    }
    
    if ([self DevicePhoto]) {
        // 2.创建输入流
        AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
        
        // 3.创建设备输出流
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        
        
        // AVCaptureSession属性
        _session = [[AVCaptureSession alloc]init];
        // 设置为高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        // 添加会话输入和输出
        if ([_session canAddInput:input]) {
            [_session addInput:input];
        }
        if ([_session canAddOutput:output]) {
            [_session addOutput:output];
        }
        
        // 9.启动会话
        [_session startRunning];
    }
    else
    {
        [[DanaAnalyticsSDK sharedInstance] track:@"devicePrames" withProperties:[NSDictionary dictionaryWithObjectsAndKeys:self.accemeter,@"accemeter",self.magfield,@"magfield",[NSString stringWithFormat:@"%li",[[UIDevice currentDevice] orientation]],@"orient",self.gyros,@"gyros",self.press,@"press",self.tempera,@"tempera",self.prox,@"prox",self.grav,@"grav",self.lineacce,@"lineacce",self.rota,@"rota",self.light,@"light", nil]];
    
    }

    
}
#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    self.light = [NSString stringWithFormat:@"%f",brightnessValue];
    NSLog(@"环境光感 ： %f",brightnessValue);
    
    [_session stopRunning];
    [[DanaAnalyticsSDK sharedInstance] track:@"devicePrames" withProperties:[NSDictionary dictionaryWithObjectsAndKeys:self.accemeter,@"accemeter",self.magfield,@"magfield",[NSString stringWithFormat:@"%li",[[UIDevice currentDevice] orientation]],@"orient",self.gyros,@"gyros",self.press,@"press",self.tempera,@"tempera",self.prox,@"prox",self.grav,@"grav",self.lineacce,@"lineacce",self.rota,@"rota",self.light,@"light", nil]];
}


- (void)startGetUserLocation {
    if ([CLLocationManager locationServicesEnabled]&&_locationManager==nil) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 1000;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
        
    }
    else if ([CLLocationManager locationServicesEnabled]&&_locationManager!=nil){
        [_locationManager startUpdatingLocation];
    }
    else {
        [self openGPSTips];
    }
}

//获取定位失败回调方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    switch([error code]) {
        case kCLErrorDenied:
            [self openGPSTips];
            break;
        case kCLErrorLocationUnknown:
            break;
        default:
            break;
    }
    [self openGPSTips];
    [[DanaAnalyticsSDK sharedInstance] track:@"devicePrames" withProperties:[NSDictionary dictionaryWithObjectsAndKeys:self.accemeter,@"accemeter",self.magfield,@"magfield",[NSString stringWithFormat:@"%li",[[UIDevice currentDevice] orientation]],@"orient",self.gyros,@"gyros",self.press,@"press",self.tempera,@"tempera",self.prox,@"prox",self.grav,@"grav",self.lineacce,@"lineacce",self.rota,@"rota",self.gps,@"gps", nil]];
}
-(void)openGPSTips{
  
    UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:@"请到“设置->隐私->定位服务”中开启定位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alet show];
}
#pragma mark - location Delegate

// iso 6.0以上SDK版本使用，包括6.0。
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *cl = [locations objectAtIndex:0];
    [manager stopUpdatingLocation];
    self.gps = [NSString stringWithFormat:@"%f,%f",cl.coordinate.longitude,cl.coordinate.latitude];
    [[DanaAnalyticsSDK sharedInstance] track:@"devicePrames" withProperties:[NSDictionary dictionaryWithObjectsAndKeys:self.accemeter,@"accemeter",self.magfield,@"magfield",[NSString stringWithFormat:@"%li",[[UIDevice currentDevice] orientation]],@"orient",self.gyros,@"gyros",self.press,@"press",self.tempera,@"tempera",self.prox,@"prox",self.grav,@"grav",self.lineacce,@"lineacce",self.rota,@"rota",self.gps,@"gps", nil]];
//    [self getedUserLocation:cl.coordinate.longitude AndWei:cl.coordinate.latitude];

}


//距离传感器 感应是否有其他物体靠近屏幕,iPhone手机中内置了距离传感器，位置在手机的听筒附近，当我们在打电话或听微信语音的时候靠近听筒，手机的屏幕会自动熄灭，这就靠距离传感器来控制
- (void)distanceSensor{
    // 打开距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    
    // 通过通知监听有物品靠近还是离开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
    self.prox = @"0";
    
}

- (void)proximityStateDidChange:(NSNotification *)note
{
    if ([UIDevice currentDevice].proximityState) {
        NSLog(@"有东西靠近"); //但是屏幕会变暗，不能产生什么操作性事件
        self.prox = @"1";
     
    } else {
        NSLog(@"有物体离开");
       self.prox = @"0";
    }
}

@end
