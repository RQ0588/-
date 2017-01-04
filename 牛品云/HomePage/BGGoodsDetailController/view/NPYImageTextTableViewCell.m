//
//  NPYImageTextTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/12/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYImageTextTableViewCell.h"

@implementation NPYImageTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    UIImageView *tm = [UIImageView new];
    [tm sd_setImageWithURL:[NSURL URLWithString:self.imgUrlStr]];
    
    _imgView.frame = CGRectMake(CGRectGetMinX(_imgView.frame), CGRectGetMinY(_imgView.frame), CGRectGetWidth(_imgView.frame), tm.image.size.height);
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:self.imgUrlStr] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
