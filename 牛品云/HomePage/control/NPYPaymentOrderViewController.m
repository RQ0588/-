//
//  NPYPaymentOrderViewController.m
//  牛品云
//
//  Created by Eric on 16/11/14.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYPaymentOrderViewController.h"
#import "NPYBaseConstant.h"
#import "NPYSuccessPaymentViewController.h"

@interface NPYPaymentOrderViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *mainTableView;
    
    UILabel *orderIDL,*payAmountL;
    
    NSArray *cellImages,*cellNames;
    NSInteger oldSelectBtnTag;
}

@property (nonatomic, strong) NPYSuccessPaymentViewController   *sucPayVC;

@end

@implementation NPYPaymentOrderViewController

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
    
    self.navigationItem.title = @"支付订单";
    
    self.view.backgroundColor = GRAY_BG;
    
    cellImages = @[@"placeholder",@"placeholder",@"placeholder"];
//    NSString *strL = [NSString stringWithFormat:@"钱包支付（余额: 10.00元）"];
//    cellNames = @[@"微信支付",@"支付宝支付",strL];
    cellNames = @[@"微信支付",@"支付宝支付"];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0]};
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    [self mainViewLoad];
    
    [self bottomViewLoad];
}

- (void)mainViewLoad {
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStylePlain];
    [self.view addSubview:mainTableView];
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.backgroundColor = [UIColor clearColor];
}

- (void)bottomViewLoad {
    UIButton *CPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 350, WIDTH_SCREEN - 20, 40)];
    CPayBtn.backgroundColor = [UIColor redColor];
    [CPayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [CPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [CPayBtn addTarget:self action:@selector(ConfirmThePaymentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mainTableView addSubview:CPayBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellNames.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    mainTableView.tableHeaderView = headerView;
    headerView.backgroundColor = GRAY_BG;
    
    UILabel *orderId = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
    [headerView addSubview:orderId];
    orderId.text = @"订单编号：";
    orderId.textColor = [UIColor blackColor];
    orderId.font = [UIFont systemFontOfSize:15.0];
    
    orderIDL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(orderId.frame), CGRectGetMinY(orderId.frame), 200, 20)];
    [headerView addSubview:orderIDL];
    orderIDL.text = @"6546565652300";
    orderIDL.textColor = [UIColor blackColor];
    orderIDL.textAlignment = NSTextAlignmentRight;
    orderIDL.font = [UIFont systemFontOfSize:15.0];
    
    UILabel *payAmount = [[UILabel alloc] initWithFrame:orderId.frame];
    [headerView addSubview:payAmount];
    payAmount.text = @"支付金额：";
    payAmount.textColor = [UIColor blackColor];
    payAmount.font = [UIFont systemFontOfSize:15.0];
    payAmount.center = CGPointMake(CGRectGetMidX(orderId.frame), CGRectGetMaxY(orderId.frame) + 10 + CGRectGetHeight(payAmount.frame) / 2);
    
    payAmountL = [[UILabel alloc] initWithFrame:orderIDL.frame];
    [headerView addSubview:payAmountL];
    payAmountL.text = @"￥38.80";
    payAmountL.textColor = [UIColor blackColor];
    payAmountL.textAlignment = NSTextAlignmentRight;
    payAmountL.font = [UIFont systemFontOfSize:15.0];
    payAmountL.center = CGPointMake(CGRectGetMidX(orderIDL.frame), CGRectGetMaxY(orderIDL.frame) + 10 + CGRectGetHeight(payAmountL.frame) / 2);
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mainCell";
    UITableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!mainCell) {
        mainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if (indexPath.row == 0) {
            mainCell.textLabel.text = @"选择支付方式";
            mainCell.textLabel.textColor = [UIColor grayColor];
            mainCell.textLabel.font = [UIFont systemFontOfSize:10.0];
        } else {
        
            mainCell.imageView.image = [UIImage imageNamed:cellImages[indexPath.row - 1]];
            
            mainCell.textLabel.text = cellNames[indexPath.row - 1];
            
            UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - 40, 0, 20, 20)];
            [mainCell addSubview:selectBtn];
            selectBtn.tag = indexPath.row + 1000;
            selectBtn.backgroundColor = [UIColor grayColor];
            selectBtn.center = CGPointMake(CGRectGetMidX(selectBtn.frame), CGRectGetHeight(mainCell.frame) / 2);
            [selectBtn addTarget:self action:@selector(selectButtonChangePaymentWay:) forControlEvents:UIControlEventTouchUpInside];
            if (indexPath.row == 1) {
                selectBtn.selected = YES;
                selectBtn.backgroundColor = [UIColor redColor];
                oldSelectBtnTag = selectBtn.tag;
            } else {
                selectBtn.selected = NO;
            }
        }
    }
    
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return mainCell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

#pragma mark - UIButton Event

- (void)selectButtonChangePaymentWay:(UIButton *)btn {
    if (oldSelectBtnTag == btn.tag) {
//        NSLog(@"选择微信支付");
        return;
    }
    
    btn.selected = YES;
    btn.backgroundColor = [UIColor redColor];
    
    UIButton *oldBtn = [self.view viewWithTag:oldSelectBtnTag];
    oldBtn.selected = NO;
    oldBtn.backgroundColor = [UIColor grayColor];
    
    oldSelectBtnTag = btn.tag;
}

- (void)ConfirmThePaymentButtonPressed:(UIButton *)btn {
//    NSLog(@"确定支付...");
    self.sucPayVC = [[NPYSuccessPaymentViewController alloc] init];
    [self.navigationController pushViewController:self.sucPayVC animated:YES];
}

#pragma mark - 更改tableView的分割线顶格显示
- (void)viewDidLayoutSubviews
{
    if ([mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - ...

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
