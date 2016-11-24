//
//  NPYAddressViewController.m
//  牛品云
//
//  Created by Eric on 16/11/10.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYAddressViewController.h"
#import "NPYBaseConstant.h"
#import "NPYAddressTableViewCell.h"
#import "NPYAddressDetailViewController.h"

@interface NPYAddressViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *mainTV;
    NSArray *addressArray;
}

@property (nonatomic, strong) NPYAddressDetailViewController    *addressInfoVC;

@end

@implementation NPYAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *tmp = [NSDictionary dictionaryWithObjectsAndKeys:@"牛品云",@"name",@"13962111234",@"phone",@"苏州高新区科技城致远国际大厦1010室",@"address", nil];
    addressArray = @[tmp,tmp,tmp];
    
    [self navigationLoad];
    
    [self mainViewLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)navigationLoad {
    self.navigationItem.title = @"选择地址";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0]};
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    //右侧消息按钮
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 20, 20)];
    [rightMesg setTitle:@"+" forState:0];
    [rightMesg setTitleColor:[UIColor grayColor] forState:0];
    rightMesg.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [rightMesg addTarget:self action:@selector(rightMessageButtonPressed:) forControlEvents:7];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightMesg];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)mainViewLoad {
    mainTV = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:mainTV];
    
    mainTV.backgroundColor = GRAY_BG;
    mainTV.delegate = self;
    mainTV.dataSource = self;
    mainTV.showsVerticalScrollIndicator = NO;
    mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"mainCell";
    NPYAddressTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!mainCell) {
        mainCell = [[NPYAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        mainCell.dataDic = addressArray[indexPath.row];
        
    }
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    mainCell.backgroundColor = [UIColor clearColor];
    
    return mainCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"点击了cell...%li",(long)indexPath.row);
    self.addressInfoVC = [[NPYAddressDetailViewController alloc] init];
    self.addressInfoVC.isEdit = YES;
    [self.navigationController pushViewController:self.addressInfoVC animated:YES];
}

#pragma mark - -

- (void)rightMessageButtonPressed:(UIButton *)btn {
//    NSLog(@"添加地址按钮点击了...");
    self.addressInfoVC = [[NPYAddressDetailViewController alloc] init];
    self.addressInfoVC.isEdit = NO;
    [self.navigationController pushViewController:self.addressInfoVC animated:YES];
}

#pragma mark - -

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
