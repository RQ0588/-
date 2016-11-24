//
//  NPYSettingTVCell.m
//  牛品云
//
//  Created by Eric on 16/11/21.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYSettingTVCell.h"
#import "NPYBaseConstant.h"

@implementation NPYSettingTVCell

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.headPortrait.layer.cornerRadius = 20;
    self.headPortrait.layer.masksToBounds = YES;
    self.headPortrait.layer.borderColor = XNColor(252, 216, 216, 1).CGColor;
    self.headPortrait.layer.borderWidth = 2.0;
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
