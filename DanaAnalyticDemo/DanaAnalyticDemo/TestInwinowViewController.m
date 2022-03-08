//
//  TestInwinowViewController.m
//  DanaAnalyticDemo
//
//  Created by xiongsh on 2017/4/26.
//  Copyright © 2017年 xiongsh. All rights reserved.
//

#import "TestInwinowViewController.h"
#import <DanaAnalytic/DanaAnalytic.h>
@interface TestInwinowViewController ()<DAAutoTracker>

@end

@implementation TestInwinowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"Test";
    self.view.backgroundColor =[UIColor whiteColor];
    
    UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width-20, 100)];
    btn.titleLabel.numberOfLines =0;
    [btn setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1]];
    [btn addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"开始统计用:testStartTimer为key 作为事件testPayPay的时长" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UIButton *btn2 =[[UIButton alloc] initWithFrame:CGRectMake(10, 250, self.view.bounds.size.width-20, 100)];
    btn2.titleLabel.numberOfLines =0;
    [btn2 setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1]];
    [btn2 addTarget:self action:@selector(endTimerAndCommitEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"提交事件testPayPay 只要点击上一步（SDK会统计这个事件的时长 timecount）" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    // Do any additional setup after loading the view.
}

- (void)startTimer {
    [[DanaAnalyticsSDK sharedInstance] trackTimer:@"testStartTimer"];
}

- (void)endTimerAndCommitEvent {
// withTrackTimer:@"testStartTimer"  和第一步参数对应，即可给事件testPayPay添加timecount时长   [[DanaAnalyticsSDK sharedInstance] trackTimer:@"testStartTimer"];
    
    [[DanaAnalyticsSDK sharedInstance] track:@"testPayPay" withProperties:@{@"testPayGoodId":@"9876543"} withTrackTimer:@"testStartTimer"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDictionary *)getTrackProperties {
    return @{@"window":@"TestInwinowViewController",@"windowtype":@"TestInwinowViewControllerwindowtype",@"text":@"内容"}; //可少传
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
