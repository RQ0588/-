//
//  UITabBar+NPYBadge.m
//  牛品云
//
//  Created by Eric on 16/12/13.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "UITabBar+NPYBadge.h"

#define TabBarItemNums  4.0     //tabBar的数量

@implementation UITabBar (NPYBadge)

- (void)showBadgeOnItemAtIndex:(int)index {
    //移除之前的小红点
    [self removeBadgeOnItemAtIndex:index];
    
    //新建小红点
    UIView *bageView = [[UIView alloc] init];
    bageView.tag = 888 + index;
    bageView.layer.cornerRadius = 5;
    bageView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index + 0.6) / TabBarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    bageView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:bageView];
}

- (void)hiddenbadgeOnItemAtIndex:(int)index {
    //移除小红点
    [self removeBadgeOnItemAtIndex:index];
}

- (void)removeBadgeOnItemAtIndex:(int)index {
    //根据tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}

@end
