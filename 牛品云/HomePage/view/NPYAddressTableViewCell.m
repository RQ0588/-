//
//  NPYAddressTableViewCell.m
//  牛品云
//
//  Created by Eric on 16/11/10.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYAddressTableViewCell.h"
#import "NPYBaseConstant.h"

@interface NPYAddressTableViewCell () {
    UILabel *nameL,*phoneL,*addressL;
    UIImageView *lineImgView;
    UIButton *editBtn;
    UILabel *defaultImg;
}

@end

@implementation NPYAddressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 10);
    bgImgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgImgView];
    
    nameL = [[UILabel alloc] init];
    nameL.frame = CGRectMake(21, 10, 100, 20);
    nameL.textColor = XNColor(17, 17, 17, 1);
    nameL.font = [UIFont systemFontOfSize:16.0];
    nameL.text = self.model.receiver;
    [bgImgView addSubview:nameL];
    
    phoneL = [[UILabel alloc] init];
    phoneL.frame = CGRectMake(CGRectGetMaxX(nameL.frame), CGRectGetMinY(nameL.frame), 150, 20);
    phoneL.textColor = XNColor(17, 17, 17, 1);
    phoneL.font = [UIFont systemFontOfSize:16.0];
    phoneL.text = self.model.phone;
    [bgImgView addSubview:phoneL];
    
    addressL = [[UILabel alloc] init];
    addressL.frame = CGRectMake(CGRectGetMinX(nameL.frame), CGRectGetMaxY(nameL.frame) + 8, self.frame.size.width - 80, 40);
    addressL.textColor = XNColor(102, 102, 102, 1);
    addressL.font = [UIFont systemFontOfSize:13.0];
    addressL.text = self.model.detailed;
    addressL.numberOfLines = 0;
    addressL.adjustsFontSizeToFitWidth = YES;
    [bgImgView addSubview:addressL];
    
    if ([self.model.defaults intValue] == 1) {
        defaultImg = [[UILabel alloc] init];
        defaultImg.frame = CGRectMake(CGRectGetMinX(nameL.frame), CGRectGetMaxY(nameL.frame) + 15, 32, 13);
        defaultImg.text = @"默认";
        defaultImg.textColor = [UIColor whiteColor];
        defaultImg.textAlignment = NSTextAlignmentCenter;
        defaultImg.backgroundColor = [UIColor redColor];
        defaultImg.font = [UIFont systemFontOfSize:11.0];
        defaultImg.center = CGPointMake(CGRectGetMidX(defaultImg.frame), addressL.center.y);
        [bgImgView addSubview:defaultImg];
        
        CGSize size2 = [self calculateStringSize:addressL.text withFontSize:13.0];
        CGFloat width2 = size2.width > self.frame.size.width - 130 ? self.frame.size.width - 130 : size2.width;
        addressL.frame = CGRectMake(CGRectGetMaxX(defaultImg.frame) + 9, CGRectGetMaxY(nameL.frame) + 15, width2, 40);
        
    } else if (defaultImg) {
        [defaultImg removeFromSuperview];
        defaultImg = nil;
        
        CGSize size2 = [self calculateStringSize:addressL.text withFontSize:13.0];
        CGFloat width2 = size2.width > self.frame.size.width - 80 ? self.frame.size.width - 80 : size2.width;
        addressL.frame = CGRectMake(CGRectGetMinX(nameL.frame), CGRectGetMaxY(nameL.frame) + 15, width2, 40);
    }
    
    
    lineImgView = [[UIImageView alloc] init];
    lineImgView.frame = CGRectMake(bgImgView.frame.size.width - 60, 5, 1, bgImgView.frame.size.height - 10);
//    lineImgView.backgroundColor = GRAY_BG;
    lineImgView.image = [UIImage imageNamed:@"88huixian"];
    [bgImgView addSubview:lineImgView];
    
    editBtn = [[UIButton alloc] init];
    editBtn.frame = CGRectMake(bgImgView.frame.size.width - 40, (bgImgView.frame.size.height - 20) / 2 , 20, 20);
    [editBtn setImage:[UIImage imageNamed:@"bianji_gouwu"] forState:UIControlStateNormal];
//    editBtn.backgroundColor = [UIColor grayColor];
    [editBtn addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editBtn];
    
}

- (CGSize)calculateStringSize:(NSString *)str withFontSize:(CGFloat)fontSize{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]};
    CGSize size=[str sizeWithAttributes:attrs];
    
    return size;
}

- (void)editButtonPressed:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(passCellIndex:)]) {
        [self.delegate passCellIndex:self.index];
        
    }
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
