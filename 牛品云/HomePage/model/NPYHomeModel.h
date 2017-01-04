//
//  NPYHomeModel.h
//  牛品云
//
//  Created by Eric on 16/12/9.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPYBaseConstant.h"
#import "NPYHomeADModel.h"
#import "NPYHomeGoodsModel.h"
#import "NPYShopModel.h"

@interface NPYHomeModel : NSObject

@property (nonatomic, strong) NSArray *adArr;
@property (nonatomic, strong) NSArray *goodsArr;
@property (nonatomic, strong) NSArray *shopArr;

- (void)toDetailModel;

- (NSMutableArray *)returnADModelArray;

- (NSMutableArray *)returnGoodsModelArray;

- (NSMutableArray *)returnShopModelArray;

@end
