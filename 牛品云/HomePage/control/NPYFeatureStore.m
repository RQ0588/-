//
//  NPYFeatureStore.m
//  牛品云
//
//  Created by Eric on 16/10/25.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYFeatureStore.h"
#import "NPYBaseConstant.h"
#import "NPYFeatureStoreTVCell.h"

@interface NPYFeatureStore () <UITableViewDelegate,UITableViewDataSource,PassMainTableViewValueDelegate> {
    double height_HeaderView;   //tableview的头高度
    int number_Function;        //头部按钮的个数
    NSInteger number_Tag;       //记录选中按钮的tag值
    
    UIButton *topLeftBtn,*topRightBtn;
    
    NSMutableArray *menuTitles;
}

@property (nonatomic, strong) UITableView *mainTView;

@property (nonatomic, strong) NPYMessageViewController *msgVC;

@end

@implementation NPYFeatureStore

#pragma mark - System Function
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    height_HeaderView = 34;
//    number_Function = 6;
    
    self.view.backgroundColor = GRAY_BG;
    
    menuTitles = [[NSMutableArray alloc] initWithObjects:@"鲜蔬水果",@"水产品",@"粮油调味",@"禽类蛋品",@"功能保健", nil];
    number_Function = (int)menuTitles.count;
    
    //导航栏设置
    [self navigationLoad];
    //加载主页面
    [self mainViewLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Custom Function
//导航栏的设置
- (void)navigationLoad {
//    NSLog(@"进入导航栏的设置...");
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"牛人馆";
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    //右侧消息按钮
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 50, 30)];
    [rightMesg setTitle:@"信息" forState:0];
    [rightMesg setTitleColor:XNColor(51, 51, 51, 1) forState:0];
    rightMesg.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightMesg addTarget:self action:@selector(rightMessageButtonPressed:) forControlEvents:7];
    topRightBtn = rightMesg;
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightMesg];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

//主页面的布局
- (void)mainViewLoad {
//    NSLog(@"进入主页面的布局设置...");
    CGRect frame = CGRectMake(0, 1, WIDTH_SCREEN, HEIGHT_SCREEN);
    
    self.mainTView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.mainTView.dataSource = self;
    self.mainTView.delegate = self;
    self.mainTView.showsVerticalScrollIndicator = NO;
    self.mainTView.backgroundColor = GRAY_BG; //灰色背景
    self.mainTView.tableFooterView = [UIView new];
    self.mainTView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTView];
}

#pragma mark - MainTableView Function

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return height_HeaderView;
}

//主页面头部布局设置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSLog(@"进入主页面头部位置...");
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    //检索按钮
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn setFrame:CGRectMake(0, 0, height_HeaderView, height_HeaderView)];
//    [searchBtn setTitle:@"🔍" forState:0];
//    [searchBtn setTitleColor:[UIColor blackColor] forState:0];
//    searchBtn.backgroundColor = [UIColor blackColor];
    [searchBtn setImage:[UIImage imageNamed:@"sousuo_icon"] forState:UIControlStateNormal];
    [headerView addSubview:searchBtn];
    //底部横线
    UIImageView *hLineImgView = [[UIImageView alloc] init];
    [hLineImgView setFrame:CGRectMake(0, height_HeaderView - 1, WIDTH_SCREEN, 1)];
//    hLineImgView.backgroundColor = [UIColor grayColor];
    hLineImgView.image = [UIImage imageNamed:@"88hui_cx"];
    [headerView addSubview:hLineImgView];
    //检索后的竖线
    UIImageView *vLineImgView = [[UIImageView alloc] init];
    vLineImgView.image = [UIImage imageNamed:@"hx_xiao"];
    [vLineImgView setFrame:CGRectMake(CGRectGetMaxX(searchBtn.frame), 5, 1, height_HeaderView - 10)];
