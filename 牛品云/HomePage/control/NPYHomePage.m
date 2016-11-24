//
//  NPYHomePage.m
//  牛品云
//
//  Created by Eric on 16/10/25.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYHomePage.h"
#import "NPYBaseConstant.h"
#import "NPYFeatureStore.h"
#import "NPYAutotrophy.h"
#import "NPYGoodsDetailViewController.h"
#import "NPYSweepViewController.h"
#import "ScanViewController.h"

@interface NPYHomePage () <UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource> {
    NSArray *topImgArray;       //滚动图片数组
    CGRect oldFrame;            //记录滚动前的位置
    CGFloat itemHeight;         //每个item的高度
    NSTimer *timer_Scroll;
    
}

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) SZCirculationImageView *topImgView;

@property (nonatomic, strong) UIScrollView *topScrollImgView;
@property (nonatomic, strong) UIPageControl *scrollPage;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UICollectionView *recommendView;

@property (nonatomic, strong) NPYSweepViewController *sweepVC;
@property (nonatomic, strong) NPYMessageViewController *msgVC;
@property (nonatomic, strong) ScanViewController *scanVC;

@property (nonatomic, strong) NPYAutotrophy *autorophy;
@property (nonatomic, strong) NPYFeatureStore *featureStore;
@property (nonatomic, strong) NPYGoodsDetailViewController *goodsView;

@end

@implementation NPYHomePage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    topImgArray = @[@"placeholder",@"placeholder",@"placeholder",@"placeholder"];
    
    itemHeight = 180;
    
    self.view.backgroundColor = GRAY_BG;
    
    self.mainScrollView = [[UIScrollView alloc] init];
    self.mainScrollView.tag = 100011;
    self.mainScrollView.frame = CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - 49);
    self.mainScrollView.delegate = self;
    self.mainScrollView.scrollEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.alwaysBounceVertical = YES;
    self.mainScrollView.directionalLockEnabled = YES;
    self.mainScrollView.backgroundColor = GRAY_BG;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];
    
    [self navigationLoad];
    
    [self topScrollImageViewLoad];
    
    [self menuViewLoad];
    
    [self recommendedViewLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.translucent = NO;
}

- (void)navigationLoad {
    self.navigationItem.title = @"首页";
//    self.navigationController.navigationBar.translucent = YES;
    
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:20.0]};

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage =[UIImage new];
    
    //左侧扫一扫按钮
    UIButton *leftSweep = [[UIButton alloc] init];
    [leftSweep setFrame:CGRectMake(0, 0, 40, 20)];
    [leftSweep setTitle:@"扫一扫" forState:UIControlStateNormal];
    [leftSweep setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    leftSweep.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [leftSweep addTarget:self action:@selector(leftSweepButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftSweep];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    //中间搜索框
    UIButton *searcherBtn = [[UIButton alloc] init];
    searcherBtn.frame = CGRectMake(0, 0, WIDTH_SCREEN - 100, 20);
    searcherBtn.layer.borderColor = GRAY_BG.CGColor;
    searcherBtn.layer.borderWidth = 1.0;
    searcherBtn.layer.cornerRadius = 10.0;
    [searcherBtn setTitle:@"点击搜索牛品" forState:0];
    [searcherBtn setTitleColor:[UIColor grayColor] forState:0];
    searcherBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    [searcherBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, CGRectGetWidth(searcherBtn.frame)/4)];
    searcherBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [searcherBtn addTarget:self action:@selector(searcherButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searcherBtn;
    
    //右侧消息按钮
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 50, 20)];
    [rightMesg setTitle:@"信息" forState:0];
    [rightMesg setTitleColor:[UIColor grayColor] forState:0];
    rightMesg.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [rightMesg addTarget:self action:@selector(rightMessageButtonPressed:) forControlEvents:7];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightMesg];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
}

