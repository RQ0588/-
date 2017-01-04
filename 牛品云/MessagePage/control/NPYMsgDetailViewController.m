//
//  NPYMsgDetailViewController.m
//  牛品云
//
//  Created by Eric on 16/11/14.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYMsgDetailViewController.h"
#import "NPYBaseConstant.h"
#import "NPYMessageTableViewCell.h"

@interface NPYMsgDetailViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *dataMArr;
    
}

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation NPYMsgDetailViewController

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
    
    self.navigationItem.title = self.titleName;
    
    self.view.backgroundColor = GRAY_BG;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
     [self.view addSubview:self.mainTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.titleName isEqualToString:@"通知消息"]) {
        NPYMessageTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"NPYMessageTableViewCell" owner:self options:nil] objectAtIndex:indexPath.row%2];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self configCell:cell indexPath:indexPath];
        
        return cell;
        
    }
    
    if ([self.titleName isEqualToString:@"优惠消息"]) {
        NPYMessageTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"NPYMessageTableViewCell" owner:self options:nil] objectAtIndex:2];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self configCell:cell indexPath:indexPath];
        
        return cell;
        
    }
    
    return nil;
}

- (void)configCell:(NPYMessageTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.timeLabel.text = @"2016-12-12";
    
}

- (UITableView *)mainTableView {
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = GRAY_BG;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 100;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _mainTableView;
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
