//
//  NPYLoginMode.h
//  牛品云
//
//  Created by Eric on 16/12/7.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYLoginMode : NSObject

@property (nonatomic, copy) NSString *integral;         /*积分*/
@property (nonatomic, copy) NSString *type;             /*是否冻结*/
@property (nonatomic, copy) NSString *user_id;          /*用户id*/
@property (nonatomic, copy) NSString *user_name;        /*用户名*/
@property (nonatomic, copy) NSString *user_phone;       /*手机号*/
@property (nonatomic, copy) NSString *user_portrait;    /*头像*/
@property (nonatomic, copy) NSString *user_time;        /*注册时间*/
@property (nonatomic, copy) NSString *r;                /*数据状态*/
@property (nonatomic, copy) NSString *sign;             /*调用其他接口所用*/

@end
