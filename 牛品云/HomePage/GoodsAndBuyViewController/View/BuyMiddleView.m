//
//  BuyMiddleView.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/21.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BuyMiddleView.h"

@interface BuyMiddleView()

- (IBAction)selectBtnPressed:(id)sender;
- (IBAction)allBtnPressed:(id)sender;
- (IBAction)intoShopBtnPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *goodImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumber;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *intoShopBtn;

@end

@implementation BuyMiddleView

+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BuyMiddleView" owner:nil options:nil] firstObject];
}

- (void)setGoodImg:(UIImageView *)goodImg {
    _goodImg = goodImg;
    _goodImg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _goodImg.layer.borderWidth = 0.5;
    _goodImg.layer.masksToBounds = YES;
}

- (IBAction)selectBtnPressed:(id)sender {
    NSLog(@"选择规格...");
    
}

- (IBAction)allBtnPressed:(id)sender {
    NSLog(@"查看全部分类");
}

- (IBAction)intoShopBtnPressed:(id)sender {
    NSLog(@"进入店铺");
    
}
@end
