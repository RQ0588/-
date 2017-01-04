//
//  NPYTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/11/30.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYGoodsDetailTableViewCell.h"
#import "NPYBaseConstant.h"

@implementation NPYGoodsDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    self.customerName.text = self.model.user_name;
    self.buyTime.text = self.model.time;
    self.commentLabel.text = self.model.content;
    
    [self.showImgOne sd_setImageWithURL:[NSURL URLWithString:self.model.img1] placeholderImage:[UIImage new]];
    [self.showImgTwo sd_setImageWithURL:[NSURL URLWithString:self.model.img2] placeholderImage:[UIImage new]];
    [self.showImgThree sd_setImageWithURL:[NSURL URLWithString:self.model.img3] placeholderImage:[UIImage new]];
    
    self.reply_Lab.layer.cornerRadius = 5.0;
    self.reply_Lab.layer.masksToBounds = YES;
    self.reply_Lab.text = self.model.reply;
    
    if (self.reply_Lab.text.length == 0) {
        self.reply_Lab.hidden = YES;
    }
    
    for (int i = 0; i < [self.model.score intValue]; i++) {
        switch (i) {
        case 0:
                [self.startOne setImage:[UIImage imageNamed:@"hongxing_gouwu"]];
            break;
            
        case 1:
                [self.startTwo setImage:[UIImage imageNamed:@"hongxing_gouwu"]];
            break;
            
        case 2:
                [self.startThree setImage:[UIImage imageNamed:@"hongxing_gouwu"]];
            break;
            
        case 3:
                [self.startFour setImage:[UIImage imageNamed:@"hongxing_gouwu"]];
            break;
            
        case 4:
                [self.startFive setImage:[UIImage imageNamed:@"hongxing_gouwu"]];
            break;
            
        default:
            break;
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
