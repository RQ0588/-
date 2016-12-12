//
//  NPYRecommendTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/12/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYRecommendTableViewCell.h"
#import "NPYBaseConstant.h"

@interface NPYRecommendTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource> {
    CGFloat itemHeight;         //每个item的高度
    CGRect oldFrame;            //记录滚动前的位置
}
@property (weak, nonatomic) IBOutlet UICollectionView *itemCell;

@end

@implementation NPYRecommendTableViewCell


- (void)recommendedViewLoad {
    itemHeight = 180;
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
    self.itemCell.collectionViewLayout = layout;
    //代理设置
    self.itemCell.delegate = self;
    self.itemCell.dataSource = self;
    self.itemCell.backgroundColor = [UIColor whiteColor];
    self.itemCell.showsVerticalScrollIndicator = NO;
    self.itemCell.scrollEnabled = YES;
    //注册item类型 这里使用系统的类型
    [self.itemCell registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.itemCell registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
    
    oldFrame = self.itemCell.frame;
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
    //    self.goodsView = [[NPYGoodsDetailViewController alloc] init];
//    self.goodsView = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
//    [self.navigationController pushViewController:self.goodsView animated:YES];
    
}

- (void)moreButtonPressed:(UIButton *)btn {
    NSLog(@"显示更多牛品推荐...");
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self recommendedViewLoad];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
