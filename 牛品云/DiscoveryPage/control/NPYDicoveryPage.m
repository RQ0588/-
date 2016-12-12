//
//  NPYDicoveryPage.m
//  牛品云
//
//  Created by Eric on 16/11/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYDicoveryPage.h"
#import "NPYBaseConstant.h"
#import "NPYMessageViewController.h"
#import "SZCirculationImageView.h"
#import "NPYDicoveryTableViewCell.h"
#import "NPYDicDetailViewController.h"

@interface NPYDicoveryPage () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NPYMessageViewController *msgVC;

@property (nonatomic, strong) UITableView                   *mainTableView;
@property (nonatomic, strong) SZCirculationImageView        *topImgView;
@property (nonatomic, strong) NPYDicoveryTableViewCell      *mainCell;
@property (nonatomic, strong) NPYDicDetailViewController    *detailVC;

@end

@implementation NPYDicoveryPage

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    [self navigationViewLoad];
    
    [self mainViewLoad];
}

- (void)navigationViewLoad {
    //右侧消息按钮
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 50, 20)];
    [rightMesg setTitle:@"信息" forState:0];
    [rightMesg setTitleColor:[UIColor grayColor] forState:0];
    rightMesg.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [rightMesg addTarget:self
                  action:@selector(rightMessageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightMesg];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
}

- (void)mainViewLoad {
    //
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStylePlain];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.estimatedRowHeight = 100;
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainTableView];
    
    self.topImgView = [[SZCirculationImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 200) andImageNamesArray:@[@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg"]];
    self.topImgView.pauseTime = 1.0;
    self.topImgView.defaultPageColor = [UIColor grayColor];
    self.topImgView.currentPageColor = [UIColor whiteColor];
    self.mainTableView.tableHeaderView = self.topImgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.mainCell == nil) {
        self.mainCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYDicoveryTableViewCell" owner:nil options:nil] firstObject];
        self.mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self.mainCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.detailVC = [[NPYDicDetailViewController alloc] initWithNibName:@"NPYDicDetailViewController" bundle:nil];
    [self.navigationController pushViewController:self.detailVC animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 130;
//    
//}

#pragma mark - 更改tableView的分割线顶格显示
- (void)viewDidLayoutSubviews
{
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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


#pragma mark - UIButton Event

- (void)rightMessageButtonPressed:(UIButton *)btn {
    self.msgVC = [[NPYMessageViewController alloc] init];
    [self.navigationController pushViewController:self.msgVC animated:YES];
    
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
