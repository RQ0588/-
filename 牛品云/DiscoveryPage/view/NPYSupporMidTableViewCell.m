//
//  NPYSupporMidTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/12/6.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYSupporMidTableViewCell.h"
#import "NPYBaseConstant.h"

@implementation NPYSupporMidTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    self.priceL.text = [NSString stringWithFormat:@"￥%@",self.model.money];
    
    self.detailL.text = self.model.explain;
    
//    self.buyNumberL.text = self.model.number;
    
    self.countValue = [self.model.number intValue];
    
    int perNumber = [self.model.money intValue] == 0 ? [self.model.target_number_repay intValue] : [self.model.target_number_repay intValue] / [self.model.money intValue];
    
    int sportNumber = [self.model.money intValue] == 0 ? [self.model.yes intValue] : [self.model.yes intValue] / [self.model.money intValue];
    
//    self.number.text = [NSString stringWithFormat:@"%i位支持者（剩余%i份）",sportNumber,(perNumber - sportNumber)];
    
    self.totalBuyNumberL.text = [NSString stringWithFormat:@"共%i件商品",self.countValue];
    
    self.totalPriceL.text =[NSString stringWithFormat:@"￥%.2f",[self.model.money doubleValue] * self.countValue];
    
    self.surplusValue = perNumber - sportNumber;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(passTotalPriceToSuperView:withBuyNumber:)]) {
        [self.delegate passTotalPriceToSuperView:self.totalPriceL.text withBuyNumber:self.countValue];
    }
}

- (IBAction)cutButtonPressed:(id)sender {
    self.countValue --;
    if (self.countValue <= 0) {
        self.countValue = 0;
        
    }
    self.buyNumberL.text = [NSString stringWithFormat:@"%i",self.countValue];
    self.totalBuyNumberL.text = [NSString stringWithFormat:@"共%i件商品",self.countValue];
    self.totalPriceL.text =[NSString stringWithFormat:@"￥%.2f",[self.model.money doubleValue] * self.countValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(passTotalPriceToSuperView:withBuyNumber:)]) {
        [self.delegate passTotalPriceToSuperView:self.totalPriceL.text withBuyNumber:self.countValue];
    }
    
}
- (IBAction)addButtonPressed:(id)sender {
//    self.surplusValue = 5;  //模拟数据
    self.countValue = [self.buyNumberL.text intValue];
    self.countValue ++;
    if (self.countValue > self.surplusValue) {
        self.countValue = self.surplusValue;
        [ZHProgressHUD showMessage:@"不能超过剩余的份数" inView:self];
    }
    self.buyNumberL.text = [NSString stringWithFormat:@"%i",self.countValue];
    self.totalBuyNumberL.text = [NSString stringWithFormat:@"共%i件商品",self.countValue];
    self.totalPriceL.text =[NSString stringWithFormat:@"￥%.2f",[self.model.money doubleValue] * self.countValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(passTotalPriceToSuperView:withBuyNumber:)]) {
        [self.delegate passTotalPriceToSuperView:self.totalPriceL.text withBuyNumber:self.countValue];
    }
}
    
@end
