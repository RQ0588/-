//
//  AppDelegate.m
//  牛品云
//
//  Created by Eric on 16/10/24.
//  Copyright © 2016年 Eric. All rights reserved.
//
//13133015776 账号

#import "AppDelegate.h"
#import "NPYBaseConstant.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //注册微信APPID
    [WXApi registerApp:@"wxb15b43bbab71cf6c" withDescription:@"调用微信支付"];
    
    //验证登录是否失效
//    [self verifyLogin];
    
    //如果已经获得发送通知的授权则创建本地通知，否则请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置)
    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
//        [self addLocalNotification];
        /**
         *  注册阿里推送
         */
        [self initCloudPush];
        
        [self registerAPNS:application];
    }else{
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
    }
    
    
    //点击通知将App从关闭状态启动时，将通知打开回执上报
    [CloudPushSDK sendNotificationAck:launchOptions];
    
    return YES;
}

/**
 *  注册阿里推送
 *  appKey && appSecret
 */
- (void)initCloudPush {
    [CloudPushSDK asyncInit:@"23538701" appSecret:@"8c738b653cf549c2f424b3beb5c4ea23" callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success,deviceld:%@",[CloudPushSDK getDeviceId]);
            
        } else {
            NSLog(@"Push SDK init failed,error:%@",res.error);
            
        }
        
    }];
    
}

- (void)registerAPNS:(UIApplication *)application {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // granted
                NSLog(@"User authored notification.");
                [application registerForRemoteNotifications];
            } else {
                // not granted
                NSLog(@"User denied notification.");
            }
        }];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    
}

#pragma mark 注册推送通知之后
//在此接收设备令牌
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    /*返回的deviceToken上传到CloudPush服务器*/
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success.");
            
        } else {
            NSLog(@"Register deviceToken failed,error:%@",res.error);
            
        }
    }];
    
    NSLog(@"device token:%@",deviceToken);
}
#pragma mark 获取device token失败后
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error.localizedDescription);
    
}

/**
 *  注册推送消息的监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:CCPDidReceiveMessageNotification
                                               object:nil];
}

/**
 *  移除监听
 */
- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CCPDidReceiveMessageNotification
                                                  object:nil];
    
}

/**
 *  处理推送消息
 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title:%@, content:%@.",title,body);
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSInteger num = [UIApplication sharedApplication].applicationIconBadgeNumber;
    num += 1;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:num];
    
}

/**
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Receive one notication.");
    //取得APNs通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //内容
    NSString *content = [aps valueForKey:@"alert"];
    //badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    //播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    //取得Extras字段内容
    NSString *Extras = [userInfo valueForKey:@"Extras"];//服务端的key自己定义
     NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    
    [self registerMessageReceive];
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CCPDidReceiveMessageNotification object:nil];
}

//切换RootViewController
- (void)switchRootViewControllerWithIdentifier:(NSString *)identifier {
    self.window.rootViewController = nil;
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *friendTabBarController = [mainSB instantiateViewControllerWithIdentifier:identifier];
    self.window.rootViewController = friendTabBarController;
}

//验证是否需要重新登录
- (void)verifyLoginWithViewController:(UIViewController *)viewController {
    NSString *urlStr = @"/index.php/app/Login/home";
    
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                             [userDict valueForKey:@"sign"],@"sign",
                             userModel.user_id,@"user_id", nil];
    
    [self requestVerifyLoginStateWithUrl:urlStr withParemes:request withViewController:viewController];
    
}

- (void)requestVerifyLoginStateWithUrl:(NSString *)urlStr withParemes:(NSDictionary *)pareme withViewController:(UIViewController *)viewController {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //不需要重新登录
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.window];
            _iSNEEDLOGIN = NO;
        } else {
            //需要重新登录
//            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.window];
            _iSNEEDLOGIN = YES;
            [self loginWithViewController:viewController];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        _iSNEEDLOGIN = NO;
    }];
}

- (void)loginWithViewController:(UIViewController *)viewController {
    NPYLoginViewController *loginVC = [[NPYLoginViewController alloc] init];
    
    [viewController.navigationController pushViewController:loginVC animated:YES];
}

- (BOOL)isNeedLogin {
    return _iSNEEDLOGIN;
    
}

/**
 *  支付宝支付回调
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

//NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"alipayResult = %@",resultDic);
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
