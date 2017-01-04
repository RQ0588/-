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

#import "NPYMyOrderModel.h"

#define OrderUrl @"/index.php/app/Order/get"

@interface NPYMyOrderViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSInteger number_Tag;       //记录选中按钮的tag值
    
    NSMutableArray *dataArr;
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
    
    dataArr = [NSMutableArray new];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    [self topMenuViewLoad];
    
    [self mainTableViewLoad];
    
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"sign"],@"sign",model.user_id,@"user_id",@"all",@"type",@"0",@"num", nil];
    [self requestOrderInfoWithUrlString:OrderUrl withParames:request];
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
        [menuBtn setTitleColor:XNColor(102, 102, 102, 1) forState:UIControlStateNormal];
        [menuBtn setTitleColor:XNColor(248, 31, 31, 1) forState:UIControlStateSelected];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        UIImageView *selectedImgView = [[UIImageView alloc] init];
        selectedImgView.image = [UIImage imageNamed:@"hongxian_xz"];
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
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topMenuView.frame), WIDTH_SCREEN, HEIGHT_SCREEN - CGRectGetMaxY(self.topMenuView.frame)-1) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.backgroundColor = GRAY_BG;
    self.mainTableView.estimatedRowHeight = 100;
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.separatorColor = GRAY_BG;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    NPYTableViewCell *cell = (NPYTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NPYTableViewCell" owner:nil options:nil] firstObject];
    }
    
    cell.model = dataArr[indexPath.section];
    
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

#pragma mark - 网络请求

- (void)requestOrderInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            for (NSDictionary *dic in dataDict[@"data"]) {
                NPYMyOrderModel *model = [NPYMyOrderModel mj_objectWithKeyValues:dic];
                
                [dataArr addObject:model];
            }
            
            [self.mainTableView reloadData];
            
        } else {
            //失败
            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
            //            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
