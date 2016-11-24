//
//  NPYFeatureStoreTVCell.m
//  牛品云
//
//  Created by Eric on 16/10/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYFeatureStoreTVCell.h"

@interface NPYFeatureStoreTVCell () {
    UIImageView *logIcon;
    UIButton *shopName,*rightIntoBtn,*product1,*product2,*product3;
    double width_LogIcon,width_ShopName,height_Space;
}

@end

@implementation NPYFeatureStoreTVCell

#pragma mark - Custom Function

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        NSLog(@"进入自定义cell...%@",self);
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        height_Space = 5.0;
        width_LogIcon = 30.0;
        width_ShopName = 100.0;
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [self customContent];
}

//内容界面的布局
- (void)customContent {
    //backgroundView
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - height_Space * 2)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backgroundView];
    //log
    logIcon = [[UIImageView alloc] init];
    logIcon.frame = CGRectMake(height_Space , height_Space, width_LogIcon, width_LogIcon);
    logIcon.image = [UIImage imageNamed:@"placeholder"];
    [self.contentView addSubview:logIcon];
    //name
    shopName = [[UIButton alloc] init];
    shopName.frame = CGRectMake(CGRectGetMaxX(logIcon.frame) + 5, height_Space, width_ShopName, width_LogIcon);
    [shopName setTitle:@"店铺名称" forState:0];
    [shopName setTitleColor:[UIColor blackColor] forState:0];
    [shopName setTag:300];
    [shopName addTarget:self action:@selector(detailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:shopName];
    //rightIntoButton
    rightIntoBtn = [[UIButton alloc] init];
    rightIntoBtn.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - width_ShopName - height_Space, height_Space, 60, 20);
    [rightIntoBtn setTitle:@"进入店铺" forState:0];
    [rightIntoBtn setTitleColor:[UIColor redColor] forState:0];
    [rightIntoBtn setTag:301];
    rightIntoBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    rightIntoBtn.layer.borderWidth = 1.0;
    rightIntoBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [rightIntoBtn addTarget:self action:@selector(detailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:rightIntoBtn];
    //product
    product1 = [[UIButton alloc] init];
    product1.frame = CGRectMake(height_Space / 2, CGRectGetMaxY(logIcon.frame) + height_Space, width_LogIcon + width_ShopName, CGRectGetMaxY(backgroundView.frame) - height_Space * 2 - CGRectGetMaxY(logIcon.frame) );
    [product1 setImage:[UIImage imageNamed:@"placeholder"] forState:0];
    [product1 setTag:302];
    [product1 addTarget:self action:@selector(detailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:product1];
    
    product2 = [[UIButton alloc] init];
    product2.frame = CGRectMake(CGRectGetMaxX(product1.frame) + height_Space, CGRectGetMaxY(logIcon.frame) + height_Space, CGRectGetWidth(backgroundView.frame) - CGRectGetMaxX(product1.frame) - height_Space * 2, (CGRectGetHeight(product1.frame) - height_Space) / 2);
    [product2 setImage:[UIImage imageNamed:@"placeholder"] forState:0];
    [product2 setTag:303];
    [product2 addTarget:self action:@selector(detailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:product2];
    
    product3 = [[UIButton alloc] init];
    product3.frame = CGRectMake(CGRectGetMaxX(product1.frame) + height_Space, CGRectGetMaxY(product2.frame) + height_Space, CGRectGetWidth(backgroundView.frame) - CGRectGetMaxX(product1.frame) - height_Space * 2, (CGRectGetHeight(product1.frame) - height_Space) / 2);
    [product3 setImage:[UIImage imageNamed:@"placeholder"] forState:0];
    [product3 setTag:304];
    [product3 addTarget:self action:@selector(detailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:product3];
    
}

#pragma mark - button pressed event
//300-店铺名称点击,301-进入店铺点击
//302-左侧商品图片点击,303-右上商品图片点击,304-右下商品图片点击
- (void)detailButtonPressed:(UIButton *)btn {
    NSLog(@"点击了%@,进入详情页...",btn.currentTitle);
    UIButton *tmpBtn = [self viewWithTag:300];
    if (self.delegate && [self.delegate respondsToSelector:@selector(passButtonTag:withButtonTitle:)]) {
        [self.delegate passButtonTag:btn.tag withButtonTitle:tmpBtn.currentTitle];
    }
    
}

#pragma mark - System

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
