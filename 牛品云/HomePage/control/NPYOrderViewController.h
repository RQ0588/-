//
//  NPYOrderViewController.h
//  牛品云
//
//  Created by Eric on 16/11/8.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYHomeGoodsModel.h"
#import "NPYShopModel.h"

@interface NPYOrderViewController : UIViewController

@property (nonatomic, strong) NPYHomeGoodsModel *goodsModel;

@property (nonatomic, strong) NPYShopModel *shopModel;

@property (nonatomic, strong) NSString *goods_id;

@property (nonatomic, strong) NSString *sign;

@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, strong) NSString *shop_id;

@property (nonatomic, assign) int buyNumber;

@property (nonatomic, strong) NSDictionary *goodsSpe;

@end
