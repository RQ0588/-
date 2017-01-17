//
//  NPYMessageViewController.m
//  牛品云
//
//  Created by Eric on 16/11/14.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYMessageViewController.h"
#import "NPYBaseConstant.h"
#import "NPYMsgDetailViewController.h"

#define MESSAGENUMBER @"/index.php/app/Push/get_num"

@interface NPYMessageViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSArray *msgNames,*imges;
    
    UITableView *mainTableView;
}

@property (nonatomic, strong) NPYMsgDetailViewController *msgDetailVC;

@property (nonatomic, strong) NSDictionary *noticNumberDict;

@end

@implementation NPYMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    msgNames = @[@"优惠消息",@"通知消息"];
    imges = @[@"youhui_xiaoxi",@"tongzhi_xiaoxi"];
    
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id", nil];
    
    [self requestMessageNumberWithUrlString:MESSAGENUMBER withParames:request];
    
    [self navigationViewLoad];
    
    [self mainViewLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.tabBarController.tabBar.hidden = NO;
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationViewLoad {
    self.navigationItem.title = @"消息";
    self.view.backgroundColor = GRAY_BG;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)mainViewLoad {
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStylePlain];
    [self.view addSubview:mainTableView];
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.backgroundColor = GRAY_BG;
    mainTableView.separatorColor = GRAY_BG;
    mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    mainTableView.scrollEnabled = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mainCell";
    UITableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!mainCell) {
        mainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        
    }
    
    mainCell.imageView.image = [UIImage imageNamed:imges[indexPath.row]];
    
    mainCell.textLabel.text = msgNames[indexPath.row];
    
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    mainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    mainCell.textLabel.font = XNFont(16.0);
    
    if (_noticNumberDict && indexPath.row == 0) {
        NSString *str = [self.noticNumberDict valueForKey:@"coupon_num"];
        mainCell.imageView.badge.text = str;
        mainCell.imageView.badgeTextColor = [UIColor whiteColor];
        mainCell.imageView.badgeFont = XNFont(10.0);
        mainCell.imageView.badgeBgColor = [UIColor redColor];
        mainCell.imageView.badgeMaximumBadgeNumber = 99;
        mainCell.imageView.badgeFrame = CGRectMake(CGRectGetHeight(mainCell.imageView.frame) -6, -6, 10, 10);
       [mainCell.imageView showBadge];
        
    }
    
    if (_noticNumberDict && indexPath.row == 1) {
        NSString *str = [self.noticNumberDict valueForKey:@"coupon_num"];
        mainCell.imageView.badge.badgeTextColor = [UIColor whiteColor];
        mainCell.imageView.badge.badgeFont = XNFont(11.0);
        mainCell.imageView.badgeBgColor = [UIColor redColor];
        mainCell.imageView.badgeMaximumBadgeNumber = 99;
        mainCell.imageView.badgeCenterOffset = CGPointMake(-10, 10);
        [mainCell showBadgeWithStyle:WBadgeStyleRedDot value:[str integerValue] animationType:WBadgeAnimTypeNone];
        if ([str integerValue] == 0) {
            [mainCell.imageView clearBadge];
        }
        
    }
   
    
    
    return mainCell;
}
//跳转（优惠、通知）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *mainCell = [tableView cellForRowAtIndexPath:indexPath];
    [mainCell.imageView clearBadge];
    
    self.msgDetailVC = [[NPYMsgDetailViewController alloc] init];
    self.msgDetailVC.titleName = msgNames[indexPath.row];
    [self.navigationController pushViewController:self.msgDetailVC animated:YES];
    
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

#pragma mark - 

- (void)requestMessageNumberWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
            
            _noticNumberDict = [NSDictionary dictionaryWithObjectsAndKeys:[dataDict[@"data"] valueForKey:@"coupon_num"],@"coupon_num",[dataDict[@"data"] valueForKey:@"notice_num"],@"notice_num", nil];
            
            [mainTableView reloadData];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - ...

- (NSDictionary *)noticNumberDict {
    if (_noticNumberDict == nil) {
        _noticNumberDict = [NSDictionary new];
    }
    
    return _noticNumberDict;
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
