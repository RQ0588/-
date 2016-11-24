//
//  ZHTextAlertView.m
//  ZHAlertView
//
//  Created by 张慧 on 16/11/1.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import "ZHTextAlertView.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define kAlertWidth 300


@implementation ZHTextAlertView
+ (instancetype)alertViewDefault {
    return [[self alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
        //背景视图(300,150)
        self.bgView = [[UIView alloc]init];
        self.bgView.center = self.center;
        self.bgView.bounds = CGRectMake(0, 0, kAlertWidth, 160);
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 10;
        self.bgView.layer.masksToBounds = YES;
        [self addSubview:self.bgView];
        
        //标题
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, kAlertWidth-20, 20)];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        self.titleLabel.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text= @"请输入关键字";
        [self.bgView addSubview:self.titleLabel];
        
        
        //内容
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(25, 55, kAlertWidth-50, 40)];
        self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.textField.layer.cornerRadius = 5;
        self.textField.layer.borderWidth = 0.5;
        [self.bgView addSubview:self.textField];
        
        
        
        UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
        cancle.backgroundColor = [UIColor lightGrayColor];
        cancle.layer.cornerRadius = 5;
        cancle.tag = 0;
        [cancle addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cancle setTitle:@"取 消" forState:UIControlStateNormal];
        [cancle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancle.frame = CGRectMake(25, 105, 110, 40);
        self.cancleBtn = cancle;
        [self.bgView addSubview:cancle];
        
        
        UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
        sure.backgroundColor = [UIColor redColor];
        sure.layer.cornerRadius = 5;
        sure.tag = 1;
        [sure addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [sure setTitle:@"确 认" forState:UIControlStateNormal];
        [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sure.frame = CGRectMake(164, 105, 110, 40);
        self.sureBtn = sure;
        [self.bgView addSubview:sure];

    }
    return self;
}

-(void)show{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
    
//动画效果
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAutoreverse animations:^{
        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)buttonClick:(UIButton *)button {
    if (self.delegate)
    {
        [self.delegate alertView:self clickedCustomButtonAtIndex:button.tag alertText:self.textField.text];
    }
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
