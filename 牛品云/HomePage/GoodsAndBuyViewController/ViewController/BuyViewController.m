//
//  BuyViewController.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/21.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BuyViewController.h"
#import "global.h"
#import "BuyTopView.h"
#import "BuyMiddleView.h"
#import "BuyBottomView.h"
#import "MyOrderTopTabBar.h"
#import "MJRefresh.h"
#import "NaviBase.h"
#import "BGGoodsDetailController.h"

#import "NPYGoodsDetailTableViewCell.h"
#import "NPYParameterTableViewCell.h"
#import "NPYImageTextTableViewCell.h"
#import "NPYRecommendTableViewCell.h"

#import "NPYBaseConstant.h"
#import "NPYOrderViewController.h"

#define TopViewH 380
#define MiddleViewH 195
#define BottomH 52
#define TopTabBarH [global pxTopt:100]
#define NaviBarH 64.0

@interface BuyViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MyOrderTopTabBarDelegate> {
    
    NSInteger selectedTag;
}

@property(nonatomic,weak)MyOrderTopTabBar* TopTabBar;
@property(nonatomic,weak)UIView* NavBarView;

@property (weak, nonatomic) UIScrollView *MyScrollView;
@property (weak, nonatomic) BuyTopView* topView;
@property (weak, nonatomic) BuyMiddleView* middleView;
@property (weak, nonatomic) BuyBottomView* bottomView;
@property (weak, nonatomic) UITableView* detailTableview;
@property (weak, nonatomic) MJRefreshHeaderView* header;
//@property (assign, nonatomic)float TopViewScale;

@property (nonatomic, strong) NPYImageTextTableViewCell     *oneCell;
@property (nonatomic, strong) NPYParameterTableViewCell     *twoCell;
@property (nonatomic, strong) NPYGoodsDetailTableViewCell   *threeCell;
@property (nonatomic, strong) NPYRecommendTableViewCell     *fourCell;

@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) NPYOrderViewController    *orderVC;

@end

@implementation BuyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage =[UIImage new];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.TopViewScale = 1.0;
    [self initView];
    [self addNavBarView];//提示,要在最后添加
}

/**
 添加导航栏背后的View
 */
-(void)addNavBarView{
    UIView* view = [[UIView alloc] init];
    self.NavBarView = view;
    view.frame = CGRectMake(0, 0, screenW, 64.0);
    [self.view addSubview:view];
}

-(void)dealloc{
    //释放下拉刷新内存
    [self.header free];
    [self.MyScrollView removeFromSuperview];
}

-(UIScrollView *)MyScrollView{
    if (_MyScrollView == nil) {
        UIScrollView* scroll = [[UIScrollView alloc] init];
        _MyScrollView = scroll;
        scroll.delegate = self;
        scroll.frame = CGRectMake(0.0, 0.0, screenW, screenH-BottomH);
        scroll.pagingEnabled = YES;//进行分页
        scroll.showsVerticalScrollIndicator = NO;
        scroll.tag = 0;
        [self.view addSubview:scroll];
    }
    return _MyScrollView;
}
/**
 添加底部购买按钮和加入购物车按钮的view
 */
-(void)initBottomView{
    self.bottom = [[UIView alloc] init];
    self.bottom.frame = CGRectMake(0, HEIGHT_SCREEN - 39, WIDTH_SCREEN, 40);
    self.bottom.backgroundColor = [UIColor whiteColor];
    self.bottom.layer.borderWidth = 1.0;
    self.bottom.layer.borderColor = GRAY_BG.CGColor;
    
    [self.view addSubview:self.bottom];
    //
    NSArray *btnNames = @[@"店铺",@"收藏",@"加入购物车"];
    NSArray *btnImges = @[@"CreditCard_ShoppingBag",@"commidity_collection",@"shoppingCart"];
    for (int i = 0; i < 3; i++) {
        //
        UIButton *btn = [[UIButton alloc] init];
        //        btn.backgroundColor = [UIColor orangeColor];
        btn.frame = CGRectMake(i * 80, 0, 80, CGRectGetHeight(self.bottom.frame));
        btn.tag = 3010 + i;
        UIImage *imgA = [UIImage imageNamed:btnImges[i]];
        [btn setImage:imgA forState:UIControlStateNormal];
        [btn setImage:imgA forState:UIControlStateSelected];
        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:8.0];
        
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(25, -imgA.size.width, 0.0, 0.0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 15, -btn.titleLabel.bounds.size.width)];
        
        [btn addTarget:self action:@selector(bottomViewEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottom addSubview:btn];
    }
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 0, WIDTH_SCREEN - 240, CGRectGetHeight(self.bottomView.frame))];
    [buyBtn setTag:3013];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setBackgroundColor:[UIColor redColor]];
    [buyBtn addTarget:self action:@selector(bottomViewEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom addSubview:buyBtn];
    
}