- (void)topScrollImageViewLoad {
    _topImgView = [[SZCirculationImageView alloc] initWithFrame:CGRectMake(0, -64, WIDTH_SCREEN, 300) andImageNamesArray:@[@"placeholder",@"placeholder",@"placeholder",@"placeholder"]];
    _topImgView.pauseTime = 1.0;
    [self.mainScrollView addSubview:_topImgView];
    _topImgView.defaultPageColor = [UIColor grayColor];
    _topImgView.currentPageColor = [UIColor purpleColor];
    
#if 0
    //
    self.topScrollImgView = [[UIScrollView alloc] init];
    self.topScrollImgView.tag = 100010;
    self.topScrollImgView.frame = CGRectMake(0, -64, WIDTH_SCREEN, 300);
    self.topScrollImgView.delegate = self;
    self.topScrollImgView.scrollEnabled = YES;
    self.topScrollImgView.showsHorizontalScrollIndicator = NO;
    self.topScrollImgView.alwaysBounceHorizontal = YES;
    self.topScrollImgView.directionalLockEnabled = YES;
    self.topScrollImgView.pagingEnabled = YES;
    //    self.topScrollImgView.backgroundColor = [UIColor blueColor];
    [self.mainScrollView addSubview:self.topScrollImgView];
    
    UIView *scrollContent = [[UIView alloc] init];
    scrollContent.frame = CGRectMake(0, 0, WIDTH_SCREEN * topImgArray.count, 300);
    scrollContent.layer.borderWidth = 1.0;
    scrollContent.layer.borderColor = GRAY_BG.CGColor;
    
    for (int i = 0; i < topImgArray.count; i++) {
        UIImageView *topImgView = [[UIImageView alloc] init];
        UIImage *topImg = [UIImage imageNamed:topImgArray[i]];
        topImgView.frame = CGRectMake(i * WIDTH_SCREEN, 0, WIDTH_SCREEN, CGRectGetHeight(scrollContent.frame));
        topImgView.image = topImg;
        //        [topImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        topImgView.contentMode = UIViewContentModeScaleAspectFit;
        topImgView.backgroundColor = [UIColor whiteColor];
        [scrollContent addSubview:topImgView];
    }
    
    [self.topScrollImgView addSubview:scrollContent];
    
    self.topScrollImgView.contentSize = CGSizeMake(CGRectGetWidth(scrollContent.frame), 0);
    
    self.scrollPage = [[UIPageControl alloc] init];
    self.scrollPage.frame = CGRectMake(0, CGRectGetMaxY(self.topScrollImgView.frame) - 50, WIDTH_SCREEN, 65);
    self.scrollPage.numberOfPages = topImgArray.count;
    self.scrollPage.currentPage = 0;
    self.scrollPage.pageIndicatorTintColor = [UIColor grayColor];
    self.scrollPage.currentPageIndicatorTintColor = GRAY_BG;
    [self.mainScrollView addSubview:self.scrollPage];

#endif
    
}

- (void)menuViewLoad {
    self.menuView = [[UIView alloc] init];
    self.menuView.frame = CGRectMake(0, CGRectGetMaxY(self.topImgView.frame), WIDTH_SCREEN, 50);
    self.menuView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.menuView];
    //自营馆 特色馆 按钮
    NSArray *menuNames = @[@"自营馆",@"特色馆"];
    for (int i = 0; i < 2; i++) {
        UIButton *menuBtn = [[UIButton alloc] init];
        menuBtn.tag = 1010 + i;
        menuBtn.frame = CGRectMake(i * WIDTH_SCREEN / 2, 0, WIDTH_SCREEN / 2, 20);
        [menuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuBtn setTitle:menuNames[i] forState:UIControlStateNormal];
        menuBtn.center = CGPointMake(CGRectGetMidX(menuBtn.frame), CGRectGetHeight(self.menuView.frame) / 2);
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [menuBtn addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:menuBtn];
    }
    UIImageView *vLine = [[UIImageView alloc] init];
    vLine.frame = CGRectMake(WIDTH_SCREEN / 2, 10, 1, 30);
    vLine.backgroundColor = GRAY_BG;
