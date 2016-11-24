//
//  NPYGoodsDetailViewController.m
//  牛品云
//
//  Created by Eric on 16/10/31.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYGoodsDetailViewController.h"
#import "NPYBaseConstant.h"
#import "NPYProductDetailView.h"
#import "NPYProductParameter.h"
#import "NPYUserEvaluation.h"
#import "NPYRecommendedView.h"
#import "NPYOrderViewController.h"

@interface NPYGoodsDetailViewController () <UIScrollViewDelegate> {
    NSArray *topImgArray;       //滚动图片数组
    int height_Space;
    UIImage *proIcon;
    UILabel *proName,*proDetail;
    UIButton *showAll,*intoShop;
    NSInteger number_Tag;       //记录选中按钮的tag值
    CGRect oldFrame;
}

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIScrollView *topScrollImgView;
@property (nonatomic, strong) UIView *goodsDetailView,*selectProductView;
@property (nonatomic, strong) UIView *productInfoView,*productDetailInfoView;

@property (nonatomic, strong) NPYProductDetailView  *menuOneView;
@property (nonatomic, strong) NPYProductParameter   *menuTwoView;
@property (nonatomic, strong) NPYUserEvaluation     *menuThreeView;
@property (nonatomic, strong) NPYRecommendedView    *menuFourView;
@property (nonatomic, strong) NPYOrderViewController    *orderVC;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *pageLabel,*goodsNameL,*goodsPriceL,*goodsOriPriceL,*goodsSaleCount,*goodsStoreCount;

@end

@implementation NPYGoodsDetailViewController

#pragma mark - System Function

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    height_Space = Height_Space;
    
    topImgArray = @[@"placeholder",@"placeholder",@"placeholder",@"placeholder"];
    
    self.view.backgroundColor = GRAY_BG;
    
    self.mainScrollView = [[UIScrollView alloc] init];
    self.mainScrollView.tag = 100011;
    self.mainScrollView.frame = CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - 40);
    self.mainScrollView.delegate = self;
    self.mainScrollView.scrollEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.alwaysBounceVertical = YES;
    self.mainScrollView.directionalLockEnabled = YES;
    self.mainScrollView.backgroundColor = GRAY_BG;
    [self.view addSubview:self.mainScrollView];
    
    [self navigationLoad];      //导航栏加载
    
    [self topScrollImageViewLoad];  //头部的图片滚动
    
    [self goodsDetailViewLoad];     //产品信息
    
    [self selectProductViewLoad];       //选择商品规格和数量
    
    [self productInfoViewLoad];     //商品信息展示
    
    [self showProductDetailInfoViewLoad];   //商品具体信息的展示
    
    [self bottomViewLoad];      //底部视图
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Custom Function
//导航栏设置
- (void)navigationLoad {
//    self.navigationController.navigationBar.translucent = YES;
    
//    self.navigationItem.title = @"产品页";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:20.0]};
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage =[UIImage new];
}
//顶部滚动图片
- (void)topScrollImageViewLoad {
    self.topScrollImgView = [[UIScrollView alloc] init];
    self.topScrollImgView.tag = 100010;
    self.topScrollImgView.frame = CGRectMake(0, 0, WIDTH_SCREEN, 300);
    self.topScrollImgView.delegate = self;
    self.topScrollImgView.scrollEnabled = YES;
    self.topScrollImgView.showsHorizontalScrollIndicator = NO;
    self.topScrollImgView.alwaysBounceHorizontal = YES;
    self.topScrollImgView.directionalLockEnabled = YES;
    self.topScrollImgView.pagingEnabled = YES;
//    self.topScrollImgView.backgroundColor = [UIColor blueColor];
    [self.mainScrollView addSubview:self.topScrollImgView];
    
    UIView *scrollContent = [[UIView alloc] init];
    scrollContent.frame = CGRectMake(0, 0, WIDTH_SCREEN * topImgArray.count, 236);
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
    
    UIImageView *pageImgView = [[UIImageView alloc] init];
    pageImgView.frame = CGRectMake(WIDTH_SCREEN - 40, CGRectGetMaxY(self.topScrollImgView.frame) - 25 - 64, 30, 15);
    pageImgView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    UILabel *pageL = [[UILabel alloc] init];
    pageL.frame = CGRectMake(0, 0, CGRectGetWidth(pageImgView.frame), CGRectGetHeight(pageImgView.frame));
    pageL.text = [NSString stringWithFormat:@"1/%li",(long)topImgArray.count];
    pageL.textColor = [UIColor whiteColor];
    pageL.textAlignment = NSTextAlignmentCenter;
    pageL.font = [UIFont systemFontOfSize:12.0];
    self.pageLabel = pageL;
    [pageImgView addSubview:self.pageLabel];
    [self.mainScrollView addSubview:pageImgView];
}

