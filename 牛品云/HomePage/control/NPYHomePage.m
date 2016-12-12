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
#import "BuyViewController.h"
#import "NPYSweepViewController.h"
#import "ScanViewController.h"
#import "NPYSearchViewController.h"
#import "NPYHomeModel.h"
#import "NPYHomeADModel.h"
#import "NPYHomeGoodsModel.h"
#import "NPYGoodsListViewController.h"

#define HomeUrl @"/index.php/app/Index/home"

@interface NPYHomePage () <UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource> {
    NSMutableArray *topImgArray;       //滚动图片数组
    CGRect oldFrame;            //记录滚动前的位置
    CGFloat itemHeight;         //每个item的高度
    NSTimer *timer_Scroll;
    
    UIButton *topLeftBtn,*topRightBtn;
    
    NSArray *adArr,*goodsArr;
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

@property (nonatomic, strong) BuyViewController *goodsView;

@property (nonatomic, strong) NPYSearchViewController   *searchVC;
@property (nonatomic, strong) NPYGoodsListViewController    *goodsListVC;

@end

@implementation NPYHomePage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestHomeData];
    
    topImgArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
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
    
    [self topScrollImageViewLoad];
    
    [self menuViewLoad];
    
    [self recommendedViewLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.navigationController.navigationBar.translucent = YES;
    
    [self navigationLoad];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)navigationLoad {
//    self.navigationItem.title = @"首页";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage =[UIImage new];
    
    //左侧扫一扫按钮
    UIButton *leftSweep = [[UIButton alloc] init];
    [leftSweep setFrame:CGRectMake(0, 0, 30, 30)];
    [leftSweep setTitle:@"扫一扫" forState:UIControlStateNormal];
    [leftSweep setTitleColor:XNColor(255, 255, 255, 1) forState:UIControlStateNormal];
    leftSweep.titleLabel.font = [UIFont systemFontOfSize:9.0];
    UIImage *sweepImg = [UIImage imageNamed:@"saomiao_icon"];
    [leftSweep setImage:sweepImg forState:UIControlStateNormal];
    leftSweep.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    leftSweep.titleEdgeInsets = UIEdgeInsetsMake(20, -sweepImg.size.width, 0.0, 0.0);
    leftSweep.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 10, -10);
    [leftSweep addTarget:self action:@selector(leftSweepButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    topLeftBtn = leftSweep;
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftSweep];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    //中间搜索框
    UIButton *searcherBtn = [[UIButton alloc] init];
    searcherBtn.frame = CGRectMake(0, 0, WIDTH_SCREEN - 100, 27);
    UIImage *bgSearchImg = [UIImage imageNamed:@"souuo_home"];
    [searcherBtn setBackgroundImage:bgSearchImg forState:UIControlStateNormal];
    [searcherBtn setTitle:@"点击搜索牛品" forState:0];
    [searcherBtn setTitleColor:XNColor(136, 136, 136, 1) forState:0];
    searcherBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    searcherBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -120, 0, 0);
    [searcherBtn addTarget:self action:@selector(searcherButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searcherBtn;
    
    //右侧消息按钮
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 30, 30)];
    [rightMesg setTitle:@"信息" forState:0];
    [rightMesg setTitleColor:XNColor(255, 255, 255, 1) forState:0];
    rightMesg.titleLabel.font = [UIFont systemFontOfSize:9.0];
    UIImage *mesgImg = [UIImage imageNamed:@"xiaoxi_icon"];
    [rightMesg setImage:mesgImg forState:UIControlStateNormal];
    rightMesg.titleEdgeInsets = UIEdgeInsetsMake(18, -mesgImg.size.width, 0.0, 0.0);
    rightMesg.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 12, -15);
    [rightMesg addTarget:self action:@selector(rightMessageButtonPressed:) forControlEvents:7];
    topRightBtn = rightMesg;
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightMesg];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
}

- (void)topScrollImageViewLoad {
//    _topImgView = [[SZCirculationImageView alloc] initWithFrame:CGRectMake(0, -64, WIDTH_SCREEN, 190) andImageNamesArray:topImgArray];
    _topImgView = [[SZCirculationImageView alloc] initWithFrame:CGRectMake(0, -64, WIDTH_SCREEN, 190) andImageURLsArray:topImgArray];
    _topImgView.pauseTime = 1.0;
    [self.mainScrollView addSubview:_topImgView];
    _topImgView.defaultPageColor = [UIColor grayColor];
    _topImgView.currentPageColor = [UIColor whiteColor];
    
}

