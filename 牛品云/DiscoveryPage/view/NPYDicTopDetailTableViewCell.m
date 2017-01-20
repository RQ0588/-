//
//  NPYDicTopDetailTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/12/2.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYDicTopDetailTableViewCell.h"
#import "NPYBaseConstant.h"

@implementation NPYDicTopDetailTableViewCell

#pragma mark - 
- (void)layoutSubviews {
    self.lookImg.userInteractionEnabled = YES;
    
    [self.topADImg sd_setImageWithURL:[NSURL URLWithString:self.homeModel.title_img] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
    
    [self.personIcon sd_setImageWithURL:[NSURL URLWithString:self.homeModel.shop_img] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
    
    self.title.text = self.homeModel.title;
    
    self.name.text = self.homeModel.shop_name;
    
    self.cllectPrice.text = self.homeModel.target_number;
    
    self.personNumber.text = self.homeModel.yes_user;
    
    float finishNumber = [self.homeModel.yes_number floatValue] / [self.homeModel.target_number floatValue];
    
    self.proValue.text = [NSString stringWithFormat:@"已完成%.2f%%",finishNumber * 100];
    
    self.proView.progress = finishNumber;
    
    [self calutTimeFromeDate:self.homeModel.start_time To:self.homeModel.stop_time];
}

- (void)calutTimeFromeDate:(NSString *)startDateStr To:(NSString *)endDateStr {
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //创建了两个日期对象
    //    NSDate *date1=[dateFormatter dateFromString:startDateStr];
    //    NSDate *date2=[dateFormatter dateFromString:endDateStr];
    //NSDate *date=[NSDate date];
    //NSString *curdate=[dateFormatter stringFromDate:date];
    
    NSDate *confromTimesp1 = [NSDate dateWithTimeIntervalSince1970:[startDateStr intValue]];
    NSDate *confromTimesp2 = [NSDate dateWithTimeIntervalSince1970:[endDateStr intValue]];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time=[confromTimesp2 timeIntervalSinceDate:confromTimesp1];
    
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    
    self.endTime.text = dateContent;
}

- (void)awakeFromNib {
//    [super awakeFromNib];
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
