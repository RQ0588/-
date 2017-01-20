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
#import "NPYLoginMode.h"
#import "NPYShopModel.h"
#import "NPYHeaderCollectionReusableView.h"
#import "NPYGoodsCollectionViewCell.h"

#define ShopUrl @"/index.php/app/Shop/home"
#define AllGoodsUrl @"/index.php/app/Shop/get_goods"
#define PromotionUrl @"/index.php/app/Shop/get_promotion"
#define NewGoodsUrl @"/index.php/app/Shop/get_new"
#define Collect_shop_set_url @"/index.php/app/Collect/set_shop"

@interface NPYAutotrophy () <UICollectionViewDelegate,UICollectionViewDataSource,LoadMoreDataDelegate> {
    double height_Space;        //间隔高度
    NSInteger number_Tag;       //记录选中按钮的tag值
    double height_ScrollView;   //底部滚动视图的大小
    CGRect oldFrame;            //记录滚动前的位置
    BOOL isMove;                //滑动上移
    BOOL isHome;                //是否是首页
    
    NSString *userID;
    NSString *signStr;
    
    UIButton *topLeftBtn,*topRightBtn;
    
    UIButton *oneAD,*twoAD;//广告位
    
    UICollectionReusableView *headerView;
    UIView *bgView;
    UIImageView *productImg;
    UILabel *titleL,*priceL,*evaluationL;
    NSMutableArray *dataArr;
    
    UIImageView *icon2;
    UILabel *nameL2;
    UILabel *addressL2;
    UIButton *collectBtn2;
    
    NSArray *goodsArr,*adArr,*shopArr;
    
    BOOL isCollected;
    
}

@property (nonatomic, strong) UIView *topTitleView;
@property (nonatomic, strong) UIView *midMenuView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *advertView;
@property (nonatomic, strong) UICollectionView *recommendView;

@property (nonatomic, strong) NPYMessageViewController  *msgVC;
@property (nonatomic, strong) NPYSearchViewController   *searchVC;
@property (nonatomic, strong) BuyViewController *goodsView;

@property (nonatomic, strong) NSMutableDictionary *cellDic;

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
    
    _cellDic = [NSMutableDictionary new];
    
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    
    signStr = [dic valueForKey:@"sign"];
    
    if (self.isAutrophy) {
        //是自营馆
        self.shopID = @"0";
    } else {
        //店铺
        if (self.shopID == nil) {
            self.shopID = @"0";
        }
    }
    
    self.view.backgroundColor = GRAY_BG; //灰色背景
    
    [self navigationLoad];  //导航栏设置
    
    [self mainViewLoad];    //主页面布局
    
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:@"npy_we874646sf",@"key",self.shopID,@"shop_id",model.user_id,@"user_id", nil];
    userID = model.user_id;
    
    [self requestHomeDataWithUrlString:ShopUrl withKeyValueParemes:requestDic];
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
    
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Custom Function

