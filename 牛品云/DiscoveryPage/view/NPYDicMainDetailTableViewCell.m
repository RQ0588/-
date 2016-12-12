//
//  NPYDicMainDetailTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/12/2.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYDicMainDetailTableViewCell.h"

@implementation NPYDicMainDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//选择按钮
- (IBAction)selectedButtonPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = btn.selected ? NO : YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedSportWithIndexPath:)]) {
        [self.delegate selectedSportWithIndexPath:self.path];
        
    }
}

//展开按钮
- (IBAction)openButtonPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [btn setTitleColor:[UIColor blueColor] forState:0];
    
    _isOpen = !_isOpen;
    if (_isOpen) {
        [btn setTitle:@"收起" forState:UIControlStateNormal];
//        _isOpen = NO;
        
    } else {
        [btn setTitle:@"展开" forState:UIControlStateNormal];
//        _isOpen = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(openSubDetailViewWithIndexPath:withIsOpen:)]) {
        [self.delegate openSubDetailViewWithIndexPath:self.path withIsOpen:_isOpen];
        
    }
}

- (IBAction)cutButtonPressed:(id)sender {
    self.countValue --;
    if (self.countValue <= 0) {
        self.countValue = 0;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(desSelectSpotWithIndexPath:)]) {
            [self.delegate desSelectSpotWithIndexPath:self.path];
            
        }
        
    }
    self.countL.text = [NSString stringWithFormat:@"%i",self.countValue];
    
}

- (IBAction)sumButtonPressed:(id)sender {
    self.surplusValue = 5;  //模拟数据
    self.countValue = [self.countL.text intValue];
    self.countValue ++;
    if (self.countValue > self.surplusValue) {
        self.countValue = self.surplusValue;
        [ZHProgressHUD showMessage:@"不能超过剩余的份数" inView:self];
    }
    self.countL.text = [NSString stringWithFormat:@"%i",self.countValue];
    
}

@end
