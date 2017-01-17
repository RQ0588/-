//
//  NPYTicketTableViewCell.m
//  牛品云
//
//  Created by Eric on 17/1/6.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "NPYTicketTableViewCell.h"

@implementation NPYTicketTableViewCell

- (void)setTicketModel:(NPYTicketModel *)ticketModel {
    _ticketModel = ticketModel;
    
    self.shopName.text = ticketModel.text;
    
    self.priceL.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%@",ticketModel.reduce] withOneColor:XNColor(251, 36, 31, 1) withTwoColor:XNColor(251, 36, 31, 1) withOneFontSize:15.0 twoFontSize:35.0];
    
    self.detailTextLabel.text = 
    
    self.endTimeL.text = [NSString stringWithFormat:@"截止日期：%@",[self calutTimeFromeTime:ticketModel.end_time withType:1]];
}

- (NSString *)calutTimeFromeTime:(NSString *)timeStr withType:(int)type {
    NSString *stringTime = @"";
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (type == 1) {
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        
    } else {
        [dateFormatter setDateFormat:@"HH:mm"];
        
    }
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[timeStr intValue]];
    
    stringTime = [dateFormatter stringFromDate:timeDate];
    
    return stringTime;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
