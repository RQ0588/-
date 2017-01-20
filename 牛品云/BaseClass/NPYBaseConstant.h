//
//  NPYBaseConstant.h
//  牛品云
//
//  Created by Eric on 16/10/25.
//  Copyright © 2016年 Eric. All rights reserved.
//

#ifndef NPYBaseConstant_h
#define NPYBaseConstant_h

//服务器基地址(114.55.112.9)
//#define BASE_URL    @"http://npy.cq-vip.com"
#define BASE_URL    @"http://114.55.112.9"

#define Verification_url    @"/index.php/app/Login/send"//验证码请求地址
#define Register_url    @"/index.php/app/Login/register"//注册请求地址
#define CollectGoods_url @"/index.php/app/Collect/get_goods"//获取商品收藏地址
#define CollectGoods_set_url @"/index.php/app/Collect/set_goods"//商品收藏地址
#define GoodsDetail_url @"/index.php/app/Getgoods/home"//商品详情地址
#define GoodsAppraise_url @"/index.php/app/Getgoods/get_appraise"//商品评论地址

/**
 *  阿里云推送
 */
#import <CloudPushSDK/CloudPushSDK.h>
#define CCPDidReceiveMessageNotification @"CCPDidReceiveMessageNotification"

#import <UserNotifications/UserNotifications.h>

/**
 *  保存登录信息到本地的key
 */
#define LoginData_Local   @"LoginData_Local"

/**
 *  登录状态的key
 */
#define LoginState  @"LoginState"

/**
 *  本地保存的头像
 */
#define LocalPortrait  @"LocalPortrait"

/**
 *  本地保存的头像
 */
#define LocalPassword  @"LocalPassword"

/**
 *  模型
 */
#import "NPYHomeModel.h"

/**
 *  登录模型
 */
#import "NPYLoginMode.h"

/**
 *  分享
 */
#import "ShareObject.h"

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
 *  登录界面
 */
#import "NPYLoginViewController.h"

/**
 *  自定义的一些方法
 */
#import "MJExtension.h"
#import "NPYChangeClass.h"

/**
 *  刷新
 */
#import "MJRefresh.h"

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

#import "UITabBar+NPYBadge.h"

#import "AppDelegate.h"

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
