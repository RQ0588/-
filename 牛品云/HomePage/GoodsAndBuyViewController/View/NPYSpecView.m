//
//  NPYSpecView.m
//  牛品云
//
//  Created by Eric on 16/12/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYSpecView.h"

@interface NPYSpecView () {
    UIImageView *goodsIcon;
    UILabel *price_lab,*inventory_lab;
    
}

@end

@implementation NPYSpecView

- (id)initWithFrame:(CGRect)frame withGoodsInfo:(NPYHomeGoodsModel *)goodsModel withSpecInfos:(NSArray *)specInfos {
    if (self == [super initWithFrame:frame]) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_SCREEN / 2, WIDTH_SCREEN, HEIGHT_SCREEN / 2)];
        bgView.backgroundColor = XNColor(255, 255, 255, 1);
        [self addSubview:bgView];
        //
        goodsIcon = [[UIImageView alloc] init];
        goodsIcon.frame = CGRectMake(15, 15, 64, 64);
        [bgView addSubview:goodsIcon];
        //
        price_lab = [[UILabel alloc] init];
        price_lab.frame = CGRectMake(CGRectGetMaxX(goodsIcon.frame) + 15, CGRectGetMinY(goodsIcon.frame) + 10, 200, 20);
        price_lab.textColor = XNColor(250, 8, 8, 1);
        price_lab.font = XNFont(18.0);
        [bgView addSubview:price_lab];
        //
        inventory_lab = [[UILabel alloc] init];
        inventory_lab.frame = CGRectMake(CGRectGetMinX(price_lab.frame), CGRectGetMinY(price_lab.frame) + 12, 200, 20);
        inventory_lab.textColor = XNColor(51, 51, 51, 1);
        inventory_lab.font = XNFont(14.0);
        [bgView addSubview:inventory_lab];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(WIDTH_SCREEN - 35, 15, 20, 20);
        [backBtn setImage:[UIImage imageNamed:@"guife_cha"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:backBtn];
    }
    
    return self;
    
}

- (void)layoutSubviews {
    
}

- (void)backButtonPressed:(UIButton *)sender {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
