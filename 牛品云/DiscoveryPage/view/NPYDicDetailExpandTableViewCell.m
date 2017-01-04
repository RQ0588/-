//
//  NPYDicDetailExpandTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/12/17.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYDicDetailExpandTableViewCell.h"

@implementation NPYDicDetailExpandTableViewCell

- (void)layoutSubviews {
    [self.detaiImage sd_setImageWithURL:[NSURL URLWithString:self.model.img] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
    
    self.detail.text = [NSString stringWithFormat:@"卖家承诺：众筹成功后%@天内发货",self.model.delivery];
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
