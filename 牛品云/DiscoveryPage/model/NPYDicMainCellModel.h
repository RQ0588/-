//
//  NPYDicMainCellModel.h
//  牛品云
//
//  Created by Eric on 16/12/5.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYDicMainCellModel : NSObject

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *id;                 //档位id
@property (nonatomic, copy) NSString *many_id;            //众筹id
@property (nonatomic, copy) NSString *money;              //单次投钱数
@property (nonatomic, copy) NSString *number;             //回报数
@property (nonatomic, copy) NSString *explain;            //说明
@property (nonatomic, copy) NSString *target_number_repay;//目标钱数
@property (nonatomic, copy) NSString *yes;                //已完成（0/1）
@property (nonatomic, copy) NSString *img;                //档位详情图片
@property (nonatomic, copy) NSString *delivery;           //程诺

@end
