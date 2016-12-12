//
//  NPYMemberCenterPage.m
//  牛品云
//
//  Created by Eric on 16/11/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYMemberCenterPage.h"
#import "NPYBaseConstant.h"
#import "NPYLoginViewController.h"
#import "NPYMessageViewController.h"
#import "NPYSettingViewController.h"
#import "NPYMyOrderViewController.h"
#import "SDTimeLineTableViewController.h"
#import "AppDelegate.h"

@interface NPYMemberCenterPage () <UITableViewDelegate,UITableViewDataSource> {
    UITableView     *mainTableView;
    UIImageView     *headPortrait;
    UILabel         *userName;
    NSArray         *funNames;
    
    NSDictionary    *loginData;
}

@property (nonatomic, strong) NPYLoginViewController            *loginVC;//登录界面
@property (nonatomic, strong) NPYMessageViewController          *msgVC;//右侧信息
@property (nonatomic, strong) NPYSettingViewController          *detailVC;//设置
@property (nonatomic, strong) NPYMyOrderViewController          *myOrderVC;//我的订单
@property (nonatomic, strong) SDTimeLineTableViewController     *ttVC;//朋友圈

@end

@implementation NPYMemberCenterPage

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage =[UIImage new];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    funNames = @[@"券管理",@"朋友圈",@"商品收藏",@"店铺收藏"];
    
    [self navigationViewLoad];
    
    [self mainViewLoad];
    
    NSString *isLogin = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginState];
    if ([isLogin intValue] == 1) {
        loginData = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
        
    }
    
}

