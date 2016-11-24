//
//  ZHTextAlertView.h
//  ZHAlertView
//
//  Created by 张慧 on 16/11/1.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHTextAlertView;

@protocol ZHTextAlertDelegate <NSObject>

- (void)alertView:(ZHTextAlertView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex alertText:(NSString*)alertText;

@end
@interface ZHTextAlertView : UIView
@property (nonatomic, strong) UIView        *bgView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UITextField   *textField;
@property (nonatomic, strong) UIButton      *cancleBtn;
@property (nonatomic, strong) UIButton      *sureBtn;
@property (nonatomic, strong) UIButton      *button;

@property (weak, nonatomic) id <ZHTextAlertDelegate> delegate;
+ (instancetype)alertViewDefault;
- (void)show;
@end
