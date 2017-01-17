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
#import "NPYSpecViewController.h"

#import "NPYBaseConstant.h"
#import "NPYOrderViewController.h"

#import "NPYGoodsSpecModel.h"
#import "NPYAppraiseModel.h"

#import "NPYAutotrophy.h"

#define TopViewH 417
#define MiddleViewH 160
#define BottomH 52
#define TopTabBarH [global pxTopt:100]
#define NaviBarH 64.0

#define Share_Url @"/index.php/app/User/share"

@interface BuyViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MyOrderTopTabBarDelegate,MidViewDelegate,popValueToSuperViewDelegate> {
    
    NSInteger selectedTag;
    UIButton *oneBtn,*twoBtn;
    
    NPYLoginMode *userModel;
//    NPYHomeGoodsModel *goodsModel;
    NPYShopModel *shopModel;
    NPYGoodsSpecModel *sepcModel;
    
    NSMutableArray *appraiseArr;
    
    NSMutableArray *titleImgs,*detailImgs;
    
    int addGoodsNumber;
    
    NSDictionary *selectedSpecDict;
    
    BOOL isCollection;
    
    NSInteger cellHeight;
    
    NSDictionary *shareInfo;
}

@property(nonatomic,weak)MyOrderTopTabBar* TopTabBar;
@property(nonatomic,weak)UIView* NavBarView;

@property (weak, nonatomic) UIScrollView *MyScrollView;
@property (weak, nonatomic) BuyTopView* topView;
@property (weak, nonatomic) BuyMiddleView* middleView;
@property (weak, nonatomic) BuyBottomView* bottomView;
@property (weak, nonatomic) UITableView* detailTableview;
@property (weak, nonatomic) MJRefreshHeaderView* header;

@property (nonatomic, strong) NPYImageTextTableViewCell     *oneCell;
@property (nonatomic, strong) NPYParameterTableViewCell     *twoCell;
@property (nonatomic, strong) NPYGoodsDetailTableViewCell   *threeCell;
@property (nonatomic, strong) NPYRecommendTableViewCell     *fourCell;

@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) NPYOrderViewController    *orderVC;

@property (nonatomic, strong) NPYAutotrophy     *shopVC;

@end

@implementation BuyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui_goumai"] forState:0];
    [backBtn addTarget:self action:@selector(backItem) forControlEvents:UIControlEventTouchUpInside];
    oneBtn = backBtn;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn setFrame:CGRectMake(0, 0, 32, 32)];
    [shareBtn setImage:[UIImage imageNamed:@"share_gouwu-"] forState:UIControlStateNormal];
    [shareBtn addTarget:self
     
                 action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    twoBtn = shareBtn;
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage =[UIImage new];
    
    self.navigationController.navigationBar.translucent = YES;
    
    self.tabBarController.tabBar.hidden = YES;
    
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    userModel.sign = [userDict valueForKey:@"sign"];
    //分享的数据
    NSDictionary *shareRequest = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",self.goodsModel.goods_id,@"goods_id",userModel.user_id,@"user_id", nil];
    [self requestShareInfoWithUrlString:Share_Url withParames:shareRequest];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.translucent = NO;
    
//    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.TopViewScale = 1.0;
    
    shareInfo = [NSDictionary new];
    
    [self initView];
    [self addNavBarView];//提示,要在最后添加
    
    //主页面网络请求
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:@"npy_we874646sf",@"key",self.goodsModel.goods_id,@"goods_id",userModel.user_id,@"user_id", nil];
    [self requestHomeDataWithUrlString:GoodsDetail_url withKeyValueParemes:requestDic];
    
    //评论页网络请求
    NSDictionary *appraiseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"npy_we874646sf",@"key",self.goodsModel.goods_id,@"goods_id",@"1",@"num", nil];
    [self requestGoodsAppraiseDataWithUrlString:GoodsAppraise_url withGoodsID:appraiseDic];
    
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
    NSArray *btnImges = @[@"dianpu_gouwu",@"shoucang_gouwu",@"gouwuche_gouwu"];
    NSArray *selImges = @[@"dianpu_gouwu",@"yishoucang_gouwu",@"gouwuche_gouwu"];
    for (int i = 0; i < 3; i++) {
        //
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(i * 80, 0, 80, CGRectGetHeight(self.bottom.frame));
        btn.tag = 3010 + i;
        UIImage *imgA = [UIImage imageNamed:btnImges[i]];
        UIImage *imgB = [UIImage imageNamed:selImges[i]];
        [btn setImage:imgA forState:UIControlStateNormal];
        [btn setImage:imgB forState:UIControlStateSelected];
        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
        [btn setTitleColor:XNColor(102, 102, 102, 1) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11.0];
        
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        if (i == 2) {
            btn.titleEdgeInsets = UIEdgeInsetsMake(20, -imgA.size.width, 0.0, 0.0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 20, -imgA.size.width - 36);
        } else {
            btn.titleEdgeInsets = UIEdgeInsetsMake(20, -imgA.size.width, 0.0, 0.0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 20, -imgA.size.width - 6);
        }
        
        btn.selected = isCollection;
        
        [btn addTarget:self action:@selector(bottomViewEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottom addSubview:btn];
    }
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 0, WIDTH_SCREEN - 240, 40)];
    [buyBtn setTag:3013];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setBackgroundColor:[UIColor redColor]];
    buyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    buyBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    buyBtn.titleLabel.font = XNFont(20.0);
    [buyBtn addTarget:self action:@selector(bottomViewEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom addSubview:buyBtn];
    
}

