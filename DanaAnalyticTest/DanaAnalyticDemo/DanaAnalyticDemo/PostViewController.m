//
//  PostViewController.m
//  DanaAnalyticDemo
//
//  Created by xiongsh on 2017/4/18.
//  Copyright © 2017年 xiongsh. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    
    [self setSubviews];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)setSubviews {
    self.title =@"Post";
    self.view.backgroundColor =[UIColor whiteColor];
//    self.btnPost =[[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [self.btnPost addTarget:self action:@selector(btnPostClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.btnPost setBackgroundColor:[UIColor blueColor]];
//    [self.btnPost setTitle:@"发帖子" forState:UIControlStateNormal];
//    [self.view addSubview:self.btnPost];
    
}
- (void)setData {
    
}
-(NSDictionary *)getTrackProperties {
    return @{@"window":@"功能位发帖页面",@"windowtype":@"功能位分类发帖"}; //可少传
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
