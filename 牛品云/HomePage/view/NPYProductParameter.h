//
//  NPYProductParameter.h
//  牛品云
//
//  Created by Eric on 16/11/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPYProductParameter : UIView     //商品参数

@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *infos;

- (CGFloat)calculateHeightOfView;

@end
