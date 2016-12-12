//
//  NPYDicTopDetailTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/12/2.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYDicTopDetailTableViewCell.h"

@implementation NPYDicTopDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//查看产品介绍内容图片
- (IBAction)lookImageButtonPressed:(id)sender {
//    NSLog(@"//查看产品介绍内容图片");
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToImageInfoViewController)]) {
        [self.delegate pushToImageInfoViewController];
        
    }
}
@end
