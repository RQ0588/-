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
}

@property (nonatomic, strong) UITableView *mainTView;

@property (nonatomic, strong) NPYMessageViewController *msgVC;

@end

@implementation NPYFeatureStore

#pragma mark - System Function
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    height_HeaderView = 40.0;
    number_Function = 6;
    
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
    
    self.navigationItem.title = @"全国特色馆";
//    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 100, 30)];
    [rightMesg setTitle:@"信息" forState:0];
    [rightMesg setTitleColor:[UIColor grayColor] forState:0];
    [rightMesg addTarget:self action:@selector(rightMessageButtonPressed:) forControlEvents:7];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightMesg];
    
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

//主页面的布局
- (void)mainViewLoad {
//    NSLog(@"进入主页面的布局设置...");
    
    CGRect frame = CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN);
    
    self.mainTView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.mainTView.dataSource = self;
    self.mainTView.delegate = self;
    self.mainTView.showsVerticalScrollIndicator = NO;
    self.mainTView.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:245/255.0 alpha:1.0]; //灰色背景
    [self.view addSubview:self.mainTView];
}

#pragma mark - MainTableView Function

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
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
    [searchBtn setTitle:@"🔍" forState:0];
    [searchBtn setTitleColor:[UIColor blackColor] forState:0];
//    searchBtn.backgroundColor = [UIColor blackColor];
    [headerView addSubview:searchBtn];
    //底部横线
    UIImageView *hLineImgView = [[UIImageView alloc] init];
    [hLineImgView setFrame:CGRectMake(0, height_HeaderView - 1, WIDTH_SCREEN, 1)];
    hLineImgView.backgroundColor = [UIColor grayColor];
    [headerView addSubview:hLineImgView];
    //检索后的竖线
    UIImageView *vLineImgView = [[UIImageView alloc] init];
    [vLineImgView setFrame:CGRectMake(CGRectGetMaxX(searchBtn.frame), 5, 1, height_HeaderView - 10)];
    vLineImgView.backgroundColor = [UIColor grayColor];
    [headerView addSubview:vLineImgView];
    
    double width_btn = 100;
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
        [funcBtn setTitle:@"ABC" forState:0];
        funcBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [funcBtn setTag:110 + i];
        [funcBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [funcBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        UIImageView *selectedImgView = [[UIImageView alloc] init];
        selectedImgView.image = [UIImage imageNamed:@"testLine"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
