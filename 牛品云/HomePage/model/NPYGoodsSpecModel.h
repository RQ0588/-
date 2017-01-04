//
//  NPYGoodsSpecModel.h
//  牛品云
//
//  Created by Eric on 16/12/24.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYGoodsSpecModel : NSObject

@property (nonatomic, copy) NSString *id;               //规格id
@property (nonatomic, copy) NSString *goods_id;         //商品id
@property (nonatomic, copy) NSString *price;            //规格市场价
@property (nonatomic, copy) NSString *promption_price;  //规格价格
@property (nonatomic, copy) NSString *inventory;        //规格库存
@property (nonatomic, copy) NSString *spec_name;        //规格名称
@property (nonatomic, copy) NSString *postage;          //邮费

@end