//底部按钮点击
//tag (3010 - 3013)
- (void)bottomViewEvent:(UIButton *)btn {
    NSLog(@"底部按钮点击%li",(long)btn.tag);
    switch (btn.tag) {
        case 3010:
            //跳转到店铺
            break;
            
        case 3011:
            //收藏
            break;
            
        case 3012:
            //加入购物车
            break;
            
        case 3013:
            //立即购买
            self.orderVC = [[NPYOrderViewController alloc] init];
            [self.navigationController pushViewController:self.orderVC animated:YES];
            break;
            
        default:
            //baoc
            [ZHProgressHUD showMessage:@"程序哥走神了..." inView:self.view];
            break;
    }
}


/**
 加入购物车按钮点击动作
 */
-(void)addShoppingCar:(id)sender{
    NSLog(@"加入购物车");
}
/**
 立即购买按钮动作
 */
-(void)nowBuy:(id)sender{
     NSLog(@"购买");
}
/**
 初始化相关的view
 */
-(void)initView{
    //初始化第一个页面
    //初始化第一个页面的父亲view
    UIView* firstPageView = [[UIView alloc] init];
    firstPageView.frame = CGRectMake(0, 0, screenW, screenH - BottomH);
    BuyTopView* topView = [BuyTopView view];
    self.topView = topView;
    topView.images = @[@"commidity_upimage",@"one.jpg",@"two.jpg",@"three.jpg",@"four.jpg",@"five.jpg"];//设置顶部Collectionview的图片数据
    __weak UINavigationController* NaviController = self.navigationController;
    self.topView.rightRefresh.block = ^{
        BGGoodsDetailController* bggc = [[BGGoodsDetailController alloc] init];
        [NaviController pushViewController:bggc animated:YES];
    };
    topView.frame = CGRectMake(0,0, screenW, TopViewH);
    [firstPageView addSubview:topView];
    BuyMiddleView* middleView = [BuyMiddleView view];
    self.middleView = middleView;
    middleView.frame = CGRectMake(0,CGRectGetMaxY(topView.frame) + 6, screenW, MiddleViewH);
    [firstPageView addSubview:middleView];
    BuyBottomView* bottomView = [BuyBottomView view];
    self.bottomView = bottomView;
    CGFloat bottomViewY = 0.0;
    if (iphone6plus) {
        bottomViewY = self.MyScrollView.frame.size.height - BottomH;
    }else{
        bottomViewY = CGRectGetMaxY(middleView.frame);
    }
    bottomView.frame = CGRectMake(0,bottomViewY, screenW, BottomH);
    [firstPageView addSubview:bottomView];
    [self.MyScrollView addSubview:firstPageView];
    [self initBottomView];
    //初始化第二个页面
    [self addSecondPageTopTabBar];
    // 设置scrollview内容区域大小
    self.MyScrollView.contentSize = CGSizeMake(screenW, (screenH - BottomH)*2);
}
/**
 添加第二个页面顶部tabBar
 */
