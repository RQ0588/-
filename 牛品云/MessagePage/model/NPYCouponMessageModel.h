//
//  NPYCouponMessageModel.h
//  牛品云
//
//  Created by Eric on 17/1/14.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYCouponMessageModel : NSObject

@property (nonatomic, assign) int push_id;
@property (nonatomic, assign) int type;     //(1是订单消息，2是朋友圈消息，3是好友消息，4是优惠卷消息 5是众筹消息 6是好友通过/不通过消息  int类型)

@property (nonatomic, assign) int order_id;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, copy) NSString *goods_img;

@property (nonatomic, assign) int moments_id;
@property (nonatomic, assign) int friend_id;
@property (nonatomic, copy) NSString *friend_type;
@property (nonatomic, copy) NSString *many_id;
@property (nonatomic, copy) NSString *many_num;
@property (nonatomic, copy) NSString *many_img;

@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *read;         //(0-未读， 1-已读)

@end
