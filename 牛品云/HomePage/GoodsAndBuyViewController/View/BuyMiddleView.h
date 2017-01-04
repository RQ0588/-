//
//  BuyMiddleView.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/21.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYBaseConstant.h"

@protocol MidViewDelegate <NSObject>

- (void)selectedSpecToPushViewWithGoodsID:(NSString *)goodsID;

- (void)pushViewToShopViewWithShopID:(NSString *)shopID;

@end

@interface BuyMiddleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *showSelectedSpec;

@property (nonatomic, strong) NPYShopModel *shopModel;

@property (nonatomic, strong) NSString *goodsID;

@property (nonatomic, weak) id<MidViewDelegate>delegate;

+ (instancetype)view;

@end
