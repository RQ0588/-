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
//    NSLog(@"%.2f",self.frame.size.height);
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 10);
    bgImgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgImgView];
    
    nameL = [[UILabel alloc] init];
    nameL.frame = CGRectMake(20, 10, 100, 20);
    nameL.textColor = [UIColor blackColor];
    nameL.font = [UIFont systemFontOfSize:17.0];
    nameL.text = [self.dataDic valueForKey:@"name"];
    [bgImgView addSubview:nameL];
    
    phoneL = [[UILabel alloc] init];
    phoneL.frame = CGRectMake(CGRectGetMaxX(nameL.frame), CGRectGetMinY(nameL.frame), 150, 20);
    phoneL.textColor = [UIColor blackColor];
    phoneL.font = [UIFont systemFontOfSize:17.0];
    phoneL.text = [self.dataDic valueForKey:@"phone"];
    [bgImgView addSubview:phoneL];
    
    addressL = [[UILabel alloc] init];
    addressL.frame = CGRectMake(CGRectGetMinX(nameL.frame), CGRectGetMaxY(nameL.frame) + 5, self.frame.size.width - 60, 20);
    addressL.textColor = [UIColor grayColor];
    addressL.font = [UIFont systemFontOfSize:13.0];
    addressL.text = [self.dataDic valueForKey:@"address"];
    addressL.numberOfLines = 0;
    addressL.adjustsFontSizeToFitWidth = YES;
    [bgImgView addSubview:addressL];
    
    lineImgView = [[UIImageView alloc] init];
    lineImgView.frame = CGRectMake(bgImgView.frame.size.width - 60, 2.5, 1, bgImgView.frame.size.height - 5);
    lineImgView.backgroundColor = GRAY_BG;
    [bgImgView addSubview:lineImgView];
    
    editBtn = [[UIButton alloc] init];
    editBtn.frame = CGRectMake(bgImgView.frame.size.width - 40, (bgImgView.frame.size.height - 20) / 2 , 20, 20);
    editBtn.backgroundColor = [UIColor grayColor];
//    [editBtn addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgImgView addSubview:editBtn];
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
