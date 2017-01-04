//
//  NPYAppraiseModel.h
//  牛品云
//
//  Created by Eric on 16/12/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYAppraiseModel : NSObject

@property (nonatomic, copy) NSString *id;               //评论id
@property (nonatomic, copy) NSString *goods_id;         //商品id
@property (nonatomic, copy) NSString *user_id;          //评论用户id
@property (nonatomic, copy) NSString *order_id;         //订单号
@property (nonatomic, copy) NSString *shop_id;          //店铺id
@property (nonatomic, copy) NSString *user_name;        //用户名
@property (nonatomic, copy) NSString *score;            //打分信息
@property (nonatomic, copy) NSString *content;          //评论具体内容
@property (nonatomic, copy) NSString *img1;             //图片1
@property (nonatomic, copy) NSString *img2;             //图片2
@property (nonatomic, copy) NSString *img3;             //图片3
@property (nonatomic, copy) NSString *time;             //评论时间
@property (nonatomic, copy) NSString *reply;            //卖家回复

@end
