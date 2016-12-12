//
//  NPYSaveGlobalVariable.h
//  牛品云
//
//  Created by Eric on 16/12/8.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYSaveGlobalVariable : NSObject

/**
 *  使用NSUserDefaults保存数据
 */
+ (void)saveValueAtLocal:(id)value withKey:(NSString *)key;

/**
 *  读取数据
 */
+ (id)readValueFromeLocalWithKey:(NSString *)key;

/**
 *  删除数据
 */
+ (void)deleteValueWithKey:(NSString *)key;

@end
