//
//  NPYProductParameter.m
//  牛品云
//
//  Created by Eric on 16/11/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYProductParameter.h"
#import "NPYBaseConstant.h"

@implementation NPYProductParameter

- (id)init {
    self = [super init];
    if (self) {
        
        
    }
    
    return self;
}

- (void)layoutSubviews {
    //
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10);
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < self.names.count; i++) {
        UILabel *nameL = [[UILabel alloc] init];
        nameL.frame = CGRectMake(0, i * 20, 60, 20);
        nameL.text = self.names[i];
        nameL.textColor = [UIColor grayColor];
        nameL.font = [UIFont systemFontOfSize:9.0];
        nameL.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:nameL];
        
        UILabel *infoL = [[UILabel alloc] init];
        infoL.frame = CGRectMake(CGRectGetMaxX(nameL.frame) + 30, CGRectGetMinY(nameL.frame), 200, 20);
        infoL.text = self.infos[i];
        infoL.textColor = [UIColor blackColor];
        infoL.font = [UIFont systemFontOfSize:9.0];
        [bgView addSubview:infoL];
        
        UIImageView *lineImgView = [[UIImageView alloc] init];
        lineImgView.frame = CGRectMake(0, (i +1 ) * 20, bgView.frame.size.width, 1);
        lineImgView.backgroundColor = GRAY_BG;
        [bgView addSubview:lineImgView];
    }
    
    bgView.frame = CGRectMake(5, 5, self.frame.size.width - 10, [self calculateHeightOfView]);
    
    //竖线
    UIImageView *h_lineImgView = [[UIImageView alloc] init];
    h_lineImgView.frame = CGRectMake(70, 0, 1, bgView.frame.size.height);
    h_lineImgView.backgroundColor = GRAY_BG;
    [bgView addSubview:h_lineImgView];
}

- (CGFloat)calculateHeightOfView {
    return self.names.count * 20;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