//    vLine.image = [UIImage imageNamed:@"placeholder"];
    [self.menuView addSubview:vLine];
}

- (void)recommendedViewLoad {
    //创建一个layout布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(WIDTH_SCREEN / 2, itemHeight);
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 2.0;
    //设置header
    [layout setHeaderReferenceSize:CGSizeMake(WIDTH_SCREEN, 30)];
    //
    UICollectionView *recommendView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.menuView.frame) + Height_Space * 3, WIDTH_SCREEN, CGRectGetHeight(self.mainScrollView.frame) - CGRectGetMaxY(self.menuView.frame) - Height_Space * 3) collectionViewLayout:layout];
    //代理设置
    recommendView.delegate = self;
    recommendView.dataSource = self;
    recommendView.backgroundColor = [UIColor whiteColor];
    recommendView.showsVerticalScrollIndicator = NO;
    recommendView.scrollEnabled = NO;
    //注册item类型 这里使用系统的类型
    [recommendView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [recommendView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
    [self.mainScrollView addSubview:recommendView];
    self.recommendView = recommendView;
    oldFrame = recommendView.frame;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor blueColor];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(Height_Space / 2, 0, cell.frame.size.width - 3/2*Height_Space, cell.frame.size.height)];
    bgView.layer.borderColor = GRAY_BG.CGColor;
    bgView.layer.borderWidth = 1.0;
    [cell addSubview:bgView];
    //产品图片
    UIImageView *productImg = [[UIImageView alloc] init];
    productImg.frame = CGRectMake(0, 0, bgView.frame.size.width, 130);
    productImg.image = [UIImage imageNamed:@"placeholder"];
    [bgView addSubview:productImg];
    //标题
    UILabel *titleL = [[UILabel alloc] init];
    titleL.frame = CGRectMake(CGRectGetMinX(productImg.frame) + Height_Space, CGRectGetMaxY(productImg.frame), CGRectGetWidth(productImg.frame) - Height_Space, 20);
    titleL.textColor = [UIColor grayColor];
    titleL.text = @"正宗黑龙江五常东北有机稻花香大米非转基因高端大米 1kg";
    titleL.numberOfLines = 0;
    titleL.adjustsFontSizeToFitWidth = YES;
    titleL.font = [UIFont systemFontOfSize:10.0];
    [cell addSubview:titleL];
    //价格
    UILabel *priceL = [[UILabel alloc] init];
    priceL.frame = CGRectMake(CGRectGetMinX(titleL.frame), CGRectGetMaxY(titleL.frame) + Height_Space, CGRectGetWidth(productImg.frame) / 2, 20);
    priceL.textColor = [UIColor redColor];
    priceL.text = @"￥45.60";
    priceL.numberOfLines = 0;
    priceL.adjustsFontSizeToFitWidth = YES;
    priceL.font = [UIFont systemFontOfSize:17.0];
    [cell addSubview:priceL];
    //评价
    UILabel *evaluationL = [[UILabel alloc] init];
    evaluationL.frame = CGRectMake(CGRectGetMaxX(priceL.frame), CGRectGetMaxY(titleL.frame) + Height_Space, CGRectGetWidth(productImg.frame) / 2, 20);
    evaluationL.textColor = [UIColor grayColor];
    evaluationL.text = @"326人购买";
    evaluationL.numberOfLines = 0;
    evaluationL.adjustsFontSizeToFitWidth = YES;
    evaluationL.font = [UIFont systemFontOfSize:12.0];
    [cell addSubview:evaluationL];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView;
    if (kind == UICollectionElementKindSectionHeader) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerIdentifier" forIndexPath:indexPath];
        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 30)];
        titleName.text = @"牛品推荐";
        titleName.textAlignment = NSTextAlignmentCenter;
        titleName.textColor = [UIColor blackColor];
        titleName.font = [UIFont systemFontOfSize:12.0];
        [headerView addSubview:titleName];
        
        UIImageView *vLine = [[UIImageView alloc] init];
        vLine.frame = CGRectMake(CGRectGetMidX(titleName.frame) - 80, 0, 40, 1);
        vLine.backgroundColor = GRAY_BG;