- (void)goodsDetailViewLoad {
    UIView *bgView1 = [[UIView alloc] init];
    bgView1.frame = CGRectMake(0, CGRectGetMaxY(self.topScrollImgView.frame) - 64, WIDTH_SCREEN, 80);
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:bgView1];
    self.goodsDetailView = bgView1;
    //name
    self.goodsNameL = [[UILabel alloc] init];
    self.goodsNameL.frame = CGRectMake(height_Space, height_Space, WIDTH_SCREEN, 20);
    self.goodsNameL.text = @"Title";
    self.goodsNameL.textColor = [UIColor blackColor];
    self.goodsNameL.font = [UIFont systemFontOfSize:12.0];
    self.goodsNameL.adjustsFontSizeToFitWidth = YES;
    self.goodsNameL.numberOfLines = 0;
    [bgView1 addSubview:self.goodsNameL];
    //price
    self.goodsPriceL = [[UILabel alloc] init];
    self.goodsPriceL.frame = CGRectMake(CGRectGetMinX(self.goodsNameL.frame), CGRectGetMaxY(self.goodsNameL.frame) + height_Space, WIDTH_SCREEN, 20);
    self.goodsPriceL.text = @"￥999";
    self.goodsPriceL.textColor = [UIColor redColor];
    self.goodsPriceL.font = [UIFont systemFontOfSize:15.0];
    self.goodsPriceL.adjustsFontSizeToFitWidth = YES;
    self.goodsPriceL.numberOfLines = 0;
    [bgView1 addSubview:self.goodsPriceL];
    //originalPrice
    self.goodsOriPriceL = [[UILabel alloc] init];
    self.goodsOriPriceL.frame = CGRectMake(CGRectGetMinX(self.goodsNameL.frame), CGRectGetMaxY(self.goodsPriceL.frame) + height_Space, WIDTH_SCREEN / 3, 20);
    self.goodsOriPriceL.text = @"市场价￥10000";
    self.goodsOriPriceL.textColor = [UIColor grayColor];
    self.goodsOriPriceL.font = [UIFont systemFontOfSize:10.0];
    self.goodsOriPriceL.adjustsFontSizeToFitWidth = YES;
    self.goodsOriPriceL.numberOfLines = 0;
    [bgView1 addSubview:self.goodsOriPriceL];
    
