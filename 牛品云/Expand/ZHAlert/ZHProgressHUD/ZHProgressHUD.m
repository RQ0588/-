//
//  ZHProgressHUD.m
//  ZHAlertView
//
//  Created by 张慧 on 16/11/2.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import "ZHProgressHUD.h"

@implementation ZHProgressHUD
+(instancetype)shareinstance{
    
    static ZHProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZHProgressHUD alloc] init];
    });
    
    return instance;
    
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(ZHProgressMode *)myMode{
    //如果已有弹框，先消失
    if ([ZHProgressHUD shareinstance].hud != nil) {
        [[ZHProgressHUD shareinstance].hud hideAnimated:YES];
        [ZHProgressHUD shareinstance].hud = nil;
    }
    
    //4\4s屏幕避免键盘存在时遮挡
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [view endEditing:YES];
    }
    
    [ZHProgressHUD shareinstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //[YJProgressHUD shareinstance].hud.dimBackground = YES;    //是否显示透明背景
    [ZHProgressHUD shareinstance].hud.color = [UIColor blackColor];
    [[ZHProgressHUD shareinstance].hud setMargin:10];
    [[ZHProgressHUD shareinstance].hud setRemoveFromSuperViewOnHide:YES];
    [ZHProgressHUD shareinstance].hud.detailsLabel.text = msg;
    [ZHProgressHUD shareinstance].hud.contentColor = [UIColor whiteColor];
    [ZHProgressHUD shareinstance].hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    switch ((NSInteger)myMode) {
        case ZHProgressModeText:
            [ZHProgressHUD shareinstance].hud.mode = MBProgressHUDModeText;
            break;

        case ZHProgressModeLoading:
            [ZHProgressHUD shareinstance].hud.mode = MBProgressHUDModeIndeterminate;
            break;
        
        default:
            break;
    }
}

+(void)hide{
    if ([ZHProgressHUD shareinstance].hud != nil) {
        [[ZHProgressHUD shareinstance].hud hideAnimated:YES];
    }
}

+(void)showMessage:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:ZHProgressModeText];
    [[ZHProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1];
    //用于关闭当前提示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
        
    });
}

+(void)showProgress:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:ZHProgressModeLoading];
}

+(void)showGif:(NSString *)msg inView:(UIView *)view{
    
    UIImage *image = [UIImage sd_animatedGIFNamed:@"ZHProgressHUDImg"];
    UIImageView *gifView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    gifView.image = image;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.color = [UIColor blackColor];
//    hud.bezelView.alpha = 0.8;
    hud.contentColor = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = msg?msg:@"";
    hud.customView = gifView;
    
}

+(void)hideGif:(UIView *)view{
    
    [MBProgressHUD hideHUDForView:view animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
