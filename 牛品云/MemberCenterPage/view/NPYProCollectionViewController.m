//
//  NPYProCollectionViewController.m
//  牛品云
//
//  Created by Eric on 16/12/20.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYProCollectionViewController.h"
#import "NPYBaseConstant.h"
#import "NPYHomeGoodsModel.h"
#import "BuyViewController.h"
#import "NPYGoodsCollectionViewCell.h"
#import "NPYLoginMode.h"

@interface NPYProCollectionViewController () <UICollectionViewDataSource,UICollectionViewDelegate> {
    NSArray *goodsArr;
    
    UICollectionReusableView *headerView;
    UIView *bgView;
    UIImageView *productImg;
    UILabel *titleL,*priceL,*evaluationL;
}

@property (nonatomic, strong) UICollectionView *recommendView;

@property (nonatomic, strong) BuyViewController *goodsView;

@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end

@implementation NPYProCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商品收藏";
    self.view.backgroundColor = GRAY_BG;
    
    _cellDic = [NSMutableDictionary new];
    
//#pragma mark - 
//    NPYHomeGoodsModel *model = [[NPYHomeGoodsModel alloc] init];
//    model.goods_name = @"大米";
//    model.goods_id = @"1";
//    model.goods_img = @"";
//    model.sold = @"38.80";
//    goodsArr = [NSArray arrayWithObjects:model,model, nil];
//    
//#pragma mark -
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    [self recommendedViewLoad];
    
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"sign"],@"sign",@"1",@"num",model.user_id,@"user_id", nil];
    [self requestDataWithUrlString:CollectGoods_url withKeyValueParemes:requestDic];
    
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
    UICollectionView *recommendView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN) collectionViewLayout:layout];
    //代理设置
    recommendView.delegate = self;
    recommendView.dataSource = self;
    recommendView.backgroundColor = [UIColor whiteColor];
    recommendView.showsVerticalScrollIndicator = NO;
    recommendView.scrollEnabled = NO;
    //注册item类型 这里使用系统的类型
    [recommendView registerClass:[NPYGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [recommendView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
    [self.view addSubview:recommendView];
    self.recommendView = recommendView;
//    oldFrame = recommendView.frame;
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
//    NPYGoodsCollectionViewCell *goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
//    
//    goodsCell.goodsModel = goodsModel;
    
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"点击了精品推荐的第%li物品",(long)indexPath.row);
    self.goodsView = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
    [self.navigationController pushViewController:self.goodsView animated:YES];
    
}

- (void)requestDataWithUrlString:(NSString *)url withKeyValueParemes:(NSDictionary *)pareme {
    if (pareme == nil) {
        return;
    }
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            NPYHomeModel *model = [[NPYHomeModel alloc] init];
            model.goodsArr = dataDict[@"data"];
            [model toDetailModel];
            goodsArr = [model returnGoodsModelArray];
            
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
        }
        
        [self.recommendView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