- (void)popValue:(NSDictionary *)dataDict withNumber:(int)number{
    selectedSpecDict = [NSDictionary dictionaryWithDictionary:dataDict];
    addGoodsNumber = number;
    
    [self.goodsModel setPromotion_price:[dataDict valueForKey:@"price"]];
    
    [self.topView setGoodsModel:self.goodsModel];
    
    //[NSString stringWithFormat:@"%f",[[dataDict valueForKey:@"price"] doubleValue] * number];//获取规格后的价格
    
    self.middleView.showSelectedSpec.text = [NSString stringWithFormat:@"已选择 %@ 规格",[dataDict valueForKey:@"name"]];
    
    
}

- (void)popValue:(NSDictionary *)dataDict withNumber:(int)number withIndex:(NSIndexPath *)indexPath {
    
}

//底部按钮点击
//tag (3010 - 3013)
- (void)bottomViewEvent:(UIButton *)btn {
//    NSLog(@"底部按钮点击%li",(long)btn.tag);
    //主页面网络请求
    if (addGoodsNumber == 0) {
        addGoodsNumber = 1;
    }
    if (selectedSpecDict == nil && btn.tag != 3010) {
        [ZHProgressHUD showMessage:@"选择规格和数量" inView:self.view];
        return;
    }
    
    NSString *specID = [selectedSpecDict valueForKey:@"id"];
    NSString *buyNumber = [NSString stringWithFormat:@"%i",addGoodsNumber];
    
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:userModel.sign,@"sign",
                                self.goodsModel.goods_id,@"goods_id",
                                userModel.user_id,@"user_id",
                                specID,@"spec_id",
                                buyNumber,@"num", nil];
    
    NSDictionary *setCollection = [NSDictionary dictionaryWithObjectsAndKeys:userModel.sign,@"sign",
                                   self.goodsModel.goods_id,@"goods_id",
                                   userModel.user_id,@"user_id", nil];
    
    if (btn.tag == 3011 || btn.tag == 3012 || btn.tag == 3013) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate verifyLoginWithViewController:self];
        
    }
    
    switch (btn.tag) {
        case 3010:
            //跳转到店铺
            self.shopVC = [[NPYAutotrophy alloc] init];
            self.shopVC.isAutrophy = NO;
            self.shopVC.shopID = shopModel.shop_id;
            [self.navigationController pushViewController:self.shopVC animated:YES];
            break;
            
        case 3011:
            //收藏
            [self requestAddGoodsToCollectListUrl:CollectGoods_set_url withParemes:setCollection];
            btn.selected = !btn.selected;
        
            break;
            
        case 3012:
            //加入购物车
        [self requestAddGoodsToShoppingCarUrl:@"/index.php/app/Shopping/set" withParemes:requestDic];
            break;
            
        case 3013:
            //立即购买
            self.orderVC = [[NPYOrderViewController alloc] init];
            self.orderVC.goods_id = self.goodsModel.goods_id;
            self.orderVC.shop_id = shopModel.shop_id;
            self.orderVC.user_id = userModel.user_id;
            self.orderVC.sign = userModel.sign;
            self.orderVC.buyNumber = addGoodsNumber;
            self.orderVC.goodsSpe = selectedSpecDict;
            self.orderVC.goodsModel = self.goodsModel;
            self.orderVC.shopModel = shopModel;
            
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
    self.topView.goodsModel = self.goodsModel;
    
//    NSMutableArray *imgs = [NSMutableArray new];
//    for (NSString *urlStr in titleImgs) {
//        UIImageView *imgView = [UIImageView new];
//        [imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
//        [imgs addObject:imgView.image];
//    }

//    topView.images = @[@"commidity_upimage",@"one.jpg",@"two.jpg",@"three.jpg",@"four.jpg",@"five.jpg"];//设置顶部Collectionview的图片数据
    topView.images = titleImgs;
//    __weak UINavigationController* NaviController = self.navigationController;
//    self.topView.rightRefresh.block = ^{
//        BGGoodsDetailController* bggc = [[BGGoodsDetailController alloc] init];
//        [NaviController pushViewController:bggc animated:YES];
//    };
    topView.frame = CGRectMake(0,0, screenW, TopViewH);
    [firstPageView addSubview:topView];
    BuyMiddleView* middleView = [BuyMiddleView view];
    middleView.delegate = self;
    middleView.frame = CGRectMake(0,CGRectGetMaxY(topView.frame) + 6, screenW, MiddleViewH);
    
    self.middleView = middleView;
    self.middleView.shopModel = shopModel;
    self.middleView.goodsID = self.goodsModel.goods_id;
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
            scrollView.contentOffset = CGPointMake(0, 0);
            
        }else{
            self.NavBarView.backgroundColor = color(252,252,252, scrollView.contentOffset.y/(screenH-BottomH));
            [oneBtn setImage:[UIImage imageNamed:@"fanhui_goumai"] forState:UIControlStateNormal];
            [twoBtn setImage:[UIImage imageNamed:@"share_gouwu-"] forState:UIControlStateNormal];
            
        }
        if(scrollView.contentOffset.y == (screenH-BottomH)){
            scrollView.scrollEnabled = NO;
            
            [oneBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:UIControlStateNormal];
            [twoBtn setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
            
        }else if (scrollView.contentOffset.y == -NaviBarH && !scrollView.isDragging){
            [UIView animateWithDuration:0.3 animations:^{
                scrollView.contentOffset = CGPointMake(0, 0);
            }];
        }else;
    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //NSLog(@" -- %f",scrollView.contentOffset.y);
}

