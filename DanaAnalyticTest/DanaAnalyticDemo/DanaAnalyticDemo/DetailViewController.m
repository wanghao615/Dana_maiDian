//
//  DetailViewController.m
//  DanaAnalyticDemo
//
//  Created by xiongsh on 2017/4/18.
//  Copyright © 2017年 xiongsh. All rights reserved.
//

#import "DetailViewController.h"
#import "PostViewController.h"
#import "DanaAnalytic.h"
@interface DetailViewController ()
@property (nonatomic, strong)UIButton *btnPost;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    
    [self setSubviews];
    
    // Do any additional setup after loading the view, typically from a nib.
    [[DanaAnalyticsSDK sharedInstance] track:@"apperror" withProperties:@{@"type": @"test"} withReduceBaseProperty:NO];
}
- (void)setSubviews {
    self.title =@"Detail";
    self.btnPost =[[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.btnPost addTarget:self action:@selector(btnPostClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPost setBackgroundColor:[UIColor blueColor]];
    [self.btnPost setTitle:@"阅读事件" forState:UIControlStateNormal];
    [self.view addSubview:self.btnPost];
    self.view.backgroundColor =[UIColor whiteColor];
}
- (void)setData {

}
- (void)btnPostClick:(id)sender {
//    PostViewController *vc =[[PostViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [[DanaAnalyticsSDK sharedInstance] trackExtend:@"read" withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"101",@"itemid",@"11110000",@"mediaid",@"1",@"itemtype",@"100",@"sortid",@"999",@"timemachid",@"111",@"subjectid",@"1",@"reftype",@"147",@"refid", nil] withReduceBaseProperty:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSDictionary *)getTrackProperties {
    return @{@"window":@"功能位详情页面",@"windowtype":@"功能位分类详情",@"text":@"详情内容"}; //可少传 
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
