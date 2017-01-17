//
//  NPYTicketModel.h
//  牛品云
//
//  Created by Eric on 17/1/6.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYTicketModel : NSObject

@property (nonatomic, copy) NSString *coupon_id;    //优惠券id
@property (nonatomic, copy) NSString *shop_id;      //店铺id
@property (nonatomic, copy) NSString *full;         //满足的金额
@property (nonatomic, copy) NSString *reduce;       //减少的金额
@property (nonatomic, copy) NSString *end_time;     //到期时间
@property (nonatomic, copy) NSString *text;         //说明

@end