//    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.goodsOriPriceL.text]  attributes:attribtDic];
//    self.goodsOriPriceL.attributedText = attribtStr;
    
    NSUInteger length = [self.goodsOriPriceL.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.goodsOriPriceL.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(3, length - 3)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(3, length - 3)];
    [self.goodsOriPriceL setAttributedText:attri];
    
    //salesVolume
    self.goodsSaleCount = [[UILabel alloc] init];
    self.goodsSaleCount.frame = CGRectMake(CGRectGetMaxX(self.goodsOriPriceL.frame), CGRectGetMinY(self.goodsOriPriceL.frame), WIDTH_SCREEN / 3, 20);
    self.goodsSaleCount.text = @"销量：0件";
    self.goodsSaleCount.textColor = [UIColor grayColor];
    self.goodsSaleCount.font = [UIFont systemFontOfSize:10.0];
    self.goodsSaleCount.adjustsFontSizeToFitWidth = YES;
    self.goodsSaleCount.numberOfLines = 0;
    [bgView1 addSubview:self.goodsSaleCount];
    //storeVolume
    self.goodsStoreCount = [[UILabel alloc] init];
    self.goodsStoreCount.frame = CGRectMake(CGRectGetMaxX(self.goodsSaleCount.frame), CGRectGetMinY(self.goodsOriPriceL.frame), WIDTH_SCREEN / 3, 20);
    self.goodsStoreCount.text = @"库存：0件";
    self.goodsStoreCount.textColor = [UIColor grayColor];
    self.goodsStoreCount.font = [UIFont systemFontOfSize:10.0];
    self.goodsStoreCount.adjustsFontSizeToFitWidth = YES;
    self.goodsStoreCount.numberOfLines = 0;
    [bgView1 addSubview:self.goodsStoreCount];
}
//选择商品规格和数量
- (void)selectProductViewLoad {
    UIView *bgView2 = [[UIView alloc] init];
    bgView2.frame = CGRectMake(0, CGRectGetMaxY(self.goodsDetailView.frame) + height_Space, WIDTH_SCREEN, 30);
    bgView2.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:bgView2];
    self.selectProductView = bgView2;
    //选择按钮
    UIButton *selectBtn = [[UIButton alloc] init];
    [selectBtn setFrame:CGRectMake(0, 0, CGRectGetWidth(bgView2.frame), CGRectGetHeight(bgView2.frame))];
    [selectBtn setTitle:@"选择商品规格和数量" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, height_Space, height_Space, WIDTH_SCREEN - 100)];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    selectBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [selectBtn addTarget:self action:@selector(selectProductButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgView2 addSubview:selectBtn];
}
//产品信息展示
- (void)productInfoViewLoad {
    UIView *bgView3 = [[UIView alloc] init];
    bgView3.frame = CGRectMake(0, CGRectGetMaxY(self.selectProductView.frame) + height_Space, WIDTH_SCREEN, 60);
    bgView3.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:bgView3];
    self.productInfoView = bgView3;
    //icon
    proIcon = [UIImage imageNamed:@"placeholder"];
    UIImageView *proIconView = [[UIImageView alloc] init];
    proIconView.frame = CGRectMake(height_Space, height_Space, 30, 30);
    proIconView.image = proIcon;
    proIconView.contentMode = UIViewContentModeScaleAspectFill;
    [bgView3 addSubview:proIconView];
    //name
    proName = [[UILabel alloc] init];
    proName.frame = CGRectMake(height_Space + CGRectGetMaxX(proIconView.frame), CGRectGetMinY(proIconView.frame), 200, 20);
    proName.text = @"五常稻花香大米";
    proName.textColor = [UIColor blackColor];
    proName.font = [UIFont systemFontOfSize:12.0];
    [bgView3 addSubview:proName];
    //detail
    proDetail = [[UILabel alloc] init];
    proDetail.frame = CGRectMake(CGRectGetMinX(proName.frame), CGRectGetMaxY(proName.frame), 200, 15);
    proDetail.text = @"全部宝贝：24件";
    proDetail.textColor = [UIColor grayColor];
    proDetail.font = [UIFont systemFontOfSize:8.0];
    [bgView3 addSubview:proDetail];
    //lookAllCat
    showAll = [[UIButton alloc] init];
    showAll.tag = 10001;
    showAll.frame = CGRectMake(CGRectGetMidX(proIconView.frame), CGRectGetMaxY(proIconView.frame) + height_Space, 80, 15);
    [showAll setTitle:@"查看全部分类" forState:UIControlStateNormal];
    [showAll setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    showAll.titleLabel.font = [UIFont systemFontOfSize:8.0];
    showAll.layer.borderColor = GRAY_BG.CGColor;
    showAll.layer.borderWidth = 1.0;
    [showAll addTarget:self action:@selector(showAllCatAndIntoShopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgView3 addSubview:showAll];
    //intoShop
    intoShop = [[UIButton alloc] init];
    intoShop.tag = 10002;
    intoShop.frame = CGRectMake(WIDTH_SCREEN * 2 / 3, CGRectGetMaxY(proIconView.frame) + height_Space, 80, 15);
    [intoShop setTitle:@"进入店铺" forState:UIControlStateNormal];
    [intoShop setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    intoShop.titleLabel.font = [UIFont systemFontOfSize:8.0];
    intoShop.layer.borderColor = GRAY_BG.CGColor;
    intoShop.layer.borderWidth = 1.0;
    [intoShop addTarget:self action:@selector(showAllCatAndIntoShopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgView3 addSubview:intoShop];
}
//商品信息的具体展示
- (void)showProductDetailInfoViewLoad {
    UIView *bgView4 = [[UIView alloc] init];
    bgView4.frame = CGRectMake(0, CGRectGetMaxY(self.productInfoView.frame) + height_Space, WIDTH_SCREEN, HEIGHT_SCREEN - CGRectGetMaxY(self.productInfoView.frame) - height_Space);
    bgView4.backgroundColor = GRAY_BG;
    [self.mainScrollView addSubview:bgView4];
    self.productDetailInfoView = bgView4;
    oldFrame = self.productDetailInfoView.frame;
    //菜单栏
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 30)];
    [bgView4 addSubview:bg];
    bg.backgroundColor = [UIColor whiteColor];
    NSArray *menuName = @[@"图文详情",@"商品参数",@"用户评价",@"牛品推荐"];
    for (int i = 0; i < 4; i++) {
        UIButton *menuBtn = [[UIButton alloc] init];
        menuBtn.tag = 2000 + i;
        menuBtn.frame = CGRectMake(i * (WIDTH_SCREEN / 4), 0, WIDTH_SCREEN / 4, 30);
        [menuBtn setTitle:menuName[i] forState:UIControlStateNormal];
        [menuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [menuBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [menuBtn addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [bgView4 addSubview:menuBtn];
        
        UIImageView *vLine = [[UIImageView alloc] init];
        vLine.frame = CGRectMake(i * (WIDTH_SCREEN / 4), 10, 1, 10);
        vLine.image = [UIImage imageNamed:@"palceholder"];
        vLine.contentMode = UIViewContentModeScaleAspectFill;
        vLine.backgroundColor = GRAY_BG;
        [bgView4 addSubview:vLine];
        
        if (i == 0) {
            menuBtn.selected = YES;
            vLine.hidden = YES;
            number_Tag = 2000;
        } else {
            menuBtn.selected = NO;
        }
        
    }
    
    UIImageView *hLine = [[UIImageView alloc] init];
    hLine.frame = CGRectMake(0, 30, WIDTH_SCREEN, 1);
    hLine.image = [UIImage imageNamed:@"palceholder"];
    hLine.contentMode = UIViewContentModeScaleAspectFill;
    hLine.backgroundColor = GRAY_BG;
    [bgView4 addSubview:hLine];
    //详细展示
    self.menuOneView = [[NPYProductDetailView alloc] init]; //图文详情
    self.menuTwoView = [[NPYProductParameter alloc] init];  //商品参数
    self.menuThreeView = [[NPYUserEvaluation alloc] init];  //用户评价
    self.menuFourView = [[NPYRecommendedView alloc] init];  //牛品推荐
    //
    self.menuOneView.frame = CGRectMake(0, 32, WIDTH_SCREEN, 100);
//    self.menuOneView.backgroundColor = [UIColor whiteColor];
    
    [bgView4 addSubview:self.menuOneView];
//    self.menuOneView.frame = CGRectMake(0, 32, WIDTH_SCREEN, [self.menuOneView calculateHeightOfView]);
    //
    self.menuTwoView.frame = CGRectMake(WIDTH_SCREEN, 32, WIDTH_SCREEN, 100);
//    self.menuTwoView.backgroundColor = [UIColor whiteColor];
    self.menuTwoView.names = @[@"主体",@"品牌",@"配料",@"保质期",@"类型",@"储存方式"];
    self.menuTwoView.infos = @[@"",@"八杂市",@"大米",@"365天",@"五常有机大米",@"阴凉、通风、干燥"];
    self.menuTwoView.frame = CGRectMake(WIDTH_SCREEN, 32, WIDTH_SCREEN, [self.menuTwoView calculateHeightOfView]);
    [bgView4 addSubview:self.menuTwoView];
    //
    self.menuThreeView.frame = CGRectMake(WIDTH_SCREEN * 2, 32, WIDTH_SCREEN, 100);
    [bgView4 addSubview:self.menuThreeView];
    //
    self.menuFourView.frame = CGRectMake(WIDTH_SCREEN * 3, 32, WIDTH_SCREEN, 100);
    [bgView4 addSubview:self.menuFourView];
    
}

//
- (void)bottomViewLoad {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0, HEIGHT_SCREEN - 39, WIDTH_SCREEN, 40);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.borderWidth = 1.0;
    self.bottomView.layer.borderColor = GRAY_BG.CGColor;
    
    [self.view addSubview:self.bottomView];
    //
    NSArray *btnNames = @[@"店铺",@"收藏",@"加入购物车"];
    NSArray *btnImges = @[@"placeholder",@"placeholder",@"placeholder"];
    for (int i = 0; i < 3; i++) {
        //
        UIButton *btn = [[UIButton alloc] init];
//        btn.backgroundColor = [UIColor orangeColor];
        btn.frame = CGRectMake(i * 80, 0, 80, CGRectGetHeight(self.bottomView.frame));
        btn.tag = 3010 + i;
        UIImage *imgA = [UIImage imageNamed:btnImges[i]];
        [btn setImage:imgA forState:UIControlStateNormal];
        [btn setImage:imgA forState:UIControlStateSelected];
        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:8.0];
        
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(25, -imgA.size.width, 0.0, 0.0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 15, -btn.titleLabel.bounds.size.width)];
        
        [btn addTarget:self action:@selector(bottomViewEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:btn];
    }
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 0, WIDTH_SCREEN - 240, CGRectGetHeight(self.bottomView.frame))];
    [buyBtn setTag:3013];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setBackgroundColor:[UIColor redColor]];
    [buyBtn addTarget:self action:@selector(bottomViewEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:buyBtn];
}

