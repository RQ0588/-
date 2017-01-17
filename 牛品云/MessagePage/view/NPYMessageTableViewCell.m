//
//  NPYMessageTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/12/21.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYMessageTableViewCell.h"

@implementation NPYMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)acceptButtonEvent:(id)sender {
//    [ZHProgressHUD showMessage:@"accept!!" inView:self.superview];
    self.mesStateLabel.hidden = NO;
    self.mesStateLabel.text = @"已添加";
    
    self.acceptBtn.hidden = YES;
    self.refuseBtn.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(acceptButtonPressedWithCellIndex:)]) {
        [self.delegate acceptButtonPressedWithCellIndex:self.cellIndex];
    }
    
}

- (IBAction)refuseButtonEvent:(id)sender {
//    [ZHProgressHUD showMessage:@"refuse!!" inView:self.superview];
    self.mesStateLabel.hidden = NO;
    self.mesStateLabel.text = @"已拒绝";
    
    self.acceptBtn.hidden = YES;
    self.refuseBtn.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(refuseButtonPressedWithCellIndex:)]) {
        [self.delegate refuseButtonPressedWithCellIndex:self.cellIndex];
    }
}

- (void)layoutSubviews {
    self.mesStateLabel.hidden = YES;
    
    self.timeLabel.layer.cornerRadius = 2.0;
    self.timeLabel.layer.masksToBounds = YES;
    
    self.acceptBtn.layer.cornerRadius = 2.0;
    self.acceptBtn.layer.borderColor = XNColor(229, 229, 229, 1).CGColor;
    self.acceptBtn.layer.borderWidth = 0.5;
    [self.acceptBtn.layer masksToBounds];
    
    self.refuseBtn.layer.cornerRadius = 2.0;
    self.refuseBtn.layer.borderColor = XNColor(229, 229, 229, 1).CGColor;
    self.refuseBtn.layer.borderWidth = 0.5;
    [self.refuseBtn.layer masksToBounds];
    
}

@end
