//
//  NPYPaymentOrderViewController.h
//  牛品云
//
//  Created by Eric on 16/11/14.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPYPaymentOrderViewController : UIViewController

@property (nonatomic, strong) NSString *order_type;//订单类型
@property (nonatomic, strong) NSString *order_id;//订单号
@property (nonatomic, strong) NSString *price;//需要支付的金额

@property (nonatomic, strong) NSString *sign;   //
@property (nonatomic, strong) NSString *user_id;//

@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *spec_id;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *address_id;
@property (nonatomic, strong) NSString *coupon_id;
@property (nonatomic, strong) NSString *integral;

@end
