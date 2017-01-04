//
//  NPYHomeModel.m
//  牛品云
//
//  Created by Eric on 16/12/9.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYHomeModel.h"

@interface NPYHomeModel ()

@property (nonatomic, strong) NSMutableArray *mADArr;
@property (nonatomic, strong) NSMutableArray *mGoodsArr;
@property (nonatomic, strong) NSMutableArray *mShopArr;

@end

@implementation NPYHomeModel

- (NSMutableArray *)returnADModelArray {
    return self.mADArr;
}

- (NSMutableArray *)returnGoodsModelArray {
    return self.mGoodsArr;
}

- (NSMutableArray *)returnShopModelArray {
    return self.mShopArr;
}

- (void)toDetailModel {
    for (int i = 0; i < self.adArr.count; i++) {
        NPYHomeADModel *adModel = [NPYHomeADModel mj_objectWithKeyValues:self.adArr[i]];
        [self.mADArr addObject:adModel];
    }
    
    for (int i = 0; i < self.goodsArr.count; i++) {
        NPYHomeGoodsModel *goodsModel = [NPYHomeGoodsModel mj_objectWithKeyValues:self.goodsArr[i]];
        [self.mGoodsArr addObject:goodsModel];
    }
    
    for (int i = 0; i < self.shopArr.count; i++) {
        NPYShopModel *shopModel = [NPYShopModel mj_objectWithKeyValues:self.shopArr[i]];
        [self.mShopArr addObject:shopModel];
    }
    
}

- (NSArray *)adArr {
    if (_adArr == nil) {
        _adArr = [NSArray new];
    }
    
    return _adArr;
}

- (NSArray *)goodsArr {
    if (_goodsArr == nil) {
        _goodsArr = [NSArray new];
    }
    
    return _goodsArr;
}

- (NSArray *)shopArr {
    if (_shopArr == nil) {
        _shopArr = [NSArray new];
    }
    
    return _shopArr;
}

- (NSMutableArray *)mADArr {
    if (_mADArr == nil) {
        _mADArr = [NSMutableArray new];
    }
    
    return _mADArr;
}

- (NSMutableArray *)mGoodsArr {
    if (_mGoodsArr == nil) {
        _mGoodsArr = [NSMutableArray new];
    }
    
    return _mGoodsArr;
}

- (NSMutableArray *)mShopArr {
    if (_mShopArr == nil) {
        _mShopArr = [NSMutableArray new];
    }
    
    return _mShopArr;
}

@end