- (void)menuViewLoad {
    self.menuView = [[UIView alloc] init];
    self.menuView.frame = CGRectMake(0, CGRectGetMaxY(self.topImgView.frame), WIDTH_SCREEN, 55);
    self.menuView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.menuView];
    //自营馆 特色馆 按钮
    NSArray *menuNames = @[@"牛品馆",@"牛人馆"];
    NSArray *menuImges = @[@"zyg_icon",@"tsg_icon"];
    for (int i = 0; i < 2; i++) {
        UIButton *menuBtn = [[UIButton alloc] init];
        menuBtn.tag = 1010 + i;
        menuBtn.titleLabel.font = XNFont(16.0);
        menuBtn.frame = CGRectMake(i * WIDTH_SCREEN / 2, 0, WIDTH_SCREEN / 2, 22);
        [menuBtn setTitleColor:XNColor(17, 17, 17, 1) forState:UIControlStateNormal];
        [menuBtn setTitle:menuNames[i] forState:UIControlStateNormal];
        menuBtn.center = CGPointMake(CGRectGetMidX(menuBtn.frame), CGRectGetHeight(self.menuView.frame) / 2);
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [menuBtn addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *sweepImg = [UIImage imageNamed:menuImges[i]];
        [menuBtn setImage:sweepImg forState:UIControlStateNormal];
        menuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        menuBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        menuBtn.titleEdgeInsets = UIEdgeInsetsMake(0, sweepImg.size.width, 0.0, 0.0);
        menuBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, sweepImg.size.width);
        
        [self.menuView addSubview:menuBtn];
    }
    UIImageView *vLine = [[UIImageView alloc] init];
    vLine.frame = CGRectMake(WIDTH_SCREEN / 2, 5, 1, 44);
//    vLine.backgroundColor = GRAY_BG;
    vLine.image = [UIImage imageNamed:@"88huixian"];
    [self.menuView addSubview:vLine];
}

- (void)recommendedViewLoad {
    //创建一个layout布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake((WIDTH_SCREEN - 15 ) / 2, (WIDTH_SCREEN - 15 ) / 2 + 50);
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 5.0;
    //设置header
    [layout setHeaderReferenceSize:CGSizeMake(WIDTH_SCREEN, 34)];
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
    return goodsArr.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor blueColor];
    
    NPYHomeGoodsModel *goodsModel = goodsArr[indexPath.row];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (WIDTH_SCREEN - 15) / 2, cell.frame.size.height - 5)];
    bgView.layer.borderColor = XNColor(242, 242, 242, 1).CGColor;
    bgView.layer.borderWidth = 0.5;
    [cell addSubview:bgView];
    //产品图片
    UIImageView *productImg = [[UIImageView alloc] init];
    productImg.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.width);
//    productImg.image = [UIImage imageNamed:@"placeholder"];
    [productImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.goods_img] placeholderImage:[UIImage new]];
    productImg.contentMode = UIViewContentModeScaleToFill;
    [bgView addSubview:productImg];
    //标题
    UILabel *titleL = [[UILabel alloc] init];
    titleL.frame = CGRectMake(CGRectGetMinX(productImg.frame) + Height_Space, CGRectGetMaxY(productImg.frame), CGRectGetWidth(productImg.frame) - Height_Space, 20);
    titleL.textColor = XNColor(85, 85, 85, 1);
    titleL.text = goodsModel.goods_name;
    titleL.numberOfLines = 0;
    titleL.adjustsFontSizeToFitWidth = YES;
    titleL.font = [UIFont systemFontOfSize:10.0];
    [cell addSubview:titleL];
    //价格
    UILabel *priceL = [[UILabel alloc] init];
    priceL.frame = CGRectMake(CGRectGetMinX(titleL.frame), CGRectGetMaxY(titleL.frame) + Height_Space, CGRectGetWidth(productImg.frame) / 2, 20);
    priceL.textColor = XNColor(251, 8, 8, 1);
    priceL.text = @"￥45.60";
    priceL.numberOfLines = 0;
    priceL.adjustsFontSizeToFitWidth = YES;
    priceL.font = [UIFont systemFontOfSize:15.0];
    [cell addSubview:priceL];
    //评价
    UILabel *evaluationL = [[UILabel alloc] init];
    evaluationL.frame = CGRectMake(CGRectGetMaxX(priceL.frame), CGRectGetMaxY(titleL.frame) + Height_Space, CGRectGetWidth(productImg.frame) / 2, 20);
    evaluationL.textColor = XNColor(136, 136, 136, 1);
    evaluationL.text = [NSString stringWithFormat:@"%@人购买",goodsModel.sold];
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
        titleName.textColor = XNColor(102, 102, 102, 1);
        titleName.font = [UIFont systemFontOfSize:13.0];
        [headerView addSubview:titleName];
        
        UIImageView *vLine = [[UIImageView alloc] init];
        vLine.frame = CGRectMake(CGRectGetMidX(titleName.frame) - 75, 0, 25, 1);
//        vLine.backgroundColor = GRAY_BG;
        vLine.image = [UIImage imageNamed:@"heixian_zuo"];
        vLine.center = CGPointMake(CGRectGetMidX(vLine.frame), CGRectGetMidY(titleName.frame));
        [headerView addSubview:vLine];
        
        UIImageView *vLine2 = [[UIImageView alloc] init];
        vLine2.frame = CGRectMake(CGRectGetMidX(titleName.frame) + 50, 0, 25, 1);
