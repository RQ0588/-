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

- (void)switchRootViewControllerWithIdentifier:(NSString *)identifier;

@end

