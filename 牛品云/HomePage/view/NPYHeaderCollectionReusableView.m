//
//  NPYHeaderCollectionReusableView.m
//  牛品云
//
//  Created by Eric on 16/12/24.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYHeaderCollectionReusableView.h"
#import "NPYBaseConstant.h"

@implementation NPYHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 30)];
    titleName.text = @"牛品推荐";
    titleName.textAlignment = NSTextAlignmentCenter;
    titleName.textColor = XNColor(102, 102, 102, 1);
    titleName.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:titleName];
    
    UIImageView *vLine = [[UIImageView alloc] init];
    vLine.frame = CGRectMake(CGRectGetMidX(titleName.frame) - 75, 0, 25, 1);
    //        vLine.backgroundColor = GRAY_BG;
    vLine.image = [UIImage imageNamed:@"heixian_zuo"];
    vLine.center = CGPointMake(CGRectGetMidX(vLine.frame), CGRectGetMidY(titleName.frame));
    [self addSubview:vLine];
    
    UIImageView *vLine2 = [[UIImageView alloc] init];
    vLine2.frame = CGRectMake(CGRectGetMidX(titleName.frame) + 50, 0, 25, 1);
    //        vLine2.backgroundColor = GRAY_BG;
    vLine2.image = [UIImage imageNamed:@"heixian_you"];
    vLine2.center = CGPointMake(CGRectGetMidX(vLine2.frame), CGRectGetMidY(titleName.frame));
    [self addSubview:vLine2];
    
    UIButton *moreBtn = [[UIButton alloc] init];
    moreBtn.frame = CGRectMake(WIDTH_SCREEN - 60, 0, 50, 30);
    moreBtn.center = CGPointMake(CGRectGetMidX(moreBtn.frame), CGRectGetMidY(titleName.frame));
    [moreBtn setTitle:@"更多 >" forState:UIControlStateNormal];
    [moreBtn setTitleColor:XNColor(240, 84, 84, 1) forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [moreBtn addTarget:self action:@selector(moreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.hidden = _isHideMore;
    [self addSubview:moreBtn];
}

- (void)moreButtonPressed:(UIButton *)btn {
    //    NSLog(@"显示更多牛品推荐...");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToNewViewController)]) {
        [self.delegate pushToNewViewController];
    }
}

@end
