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

@end

@implementation NPYHomeModel

- (NSMutableArray *)returnADModelArray {
    return self.mADArr;
}

- (NSMutableArray *)returnGoodsModelArray {
    return self.mGoodsArr;
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

@end