//    vLineImgView.backgroundColor = [UIColor grayColor];
    [headerView addSubview:vLineImgView];
    
    double width_btn = 80;
    double width_scrollView = (number_Function * width_btn) >= (WIDTH_SCREEN - CGRectGetMaxX(vLineImgView.frame)) ? (WIDTH_SCREEN - CGRectGetMaxX(vLineImgView.frame)) : (number_Function * width_btn);
    UIScrollView *fScrollView = [[UIScrollView alloc] init];
    [fScrollView setFrame:CGRectMake(CGRectGetMaxX(vLineImgView.frame), 0, width_scrollView, height_HeaderView)];
    [fScrollView setContentSize:CGSizeMake(width_btn * number_Function, 0)];
    fScrollView.scrollEnabled = YES;
    fScrollView.alwaysBounceHorizontal = YES;
    fScrollView.directionalLockEnabled = YES;
    fScrollView.showsHorizontalScrollIndicator = NO;
    [headerView addSubview:fScrollView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width_btn * number_Function, 60)];
    
    for (int i = 0; i < number_Function; i++) {
        UIButton *funcBtn = [[UIButton alloc] init];
        [funcBtn setFrame: CGRectMake(i * width_btn, 0, width_btn, height_HeaderView)];
        [funcBtn setTitle:menuTitles[i] forState:0];
        funcBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        funcBtn.titleLabel.font = XNFont(12.0);
        [funcBtn setTag:110 + i];
        [funcBtn setTitleColor:XNColor(102, 102, 102, 1) forState:UIControlStateNormal];
        [funcBtn setTitleColor:XNColor(241, 8, 8, 1) forState:UIControlStateSelected];
        
        UIImageView *selectedImgView = [[UIImageView alloc] init];
        selectedImgView.image = [UIImage imageNamed:@"hx_zhuangtai"];
        selectedImgView.tag = funcBtn.tag + 100;
        selectedImgView.frame = CGRectMake(0, CGRectGetHeight(funcBtn.frame) - 2, CGRectGetWidth(funcBtn.frame), 2);
        [funcBtn addSubview:selectedImgView];
        if (i == 0) {
            funcBtn.selected = YES;
            selectedImgView.hidden = NO;
            number_Tag = 110;
        } else {
            funcBtn.selected = NO;
            selectedImgView.hidden = YES;
        }
        
        [funcBtn addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:funcBtn];
    }
    
    [fScrollView addSubview:contentView];
    
    return headerView;
}

//主页面的布局设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"进入tableviewcell...%li",indexPath.row);
    static NSString *identifier = @"mainCell";
    NPYFeatureStoreTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NPYFeatureStoreTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    
    return cell;
}

#pragma mark - Button Pressed Event 
//导航栏右侧的消息按钮事件
- (void)rightMessageButtonPressed:(UIButton *)btn {
//    NSLog(@"消息按钮点击了...");
    self.msgVC = [[NPYMessageViewController alloc] init];
    [self.navigationController pushViewController:self.msgVC animated:YES];
    
}
//菜单按钮的点击事件
- (void)menuButtonPressed:(UIButton *)btn {
//    NSLog(@"菜单按钮点击了...%li",btn.tag);
    if (number_Tag == btn.tag) {
        return;
    }
    
    btn.selected = YES;
    UIImageView *tmpImgView = [self.view viewWithTag:btn.tag + 100];
    tmpImgView.hidden = NO;
    
    UIButton *tmpBtn = [self.view viewWithTag:number_Tag];
    tmpBtn.selected = NO;
    UIImageView *tmpImgView2 = [self.view viewWithTag:number_Tag + 100];
    tmpImgView2.hidden = YES;
    
    number_Tag = btn.tag;
}

#pragma mark - 自定义cell点击回传值
//300-店铺名称点击,301-进入店铺点击
//302-左侧商品图片点击,303-右上商品图片点击,304-右下商品图片点击
- (void)passButtonTag:(NSInteger)tag withButtonTitle:(NSString *)title {
    NSLog(@"点击了...%li,name = %@",tag,title);
    
}

- (void)backItem {
    [self.navigationController popViewControllerAnimated:YES];
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
