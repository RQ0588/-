//
//  NPYRecommendTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/12/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYRecommendTableViewCell.h"
#import "NPYBaseConstant.h"
#import "NPYHomeModel.h"
#import "NPYHomeADModel.h"
#import "NPYHomeGoodsModel.h"
#import "NPYGoodsCollectionViewCell.h"

#define RecommendUrl @"/index.php/app/Getgoods/get_recommend"

@interface NPYRecommendTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource> {
    CGFloat itemHeight;         //每个item的高度
    CGRect oldFrame;            //记录滚动前的位置
    
    UIView *bgView;
    UIImageView *productImg;
    UILabel *titleL,*priceL,*evaluationL;
    
    NSArray *goodsArr;
}
@property (weak, nonatomic) IBOutlet UICollectionView *itemCell;

@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end

@implementation NPYRecommendTableViewCell


- (void)recommendedViewLoad {
    itemHeight = 180;
    //创建一个layout布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake((WIDTH_SCREEN - 15 ) / 2, (WIDTH_SCREEN - 15 ) / 2 + 50);
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 5.0;
    //设置header
    [layout setHeaderReferenceSize:CGSizeMake(WIDTH_SCREEN, 10)];
    //
    self.itemCell.collectionViewLayout = layout;
    //代理设置
    self.itemCell.delegate = self;
    self.itemCell.dataSource = self;
    self.itemCell.backgroundColor = [UIColor whiteColor];
    self.itemCell.showsVerticalScrollIndicator = NO;
    self.itemCell.scrollEnabled = YES;
    //注册item类型 这里使用系统的类型
    [self.itemCell registerClass:[NPYGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.itemCell registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
    
    oldFrame = self.itemCell.frame;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return goodsArr.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NPYGoodsCollectionViewCell *goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
//    NPYHomeGoodsModel *goodsModel = goodsArr[indexPath.row];
//    goodsCell.goodsModel = goodsModel;
    
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"DayCell", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.itemCell registerClass:[NPYGoodsCollectionViewCell class]  forCellWithReuseIdentifier:identifier];
    }
    
    NPYGoodsCollectionViewCell *goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];;
    NPYHomeGoodsModel *goodsModel = goodsArr[indexPath.row];
    goodsCell.goodsModel = goodsModel;
    
    return goodsCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了精品推荐的第%li物品",(long)indexPath.row);
    
}

- (void)moreButtonPressed:(UIButton *)btn {
    NSLog(@"显示更多牛品推荐...");
}

#pragma mark - 网络请求

- (void)requestGoodsAppraiseDataWithUrlString:(NSString *)url withGoodsID:(NSDictionary *)pareme {
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"请求成功" inView:self.superview];
            NPYHomeModel *model = [[NPYHomeModel alloc] init];
            model.goodsArr = dataDict[@"data"];
            [model toDetailModel];
            
            goodsArr = [model returnGoodsModelArray];
            
            [self.itemCell reloadData];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.superview];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _cellDic = [NSMutableDictionary new];
    
    [self recommendedViewLoad];
    
}

- (void)layoutSubviews {
    //评论页网络请求
    NSDictionary *appraiseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"npy_we874646sf",@"key",self.goodsID,@"goods_id", nil];
    [self requestGoodsAppraiseDataWithUrlString:RecommendUrl withGoodsID:appraiseDic];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
