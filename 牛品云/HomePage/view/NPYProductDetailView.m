//
//  NPYProductDetailView.m
//  牛品云
//
//  Created by Eric on 16/11/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYProductDetailView.h"
#import "NPYBaseConstant.h"

@interface NPYProductDetailView () {
    UIImageView *imgView;
}

@end

@implementation NPYProductDetailView

- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)layoutSubviews {
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame))];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgName] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self addSubview:imgView];
    imgView.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)calculateHeightOfView {
    return imgView.image.size.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