#pragma -- MyOrderTopTabBarDelegate(顶部标题栏delegate)
-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index{
//    NSLog(@"点击了 －－－ %ld",index);
    selectedTag = index;
    [self.detailTableview reloadData];
    
}
#pragma -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (selectedTag == 0) {
        return detailImgs.count;
        
    } else if (selectedTag == 1) {
        return 1;
        
    } else if (selectedTag == 2) {
        
        return appraiseArr.count;
        
    } else if (selectedTag == 3) {
        return 1;
        
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (selectedTag == 0) {
        self.oneCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYImageTextTableViewCell" owner:nil options:nil] firstObject];
        self.oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.oneCell.imgUrlStr = detailImgs[indexPath.row];
        
        return self.oneCell;
        
    } else if (selectedTag == 1) {
        self.twoCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYParameterTableViewCell" owner:nil options:nil] firstObject];
        self.twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.twoCell.imgUrlStr = self.goodsModel.parameter_img;
        return self.twoCell;
        
    } else if (selectedTag == 2) {
        self.threeCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYGoodsDetailTableViewCell" owner:nil options:nil] firstObject];
        self.threeCell.model = appraiseArr[indexPath.row];
        return self.threeCell;
        
    } else if (selectedTag == 3) {
        self.fourCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYRecommendTableViewCell" owner:nil options:nil] firstObject];
        self.fourCell.goodsID = self.goodsModel.goods_id;
        return self.fourCell;
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedTag == 0) {
        UIImageView *tm = [UIImageView new];
        [tm sd_setImageWithURL:[NSURL URLWithString:detailImgs[indexPath.row]] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
        cellHeight = tm.image.size.height / (tm.image.size.height / WIDTH_SCREEN == 0 ? 1 : tm.image.size.height / WIDTH_SCREEN);
        if (cellHeight == 0) {
//            [self.detailTableview reloadData];
        }
    }
    
    if (selectedTag == 1) {
        
        UIImageView *tm = [UIImageView new];
        [tm sd_setImageWithURL:[NSURL URLWithString:self.goodsModel.parameter_img]];
        cellHeight = tm.image.size.height / (tm.image.size.height / WIDTH_SCREEN == 0 ? 1 : tm.image.size.height / WIDTH_SCREEN);
        if (cellHeight == 0) {
            
        }

    }
    
    if (selectedTag == 2) {
        NPYAppraiseModel *mode = appraiseArr[indexPath.row];
        if (mode.reply.length != 0) {
            cellHeight = [self calculateStringSize:mode.reply withFontSize:12.0].height;
            
        } else {
            cellHeight = 0;
            
        }
        
        return 265 + cellHeight;
    }
    
    if (selectedTag == 3) {
        return self.detailTableview.frame.size.height;
    }
    
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (selectedTag == 2) {
        return 10;
    }
    return 0.1;
}

#pragma mark - 获取服务器数据
- (void)requestHomeDataWithUrlString:(NSString *)url withKeyValueParemes:(NSDictionary *)pareme {
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            NSDictionary *tpDict = dataDict[@"data"];
            
            self.goodsModel = [NPYHomeGoodsModel mj_objectWithKeyValues:tpDict[@"goods"]];
            shopModel = [NPYShopModel mj_objectWithKeyValues:tpDict[@"shop"]];
            sepcModel = [NPYGoodsSpecModel mj_objectWithKeyValues:tpDict[@"spec"]];
            
            titleImgs = [[NSMutableArray alloc] initWithArray:tpDict[@"title"]];
            detailImgs = [[NSMutableArray alloc] initWithArray:tpDict[@"details"]];
            
            if ([tpDict[@"user"] isEqualToString:@"true"]) {
                isCollection = YES;
                
            } else {
                isCollection = NO;
            }
            
            [self.topView removeFromSuperview];
            self.topView = nil;
            
            [self.middleView removeFromSuperview];
            self.middleView = nil;
            
            [self.bottomView removeFromSuperview];
            self.bottomView = nil;
            
            [self initView];
           
        } else {
            //失败
//            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestGoodsAppraiseDataWithUrlString:(NSString *)url withGoodsID:(NSDictionary *)pareme {
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            NSDictionary *tpDict = dataDict[@"data"];
            
            appraiseArr = [NSMutableArray new];
            for (NSDictionary *infoDict in tpDict[@"appraise"]) {
                NPYAppraiseModel *appraiseModel = [NPYAppraiseModel mj_objectWithKeyValues:infoDict];
                [appraiseArr addObject:appraiseModel];
                
            }
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestAddGoodsToShoppingCarUrl:(NSString *)url withParemes:(NSDictionary *)pareme {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            NSDictionary *tpDict = dataDict[@"data"];
            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        } else {
            //失败
//            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestAddGoodsToCollectListUrl:(NSString *)url withParemes:(NSDictionary *)pareme {
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

- (void)requestShareInfoWithUrlString:(NSString *)url withParames:(NSDictionary *)pareme {
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            //            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            NSDictionary *tpDict = dataDict[@"data"];
            
            shareInfo = [NSDictionary dictionaryWithObjectsAndKeys:[tpDict valueForKey:@"img"],@"img",[tpDict valueForKey:@"text"],@"text",[tpDict valueForKey:@"url"],@"url", nil];
            
        } else {
            //失败
            //            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)selectedSpecToPushViewWithGoodsID:(NSString *)goodsID {
//    [ZHProgressHUD showMessage:@"跳到规格选择页" inView:self.view];
    NPYSpecViewController *specVC = [[NPYSpecViewController alloc] initWithNibName:@"NPYSpecViewController" bundle:nil];
    specVC.goodsID = goodsID;
    specVC.goodsIconUrl = self.goodsModel.goods_img;
    specVC.sign = userModel.sign;
    specVC.userID = userModel.user_id;
    specVC.storNumber = self.goodsModel.inventory;
    specVC.delegate = self;
    specVC.view.backgroundColor = XNColor(0, 0, 0, 0.2);
    specVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:specVC animated:YES completion:nil];
    
}

- (void)pushViewToShopViewWithShopID:(NSString *)shopID {
    self.shopVC = [[NPYAutotrophy alloc] init];
    self.shopVC.isAutrophy = NO;
    self.shopVC.shopID = shopModel.shop_id;
    [self.navigationController pushViewController:self.shopVC animated:YES];
}

- (void)backItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NPYHomeGoodsModel *)goodsModel {
    if (_goodsModel == nil) {
        _goodsModel = [[NPYHomeGoodsModel alloc] init];
    }
    
    return _goodsModel;
}

- (void)shareButtonPressed:(UIButton *)sender {
    //分享
    [ShareObject shareDefault];
    
    if (shareInfo == nil) {
        return;
    }
    
    [[ShareObject shareDefault] sendMessageWithTitle:[shareInfo valueForKey:@"text"] withContent:[shareInfo valueForKey:@"text"] withUrl:[shareInfo valueForKey:@"url"] withImages:[NSArray arrayWithObjects:[shareInfo valueForKey:@"img"], nil] result:^(NSString *result, UIAlertViewStyle style) {
        [ZHProgressHUD showMessage:result inView:self.detailTableview];
    }];
}

- (CGSize)calculateStringSize:(NSString *)str withFontSize:(CGFloat)fontSize{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]};
    CGSize size=[str sizeWithAttributes:attrs];
    
    return size;
}

@end
