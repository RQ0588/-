//
//  NPYShopCarOrderViewController.h
//  牛品云
//
//  Created by Eric on 17/1/8.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingCartModel.h"
#import "NPYHomeGoodsModel.h"
#import "NPYShopModel.h"

@interface NPYShopCarOrderViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *mGoodsModels;
@property (nonatomic, strong) NSMutableArray *mShopModels;
@property (nonatomic, strong) NSMutableArray *mGoodsSpes;
@property (nonatomic, strong) NSMutableArray *mBuyNumbers;
@property (nonatomic, strong) NSString *totalPrice;

@property (nonatomic, strong) NPYHomeGoodsModel *goodsModel;
@property (nonatomic, strong) NPYShopModel *shopModel;

@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *shop_id;

@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, assign) int buyNumber;

@property (nonatomic, strong) NSDictionary *goodsSpe;

@end