#pragma mark - 滚动

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 100011) {
        //上下滑动
        self.mainScrollView.contentSize = CGSizeMake(0, self.mainScrollView.frame.size.height + self.productDetailInfoView.frame.size.height - oldFrame.size.height + 64);
        return;
    }
    //获取当前视图的宽度
    CGFloat pageWith = scrollView.frame.size.width;
    //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
    int page = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;
    //显示在界面上
    self.pageLabel.text = [NSString stringWithFormat:@"%i/%li",page + 1,(long)topImgArray.count];
}

#pragma mark - 按钮点击事件
//选择商品按钮点击
- (void)selectProductButtonPressed:(UIButton *)btn {
    NSLog(@"跳转到新的页面...");
}

//查看全部分类和进入店铺按钮点击
//10001 - 10002
- (void)showAllCatAndIntoShopButtonPressed:(UIButton *)btn {
    NSLog(@"%li",(long)btn.tag);
    
}

//菜单按钮点击
//tag （2000 - 2003）
- (void)menuButtonPressed:(UIButton *)btn {
    if (number_Tag == btn.tag) {
        return;
    }
    
    btn.selected = YES;
    
    UIButton *tmpBtn = [self.view viewWithTag:number_Tag];
    tmpBtn.selected = NO;
    
    number_Tag = btn.tag;
    
    if (btn.tag == 2000) {
        [UIView animateWithDuration:0.5 animations:^{
            self.menuTwoView.frame = CGRectMake(WIDTH_SCREEN, CGRectGetMinY(self.menuOneView.frame), WIDTH_SCREEN, 100);
            self.menuThreeView.frame = CGRectMake(WIDTH_SCREEN * 2, CGRectGetMinY(self.menuOneView.frame), WIDTH_SCREEN, 100);
            self.menuFourView.frame = CGRectMake(WIDTH_SCREEN * 3, CGRectGetMinY(self.menuOneView.frame), WIDTH_SCREEN, 100);
            self.menuOneView.frame = CGRectMake(0, CGRectGetMaxY(btn.frame) + 2, WIDTH_SCREEN, 100);
        } completion:^(BOOL finished) {
            
        }];
    }
    if (btn.tag == 2001) {
        [UIView animateWithDuration:0.5 animations:^{
            self.menuTwoView.frame = CGRectMake(0, CGRectGetMaxY(btn.frame) + 2, WIDTH_SCREEN, 100);
        } completion:^(BOOL finished) {
            self.menuOneView.frame = CGRectMake(-WIDTH_SCREEN, CGRectGetMinY(self.menuOneView.frame), WIDTH_SCREEN, 100);
            self.menuThreeView.frame = CGRectMake(WIDTH_SCREEN * 2, CGRectGetMinY(self.menuOneView.frame), WIDTH_SCREEN, 100);
            self.menuFourView.frame = CGRectMake(WIDTH_SCREEN * 3, CGRectGetMinY(self.menuOneView.frame), WIDTH_SCREEN, 100);
        }];
    }
    if (btn.tag == 2002) {
        [UIView animateWithDuration:0.5 animations:^{
            self.menuThreeView.frame = CGRectMake(0, CGRectGetMaxY(btn.frame) + 2, WIDTH_SCREEN, 100);
        } completion:^(BOOL finished) {
            self.menuTwoView.frame = CGRectMake(WIDTH_SCREEN, CGRectGetMinY(self.menuOneView.frame), WIDTH_SCREEN, 100);
            self.menuOneView.frame = CGRectMake( -WIDTH_SCREEN * 2, CGRectGetMinY(self.menuOneView.frame), WIDTH_SCREEN, 100);
            self.menuFourView.frame = CGRectMake(WIDTH_SCREEN * 3, CGRectGetMinY(self.menuOneView.frame), WIDTH_SCREEN, 100);
        }];
    }
    if (btn.tag == 2003) {
        [UIView animateWithDuration:0.5 animations:^{
            self.menuFourView.frame = CGRectMake(0, CGRectGetMaxY(btn.frame) + 2, WIDTH_SCREEN, 100);
        } completion:^(BOOL finished) {
            self.menuTwoView.frame = CGRectMake(WIDTH_SCREEN, CGRectGetMinY(self.menuOneView.frame), WIDTH_SCREEN, 100);
            self.menuThreeView.frame = CGRectMake(WIDTH_SCREEN * 2, CGRectGetMinY(self.menuOneView.frame), WIDTH_SCREEN, 100);
            self.menuOneView.frame = CGRectMake(-WIDTH_SCREEN * 3, CGRectGetMinY(self.menuOneView.frame), WIDTH_SCREEN, 100);
        }];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