//        vLine2.backgroundColor = GRAY_BG;
        vLine2.image = [UIImage imageNamed:@"heixian_you"];
        vLine2.center = CGPointMake(CGRectGetMidX(vLine2.frame), CGRectGetMidY(titleName.frame));
        [headerView addSubview:vLine2];
        
        UIButton *moreBtn = [[UIButton alloc] init];
        moreBtn.frame = CGRectMake(WIDTH_SCREEN - 60, 0, 50, 30);
        moreBtn.center = CGPointMake(CGRectGetMidX(moreBtn.frame), CGRectGetMidY(titleName.frame));
        [moreBtn setTitle:@"更多 >" forState:UIControlStateNormal];
        [moreBtn setTitleColor:XNColor(240, 84, 84, 1) forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [moreBtn addTarget:self action:@selector(moreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:moreBtn];
    }
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"点击了精品推荐的第%li物品",(long)indexPath.row);
    self.goodsView = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
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
        
        if (self.mainScrollView.contentOffset.y > -60 && self.mainScrollView.contentOffset.y != 0) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
            
            [topLeftBtn setTitleColor:XNColor(132, 134, 145, 1) forState:UIControlStateNormal];
            [topLeftBtn setImage:[UIImage imageNamed:@"saomiao_hui"] forState:UIControlStateNormal];
            [topRightBtn setTitleColor:XNColor(132, 134, 145, 1) forState:UIControlStateNormal];
            [topRightBtn setImage:[UIImage imageNamed:@"xiaoxi_hui"] forState:UIControlStateNormal];
            
        } else if ((self.mainScrollView.contentOffset.y >= -3 && self.mainScrollView.contentOffset.y <= 3) || (self.mainScrollView.contentOffset.y >= -67 && self.mainScrollView.contentOffset.y <= -61)) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            
            [topLeftBtn setTitleColor:XNColor(255, 255, 255, 1) forState:UIControlStateNormal];
            [topLeftBtn setImage:[UIImage imageNamed:@"saomiao_icon"] forState:UIControlStateNormal];
            [topRightBtn setTitleColor:XNColor(255, 255, 255, 1) forState:UIControlStateNormal];
            [topRightBtn setImage:[UIImage imageNamed:@"xiaoxi_icon"] forState:UIControlStateNormal];
        }
        
        CGRect fram = CGRectMake(self.recommendView.frame.origin.x, self.recommendView.frame.origin.y, self.recommendView.frame.size.width, self.recommendView.contentSize.height);
        self.recommendView.frame = fram;
        
        self.mainScrollView.contentSize = CGSizeMake(0, self.mainScrollView.frame.size.height + self.recommendView.contentSize.height - oldFrame.size.height - 49);
        
    }
    
}

- (void)searcherButtonPressed:(UIButton *)btn {
//    NSLog(@"跳转到搜索页面...");
    self.searchVC = [[NPYSearchViewController alloc] init];
//    [self presentViewController:self.searchVC animated:YES completion:nil];
    [self.navigationController pushViewController:self.searchVC animated:NO];
}

- (void)leftSweepButtonPressed:(UIButton *)btn {
//    NSLog(@"扫一扫，打开摄像头...");
    self.sweepVC = [[NPYSweepViewController alloc] init];
    [self.navigationController pushViewController:self.sweepVC animated:YES];
    
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
        self.autorophy.isAutrophy = YES;
        [self.navigationController pushViewController:self.autorophy animated:YES];
        
    } else if (btn.tag == 1011) {
        //跳转到特色馆
        self.featureStore = [[NPYFeatureStore alloc] init];
        [self.navigationController pushViewController:self.featureStore animated:YES];
        
    }
}

- (void)moreButtonPressed:(UIButton *)btn {
//    NSLog(@"显示更多牛品推荐...");
    self.goodsListVC = [[NPYGoodsListViewController alloc] init];
    self.goodsListVC.isMore = YES;
    [self.navigationController pushViewController:self.goodsListVC animated:YES];
    
}

- (void)requestHomeData {
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:@"npy_we874646sf",@"key", nil];
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:requestDic] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,HomeUrl] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            [ZHProgressHUD showMessage:@"登录成功" inView:self.view];
            NPYHomeModel *model = [[NPYHomeModel alloc] init];
            model.adArr = dataDict[@"ad"];
            model.goodsArr = dataDict[@"recommend"];
            [model toDetailModel];
            
            adArr = [model returnADModelArray];
            goodsArr = [model returnGoodsModelArray];
            
            NPYHomeADModel *adModel = [[NPYHomeADModel alloc] init];
            
            [topImgArray removeAllObjects];
            
            for (adModel in adArr) {
                adModel = adModel;
                [topImgArray addObject:adModel.img];
            }
            
            [self.recommendView reloadData];
//            NSLog(@"...");
            
        } else {
            //失败
            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
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
