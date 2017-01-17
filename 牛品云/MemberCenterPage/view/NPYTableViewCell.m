//
//  NPYTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/11/22.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYTableViewCell.h"
#import "NPYBaseConstant.h"

@implementation NPYTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NPYMyOrderModel *)model {
    _model = model;
    
    [self.shopIcon sd_setImageWithURL:[NSURL URLWithString:self.model.shop_img] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
    
    self.shopName.text = self.model.shop_name;
    
    self.orderState.text = [self orderStateString][0];
    
    self.buyNumber.text = [NSString stringWithFormat:@"共%@件商品",self.model.num];
    
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:self.model.goods_img] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
    
    self.goodsName.text = self.model.goods_name;
    
    self.goddsPrice.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%@",self.model.price] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
    
    [self.delOrderBtn setTitle:[self orderStateString][1] forState:UIControlStateNormal];
    [self.buyBtn setTitle:[self orderStateString][2] forState:UIControlStateNormal];
    
    if (_isManyOrder) {
        self.delOrderBtn.hidden = YES;
        self.buyBtn.hidden = YES;
    }
    
}

- (NSArray *)orderStateString {
    NSArray *StringArr = [NSArray new];
    NSString *str = @"";
    NSString *btnTitle = @"";
    NSString *btnTitle2 = @"";
    
//    NSLog(@"%@-%@",self.model.order_id,self.model.type);
    
    switch ([self.model.type intValue]) {
        case 0:
            str = @"待付款";
            btnTitle = @"删除订单";
            btnTitle2 = @"立即付款";
            
            break;
            
        case 1:
            str = @"发货中";
            btnTitle = @"售后/退款";
            btnTitle2 = @"确认收货";
            
            if (_isManyOrder) {
                str = @"已付款";
            }
            
            break;
            
        case 2:
            str = @"已发货";
            btnTitle = @"售后/退款";
            btnTitle2 = @"确认收货";
            break;
            
        case 3:
            str = @"待评价";
            btnTitle = @"售后/退款";
            btnTitle2 = @"立即评价";
            break;
            
        case 4:
            str = @"已完成";
//            btnTitle = @"售后/退款";
            self.delOrderBtn.hidden = YES;
            btnTitle2 = @"已完成";
            break;
            
        case 5:
            str = @"售后";
            self.delOrderBtn.hidden = YES;
            btnTitle2 = @"售后中";
            break;
            
        case -1:
            str = @"已取消";
            self.delOrderBtn.hidden = YES;
            self.buyBtn.hidden = YES;
            break;
            
        default:
            break;
    }
    
    StringArr = @[str,btnTitle,btnTitle2];
    
    return StringArr;
}

- (IBAction)oneButton:(id)sender {
//    NSLog(@"左侧的按钮");
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellButtonEventWithType:withIndexPath:)]) {
        [self.delegate cellLeftButtonEventWithType:[self.model.type intValue] withIndexPath:self.cellPath];
        
    }
}

- (IBAction)twoButton:(id)sender {
//    NSLog(@"右侧按钮");
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellButtonEventWithType:withIndexPath:)]) {
        [self.delegate cellButtonEventWithType:[self.model.type intValue] withIndexPath:self.cellPath];
        
    }
}

- (NSMutableAttributedString *)attributedStringWithSegmentationString:(NSString *)segStr withOriginalString:(NSString *)orStr withOneColor:(UIColor *)oneColor withTwoColor:(UIColor *)twoColor withOneFontSize:(CGFloat)oneSize twoFontSize:(CGFloat)twoSize {
    NSString *tmp = [orStr componentsSeparatedByString:segStr][0];
    NSMutableAttributedString *mTmp = [[NSMutableAttributedString alloc] initWithString:orStr];
    NSUInteger length = tmp.length;
    if (length == 0) {
        length = 1;
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:oneSize] range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:twoSize] range:NSMakeRange(length, orStr.length - 1)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:oneColor range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:twoColor range:NSMakeRange(length, orStr.length - 1)];
        
    } else {
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:oneSize] range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:twoSize] range:NSMakeRange(length + 1, orStr.length - length - 1)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:oneColor range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:twoColor range:NSMakeRange(length + 1, orStr.length - length - 1)];
        
    }
    
    return mTmp;
}

@end
