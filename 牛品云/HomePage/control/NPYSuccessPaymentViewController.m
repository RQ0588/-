//
//  NPYSuccessPaymentViewController.m
//  牛品云
//
//  Created by Eric on 16/11/14.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYSuccessPaymentViewController.h"
#import "NPYBaseConstant.h"

@interface NPYSuccessPaymentViewController ()

@end

@implementation NPYSuccessPaymentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"支付成功";
    
    self.view.backgroundColor = GRAY_BG;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0]};
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    [self subViewsLoad];
}

- (void)subViewsLoad {
    //
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 200)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIImageView *sucImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    sucImgView.image = [UIImage imageNamed:@"placeholder"];
    sucImgView.center = CGPointMake(WIDTH_SCREEN / 2, 35);
    [topView addSubview:sucImgView];
    
    UILabel *sucL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sucImgView.frame) + 10, 100, 20)];
    sucL.text = @"支付成功";
    sucL.textColor = [UIColor blackColor];
    sucL.center = CGPointMake(WIDTH_SCREEN / 2, CGRectGetMidY(sucL.frame));
    [topView addSubview:sucL];
    
    UILabel *alertL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sucL.frame) + 10, WIDTH_SCREEN, 20)];
    alertL.text = @"亲、我们会尽快给您发货，请保持手机通畅~";
    alertL.textColor = [UIColor grayColor];
    alertL.textAlignment = NSTextAlignmentCenter;
    alertL.font = [UIFont systemFontOfSize:12.0];
    [topView addSubview:alertL];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(alertL.frame) + 10, WIDTH_SCREEN, 1)];
    lineImg.backgroundColor = GRAY_BG;
    [topView addSubview:lineImg];
    
    UIButton *lookOrder = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lineImg.frame) + 10, 100, 30)];
    [lookOrder setTitle:@"查看订单" forState:UIControlStateNormal];
    [lookOrder setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    lookOrder.layer.borderColor = [UIColor redColor].CGColor;
    lookOrder.layer.borderWidth = 1.0;
    lookOrder.layer.cornerRadius = 5.0;
    lookOrder.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [lookOrder addTarget:self action:@selector(lookOrderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:lookOrder];
    
    UIButton *waite = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - 120, CGRectGetMinY(lookOrder.frame), 100, 30)];
    [waite setTitle:@"再去逛逛" forState:UIControlStateNormal];
    [waite setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    waite.layer.borderColor = [UIColor redColor].CGColor;
    waite.layer.borderWidth = 1.0;
    waite.layer.cornerRadius = 5.0;
    waite.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [waite addTarget:self action:@selector(waiteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:waite];
    
    
    UILabel *safeAlert = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topView.frame), WIDTH_SCREEN - 20, 50)];
    safeAlert.text = @"安全提醒：牛品云不会以任何理由要求您提供银行卡信息或支付额外费用，请谨防钓鱼链接或诈骗电话。";
    safeAlert.textColor = [UIColor grayColor];
    safeAlert.numberOfLines = 0;
    safeAlert.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:safeAlert];
}

- (void)lookOrderButtonPressed:(UIButton *)btn {
    //跳到订单详情
    NSLog(@"跳到订单详情...");
}

- (void)waiteButtonPressed:(UIButton *)btn {
    //跳到首页
    [self.navigationController popToRootViewControllerAnimated:YES];
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
