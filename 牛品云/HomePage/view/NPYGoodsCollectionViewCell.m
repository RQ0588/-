//
//  NPYGoodsCollectionViewCell.m
//  牛品云
//
//  Created by Eric on 16/12/15.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYGoodsCollectionViewCell.h"
#import "NPYBaseConstant.h"

@interface NPYGoodsCollectionViewCell ()  {
    UIView *bgView;
    UIImageView *productImg;
    UILabel *titleL,*priceL,*evaluationL;
    NSMutableArray *dataArr;
}

@end

@implementation NPYGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (WIDTH_SCREEN - 15) / 2, self.frame.size.height)];
    bgView.layer.borderColor = XNColor(242, 242, 242, 1).CGColor;
    bgView.layer.borderWidth = 0.5;
    [self addSubview:bgView];
    //产品图片
    productImg = [[UIImageView alloc] init];
    productImg.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.width);
    [productImg sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goods_img] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
    productImg.contentMode = UIViewContentModeScaleToFill;
    [bgView addSubview:productImg];
    //标题
    titleL = [[UILabel alloc] init];
    titleL.frame = CGRectMake(CGRectGetMinX(productImg.frame) + Height_Space, CGRectGetMaxY(productImg.frame), CGRectGetWidth(productImg.frame) - Height_Space, 20);
    titleL.textColor = XNColor(85, 85, 85, 1);
    titleL.text = _goodsModel.goods_name;
    titleL.numberOfLines = 0;
    titleL.adjustsFontSizeToFitWidth = YES;
    titleL.font = [UIFont systemFontOfSize:10.0];
    [self addSubview:titleL];
    //价格
    priceL = [[UILabel alloc] init];
    priceL.frame = CGRectMake(CGRectGetMinX(titleL.frame), CGRectGetMaxY(titleL.frame) + Height_Space, CGRectGetWidth(productImg.frame) / 2, 20);
    priceL.textColor = XNColor(251, 8, 8, 1);
    priceL.text = _goodsModel.goods_price;
    priceL.numberOfLines = 0;
    priceL.adjustsFontSizeToFitWidth = YES;
    priceL.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:priceL];
    //评价
    evaluationL = [[UILabel alloc] init];
    evaluationL.frame = CGRectMake(CGRectGetMaxX(priceL.frame), CGRectGetMaxY(titleL.frame) + Height_Space, CGRectGetWidth(productImg.frame) / 2, 20);
    evaluationL.textColor = XNColor(136, 136, 136, 1);
    evaluationL.text = [NSString stringWithFormat:@"%@人购买",_goodsModel.sold];
    evaluationL.numberOfLines = 0;
    evaluationL.adjustsFontSizeToFitWidth = YES;
    evaluationL.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:evaluationL];
}

@end