//        vLine.image = [UIImage imageNamed:@"placeholder"];
        vLine.center = CGPointMake(CGRectGetMidX(vLine.frame), CGRectGetMidY(titleName.frame));
        [headerView addSubview:vLine];
        
        UIImageView *vLine2 = [[UIImageView alloc] init];
        vLine2.frame = CGRectMake(CGRectGetMidX(titleName.frame) + 40, 0, 40, 1);
        vLine2.backgroundColor = GRAY_BG;
        //        vLine.image = [UIImage imageNamed:@"placeholder"];
        vLine2.center = CGPointMake(CGRectGetMidX(vLine2.frame), CGRectGetMidY(titleName.frame));
        [headerView addSubview:vLine2];
        
        UIButton *moreBtn = [[UIButton alloc] init];
        moreBtn.frame = CGRectMake(WIDTH_SCREEN - 60, 0, 50, 30);
        moreBtn.center = CGPointMake(CGRectGetMidX(moreBtn.frame), CGRectGetMidY(titleName.frame));
        [moreBtn setTitle:@"更多>" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [moreBtn addTarget:self action:@selector(moreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:moreBtn];
    }
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了精品推荐的第%li物品",(long)indexPath.row);
    self.goodsView = [[NPYGoodsDetailViewController alloc] init];
    [self.navigationController pushViewController:self.goodsView animated:YES];
    
}

- (void)viewDidLayoutSubviews {
    CGRect fram = CGRectMake(self.recommendView.frame.origin.x, self.recommendView.frame.origin.y, self.recommendView.frame.size.width, self.recommendView.contentSize.height);
    self.recommendView.frame = fram;
    
    self.mainScrollView.contentSize = CGSizeMake(0, self.mainScrollView.frame.size.height + self.recommendView.contentSize.height - oldFrame.size.height);
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 100010) {
        //获取当前视图的宽度
        CGFloat pageWith = scrollView.frame.size.width;
        //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
        int page = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;
        self.scrollPage.currentPage = page;
    }
    
    if (scrollView.tag == 100011) {
        
        CGRect fram = CGRectMake(self.recommendView.frame.origin.x, self.recommendView.frame.origin.y, self.recommendView.frame.size.width, self.recommendView.contentSize.height);
        self.recommendView.frame = fram;
        
        self.mainScrollView.contentSize = CGSizeMake(0, self.mainScrollView.frame.size.height + self.recommendView.contentSize.height - oldFrame.size.height - 49);
        
    }
    
}

- (void)searcherButtonPressed:(UIButton *)btn {
    NSLog(@"跳转到搜索页面...");
}

- (void)leftSweepButtonPressed:(UIButton *)btn {
//    NSLog(@"扫一扫，打开摄像头...");
    self.sweepVC = [[NPYSweepViewController alloc] init];
    [self.navigationController pushViewController:self.sweepVC animated:YES];
    
//    self.scanVC = [[ScanViewController alloc] init];
//    [self.navigationController pushViewController:self.scanVC animated:YES];
}

- (void)rightMessageButtonPressed:(UIButton *)btn {
//    NSLog(@"消息按钮点击了...");
    self.msgVC = [[NPYMessageViewController alloc] init];
    [self.navigationController pushViewController:self.msgVC animated:YES];
    
}

- (void)menuButtonPressed:(UIButton *)btn {
    if (btn.tag == 1010) {
        //跳转到自营馆
        self.autorophy = [[NPYAutotrophy alloc] init];
        [self.navigationController pushViewController:self.autorophy animated:YES];
        
    } else if (btn.tag == 1011) {
        //跳转到特色馆
        self.featureStore = [[NPYFeatureStore alloc] init];
        [self.navigationController pushViewController:self.featureStore animated:YES];
        
    }
}

- (void)moreButtonPressed:(UIButton *)btn {
    NSLog(@"显示更多牛品推荐...");
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
