//
//  NPYTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/11/22.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYTableViewCell.h"

@implementation NPYTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)oneButton:(id)sender {
    NSLog(@"左侧的按钮");
}

- (IBAction)twoButton:(id)sender {
    NSLog(@"右侧按钮");
}

@end
