//
//  NPYMyOrderDetailModel.h
//  牛品云
//
//  Created by Eric on 17/1/9.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYMyOrderDetailModel : NSObject

@property (nonatomic, copy) NSString *goods_id;         //商品id
@property (nonatomic, copy) NSString *shop_id;          //店铺id
@property (nonatomic, copy) NSString *order_id;         //订单号
@property (nonatomic, copy) NSString *shop_name;        //店铺名
@property (nonatomic, copy) NSString *shop_img;         //店铺logo
@property (nonatomic, copy) NSString *goods_name;       //商品名
@property (nonatomic, copy) NSString *goods_img;        //商品图片
@property (nonatomic, copy) NSString *type;             //订单状态（0-待付款，1-待发货，2-待收货，3-确认收货，4-已完成订单，5-售货订单，-1已取消订单）
@property (nonatomic, copy) NSString *price;            //价格
@property (nonatomic, copy) NSString *num;              //购买数量
@property (nonatomic, copy) NSString *postage;          //邮费
@property (nonatomic, copy) NSString *courier_number;   //快递单号
@property (nonatomic, copy) NSString *cancel_time;      //自动取消时间
@property (nonatomic, copy) NSString *buy_time;         //下单时间
@property (nonatomic, copy) NSString *integral;         //优惠抵扣钱数
@property (nonatomic, copy) NSString *coupon;           //牛豆抵扣钱数

@end
