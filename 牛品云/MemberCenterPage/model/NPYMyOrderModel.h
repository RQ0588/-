//
//  NPYMyOrderModel.h
//  牛品云
//
//  Created by Eric on 17/1/3.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYMyOrderModel : NSObject

@property (nonatomic, copy) NSString *shop_id;      //店铺id
@property (nonatomic, copy) NSString *order_id;     //订单号
@property (nonatomic, copy) NSString *shop_name;    //店铺名
@property (nonatomic, copy) NSString *shop_img;     //店铺logo
@property (nonatomic, copy) NSString *goods_name;   //商品名
@property (nonatomic, copy) NSString *goods_img;    //商品图片
@property (nonatomic, copy) NSString *type;         //订单状态（0-待付款，1-待发货，2-待收货，3-确认收货，4-已完成订单，5-售货订单，-1已取消订单）
@property (nonatomic, copy) NSString *price;        //价格
@property (nonatomic, copy) NSString *num;          //购买数量

@end
