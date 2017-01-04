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

+ (instancetype)tableViewCellwith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath isOpen:(BOOL)open {
    NSString *identifier = @"";//对应xib种设置的identifier
    NSInteger index = 0;//xib中德第几个cell
    
    if (open) {
        identifier = @"Second";
        index = 1;
    } else {
        identifier = @"First";
        index = 0;
    }
    
    NPYDicMainDetailTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NPYDicMainDetailTableViewCell" owner:self options:nil] objectAtIndex:index];
        
    }
    
    return cell;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.openBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.openBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.openBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0.0, 0.0);
    self.openBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -40);
}

- (void)layoutSubviews {
    
    self.price.text = self.detailModel.money;
    
    self.word.text = self.detailModel.explain;
    
    self.YQGImg.hidden = [self.detailModel.target_number_repay intValue] == [self.detailModel.yes intValue] ? NO : YES;
    
    self.selectBtn.hidden = !self.YQGImg.hidden;
    
    self.countL.text = self.detailModel.number;
    
    self.countValue = [self.detailModel.number intValue];
    
    int perNumber = [self.detailModel.money intValue] == 0 ? [self.detailModel.target_number_repay intValue] : [self.detailModel.target_number_repay intValue] / [self.detailModel.money intValue];
    
    int sportNumber = [self.detailModel.money intValue] == 0 ? [self.detailModel.yes intValue] : [self.detailModel.yes intValue] / [self.detailModel.money intValue];
    
    self.number.text = [NSString stringWithFormat:@"%i位支持者（剩余%i份）",sportNumber,(perNumber - sportNumber)];
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
//    _isOpen = !_isOpen;
    
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