//导航栏的设置
- (void)navigationLoad {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
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
    [rightMesg setTitle:@"消息" forState:0];
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
    shopIcon.image = [UIImage imageNamed:@"tiantu_icon"];
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
    addressL.frame = CGRectMake(CGRectGetMinX(nameL.frame), CGRectGetMaxY(nameL.frame) + height_Space, WIDTH_SCREEN / 2 + 50, 20);
    addressL.text = @"苏州高新区科技城致远大厦";
    addressL.textColor = XNColor(153, 153, 153, 1);
    addressL.font = [UIFont systemFontOfSize:11.0];
    addressL.adjustsFontSizeToFitWidth = YES;
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
    collectBtn.selected = isCollected;
    collectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    collectBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -placeHolder.size.width, 0.0, 0.0);
    collectBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 20, -placeHolder.size.width - 8);
    [collectBtn addTarget:self action:@selector(collectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topTitleView addSubview:collectBtn];
    collectBtn2 = collectBtn;
    
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
//    UIImage *imgOne = [UIImage imageNamed:@"tiantu_icon"];
//    [oneImg setImage:imgOne forState:UIControlStateNormal];
//    [oneImg setImageEdgeInsets:UIEdgeInsetsMake(height_Space / 2, height_Space, height_Space / 2, height_Space)];
    [oneImg addTarget:self action:@selector(adButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [advertView addSubview:oneImg];
    oneAD = oneImg;
    oneImg.layer.borderColor = GRAY_BG.CGColor;
    oneImg.layer.borderWidth = 0.5;
    
    //twoAD
    UIButton *twoImg = [[UIButton alloc] init];
    twoImg.tag = 2020;
    twoImg.frame = CGRectMake(10, CGRectGetMaxY(oneImg.frame) + 10, CGRectGetWidth(advertView.frame) - 20, (CGRectGetHeight(advertView.frame) - 20) / 2);
//    UIImage *imgTwo = [UIImage imageNamed:@"tiantu_icon"];
//    [twoImg setImage:imgTwo forState:UIControlStateNormal];
//    [twoImg setImageEdgeInsets:UIEdgeInsetsMake(height_Space / 2, height_Space, height_Space / 2, height_Space)];
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
    [recommendView registerClass:[NPYGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"goodsCell"];
    [recommendView registerClass:[NPYHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
    [bottomScorllView addSubview:recommendView];
    self.recommendView = recommendView;
    oldFrame = recommendView.frame;
}

- (void)addRecommendViewAndMenu {
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return goodsArr.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NPYHomeGoodsModel *goodsModel = goodsArr[indexPath.row];
//    
//    NPYGoodsCollectionViewCell *goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCell" forIndexPath:indexPath];
//    
//    goodsCell.goodsModel = goodsModel;
//
    
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"DayCell", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.recommendView registerClass:[NPYGoodsCollectionViewCell class]  forCellWithReuseIdentifier:identifier];
    }
    
    NPYGoodsCollectionViewCell *goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];;
    NPYHomeGoodsModel *goodsModel = goodsArr[indexPath.row];
    goodsCell.goodsModel = goodsModel;
    return goodsCell;
    
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader ) {
        NPYHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerIdentifier" forIndexPath:indexPath];
        header.isHiddenAll = !isHome;
        header.delegate = self;
        header.isHideMore = YES;
        return header;
       
    }
    return nil;
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

#pragma mark - 

- (void)requestHomeDataWithUrlString:(NSString *)urlStr withKeyValueParemes:(NSDictionary *)pareme {
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            NSDictionary *tpDict = dataDict[@"data"];
            
            NPYHomeModel *model = [[NPYHomeModel alloc] init];
            model.goodsArr = tpDict[@"goods"];
            [model toDetailModel];
            goodsArr = [model returnGoodsModelArray];
            
            NSString *collectState = tpDict[@"collect"];
            
            if ([collectState isEqualToString:@"true"]) {
                
            }
            
            isCollected = [collectState boolValue];
            
            [collectBtn2 setSelected:isCollected];
            
//            [self topTitleViewLoad];
            
            NPYShopModel *shopModel = [NPYShopModel mj_objectWithKeyValues:tpDict[@"shop"]];
            nameL2.text = shopModel.shop_name;
            [icon2 sd_setImageWithURL:[NSURL URLWithString:shopModel.shop_img] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
            addressL2.text = shopModel.address;
            
            NPYHomeADModel *ad1Model = [NPYHomeADModel mj_objectWithKeyValues:tpDict[@"ad1"]];
            UIImageView *tp = [UIImageView new];
            [tp sd_setImageWithURL:[NSURL URLWithString:ad1Model.img] placeholderImage:[UIImage imageNamed:@"tiantu_icon"] options:SDWebImageRetryFailed];
            [oneAD setImage:tp.image forState:UIControlStateNormal];
            
            NPYHomeADModel *ad2Model = [NPYHomeADModel mj_objectWithKeyValues:tpDict[@"ad2"]];
            [tp sd_setImageWithURL:[NSURL URLWithString:ad2Model.img] placeholderImage:[UIImage imageNamed:@"tiantu_icon"] options:SDWebImageRetryFailed];
            [twoAD setImage:tp.image forState:UIControlStateNormal];
            
            [self.recommendView reloadData];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
//            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestAddShopToCollectListUrl:(NSString *)url withParemes:(NSDictionary *)pareme {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        } else {
            //失败
//            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark - Button Pressed Event

- (void)backItem:(UIButton *)sender {
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
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:signStr,@"sign",self.shopID,@"shop_id",userID,@"user_id", nil];
    [self requestAddShopToCollectListUrl:Collect_shop_set_url withParemes:requestDic];
    
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
    
    NSString *urlStr;
    
    switch (btn.tag) {
        case 2000:
            isHome = YES;
            urlStr = ShopUrl;
            break;
            
        case 2001:
             isHome = NO;
            urlStr = AllGoodsUrl;
            break;
            
        case 2002:
             isHome = NO;
            urlStr = PromotionUrl;
            break;
            
        case 2003:
             isHome = NO;
            urlStr = NewGoodsUrl;
            break;
            
        default:
            break;
    }
    
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:@"npy_we874646sf",@"key",self.shopID,@"shop_id",@"1",@"num", nil];
    [self requestHomeDataWithUrlString:urlStr withKeyValueParemes:requestDic];
    
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
