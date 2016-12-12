//
//  NPYGoodsListViewController.m
//  牛品云
//
//  Created by Eric on 16/12/12.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYGoodsListViewController.h"
#import "NPYBaseConstant.h"
#import "BuyViewController.h"
#import "NPYHomeModel.h"
#import "NPYHomeADModel.h"
#import "NPYHomeGoodsModel.h"

@interface NPYGoodsListViewController () <UICollectionViewDelegate,UICollectionViewDataSource> {
    NSArray *adArr,*goodsArr;
}

@property (nonatomic, strong) UICollectionView *recommendView;

@property (nonatomic, strong) BuyViewController *goodsView;

@end

@implementation NPYGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = GRAY_BG;
    
//    self.navigationItem.title = @"";
    
    [self recommendedViewLoad];
    
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
    UICollectionView *recommendView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 1, WIDTH_SCREEN, HEIGHT_SCREEN) collectionViewLayout:layout];
    //代理设置
    recommendView.delegate = self;
    recommendView.dataSource = self;
    recommendView.backgroundColor = [UIColor whiteColor];
    recommendView.showsVerticalScrollIndicator = NO;
    recommendView.scrollEnabled = NO;
    //注册item类型 这里使用系统的类型
    [recommendView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
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
        
//        UIButton *moreBtn = [[UIButton alloc] init];
//        moreBtn.frame = CGRectMake(WIDTH_SCREEN - 60, 0, 50, 30);
//        moreBtn.center = CGPointMake(CGRectGetMidX(moreBtn.frame), CGRectGetMidY(titleName.frame));
//        [moreBtn setTitle:@"更多 >" forState:UIControlStateNormal];
//        [moreBtn setTitleColor:XNColor(240, 84, 84, 1) forState:UIControlStateNormal];
//        moreBtn.titleLabel.font = [UIFont systemFontOfSize:11];
//        [moreBtn addTarget:self action:@selector(moreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:moreBtn];
    }
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"点击了精品推荐的第%li物品",(long)indexPath.row);
    self.goodsView = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
    [self.navigationController pushViewController:self.goodsView animated:YES];
    
}

- (void)viewDidLayoutSubviews {
//    CGRect fram = CGRectMake(self.recommendView.frame.origin.x, self.recommendView.frame.origin.y, self.recommendView.frame.size.width, self.recommendView.contentSize.height);
//    self.recommendView.frame = fram;
//    
//    self.mainScrollView.contentSize = CGSizeMake(0, self.mainScrollView.frame.size.height + self.recommendView.contentSize.height - oldFrame.size.height);
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.tag == 100010) {
//        //获取当前视图的宽度
//        CGFloat pageWith = scrollView.frame.size.width;
//        //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
//        int page = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;
//        self.scrollPage.currentPage = page;
//    }
//    
//    if (scrollView.tag == 100011) {
//        
//        if (self.mainScrollView.contentOffset.y > -60 && self.mainScrollView.contentOffset.y != 0) {
//            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
//            
//            [topLeftBtn setTitleColor:XNColor(132, 134, 145, 1) forState:UIControlStateNormal];
//            [topLeftBtn setImage:[UIImage imageNamed:@"saomiao_hui"] forState:UIControlStateNormal];
//            [topRightBtn setTitleColor:XNColor(132, 134, 145, 1) forState:UIControlStateNormal];
//            [topRightBtn setImage:[UIImage imageNamed:@"xiaoxi_hui"] forState:UIControlStateNormal];
//            
//        } else if ((self.mainScrollView.contentOffset.y >= -3 && self.mainScrollView.contentOffset.y <= 3) || (self.mainScrollView.contentOffset.y >= -67 && self.mainScrollView.contentOffset.y <= -61)) {
//            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//            
//            [topLeftBtn setTitleColor:XNColor(255, 255, 255, 1) forState:UIControlStateNormal];
//            [topLeftBtn setImage:[UIImage imageNamed:@"saomiao_icon"] forState:UIControlStateNormal];
//            [topRightBtn setTitleColor:XNColor(255, 255, 255, 1) forState:UIControlStateNormal];
//            [topRightBtn setImage:[UIImage imageNamed:@"xiaoxi_icon"] forState:UIControlStateNormal];
//        }
//        
//        CGRect fram = CGRectMake(self.recommendView.frame.origin.x, self.recommendView.frame.origin.y, self.recommendView.frame.size.width, self.recommendView.contentSize.height);
//        self.recommendView.frame = fram;
//        
//        self.mainScrollView.contentSize = CGSizeMake(0, self.mainScrollView.frame.size.height + self.recommendView.contentSize.height - oldFrame.size.height - 49);
//        
//    }
//    
//}

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
