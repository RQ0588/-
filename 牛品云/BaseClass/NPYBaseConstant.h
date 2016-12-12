//
//  NPYBaseConstant.h
//  牛品云
//
//  Created by Eric on 16/10/25.
//  Copyright © 2016年 Eric. All rights reserved.
//

#ifndef NPYBaseConstant_h
#define NPYBaseConstant_h

/**
 *  网络请求
 */
#import "AFNetworking.h"
#import "NPYHttpRequest.h"

/**
 *  保存数据到本地
 */
#import "NPYSaveGlobalVariable.h"

/**
 *  自定义的一些方法
 */
#import "MJExtension.h"
#import "NPYChangeClass.h"

/**
 *  弹窗
 */
#import "ZHAttAlertView.h"
#import "ZHProgressHUD.h"
#import "ZHTextAlertView.h"
#import "ZHActionSheet.h"
#import "ZHActionSheetView.h"

#import "UIImageView+WebCache.h"
#import "NPYMessageViewController.h"
#import "SZCirculationImageView.h"

#import "WZLBadgeImport.h"

//服务器地址
#define BASE_URL    @"http://npy.cq-vip.com"

/**
 *  保存登录信息到本地的key
 */
#define LoginData_Local   @"LoginData_Local"

/**
 *  登录状态的key
 */
#define LoginState  @"LoginState"

//日志输出
#ifdef DEBUG
#define NSLog(...)  NSLog(__VA_ARGS__)
#define debugMethod()   NSLog(@"%s",__func__)
#else
#deine NSLog(...)
#define debugMethod()
#endif

//屏幕宽度、高度
#define WIDTH_SCREEN        [UIScreen mainScreen].bounds.size.width //屏幕宽度
#define HEIGHT_SCREEN       [UIScreen mainScreen].bounds.size.height //屏幕高度
//间隔宽度
#define Height_Space        5
//背景灰
#define GRAY_BG     [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]

#define XNWindowWidth ([[UIScreen mainScreen] bounds].size.width)

#define XNWindowHeight ([[UIScreen mainScreen] bounds].size.height)

#define XNColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define XNFont(font) [UIFont systemFontOfSize:(font)]


#define WEAK  @weakify(self);
#define STRONG  @strongify(self);

#endif /* NPYBaseConstant_h */
