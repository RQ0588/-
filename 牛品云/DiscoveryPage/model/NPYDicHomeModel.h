//
//  NPYDicHomeModel.h
//  牛品云
//
//  Created by Eric on 16/12/29.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYDicHomeModel : NSObject

@property (nonatomic, copy) NSString *many_id;      //众筹id
@property (nonatomic, copy) NSString *title_img;    //标题图片
@property (nonatomic, copy) NSString *title;        //标题
@property (nonatomic, copy) NSString *start_time;   //开始时间
@property (nonatomic, copy) NSString *stop_time;    //结束时间
@property (nonatomic, copy) NSString *target_number;//目标钱数
@property (nonatomic, copy) NSString *yes_number;   //已完成数量
@property (nonatomic, copy) NSString *yes_user;     //已购买的用户数量

@property (nonatomic, copy) NSString *shop_id;  //店铺id
@property (nonatomic, copy) NSString *text;     //众筹详情
@property (nonatomic, copy) NSString *text_img; //详情图片
@property (nonatomic, copy) NSString *type;     //类型（0审核中 1正在进行 2未通过）
@property (nonatomic, copy) NSString *shop_img; //店铺logo
@property (nonatomic, copy) NSString *shop_name;//店铺名称

@end
