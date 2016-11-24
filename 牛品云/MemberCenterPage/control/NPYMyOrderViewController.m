//
//  NPYMyOrderViewController.m
//  牛品云
//
//  Created by Eric on 16/11/22.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYMyOrderViewController.h"
#import "NPYBaseConstant.h"
#import "NPYTableViewCell.h"
#import "NPYPaymentViewController.h"
#import "NPYOrdeDetailViewController.h"

@interface NPYMyOrderViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSInteger number_Tag;       //记录选中按钮的tag值
}

@property (nonatomic, strong) UIView        *topMenuView;
@property (nonatomic, strong) UITableView   *mainTableView;

@property (nonatomic, strong) NPYPaymentViewController      *paymentVC;
@property (nonatomic, strong) NPYOrdeDetailViewController   *orderDetailVC;

@end

@implementation NPYMyOrderViewController

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
    
    self.view.backgroundColor = GRAY_BG;
    self.navigationItem.title = @"我的订单";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    [self topMenuViewLoad];
    
    [self mainTableViewLoad];
}

//midMenuView
- (void)topMenuViewLoad {
    UIView *topMenuView = [[UIView alloc] init];
    topMenuView.backgroundColor = [UIColor whiteColor];
    topMenuView.frame = CGRectMake(0, CGRectGetMaxY(self.self.navigationController.navigationBar.frame) + 10, WIDTH_SCREEN, 40);
    [self.view addSubview:topMenuView];
    self.topMenuView = topMenuView;
    //button
    NSArray *nameBtn = @[@"全部",@"待付款",@"待收货",@"待评价",@"售后/退款"];
    for (int i = 0; i < nameBtn.count; i++) {
        UIButton *menuBtn = [[UIButton alloc] init];
        menuBtn.frame = CGRectMake(i * WIDTH_SCREEN / nameBtn.count, 0, WIDTH_SCREEN / nameBtn.count, CGRectGetHeight(topMenuView.frame));
        [menuBtn setTag:2000 + i];
        [menuBtn setTitle:nameBtn[i] forState:UIControlStateNormal];
        [menuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [menuBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        UIImageView *selectedImgView = [[UIImageView alloc] init];
        selectedImgView.image = [UIImage imageNamed:@"testLine"];
        selectedImgView.tag = menuBtn.tag + 100;
        selectedImgView.frame = CGRectMake(0, CGRectGetHeight(menuBtn.frame) - 2, CGRectGetWidth(menuBtn.frame), 2);
        [menuBtn addSubview:selectedImgView];
        if (i == 0) {
            menuBtn.selected = YES;
            selectedImgView.hidden = NO;
            number_Tag = 2000;
        } else {
            menuBtn.selected = NO;
            selectedImgView.hidden = YES;
        }
        
        [menuBtn addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [topMenuView addSubview:menuBtn];
    }
}

//tableView
- (void)mainTableViewLoad {
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topMenuView.frame), WIDTH_SCREEN, HEIGHT_SCREEN - CGRectGetMaxY(self.topMenuView.frame)) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    NPYTableViewCell *cell = (NPYTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NPYTableViewCell" owner:nil options:nil] firstObject];
        if (indexPath.section == 0) {
            cell.orderState.text = @"待付款";
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    NPYTableViewCell *cell = (NPYTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.orderState.text isEqualToString:@"待付款"]) {
        //待付款单独界面
        self.paymentVC = [[NPYPaymentViewController alloc] init];
        [self.navigationController pushViewController:self.paymentVC animated:YES];
        
    } else {
        //订单详情统一界面
        self.orderDetailVC = [[NPYOrdeDetailViewController alloc] init];
        [self.navigationController pushViewController:self.orderDetailVC animated:YES];
        
    }
}

#pragma mark - 

//菜单按钮的点击事件
//(2000 - 2004)
- (void)menuButtonPressed:(UIButton *)btn {
    //    NSLog(@"菜单按钮点击了...%li",btn.tag);
    if (number_Tag == btn.tag) {
        return;
    }
    
    btn.selected = YES;
    UIImageView *tmpImgView = [self.view viewWithTag:btn.tag + 100];
    tmpImgView.hidden = NO;
    
    UIButton *tmpBtn = [self.view viewWithTag:number_Tag];
    tmpBtn.selected = NO;
    UIImageView *tmpImgView2 = [self.view viewWithTag:number_Tag + 100];
    tmpImgView2.hidden = YES;
    
    number_Tag = btn.tag;
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
