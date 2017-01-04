//
//  UITabBar+NPYBadge.h
//  牛品云
//
//  Created by Eric on 16/12/13.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (NPYBadge)

- (void)showBadgeOnItemAtIndex:(int)index;      //显示小红点

- (void)hiddenbadgeOnItemAtIndex:(int)index;    //隐藏小红点

@end
