//
//  NPYAddressModel.h
//  牛品云
//
//  Created by Eric on 17/1/4.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYAddressModel : NSObject

@property (nonatomic, copy) NSString *address_id;   //收货地址id
@property (nonatomic, copy) NSString *receiver;     //收货人姓名
@property (nonatomic, copy) NSString *phone;        //联系电话
@property (nonatomic, copy) NSString *province;     //收货省份
@property (nonatomic, copy) NSString *city;         //收货城市
@property (nonatomic, copy) NSString *detailed;     //详细地址
@property (nonatomic, copy) NSString *defaults;     //是否默认（1 默认）

@end
