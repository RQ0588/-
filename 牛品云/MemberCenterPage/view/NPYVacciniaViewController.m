//
//  NPYVacciniaViewController.m
//  牛品云
//
//  Created by Eric on 16/12/20.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYVacciniaViewController.h"
#import "NPYBaseConstant.h"

@interface NPYVacciniaViewController ()

@end

@implementation NPYVacciniaViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"获取牛豆";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    self.mainScroller.contentSize = CGSizeMake(0, WIDTH_SCREEN + 50);
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//fenxiang
- (IBAction)shareButtonPressed:(id)sender {
    ShareObject *share = [ShareObject shareDefault];
    [share sendMessageWithTitle:@"share" withContent:@"shareDetail" withUrl:@"" withImages:[NSArray new] result:^(NSString *result, UIAlertViewStyle style) {
       
        [ZHProgressHUD showMessage:result inView:self.view];
        
    }];

}

- (IBAction)wxClick:(id)sender {
    //weixinhaoyou
    
}

- (IBAction)wxFriendClick:(id)sender {
    //weixinpengyouquan
    
}
- (IBAction)wbClick:(id)sender {
    //weibo
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
