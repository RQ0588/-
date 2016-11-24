//
//  NPYLogisticsViewController.m
//  牛品云
//
//  Created by Eric on 16/11/23.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYLogisticsViewController.h"
#import "NPYBaseConstant.h"

@interface NPYLogisticsViewController () {
    UIView  *topView;
    UIImageView *goodsImgView;
    UILabel *logisticsStateL;
    UILabel *courierL;
    UILabel *waybillID;
}

@end

@implementation NPYLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    self.navigationItem.title = @"物流信息";
    
    self.view.backgroundColor = GRAY_BG;
    
    [self topViewLoad];
}

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

- (void)topViewLoad {
    //topView
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, WIDTH_SCREEN, 100)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.borderColor = GRAY_BG.CGColor;
    topView.layer.borderWidth = 0.5;
    [self.view addSubview:topView];
    //
    goodsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 60, 60)];
    [goodsImgView sd_setImageWithURL:[NSURL new] placeholderImage:[UIImage imageNamed:@"background_01"]];
    goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
    goodsImgView.layer.borderWidth = 0.5;
    goodsImgView.layer.borderColor = GRAY_BG.CGColor;
    [topView addSubview:goodsImgView];
    //
    UILabel *stateL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImgView.frame) + 10, CGRectGetMinY(goodsImgView.frame), 100, 20)];
    stateL.text = @"物流状态";
    stateL.textColor = [UIColor blackColor];
    stateL.font = [UIFont systemFontOfSize:15.0];
    [topView addSubview:stateL];
    
    logisticsStateL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stateL.frame), CGRectGetMinY(stateL.frame), WIDTH_SCREEN, CGRectGetHeight(stateL.frame))];
    logisticsStateL.text = @"已签收";
    logisticsStateL.textColor = [UIColor redColor];
    logisticsStateL.font = [UIFont systemFontOfSize:15.0];
    [topView addSubview:logisticsStateL];
    //
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
