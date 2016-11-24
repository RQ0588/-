//
//  ZHProgressHUD.h
//  ZHAlertView
//
//  Created by 张慧 on 16/11/2.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"
#import "UIImage+GIF.h"

typedef enum{
    ZHProgressModeText = 0,           //文字
    ZHProgressModeLoading,              //加载菊花
    ZHProgressModeGIF,            //加载动画
    ZHProgressModeSuccess               //成功
    
}ZHProgressMode;
@interface ZHProgressHUD : UIView
@property (nonatomic,strong) MBProgressHUD  *hud;
+(instancetype)shareinstance;

//显示
+(void)show:(NSString *)msg inView:(UIView *)view mode:(ZHProgressMode *)myMode;

//隐藏
+(void)hide;

//显示提示（1秒后消失）
+(void)showMessage:(NSString *)msg inView:(UIView *)view;


//显示进度
+(void)showProgress:(NSString *)msg inView:(UIView *)view;

//加载动画
+(void)showGif:(NSString *)msg inView:(UIView *)view;

//隐藏动画
+(void)hideGif:(UIView *)view;
@end
