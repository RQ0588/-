//
//  CollectionViewCell.m
//  多选图片
//
//  Created by holier_zyq on 2016/10/24.
//  Copyright © 2016年 holier_zyq. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imagev];
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (UIImageView *)imagev{
    if (!_imagev) {
        self.imagev = [[UIImageView alloc] initWithFrame:self.bounds];
//        _imagev.backgroundColor = [UIColor blueColor];
    }
    return _imagev;
}
- (UIButton *)deleteButton{
    if (!_deleteButton) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(CGRectGetWidth(self.bounds)-10, -3, 13, 13);
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"chahao_pyq"] forState:UIControlStateNormal];
    }
    return _deleteButton;
}

@end