-(void)addSecondPageTopTabBar{
    //初始化第二个页面的父亲view
    UIView* secondPageView = [[UIView alloc] init];
    secondPageView.frame = CGRectMake(0, screenH - BottomH, screenW, screenH - BottomH);
    NSArray* array  = @[@"图文详情",@"商品参数",@"用户评价",@"牛品推荐"];
    //初始化顶部导航标题
    MyOrderTopTabBar* tabBar = [[MyOrderTopTabBar alloc] initWithArray:array] ;
    tabBar.frame = CGRectMake(0,NaviBarH, screenW, TopTabBarH);
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.delegate = self;
    self.TopTabBar = tabBar;
    [secondPageView addSubview:tabBar];
    //初始化一个UITableView
    UITableView* tableview = [[UITableView alloc] init];
    self.detailTableview = tableview;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = GRAY_BG;
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.tag = 1;
    tableview.frame = CGRectMake(0, CGRectGetMaxY(tabBar.frame), screenW,secondPageView.frame.size.height - tabBar.frame.size.height-NaviBarH);
    MJRefreshHeaderView* RheaderView = [MJRefreshHeaderView header];
    RheaderView.scrollView = tableview;
    self.header = RheaderView;
    RheaderView.beginRefreshingBlock = ^(MJRefreshBaseView* refreshView){
        NSOperationQueue* Queue = [[NSOperationQueue alloc] init];
        [Queue addOperationWithBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    self.MyScrollView.contentOffset = CGPointMake(0, 0);
                } completion:^(BOOL finished) {
                    self.MyScrollView.scrollEnabled = YES;
                }];
                [self.header endRefreshing];
            });
        }];
    };

    [secondPageView addSubview:tableview];
    [self.MyScrollView addSubview:secondPageView];
}
#pragma -- <UIScrollViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@" --== %f",scrollView.contentOffset.y);
    if(scrollView.tag == 0){
        if(scrollView.contentOffset.y<0){
//            if(self.TopViewScale<1.01){
//                self.TopViewScale += 0.00015f;
//                [self.topView.icon_img setTransform:CGAffineTransformScale(self.topView.icon_img.transform, self.TopViewScale, self.TopViewScale)];
//            }
            scrollView.contentOffset = CGPointMake(0, 0);
        }else{
            self.NavBarView.backgroundColor = color(0.0,162.0,154.0, scrollView.contentOffset.y/(screenH-BottomH));
        }
        if(scrollView.contentOffset.y == (screenH-BottomH)){
            scrollView.scrollEnabled = NO;
        }else if (scrollView.contentOffset.y == -NaviBarH && !scrollView.isDragging){
            [UIView animateWithDuration:0.3 animations:^{
                scrollView.contentOffset = CGPointMake(0, 0);
            }];
        }else;
    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    NSLog(@" endd-- %f",self.TopViewScale);
//    self.TopViewScale = 1.0;
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.topView.icon_img setTransform:CGAffineTransformIdentity];//恢复原来的大小
//    }];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //NSLog(@" -- %f",scrollView.contentOffset.y);
}

#pragma -- MyOrderTopTabBarDelegate(顶部标题栏delegate)
-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index{
    NSLog(@"点击了 －－－ %ld",index);
//    self.detailTableview.backgroundColor = color(random()%255, random()%255, random()%255, 1.0);
    
    selectedTag = index;
    
    [self.detailTableview reloadData];
}
#pragma -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (selectedTag == 0) {
        return 2;
        
    } else if (selectedTag == 1) {
        return 1;
        
    } else if (selectedTag == 2) {
        
        return 10;
        
    } else if (selectedTag == 3) {
        return 1;
        
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (selectedTag == 0) {
        self.oneCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYImageTextTableViewCell" owner:nil options:nil] firstObject];
        self.oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.oneCell;
        
    } else if (selectedTag == 1) {
        self.twoCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYParameterTableViewCell" owner:nil options:nil] firstObject];
        self.twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.twoCell;
        
    } else if (selectedTag == 2) {
        self.threeCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYGoodsDetailTableViewCell" owner:nil options:nil] firstObject];
        return self.threeCell;
        
    } else if (selectedTag == 3) {
        self.fourCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYRecommendTableViewCell" owner:nil options:nil] firstObject];
        return self.fourCell;
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (selectedTag == 3) {
        return self.detailTableview.frame.size.height;
        
    }
    
    return 250;
}

@end
