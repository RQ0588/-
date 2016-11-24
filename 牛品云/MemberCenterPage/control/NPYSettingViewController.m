//
//  NPYDetailCenterViewController.m
//  牛品云
//
//  Created by Eric on 16/11/21.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYSettingViewController.h"
#import "NPYBaseConstant.h"
#import "NPYSettingTVCell.h"
#import "NPYLoginViewController.h"

@interface NPYSettingViewController () <UITableViewDataSource,UITableViewDelegate> {
    UITableView     *mainTableView;
    NSInteger   row;
    CGFloat     hegiht;
    NSArray     *dataArray;
}

@property (nonatomic, strong) NPYLoginViewController    *loginVC;

@end

@implementation NPYSettingViewController

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
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.titleStr;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    if ([self.titleStr isEqualToString:@"设置"]) {
        row = 5;
        hegiht = 60;
        dataArray = @[@"头像",@"用户名",@"修改登录密码",@"地址管理",@"关于"];
    }
    
    [self mainViewLoad];
}

- (void)mainViewLoad {
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStylePlain];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:mainTableView];
    
    UIButton *outBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, HEIGHT_SCREEN / 2, WIDTH_SCREEN - 20, 40)];
    [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [outBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    outBtn.backgroundColor = [UIColor redColor];
    outBtn.layer.cornerRadius = 5;
    outBtn.layer.masksToBounds = YES;
    [outBtn addTarget:self action:@selector(outLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outBtn];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    NPYSettingTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NPYSettingTVCell" owner:nil options:nil] firstObject];
        cell.funName.text = dataArray[indexPath.row];
        
        if (indexPath.row == 0) {
            [cell.headPortrait sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        } else {
            cell.headPortrait.hidden = YES;
        }
    }
    
    return cell;
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

#pragma mark - UIButton

- (void)outLoginButtonPressed:(UIButton *)btn {
    //退出登录
    NSLog(@"退出登录...");
    
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
