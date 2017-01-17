//
//  NPYSupporTopTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/12/6.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYSupporTopTableViewCell.h"

@implementation NPYSupporTopTableViewCell

- (void)setModel:(NPYAddressModel *)model {
    _model = model;
    
    self.nameL.text = model.receiver;
    
    self.phoneL.text = model.phone;
    
    self.addressL.text = model.detailed;
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
