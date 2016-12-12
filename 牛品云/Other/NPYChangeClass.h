//
//  NPYChangeClass.h
//  牛品云
//
//  Created by Eric on 16/12/7.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPYChangeClass : NSObject

+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)jsonStringWithString:(NSString *)string;

@end
