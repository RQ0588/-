//
//  NPYMemberCenterPage.m
//  牛品云
//
//  Created by Eric on 16/11/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYMemberCenterPage.h"
#import "NPYLoginViewController.h"
#import "NPYMessageViewController.h"
#import "NPYSettingViewController.h"
#import "NPYMyOrderViewController.h"

@interface NPYMemberCenterPage () <UITableViewDelegate,UITableViewDataSource> {
    UITableView     *mainTableView;
    UIImageView     *headPortrait;
    UILabel         *userName;
    NSArray         *funNames;
}

@property (nonatomic, strong) NPYLoginViewController            *loginVC;
@property (nonatomic, strong) NPYMessageViewController          *msgVC;
@property (nonatomic, strong) NPYSettingViewController          *detailVC;
@property (nonatomic, strong) NPYMyOrderViewController          *myOrderVC;

@end

@implementation NPYMemberCenterPage

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 50)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(loginButtonPressed:) forControlEvents:7];
    
    funNames = @[@"券管理",@"朋友圈",@"商品收藏",@"店铺收藏"];
    
    [self navigationViewLoad];
    
    [self mainViewLoad];
}

- (void)navigationViewLoad {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage =[UIImage new];
    //
    UIButton *setBtn = [[UIButton alloc] init];
    setBtn.frame = CGRectMake(0, 0, 40, 40);
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    setBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [setBtn addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *setBtnItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    self.navigationItem.leftBarButtonItem = setBtnItem;
    
    //右侧消息按钮
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 50, 20)];
    [rightMesg setTitle:@"信息" forState:0];
    [rightMesg setTitleColor:[UIColor whiteColor] forState:0];
    rightMesg.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [rightMesg addTarget:self action:@selector(rightMessageButtonPressed:) forControlEvents:7];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightMesg];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)mainViewLoad {
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:mainTableView];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.tableHeaderView = [self headerView];
    mainTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)headerView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 200)];
    headerView.backgroundColor = [UIColor redColor];
    //头像
    headPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [headPortrait sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    headPortrait.contentMode = UIViewContentModeScaleAspectFill;
    headPortrait.center = CGPointMake(WIDTH_SCREEN / 2, 100);
    headPortrait.layer.cornerRadius = CGRectGetHeight(headPortrait.frame) / 2;
    headPortrait.layer.borderColor = XNColor(252, 216, 216, 1).CGColor;
    headPortrait.layer.borderWidth = 2.0;
    headPortrait.layer.masksToBounds = YES;
    [headerView addSubview:headPortrait];
    //会员名
    userName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headPortrait.frame) + 10, 100, 20)];
    [headerView addSubview:userName];
    userName.text = @"牛品云";
    userName.textColor = [UIColor whiteColor];
    userName.font = [UIFont systemFontOfSize:15.0];
    userName.textAlignment = NSTextAlignmentCenter;
    userName.center = CGPointMake(WIDTH_SCREEN / 2, CGRectGetMidY(userName.frame));
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mainCell";
    UITableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!mainCell) {
        mainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [mainCell.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                mainCell.textLabel.text = @"我的订单";
            } else {
                //
                NSArray *nameBtn = @[@"待付款",@"待收货",@"待评价",@"售后/退款"];
                for (int i = 0; i < 4; i++) {
                    //
                    UIButton *funBtn = [[UIButton alloc] init];
                    funBtn.frame = CGRectMake(i * WIDTH_SCREEN / 4, 0, WIDTH_SCREEN / 4, 60);
                    [funBtn setTag:2000 + i];
                    [funBtn setTitle:nameBtn[i] forState:UIControlStateNormal];
                    [funBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [funBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                    
                    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
                    [funBtn setImage:placeHolder forState:UIControlStateNormal];
                    [funBtn setImage:placeHolder forState:UIControlStateSelected];
                    funBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
                    funBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    funBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -placeHolder.size.width, 0.0, 0.0);
                    funBtn.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 30, -funBtn.titleLabel.frame.size.width + 10);
                    [funBtn addTarget:self action:@selector(functionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [mainCell addSubview:funBtn];
                }
                
            }
            
        } else if (indexPath.section == 2) {
            [mainCell.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            mainCell.textLabel.text = funNames[indexPath.row];
        } else {
            [mainCell.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            mainCell.textLabel.text = @"我的牛豆";
        }
    }
    
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return mainCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //我的订单
        self.myOrderVC = [[NPYMyOrderViewController alloc] init];
        [self.navigationController pushViewController:self.myOrderVC animated:YES];
    }
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
//tag(2000 - 2003)
- (void)functionButtonPressed:(UIButton *)btn {
    NSLog(@"%li",(long)btn.tag);
}

- (void)settingButtonPressed:(UIButton *)btn {
    //
    NSLog(@"设置按钮...");
    self.detailVC = [[NPYSettingViewController alloc] init];
    self.detailVC.titleStr = @"设置";
    [self.navigationController pushViewController:self.detailVC animated:YES];
    
}

- (void)rightMessageButtonPressed:(UIButton *)btn {
    //    NSLog(@"消息按钮点击了...");
    self.msgVC = [[NPYMessageViewController alloc] init];
    [self.navigationController pushViewController:self.msgVC animated:YES];
    
}

- (void)loginButtonPressed:(UIButton *)btn {
    self.loginVC = [[NPYLoginViewController alloc] init];
    [self.navigationController pushViewController:self.loginVC animated:YES];
    
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
