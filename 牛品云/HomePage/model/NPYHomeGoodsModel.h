//
//  NPYHomeGoodsModel.h
//  牛品云
//
//  Created by Eric on 16/12/9.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYHomeGoodsModel : NSObject

@property (nonatomic, copy) NSString *goods_id;     //商品id
@property (nonatomic, copy) NSString *goods_name;   //商品名称
@property (nonatomic, copy) NSString *goods_img;    //商品图片链接
@property (nonatomic, copy) NSString *sold;         //销量

@end
