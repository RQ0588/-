//
//  BGGoodsDetailController.m
//  BGTaobao
//
//  Created by huangzhibiao on 16/2/22.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import "BGGoodsDetailController.h"
#import "MyOrderTopTabBar.h"
#import "MJRefresh.h"
#import "global.h"
#import "NPYGoodsDetailTableViewCell.h"

@interface BGGoodsDetailController ()<UITableViewDataSource,UITableViewDelegate,MyOrderTopTabBarDelegate>

@property (weak, nonatomic) UITableView* detailTableview;
@property (nonatomic, strong) NPYGoodsDetailTableViewCell   *threeCell;

@end

@implementation BGGoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, screenW, 64.0);
    view.backgroundColor = color(0.0,162.0,154.0,1.0);
    [self.view addSubview:view];
    //初始化顶部导航标题
    NSArray* array  = @[@"图文详情",@"商品参数",@"用户评价",@"牛品推荐"];
    MyOrderTopTabBar* tabBar = [[MyOrderTopTabBar alloc] initWithArray:array] ;
    tabBar.frame = CGRectMake(0,64.0, screenW,50.0);
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.delegate = self;
    
    //初始化一个UITableView
    UITableView* tableview = [[UITableView alloc] init];
    self.detailTableview = tableview;
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.tag = 1;
    tableview.frame = CGRectMake(0,114.0, screenW,screenH-114.0);
    [self.view addSubview:tabBar];
    [self.view addSubview:tableview];
}

#pragma -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.threeCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYGoodsDetailTableViewCell" owner:nil options:nil] firstObject];
    
    return self.threeCell;
}

#pragma -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

#pragma -- MyOrderTopTabBarDelegate(顶部标题栏delegate)
-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index{
    NSLog(@"点击了 －－－ %ld",index);
    self.detailTableview.backgroundColor = color(random()%255, random()%255, random()%255, 1.0);
    
}

@end