- (void)navigationViewLoad {
    //
    UIButton *setBtn = [[UIButton alloc] init];
    setBtn.frame = CGRectMake(0, 0, 40, 40);
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [setBtn setTitleColor:XNColor(255, 255, 255, 1) forState:UIControlStateNormal];
    setBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [setBtn addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *setBtnItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    self.navigationItem.leftBarButtonItem = setBtnItem;
    
    //右侧消息按钮
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 50, 20)];
    [rightMesg setTitle:@"信息" forState:0];
    [rightMesg setTitleColor:[UIColor whiteColor] forState:0];
    rightMesg.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightMesg addTarget:self action:@selector(rightMessageButtonPressed:) forControlEvents:7];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightMesg];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)mainViewLoad {
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, WIDTH_SCREEN, HEIGHT_SCREEN - 49 + 64) style:UITableViewStyleGrouped];
    [self.view addSubview:mainTableView];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.tableHeaderView = [self headerView];
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.separatorColor = XNColor(242, 242, 242, 1);
    mainTableView.backgroundColor = GRAY_BG;
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
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 70;
    }
    
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)headerView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 180)];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:headerView.frame];
    bgImgView.image = [UIImage imageNamed:@"huiyuan_beijing"];
    bgImgView.contentMode = UIViewContentModeScaleToFill;
    [headerView addSubview:bgImgView];
    //头像
    headPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(0, -10, 70, 70)];
    [headPortrait sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"0.jpg"]];
    headPortrait.contentMode = UIViewContentModeScaleAspectFill;
    headPortrait.center = CGPointMake(WIDTH_SCREEN / 2, 100);
    headPortrait.layer.cornerRadius = CGRectGetHeight(headPortrait.frame) / 2;
    headPortrait.layer.borderColor = XNColor(253, 220, 220, 1).CGColor;
    headPortrait.layer.borderWidth = 2.0;
    headPortrait.layer.masksToBounds = YES;
    [headerView addSubview:headPortrait];
    
    headPortrait.badgeBgColor = [UIColor blueColor];
    headPortrait.badgeTextColor = [UIColor whiteColor];
    headPortrait.badgeFont = [UIFont boldSystemFontOfSize:11];
    headPortrait.badgeMaximumBadgeNumber = 99;
    headPortrait.badgeCenterOffset = CGPointMake(5, 0);
    [headPortrait showBadgeWithStyle:WBadgeStyleNumber value:100 animationType:WBadgeAnimTypeScale];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:headPortrait.frame];
    [headerView addSubview:btn];
    [btn addTarget:self action:@selector(loginButtonPressed2:) forControlEvents:7];
    
    //会员名
    userName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headPortrait.frame) + 15, 100, 20)];
    [headerView addSubview:userName];
    userName.text = @"牛品云";
    userName.textColor = [UIColor whiteColor];
    userName.font = [UIFont systemFontOfSize:17.0];
    userName.textAlignment = NSTextAlignmentCenter;
    userName.center = CGPointMake(WIDTH_SCREEN / 2, CGRectGetMidY(userName.frame));
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mainCell";
    UITableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!mainCell) {
        mainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
//                [mainCell.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"dingdan_icon"]];
                mainCell.imageView.image = [UIImage imageNamed:@"dingdan_icon"];
                mainCell.textLabel.text = @"我的订单";
                mainCell.detailTextLabel.text = @"查看全部订单";
                
            } else {
                //
                NSArray *nameBtn = @[@"待付款",@"待收货",@"待评价",@"售后/退款"];
                NSArray *imges = @[@"daifukuan_hy",@"daishouhuo_hy",@"daipingjia_hy",@"shouhou_hy"];
                for (int i = 0; i < 4; i++) {
                    //
                    UIButton *funBtn = [[UIButton alloc] init];
                    funBtn.frame = CGRectMake(i * WIDTH_SCREEN / 4, 0, WIDTH_SCREEN / 4, 60);
                    [funBtn setTag:2000 + i];
                    [funBtn setTitle:nameBtn[i] forState:UIControlStateNormal];
                    [funBtn setTitleColor:XNColor(102, 102, 102, 1) forState:UIControlStateNormal];
                    
                    UIImage *placeHolder = [UIImage imageNamed:imges[i]];
                    [funBtn setImage:placeHolder forState:UIControlStateNormal];
                    funBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
                    funBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    funBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -placeHolder.size.width, 0.0, 0.0);
                    if (i == 3) {
                        funBtn.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 30, -placeHolder.size.width - 30);
                    } else {
                        funBtn.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 30, -placeHolder.size.width - 15);
                    }
                    
                    [funBtn addTarget:self action:@selector(functionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [mainCell addSubview:funBtn];
                }
                
            }
            
        } else if (indexPath.section == 2) {
            NSArray *imges = @[@"quanguanli_icon",@"pengyouqun_icon",@"shangpin_icon",@"dianpu_icon"];
//            [mainCell.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:imges[indexPath.row]]];
            mainCell.imageView.image = [UIImage imageNamed:imges[indexPath.row]];
            mainCell.textLabel.text = funNames[indexPath.row];
            
        } else {
//            [mainCell.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"niudou_icon"]];
            mainCell.imageView.image = [UIImage imageNamed:@"niudou_icon"];
            mainCell.textLabel.text = @"我的牛豆";
            mainCell.detailTextLabel.text = [NSString stringWithFormat:@"%i牛豆",20];
        }
    }
    
    mainCell.textLabel.textColor = XNColor(51, 51, 51, 1);
    mainCell.textLabel.font = XNFont(15.0);
    
    mainCell.detailTextLabel.textColor = XNColor(170, 170, 170, 1);
    mainCell.detailTextLabel.font = XNFont(14.0);
    
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 1 ) {
        mainCell.accessoryType = UITableViewCellAccessoryNone;
        
    } else {
        mainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        NSLog(@"%li,%li",indexPath.section,indexPath.row);
        
    }
    
    return mainCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //我的订单
        self.myOrderVC = [[NPYMyOrderViewController alloc] init];
        [self.navigationController pushViewController:self.myOrderVC animated:YES];
    }
    
    if (indexPath.section == 1) {
        self.detailVC = [[NPYSettingViewController alloc] init];
        self.detailVC.titleStr = @"我的牛豆";
        [self.navigationController pushViewController:self.detailVC animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        //朋友圈
//        self.ttVC = [[SDTimeLineTableViewController alloc] init];
//        self.ttVC = [[SDTimeLineTableViewController alloc] initWithNibName:@"SDTimeLineTableViewController" bundle:nil];
//        [self.navigationController pushViewController:self.ttVC animated:YES];
        [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootViewControllerWithIdentifier:@"NPYFriend"];
        
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

- (void)loginButtonPressed2:(UIButton *)btn {
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
