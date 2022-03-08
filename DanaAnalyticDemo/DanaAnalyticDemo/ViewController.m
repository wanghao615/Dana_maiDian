//
//  ViewController.m
//  DanaAnalyticDemo
//
//  Created by xiongsh on 2017/4/10.
//  Copyright © 2017年 xiongsh. All rights reserved.
//

#import "ViewController.h"
#import <DanaAnalytic/DanaAnalytic.h>
#import "DetailViewController.h"
static NSString *cellId =@"ViewController";
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataList;
@property (nonatomic, strong) DetailViewController *detailVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"did=%@",[[DanaAnalyticsSDK sharedInstance] getDanaDid]);
    
    [self setData];
    
    [self setSubviews];
    self.detailVC = [[DetailViewController alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setSubviews {
    self.title =@"主页";
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    self.table.rowHeight =100.0f;
//    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"detail" style:UIBarButtonItemStylePlain target:self action:@selector(rightItem:)];
}
- (void)rightItem:(id)sender {
    DetailViewController *vc =[[DetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)setData {
    self.dataList =[[NSMutableArray alloc] init];
    
    NSDictionary *dic0 =[NSDictionary dictionaryWithObjectsAndKeys:@"启动事件",@"title", nil];
    [self.dataList addObject:dic0];
    
    NSDictionary *dic1 =[NSDictionary dictionaryWithObjectsAndKeys:@"注册 （不附加参数）",@"title",@"register",@"event", nil];
    [self.dataList addObject:dic1];
    
    NSDictionary *dic2 =[NSDictionary dictionaryWithObjectsAndKeys:@"登录 （不附加参数 但是成功后，设置用户ID：ouid）",@"title",@"login",@"event", nil];
    [self.dataList addObject:dic2];
    
    NSDictionary *dic3 =[NSDictionary dictionaryWithObjectsAndKeys:@"分享 （附加参数  分享内容 ：content ）",@"title",@"share",@"event", nil];
    [self.dataList addObject:dic3];
    
    NSDictionary *dic4 =[NSDictionary dictionaryWithObjectsAndKeys:@"购买道具 （附加参数  价格 ：price  id：goodsId）",@"title",@"pay",@"event", nil];
    [self.dataList addObject:dic4];
    
    NSDictionary *dic5 =[NSDictionary dictionaryWithObjectsAndKeys:@"测试点击后立即将数据上报 （附加参数  key1: vaule1）",@"title",@"test",@"event", nil];
    [self.dataList addObject:dic5];
    
    NSDictionary *dic6 =[NSDictionary dictionaryWithObjectsAndKeys:@"登出 （将用户SDK中的ouid登出，系统会将ouid设置为-1）",@"title",@"logout",@"event", nil];
    [self.dataList addObject:dic6];
    
    NSDictionary *dic7 =[NSDictionary dictionaryWithObjectsAndKeys:@"测试自定义的计时时件且不是用event当key  假设是用要统计一个商品支付到成功购买的流程   testPayKey",@"title", nil];
    [self.dataList addObject:dic7];
    
    NSDictionary *dic8 =[NSDictionary dictionaryWithObjectsAndKeys:@"对应上面的记录这个paypay事件添加时长的一个属性 用这个：testPayKey去获取记录这个事件的时长",@"title",@"paypay",@"event", nil];
    [self.dataList addObject:dic8];
    
    NSDictionary *dic9 =[NSDictionary dictionaryWithObjectsAndKeys:@"加速度、磁力、方向等设备数据等（光感，GPS的功能有权限就有值）",@"title",@"devicePrames",@"event", nil];
    [self.dataList addObject:dic9];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic =[self.dataList objectAtIndex:indexPath.row];
#warning 通过logSwitch 控制台打印postbody日志和服务器返回的数据 
    [DanaAnalyticsSDK sharedInstance].logSwitch = YES;
            switch (indexPath.row) {
                case 0:
                    //启动的事件
                    [[DanaAnalyticsSDK sharedInstance] Dana_Activation];
                    break;
                case 1:
                    //注册不带参数 withReduceBaseProperty
                    [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"formloginpage",@"window", nil] withReduceBaseProperty:YES];
                    break;
                    
                case 2:
                    //登录成功后 去设置ouid  SDK用户登入设置，后续记录的事件会把用户数据带入
                    [[DanaAnalyticsSDK sharedInstance] login:@"545726267"];
                    
                    //登录不带参数，登录成功后设置ouid。 SDK用户登出事件
                    [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:nil withReduceBaseProperty:YES];
                    
                    
                    break;
                case 3:
                    //分享添加content 内容参数
                    [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"分享的内容",@"content", nil] withReduceBaseProperty:YES];
                    break;
                case 4:
                    //购买道具 添加价格和id
                    [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"¥6.00",@"price",@"666",@"goodId", nil] withReduceBaseProperty:YES];
                    
                    break;
                case 5:
                    //测试  附加参数  key1: vaule1  立即将数据上报
                    [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"vaule1",@"key1", nil] withReduceBaseProperty:YES];
                    
                    //立即上报数据
                    [[DanaAnalyticsSDK sharedInstance] flush];
                    break;
                case 6:
                    
                    //SDK用户登出事件
                    [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:nil withReduceBaseProperty:YES];
                    //SDK用户登出
                    [[DanaAnalyticsSDK sharedInstance] logout];
                    break;
                case 7:
                    //立即上报数据
                    [[DanaAnalyticsSDK sharedInstance] trackTimer:@"paypay"];
                    break;
                case 8:
                    
                    [[DanaAnalyticsSDK sharedInstance] track:[dic objectForKey:@"event"] withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"vaule123",@"key111", nil] withTrackTimer:@"paypay" withReduceBaseProperty:YES];
                    break;
                case 9:
                    
                    [[DanaAnalyticsSDK sharedInstance] trackExtend:@"read" withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"101",@"itemid",@"11110000",@"mediaid",@"1",@"itemtype",@"100",@"sortid",@"999",@"timemachid",@"111",@"subjectid",@"1",@"reftype",@"147",@"refid", nil] withReduceBaseProperty:NO];
                    
                    break;
               
                default:
                    break;
            }
   
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"应用：事件参数传dic";
}
@end
