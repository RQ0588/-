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
#import "NPYDicHomeModel.h"

#define ManyData_Url @"/index.php/app/Many/home"

@interface NPYDicoveryPage () <UITableViewDelegate,UITableViewDataSource> {
    NSArray *ADImages;
    NSMutableArray *tabelViewDatas;
}

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ADImages = @[@"",@"",@""];
    
    tabelViewDatas = [NSMutableArray new];
    
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    [self navigationViewLoad];
    
    [self mainViewLoad];
    
    NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:@"npy_we874646sf",@"key",@"0",@"num", nil];
    
    [self requestManyDataWithUrlstring:ManyData_Url withParame:requestDict];
}

- (void)navigationViewLoad {
    //右侧消息按钮
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 50, 20)];
    [rightMesg setTitle:@"消息" forState:0];
    [rightMesg setTitleColor:XNColor(51, 51, 51, 1) forState:0];
    rightMesg.titleLabel.font = [UIFont systemFontOfSize:15.0];
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
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:@"npy_we874646sf",@"key",@"0",@"num", nil];
        
        [self requestManyDataWithUrlstring:ManyData_Url withParame:requestDict];
    }];
    
    [self.mainTableView.mj_header beginRefreshing];
    
    [self topADImageViewLoad];
}

- (void)topADImageViewLoad {
//    self.topImgView = [[SZCirculationImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 180) andImageNamesArray:ADImages];
    self.topImgView = [[SZCirculationImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 180) andImageURLsArray:ADImages];
    self.topImgView.pauseTime = 1.0;
    self.topImgView.defaultPageColor = [UIColor grayColor];
    self.topImgView.currentPageColor = [UIColor whiteColor];
    self.mainTableView.tableHeaderView = self.topImgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tabelViewDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.mainCell == nil) {
        self.mainCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYDicoveryTableViewCell" owner:nil options:nil] firstObject];
        self.mainCell.homeModel = tabelViewDatas[indexPath.row];
        self.mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self.mainCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.detailVC = [[NPYDicDetailViewController alloc] initWithNibName:@"NPYDicDetailViewController" bundle:nil];
    self.detailVC.homeModel = tabelViewDatas[indexPath.row];
    [self.navigationController pushViewController:self.detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

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

#pragma mark - 网络请求

- (void)requestManyDataWithUrlstring:(NSString *)urlStr withParame:(NSDictionary *)parame {
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            [tabelViewDatas removeAllObjects];
//            [ZHProgressHUD showMessage:@"网络请求成功" inView:self.view];
            NSDictionary *tpDict = [NSDictionary dictionaryWithDictionary:dataDict[@"data"]];
            
            ADImages = @[[[tpDict valueForKey:@"ad1"] valueForKey:@"img"], [[tpDict valueForKey:@"ad2"] valueForKey:@"img"], [[tpDict valueForKey:@"ad3"] valueForKey:@"img"], [[tpDict valueForKey:@"ad4"] valueForKey:@"img"]];
            
            [self.topImgView removeFromSuperview];
            self.topImgView = nil;
            [self topADImageViewLoad];
            
            NSArray *tpArr = tpDict[@"list"];
            
            for (int i = 0; i < tpArr.count; i++) {
                NPYDicHomeModel *model = [NPYDicHomeModel mj_objectWithKeyValues:tpArr[i]];
                [tabelViewDatas addObject:model];
            }
            
            [self.mainTableView.mj_header endRefreshing];
            
            [self.mainTableView reloadData];
            
        } else {
            //请求失败
//            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
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
