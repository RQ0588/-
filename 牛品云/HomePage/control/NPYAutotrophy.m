//
//  NPYAutotrophy.m
//  牛品云
//
//  Created by Eric on 16/10/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYAutotrophy.h"
#import "NPYBaseConstant.h"
#import "NPYSearchViewController.h"
#import "BuyViewController.h"

@interface NPYAutotrophy () <UICollectionViewDelegate,UICollectionViewDataSource> {
    double height_Space;        //间隔高度
    NSInteger number_Tag;       //记录选中按钮的tag值
    double height_ScrollView;   //底部滚动视图的大小
    CGRect oldFrame;            //记录滚动前的位置
    BOOL isMove;                //滑动上移
    BOOL isHome;                //是否是首页
    
    UIButton *topLeftBtn,*topRightBtn;
    
    UIButton *oneAD,*twoAD;//广告位
    
    NSMutableArray *dataArr;
    
    UIImageView *icon2;
    UILabel *nameL2;
    UILabel *addressL2;
}

@property (nonatomic, strong) UIView *topTitleView;
@property (nonatomic, strong) UIView *midMenuView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *advertView;
@property (nonatomic, strong) UICollectionView *recommendView;

@property (nonatomic, strong) NPYMessageViewController  *msgVC;
@property (nonatomic, strong) NPYSearchViewController   *searchVC;
@property (nonatomic, strong) BuyViewController *goodsView;

@end

@implementation NPYAutotrophy

#pragma mark - System Function

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //模拟数据
    height_Space = Height_Space;
    height_ScrollView = 300.0;
    isMove = YES;
    
    if (self.isAutrophy) {
        //是自营馆
        
    } else {
        //店铺
        
    }
    
    self.view.backgroundColor = GRAY_BG; //灰色背景
    
    [self navigationLoad];  //导航栏设置
    
    [self mainViewLoad];    //主页面布局
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Custom Function

//导航栏的设置
- (void)navigationLoad {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationController.navigationBar.shadowImage =[UIImage imageNamed:@"hk_dingbu"];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    //中间搜索框
    UIButton *searcherBtn = [[UIButton alloc] init];
    searcherBtn.frame = CGRectMake(0, 0, WIDTH_SCREEN - 100, 27);
    UIImage *bgSearchImg = [UIImage imageNamed:@"sousuo_qita"];
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
    [rightMesg setTitleColor:XNColor(132, 134, 145, 1) forState:0];
    rightMesg.titleLabel.font = [UIFont systemFontOfSize:9.0];
    UIImage *mesgImg = [UIImage imageNamed:@"xiaoxi_hui"];
    [rightMesg setImage:mesgImg forState:UIControlStateNormal];
    rightMesg.titleEdgeInsets = UIEdgeInsetsMake(18, -mesgImg.size.width, 0.0, 0.0);
    rightMesg.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 12, -15);
    [rightMesg addTarget:self action:@selector(rightMessageButtonPressed:) forControlEvents:7];
    topRightBtn = rightMesg;
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightMesg];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

