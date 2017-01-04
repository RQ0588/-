//
//  AppDelegate.h
//  牛品云
//
//  Created by Eric on 16/10/24.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UITabBarController *tabBarC;

@property (nonatomic, assign) BOOL iSNEEDLOGIN;

//切换朋友圈和购物商城
- (void)switchRootViewControllerWithIdentifier:(NSString *)identifier;
//验证登录状态是否过期
- (void)verifyLoginWithViewController:(UIViewController *)viewController;

- (BOOL)isNeedLogin;

@end

