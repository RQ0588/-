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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
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
    
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0]};
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    [self subViewsLoad];
}

- (void)subViewsLoad {
    //
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, WIDTH_SCREEN, 260)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIImageView *sucImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    sucImgView.image = [UIImage imageNamed:@"zfcg_gouwu"];
    sucImgView.center = CGPointMake(WIDTH_SCREEN / 2, 75);
    [topView addSubview:sucImgView];
    
    UILabel *sucL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sucImgView.frame) + 15, 100, 20)];
    sucL.text = @"支付成功";
    sucL.textColor = XNColor(51, 51, 51, 1);
    sucL.font = XNFont(18.0);
    sucL.textAlignment = NSTextAlignmentCenter;
    sucL.center = CGPointMake(WIDTH_SCREEN / 2, CGRectGetMidY(sucL.frame));
    [topView addSubview:sucL];
    
    UILabel *alertL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sucL.frame) + 15, WIDTH_SCREEN, 20)];
    alertL.text = @"亲、我们会尽快给您发货，请保持手机通畅~";
    alertL.textColor = XNColor(166, 166, 166, 1);
    alertL.textAlignment = NSTextAlignmentCenter;
    alertL.font = [UIFont systemFontOfSize:12.0];
    [topView addSubview:alertL];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(alertL.frame) + 15, WIDTH_SCREEN, 1)];
//    lineImg.backgroundColor = GRAY_BG;
    lineImg.image = [UIImage imageNamed:@"750huixian_92"];
    [topView addSubview:lineImg];
    
    UIButton *lookOrder = [[UIButton alloc] initWithFrame:CGRectMake(43, CGRectGetMaxY(lineImg.frame) + 10, 100, 30)];
    [lookOrder setTitle:@"查看订单" forState:UIControlStateNormal];
    [lookOrder setBackgroundImage:[UIImage imageNamed:@"hongkuang_gouwu"] forState:UIControlStateNormal];
    [lookOrder setTitleColor:XNColor(248, 31, 31, 1) forState:UIControlStateNormal];
    lookOrder.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [lookOrder addTarget:self action:@selector(lookOrderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:lookOrder];
    
    UIButton *waite = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - 143, CGRectGetMinY(lookOrder.frame), 100, 30)];
    [waite setTitle:@"再去逛逛" forState:UIControlStateNormal];
    [waite setBackgroundImage:[UIImage imageNamed:@"hongkuang_gouwu"] forState:UIControlStateNormal];
    [waite setTitleColor:XNColor(248, 31, 31, 1) forState:UIControlStateNormal];
    waite.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [waite addTarget:self action:@selector(waiteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:waite];
    
    
    UILabel *safeAlert = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(topView.frame) + 15, WIDTH_SCREEN - 30, 50)];
    safeAlert.text = @"安全提醒：牛品云不会以任何理由要求您提供银行卡信息或支付额外费用，请谨防钓鱼链接或诈骗电话。";
    safeAlert.textColor = XNColor(166, 166, 166, 1);
    safeAlert.numberOfLines = 0;
    safeAlert.font = [UIFont systemFontOfSize:12.0];
    [self setLabelSpace:safeAlert withValue:safeAlert.text withFont:[UIFont systemFontOfSize:12.0]];
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

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
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