//主页面的布局
- (void)mainViewLoad {
//    NSLog(@"进入主页面的布局设置...");
    //标题布局设置
    [self topTitleViewLoad];
    //中间导航栏
    [self midMenuViewLoad];
    //底部产品展示
    [self bottomViewLoad];
}
//topTitleView
- (void)topTitleViewLoad {
    UIView *topTitleView = [[UIView alloc] init];
    topTitleView.frame = CGRectMake(0, 1, WIDTH_SCREEN, 60);
    topTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topTitleView];
    self.topTitleView = topTitleView;
    //icon
    UIImageView *shopIcon = [[UIImageView alloc] init];
    shopIcon.frame = CGRectMake(14, 20, 40, 40);
    shopIcon.center = CGPointMake(CGRectGetMidX(shopIcon.frame), topTitleView.frame.size.height / 2);
    shopIcon.image = [UIImage imageNamed:@"placeholder"];
    [topTitleView addSubview:shopIcon];
    icon2 = shopIcon;
    //titleName
    UILabel *nameL = [[UILabel alloc] init];
    nameL.frame = CGRectMake(CGRectGetMaxX(shopIcon.frame) + height_Space * 2, CGRectGetMinY(shopIcon.frame), WIDTH_SCREEN / 2, 20);
    nameL.text = @"牛品馆";
    nameL.textColor = XNColor(68, 68, 68, 1);
    nameL.font = [UIFont systemFontOfSize:16.0];
    [topTitleView addSubview:nameL];
    nameL2 = nameL;
    //address
    UILabel *addressL = [[UILabel alloc] init];
    addressL.frame = CGRectMake(CGRectGetMinX(nameL.frame), CGRectGetMaxY(nameL.frame) + height_Space, WIDTH_SCREEN / 2, 20);
    addressL.text = @"苏州高新区科技城致远大厦";
    addressL.textColor = XNColor(153, 153, 153, 1);
    addressL.font = [UIFont systemFontOfSize:11.0];
    [topTitleView addSubview:addressL];
    addressL2 = addressL;
    //collect
    UIButton *collectBtn = [[UIButton alloc] init];
    collectBtn.frame = CGRectMake(WIDTH_SCREEN - 40 - height_Space, CGRectGetMinY(shopIcon.frame), 40, 40);
    [collectBtn setTag:1001];
    UIImage *placeHolder = [UIImage imageNamed:@"dianzan_yi"];
    UIImage *norImg = [UIImage imageNamed:@"dianzan_wei"];
    [collectBtn setImage:norImg forState:UIControlStateNormal];
    [collectBtn setImage:placeHolder forState:UIControlStateSelected];
    [collectBtn setTitle:@"收藏" forState:0];
    [collectBtn setTitleColor:XNColor(153, 153, 153, 1) forState:UIControlStateNormal];
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    collectBtn.selected = NO;
    collectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    collectBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -placeHolder.size.width, 0.0, 0.0);
    collectBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 20, -placeHolder.size.width - 8);
    [collectBtn addTarget:self action:@selector(collectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topTitleView addSubview:collectBtn];
    
}
//midMenuView
- (void)midMenuViewLoad {
    UIView *midMenuView = [[UIView alloc] init];
    midMenuView.backgroundColor = [UIColor whiteColor];
    midMenuView.frame = CGRectMake(0, CGRectGetMaxY(self.topTitleView.frame) + height_Space, WIDTH_SCREEN, 60);
    [self.view addSubview:midMenuView];
    self.midMenuView = midMenuView;
    //button
    NSArray *nameBtn = @[@"店铺首页",@"全部商品",@"促销",@"新品"];
    NSArray *norImges = @[@"dpsy_wei",@"pbsp_wei",@"cx_wei",@"xp_wei"];
    NSArray *selectedImges = @[@"dpsy_yi",@"pbsp_yi",@"cx_yi",@"xp_yi"];
    
    for (int i = 0; i < 4; i++) {
        UIButton *menuBtn = [[UIButton alloc] init];
        menuBtn.frame = CGRectMake(i * WIDTH_SCREEN / 4, 0, WIDTH_SCREEN / 4, CGRectGetHeight(midMenuView.frame));
        [menuBtn setTag:2000 + i];
        [menuBtn setTitle:nameBtn[i] forState:UIControlStateNormal];
        [menuBtn setTitleColor:XNColor(68, 68, 68, 1) forState:UIControlStateNormal];
        [menuBtn setTitleColor:XNColor(248, 31, 31, 1) forState:UIControlStateSelected];
        
        UIImage *norImg = [UIImage imageNamed:norImges[i]];
        UIImage *selImg = [UIImage imageNamed:selectedImges[i]];
        [menuBtn setImage:norImg forState:UIControlStateNormal];
        [menuBtn setImage:selImg forState:UIControlStateSelected];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        menuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        if (i == 2 || i == 3) {
            menuBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -norImg.size.width, 0.0, 0.0);
            menuBtn.imageEdgeInsets = UIEdgeInsetsMake(10.0, 0, 30, -norImg.size.width - 8);
        } else {
            menuBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -norImg.size.width, 0.0, 0.0);
            menuBtn.imageEdgeInsets = UIEdgeInsetsMake(10.0, 0, 30, -norImg.size.width - 30);
        }
        
        
        UIImageView *selectedImgView = [[UIImageView alloc] init];
        selectedImgView.image = [UIImage imageNamed:@"hongxian_xz"];
        selectedImgView.tag = menuBtn.tag + 100;
        selectedImgView.frame = CGRectMake(0, CGRectGetHeight(menuBtn.frame) - 2, CGRectGetWidth(menuBtn.frame), 2);
        [menuBtn addSubview:selectedImgView];
        if (i == 0) {
            menuBtn.selected = YES;
            selectedImgView.hidden = NO;
            number_Tag = 2000;
        } else {
            menuBtn.selected = NO;
            selectedImgView.hidden = YES;
        }
        
        [menuBtn addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [midMenuView addSubview:menuBtn];
    }
}
//bottomView
- (void)bottomViewLoad {
    isHome = YES;
    UIView *bottomScorllView = [[UIView alloc] init];
    bottomScorllView.frame = CGRectMake(0, CGRectGetMaxY(self.midMenuView.frame) + 10, WIDTH_SCREEN, HEIGHT_SCREEN - CGRectGetMaxY(self.midMenuView.frame) - 75);
    [self.view addSubview:bottomScorllView];
    self.bottomView = bottomScorllView;
    //advert（广告位）
    UIView *advertView = [[UIView alloc] init];
    advertView.frame = CGRectMake(0, 0, WIDTH_SCREEN, 290);
    advertView.backgroundColor = [UIColor whiteColor];
    [bottomScorllView addSubview:advertView];
    self.advertView = advertView;
    //topAD
    UIButton *oneImg = [[UIButton alloc] init];
    oneImg.tag = 2010;
    oneImg.frame = CGRectMake(10, 5, CGRectGetWidth(advertView.frame) - 20, (CGRectGetHeight(advertView.frame) - 20) / 2);
    UIImage *imgOne = [UIImage imageNamed:@"placeholder"];
    [oneImg setImage:imgOne forState:UIControlStateNormal];
    [oneImg setImageEdgeInsets:UIEdgeInsetsMake(height_Space / 2, height_Space, height_Space / 2, height_Space)];
    [oneImg addTarget:self action:@selector(adButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [advertView addSubview:oneImg];
    oneAD = oneImg;
    oneImg.layer.borderColor = GRAY_BG.CGColor;
    oneImg.layer.borderWidth = 0.5;
    
    //twoAD
    UIButton *twoImg = [[UIButton alloc] init];
    twoImg.tag = 2020;
    twoImg.frame = CGRectMake(10, CGRectGetMaxY(oneImg.frame) + 10, CGRectGetWidth(advertView.frame) - 20, (CGRectGetHeight(advertView.frame) - 20) / 2);
    UIImage *imgTwo = [UIImage imageNamed:@"placeholder"];
    [twoImg setImage:imgTwo forState:UIControlStateNormal];
    [twoImg setImageEdgeInsets:UIEdgeInsetsMake(height_Space / 2, height_Space, height_Space / 2, height_Space)];
    [twoImg addTarget:self action:@selector(adButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [advertView addSubview:twoImg];
    twoAD = twoImg;
    twoImg.layer.borderColor = GRAY_BG.CGColor;
    twoImg.layer.borderWidth = 0.5;
    
    //recommend（精品推荐）
    //创建一个layout布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake((WIDTH_SCREEN - 15 ) / 2, (WIDTH_SCREEN - 15 ) / 2 + 50);
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 5.0;
    //设置header
    [layout setHeaderReferenceSize:CGSizeMake(WIDTH_SCREEN, 30)];
    //
    UICollectionView *recommendView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(advertView.frame) + 10, WIDTH_SCREEN, CGRectGetHeight(bottomScorllView.frame) - CGRectGetHeight(advertView.frame) - height_Space - 1) collectionViewLayout:layout];
    //代理设置
    recommendView.delegate = self;
    recommendView.dataSource = self;
    recommendView.backgroundColor = [UIColor whiteColor];
    recommendView.showsVerticalScrollIndicator = NO;
    //注册item类型 这里使用系统的类型
    [recommendView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [recommendView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
    [bottomScorllView addSubview:recommendView];
    self.recommendView = recommendView;
    oldFrame = recommendView.frame;
}

- (void)addRecommendViewAndMenu {
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor blueColor];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (WIDTH_SCREEN - 15) / 2, cell.frame.size.height)];
    bgView.layer.borderColor = XNColor(242, 242, 242, 1).CGColor;
    bgView.layer.borderWidth = 0.5;
    [cell addSubview:bgView];
    //产品图片
    UIImageView *productImg = [[UIImageView alloc] init];
    productImg.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.width);
    productImg.image = [UIImage imageNamed:@"placeholder"];
    productImg.contentMode = UIViewContentModeScaleToFill;
    [bgView addSubview:productImg];
    //标题
    UILabel *titleL = [[UILabel alloc] init];
    titleL.frame = CGRectMake(CGRectGetMinX(productImg.frame) + Height_Space, CGRectGetMaxY(productImg.frame), CGRectGetWidth(productImg.frame) - Height_Space, 20);
    titleL.textColor = XNColor(85, 85, 85, 1);
    titleL.text = @"正宗黑龙江五常东北有机稻花香大米非转基因高端大米 1kg";
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
        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(height_Space * 2, 0, WIDTH_SCREEN, 30)];
        titleName.text = @"精品推荐";
        titleName.textAlignment = NSTextAlignmentCenter;
        titleName.textColor = XNColor(102, 102, 102, 1);
        titleName.font = [UIFont systemFontOfSize:12.0];
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
    }
    return headerView;
}
//点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"点击了精品推荐的第%li物品",(long)indexPath.row);
    self.goodsView = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
    [self.navigationController pushViewController:self.goodsView animated:YES];
    
}
//滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
//    NSLog(@"%f,%f",point.x,point.y);
    if (isMove && point.y > 0) {
        self.recommendView.frame = CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - CGRectGetMaxY(self.midMenuView.frame) - 75);
        
        isMove = NO;
    }
    
    if (point.y < 0 && isMove == NO) {
        isMove = YES;
        if (isHome) {
           self.recommendView.frame = CGRectMake(0, CGRectGetMaxY(self.advertView.frame) + 10, WIDTH_SCREEN, CGRectGetHeight(self.bottomView.frame) - CGRectGetHeight(self.advertView.frame) - height_Space - 1);
        } else {
            self.recommendView.frame = CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - CGRectGetMaxY(self.midMenuView.frame) - 75);
        }
        
    }
    
}

