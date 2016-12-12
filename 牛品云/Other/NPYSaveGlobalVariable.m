//
//  NPYSaveGlobalVariable.m
//  牛品云
//
//  Created by Eric on 16/12/8.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYSaveGlobalVariable.h"

@implementation NPYSaveGlobalVariable

+ (void)saveValueAtLocal:(id)value withKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize]; //强制立即写入数据到磁盘
    
}

+ (id)readValueFromeLocalWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:key];
    
}

+ (void)deleteValueWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    
}

@end
