//
//  NPYShopModel.h
//  牛品云
//
//  Created by Eric on 16/12/23.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYShopModel : NSObject

@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *shop_img;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *shop_province;
@property (nonatomic, copy) NSString *num_goods;

@property (nonatomic, copy) NSArray *goods;

@end
