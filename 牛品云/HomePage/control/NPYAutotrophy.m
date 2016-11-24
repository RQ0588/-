//
//  NPYAutotrophy.m
//  牛品云
//
//  Created by Eric on 16/10/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYAutotrophy.h"
#import "NPYBaseConstant.h"

@interface NPYAutotrophy () <UICollectionViewDelegate,UICollectionViewDataSource> {
    double height_Space;        //间隔高度
    NSInteger number_Tag;       //记录选中按钮的tag值
    double height_ScrollView;   //底部滚动视图的大小
    CGRect oldFrame;            //记录滚动前的位置
    BOOL isMove;                //滑动上移
}

@property (nonatomic, strong) UIView *topTitleView;
@property (nonatomic, strong) UIView *midMenuView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *advertView;
@property (nonatomic, strong) UICollectionView *recommendView;

@property (nonatomic, strong) NPYMessageViewController  *msgVC;

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
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:245/255.0 alpha:1.0]; //灰色背景
    
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
    
//    self.navigationItem.title = @"牛品自营";
//    self.navigationController.navigationBar.translucent = NO;
    
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:20.0]};
//    
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"placeholder"] forBarMetrics:UIBarMetricsDefault];
//    
//    self.navigationController.navigationBar.shadowImage =[UIImage imageNamed:@"palceholder"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    //中间搜索框
    UITextField *searcherTF = [[UITextField alloc] init];
    searcherTF.frame = CGRectMake(0, 0, WIDTH_SCREEN - 200, 20);
    searcherTF.center = CGPointMake(CGRectGetMidX(self.navigationController.navigationBar.frame), CGRectGetMidY(self.navigationController.navigationBar.frame));
    searcherTF.borderStyle = UITextBorderStyleRoundedRect;
    searcherTF.placeholder = @"点击搜索牛品";
    [searcherTF setClearButtonMode:UITextFieldViewModeAlways];
    self.navigationItem.titleView = searcherTF;
    // 添加图标“放大镜“
    UIImageView *searchBarIconView = [[UIImageView alloc] init];
    searchBarIconView.frame = CGRectMake(0, 0, 20, 20);
    UIImage *searcheIcon = [UIImage imageNamed:@"placeholder"];
    searchBarIconView.image = searcheIcon;
    searcherTF.leftView = searchBarIconView;
    
    //右侧消息按钮
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 50, 20)];
    [rightMesg setTitle:@"信息" forState:0];
    [rightMesg setTitleColor:[UIColor grayColor] forState:0];
    [rightMesg addTarget:self action:@selector(rightMessageButtonPressed:) forControlEvents:7];
    
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
    topTitleView.frame = CGRectMake(0, 64, WIDTH_SCREEN, 60);
    topTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topTitleView];
    self.topTitleView = topTitleView;
    //icon
    UIImageView *shopIcon = [[UIImageView alloc] init];
    shopIcon.frame = CGRectMake(height_Space, 0, 40, 40);
    shopIcon.center = CGPointMake(CGRectGetMidX(shopIcon.frame), topTitleView.frame.size.height / 2);
    shopIcon.image = [UIImage imageNamed:@"placeholder"];
    [topTitleView addSubview:shopIcon];
    //titleName
    UILabel *nameL = [[UILabel alloc] init];
    nameL.frame = CGRectMake(CGRectGetMaxX(shopIcon.frame) + height_Space * 2, CGRectGetMinY(shopIcon.frame), WIDTH_SCREEN / 2, 20);
    nameL.text = @"牛品自营";
    nameL.textColor = [UIColor blackColor];
    nameL.font = [UIFont systemFontOfSize:15.0];
    [topTitleView addSubview:nameL];
    //address
    UILabel *addressL = [[UILabel alloc] init];
    addressL.frame = CGRectMake(CGRectGetMinX(nameL.frame), CGRectGetMaxY(nameL.frame) + height_Space, WIDTH_SCREEN / 2, 20);
    addressL.text = @"苏州高新区科技城致远大厦";
    addressL.textColor = [UIColor grayColor];
    addressL.font = [UIFont systemFontOfSize:11.0];
    [topTitleView addSubview:addressL];
    //collect
    UIButton *collectBtn = [[UIButton alloc] init];
    collectBtn.frame = CGRectMake(WIDTH_SCREEN - 40 - height_Space, CGRectGetMinY(shopIcon.frame), 40, 40);
    [collectBtn setTag:1001];
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    [collectBtn setImage:placeHolder forState:UIControlStateNormal];
    [collectBtn setImage:placeHolder forState:UIControlStateSelected];
    [collectBtn setTitle:@"收藏" forState:0];
    [collectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
//    collectBtn.backgroundColor = [UIColor yellowColor];
    collectBtn.selected = NO;
    collectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    collectBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -placeHolder.size.width, 0.0, 0.0);
    collectBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 20, -collectBtn.titleLabel.frame.size.width);
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
    for (int i = 0; i < 4; i++) {
        UIButton *menuBtn = [[UIButton alloc] init];
        menuBtn.frame = CGRectMake(i * WIDTH_SCREEN / 4, 0, WIDTH_SCREEN / 4, CGRectGetHeight(midMenuView.frame));
        [menuBtn setTag:2000 + i];
        [menuBtn setTitle:nameBtn[i] forState:UIControlStateNormal];
        [menuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [menuBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
        [menuBtn setImage:placeHolder forState:UIControlStateNormal];
        [menuBtn setImage:placeHolder forState:UIControlStateSelected];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
        menuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        menuBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -placeHolder.size.width, 0.0, 0.0);
        menuBtn.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 30, -menuBtn.titleLabel.frame.size.width + 10);
        
        UIImageView *selectedImgView = [[UIImageView alloc] init];
        selectedImgView.image = [UIImage imageNamed:@"testLine"];
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
    UIView *bottomScorllView = [[UIView alloc] init];
    bottomScorllView.frame = CGRectMake(0, CGRectGetMaxY(self.midMenuView.frame) + height_Space, WIDTH_SCREEN, CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(self.midMenuView.frame) - height_Space);
    [self.view addSubview:bottomScorllView];
    self.bottomView = bottomScorllView;
    //advert（广告位）
    UIView *advertView = [[UIView alloc] init];
    advertView.frame = CGRectMake(0, 0, WIDTH_SCREEN, 150);
    advertView.backgroundColor = [UIColor whiteColor];
    [bottomScorllView addSubview:advertView];
    self.advertView = advertView;
    //topAD
    UIButton *oneImg = [[UIButton alloc] init];
    oneImg.tag = 2010;
    oneImg.frame = CGRectMake(0, 0, CGRectGetWidth(advertView.frame), CGRectGetHeight(advertView.frame) / 2);
    UIImage *imgOne = [UIImage imageNamed:@"placeholder"];
    [oneImg setImage:imgOne forState:UIControlStateNormal];
    [oneImg setImageEdgeInsets:UIEdgeInsetsMake(height_Space / 2, height_Space, height_Space / 2, height_Space)];
    [oneImg addTarget:self action:@selector(adButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [advertView addSubview:oneImg];
    //twoAD
    UIButton *twoImg = [[UIButton alloc] init];
    twoImg.tag = 2020;
    twoImg.frame = CGRectMake(0, CGRectGetMaxY(oneImg.frame), CGRectGetWidth(advertView.frame), CGRectGetHeight(advertView.frame) / 2);
    UIImage *imgTwo = [UIImage imageNamed:@"placeholder"];
    [twoImg setImage:imgTwo forState:UIControlStateNormal];
    [twoImg setImageEdgeInsets:UIEdgeInsetsMake(height_Space / 2, height_Space, height_Space / 2, height_Space)];
    [twoImg addTarget:self action:@selector(adButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [advertView addSubview:twoImg];
    
    //recommend（精品推荐）
    //创建一个layout布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(WIDTH_SCREEN / 2, 150);
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 2.0;
    //设置header
    [layout setHeaderReferenceSize:CGSizeMake(WIDTH_SCREEN, 30)];
    //
    UICollectionView *recommendView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(advertView.frame) + height_Space, WIDTH_SCREEN, CGRectGetHeight(bottomScorllView.frame) - CGRectGetHeight(advertView.frame) - height_Space - 1) collectionViewLayout:layout];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor blueColor];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(height_Space / 2, 0, cell.frame.size.width - 3/2*height_Space, cell.frame.size.height)];
    bgView.layer.borderColor = GRAY_BG.CGColor;
    bgView.layer.borderWidth = 1.0;
    [cell addSubview:bgView];
    //产品图片
    UIImageView *productImg = [[UIImageView alloc] init];
    productImg.frame = CGRectMake(0, 0, bgView.frame.size.width, 100);
    productImg.image = [UIImage imageNamed:@"placeholder"];
    [bgView addSubview:productImg];
    //标题
    UILabel *titleL = [[UILabel alloc] init];
    titleL.frame = CGRectMake(CGRectGetMinX(productImg.frame) + height_Space, CGRectGetMaxY(productImg.frame), CGRectGetWidth(productImg.frame) - height_Space, 20);
    titleL.textColor = [UIColor grayColor];
    titleL.text = @"正宗黑龙江五常东北有机稻花香大米非转基因高端大米 1kg";
    titleL.numberOfLines = 0;
    titleL.adjustsFontSizeToFitWidth = YES;
    titleL.font = [UIFont systemFontOfSize:10.0];
    [cell addSubview:titleL];
    //价格
    UILabel *priceL = [[UILabel alloc] init];
    priceL.frame = CGRectMake(CGRectGetMinX(titleL.frame), CGRectGetMaxY(titleL.frame), CGRectGetWidth(productImg.frame) / 2, 20);
    priceL.textColor = [UIColor redColor];
    priceL.text = @"￥45.60";
    priceL.numberOfLines = 0;
    priceL.adjustsFontSizeToFitWidth = YES;
    priceL.font = [UIFont systemFontOfSize:17.0];
    [cell addSubview:priceL];
    //评价
    UILabel *evaluationL = [[UILabel alloc] init];
    evaluationL.frame = CGRectMake(CGRectGetMaxX(priceL.frame), CGRectGetMaxY(titleL.frame), CGRectGetWidth(productImg.frame) / 2, 20);
    evaluationL.textColor = [UIColor grayColor];
    evaluationL.text = @"326人已付款";
    evaluationL.numberOfLines = 0;
    evaluationL.adjustsFontSizeToFitWidth = YES;
    evaluationL.font = [UIFont systemFontOfSize:15.0];
    [cell addSubview:evaluationL];

    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView;
    if (kind == UICollectionElementKindSectionHeader) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerIdentifier" forIndexPath:indexPath];
        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(height_Space * 2, 0, 100, 30)];
        titleName.text = @"精品推荐";
        titleName.textAlignment = NSTextAlignmentLeft;
        titleName.textColor = [UIColor grayColor];
        titleName.font = [UIFont systemFontOfSize:12.0];
        [headerView addSubview:titleName];
    }
    return headerView;
}
//点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了精品推荐的第%li物品",(long)indexPath.row);
    
}
//滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
//    NSLog(@"%f,%f",point.x,point.y);
    if (isMove && point.y > 0) {
        self.recommendView.frame = CGRectMake(0, 0, CGRectGetWidth(self.recommendView.frame), CGRectGetHeight(self.recommendView.frame) + CGRectGetHeight(self.advertView.frame) + height_Space + 1);
        isMove = NO;
    }
    
    if (point.y < 0 && isMove == NO) {
        isMove = YES;
        self.recommendView.frame = CGRectMake(0, CGRectGetMaxY(self.advertView.frame) + height_Space, WIDTH_SCREEN, CGRectGetHeight(self.recommendView.frame) - CGRectGetHeight(self.advertView.frame) - height_Space - 1);
    }
    
}

#pragma mark - Button Pressed Event

//导航栏右侧的消息按钮事件
- (void)rightMessageButtonPressed:(UIButton *)btn {
//    NSLog(@"消息按钮点击了...");
    self.msgVC = [[NPYMessageViewController alloc] init];
    [self.navigationController pushViewController:self.msgVC animated:YES];
    
}
//收藏按钮的点击事件
- (void)collectButtonPressed:(UIButton *)btn {
//    NSLog(@"收藏按钮点击了...");
    
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
