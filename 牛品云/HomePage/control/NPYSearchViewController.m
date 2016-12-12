//
//  NPYSearchViewController.m
//  牛品云
//
//  Created by Eric on 16/12/8.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYSearchViewController.h"
#import "NPYBaseConstant.h"
#import "NPYGoodsListViewController.h"

@interface NPYSearchViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView   *mainTabelView;
@property (nonatomic, strong) UITextField   *searchTF;
@property (nonatomic, strong) UIButton      *cancelBtn;
@property (nonatomic, strong) UIButton      *emptyBtn;

@property (nonatomic, assign) CGFloat   cell_Height;
@property (nonatomic, strong) NSMutableArray    *tableDatas;

@property (nonatomic, strong) NPYGoodsListViewController    *goodsListVC;

@end

@implementation NPYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = GRAY_BG;
    
    [self navigationViewLoad];
    
    [self mainTableViewLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *item = [UIBarButtonItem new];
    self.navigationItem.leftBarButtonItem = item;
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.searchTF removeFromSuperview];
    self.searchTF = nil;
}

#pragma mark - UITableView

- (void)navigationViewLoad {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *searchBGImg = [UIImage imageNamed:@"kuang_sousuoye"];
    self.searchTF = [[UITextField alloc] init];
    self.searchTF.backgroundColor = [UIColor colorWithPatternImage:searchBGImg];
    self.searchTF.frame = CGRectMake(14, 8, WIDTH_SCREEN - 75, 27);
    self.searchTF.placeholder = @"点击搜索牛品";
    self.searchTF.textColor = XNColor(17, 17, 17, 1);
    self.searchTF.font = XNFont(14);
    self.searchTF.layer.cornerRadius = 13.5;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.delegate = self;
    self.searchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    [self.navigationController.navigationBar addSubview:self.searchTF];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEvent)];
    self.navigationItem.rightBarButtonItem = cancel;
}

- (void)mainTableViewLoad {
    self.mainTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStylePlain];
    self.mainTabelView.showsVerticalScrollIndicator = NO;
    self.mainTabelView.dataSource = self;
    self.mainTabelView.delegate = self;
    self.mainTabelView.tableFooterView = [UIView new];
    
    [self.view addSubview:self.mainTabelView];
    
    self.emptyBtn = [[UIButton alloc] init];
    self.emptyBtn.frame = CGRectMake(0, self.cell_Height * self.tableDatas.count + 30 , 219, 33.5);
    [self.emptyBtn setBackgroundImage:[UIImage imageNamed:@"biankuang_sosuo"] forState:UIControlStateNormal];
    UIImage *emptyImg = [UIImage imageNamed:@"lajitong_sousuo"];
    [self.emptyBtn setImage:emptyImg forState:UIControlStateNormal];
    [self.emptyBtn setTitle:@"清空历史搜索" forState:UIControlStateNormal];
    [self.emptyBtn setTitleColor:XNColor(153, 153, 153, 1) forState:UIControlStateNormal];
    self.emptyBtn.titleLabel.font = XNFont(15);
    self.emptyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.emptyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, emptyImg.size.width, 0.0, 0.0);
    self.emptyBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0, 0, emptyImg.size.width);
    self.emptyBtn.center = CGPointMake(WIDTH_SCREEN / 2, CGRectGetMidY(self.emptyBtn.frame));
    [self.emptyBtn addTarget:self action:@selector(emptyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainTabelView addSubview:self.emptyBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cell_Height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if (indexPath.row == 0) {
            cell.textLabel.textColor = XNColor(17, 17, 17, 1);
            
        } else {
            cell.textLabel.textColor = XNColor(153, 153, 153, 1);
            
        }
        
        cell.textLabel.font = XNFont(14);
    }
    
    cell.textLabel.text = self.tableDatas[indexPath.row];
    
    self.emptyBtn.frame = CGRectMake(0, self.cell_Height * self.tableDatas.count + 30 , 219, 33.5);
    
    self.emptyBtn.center = CGPointMake(WIDTH_SCREEN / 2, CGRectGetMidY(self.emptyBtn.frame));
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.goodsListVC = [[NPYGoodsListViewController alloc] init];
    self.goodsListVC.isMore = NO;
    self.goodsListVC.searchStr = cell.textLabel.text;
    [self.navigationController pushViewController:self.goodsListVC animated:YES];
    
}

#pragma mark - 更改tableView的分割线顶格显示
- (void)viewDidLayoutSubviews
{
    if ([self.mainTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTabelView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.mainTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTabelView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.searchTF.text.length <= 0) {
        return NO;
        
    } else {
        [self.tableDatas addObject:textField.text];
        
        [self.mainTabelView reloadData];
        
        return YES;
    }
    
}

- (CGFloat)cell_Height {
    if (_cell_Height == 0) {
        _cell_Height = 33.0;
    }
    
    return _cell_Height;
}

- (NSMutableArray *)tableDatas {
    if (_tableDatas == nil) {
        _tableDatas = [[NSMutableArray alloc] init];
        [_tableDatas addObject:@"历史搜索"];
    }
    
    return _tableDatas;
}

- (void)cancelEvent {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)emptyButtonPressed:(UIButton *)sender {
    NSLog(@"清空历史搜索");
    
    [self.tableDatas removeAllObjects];
    self.tableDatas = nil;
    
    [self.mainTabelView reloadData];
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
