//
//  ShareObject.h
//  SDWTestProduct
//
//  Created by Raija on 16/4/13.
//  Copyright © 2016年 Lqing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"    //需要在项目Build Settings 中的 Other Linker Flags 添加 "-ObjC"

//引用头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>

typedef void(^shareResultBlock)(NSString *result, UIAlertViewStyle style);

@interface ShareObject : NSObject <WXApiDelegate>

@property (nonatomic, copy) shareResultBlock block;

/**
 *  初始化分享平台并配置分享平台
 *  目前仅配置了新浪微博、微信、QQ平台
 *  微信、QQ没有安装客户端不显示分享平台
 **/
+ (ShareObject *)shareDefault;

/**
 *  文字、图片分享
 *  （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，
 *  如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
 **/

- (void)sendMessageWithTitle:(NSString *)title withContent:(NSString *)content withUrl:(NSString *)aUrlString withImages:(id)images result:(shareResultBlock)result;

@end