#pragma mark - Button Pressed Event

- (void)backItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searcherButtonPressed:(UIButton *)btn {
    //    NSLog(@"跳转到搜索页面...");
    self.searchVC = [[NPYSearchViewController alloc] init];
    //    [self presentViewController:self.searchVC animated:YES completion:nil];
    [self.navigationController pushViewController:self.searchVC animated:NO];
}

//导航栏右侧的消息按钮事件
- (void)rightMessageButtonPressed:(UIButton *)btn {
//    NSLog(@"消息按钮点击了...");
    self.msgVC = [[NPYMessageViewController alloc] init];
    [self.navigationController pushViewController:self.msgVC animated:YES];
    
}
//收藏按钮的点击事件
- (void)collectButtonPressed:(UIButton *)btn {
//    NSLog(@"收藏按钮点击了...");
    btn.selected = !btn.selected;
    
}
//广告位按钮的点击事件
- (void)adButtonPressed:(UIButton *)btn {
//    NSLog(@"广告位按钮点击了...%li",(long)btn.tag);
    
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
    
//    [self.advertView removeFromSuperview];
//    self.advertView = nil;
//    [self.recommendView removeFromSuperview];
//    self.recommendView = nil;
//    [self.bottomView removeFromSuperview];
//    self.bottomView = nil;
    
//    [self.view setNeedsDisplay];
    
    switch (btn.tag) {
        case 2000:
            isHome = YES;
            break;
            
        case 2001:
             isHome = NO;
            break;
            
        case 2002:
             isHome = NO;
            break;
            
        case 2003:
             isHome = NO;
            break;
            
        default:
            break;
    }
    
    if (isHome) {
        self.advertView.hidden = NO;
        
        self.recommendView.frame = CGRectMake(0, CGRectGetMaxY(self.advertView.frame) + height_Space, WIDTH_SCREEN, HEIGHT_SCREEN - CGRectGetMaxY(self.midMenuView.frame) - 75);
        
        
    } else {
        self.advertView.hidden = YES;
        
        self.recommendView.frame = CGRectMake(0, 0, CGRectGetWidth(self.recommendView.frame), CGRectGetHeight(self.recommendView.frame) + CGRectGetHeight(self.advertView.frame) + height_Space + 1);
        
    }
    
    [self.recommendView reloadData];
    
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
