//
//  SelctCityView.h
//  自定义城市选择器
//
//  Created by Eric on 2016/10/28.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyCitySelectBlock)(NSString *selectCity);

@interface SelctCityView : UIView

-(instancetype)initWithFrame:(CGRect)frame andMyCitySelect:(MyCitySelectBlock)selectCity;


@end
