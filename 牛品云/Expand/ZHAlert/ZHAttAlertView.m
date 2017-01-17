//
//  ZHAttAlertView.m
//  ZHAlertView
//
//  Created by 张慧 on 16/11/2.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import "ZHAttAlertView.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define kAlertWidth 300


@interface ZHAttAlertView ()
@property (nonatomic, strong) UIView    *bgView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *contentLabel;
@property (nonatomic, strong) UIView    *grayHLine;
@property (nonatomic, strong) UIView    *grayVLine;
@property (nonatomic, strong) UIButton  *button;
@end

@implementation ZHAttAlertView
+ (instancetype)alertViewDefault {
    return [[self alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
        //背景视图(300,150)
        self.bgView = [[UIView alloc]init];
        self.bgView.center = self.center;
        self.bgView.bounds = CGRectMake(0, 0, kAlertWidth, 150);
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 10;
        self.bgView.layer.masksToBounds = YES;
        [self addSubview:self.bgView];
        
        //标题
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, kAlertWidth-20, 20)];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        self.titleLabel.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text= @"提示";
        [self.bgView addSubview:self.titleLabel];
        
        //内容
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 55, kAlertWidth-80, 0)];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.contentLabel];
        
        //水平灰线
        self.grayHLine = [[UIView alloc]init];
        self.grayHLine.bounds = CGRectMake(0, 0, kAlertWidth, 0.5);
        self.grayHLine.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
        [self.bgView addSubview:self.grayHLine];
        
        //垂直灰线
        self.grayVLine = [[UIView alloc]init];
        self.grayVLine.bounds = CGRectMake(0, 0, 0.5, 44);
        self.grayVLine.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
        
        
    }
    return self;
}

- (void)show {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
//    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAutoreverse animations:^{
//        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
//    } completion:^(BOOL finished) {
//        self.transform = CGAffineTransformMakeScale(1, 1);
//    }];
    
    if (self.title) {
        self.titleLabel.text= self.title;
    }
    CGRect rect = [self.content boundingRectWithSize:CGSizeMake(kAlertWidth-80, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    self.contentLabel.frame = CGRectMake(40, 55, kAlertWidth-80, rect.size.height+20);
    self.contentLabel.attributedText = self.content;
    
    self.bgView.bounds = CGRectMake(0, 0, kAlertWidth, rect.size.height+95+44);
    self.grayHLine.center = CGPointMake(kAlertWidth/2, rect.size.height+95);
    
    
    //处理按钮
    if (self.buttonArray.count==0) {
        return;
    } else if (self.buttonArray.count==1) {
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, self.grayHLine.frame.origin.y, kAlertWidth, 44);
        [self.button setTitle:self.buttonArray[0] forState:UIControlStateNormal];
        self.button.tag =0;
        [self.button setTitleColor:[UIColor colorWithRed:254/255.0     green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        self.button.titleLabel.font =[UIFont systemFontOfSize:18];
        [self.bgView addSubview:self.button];
        [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (self.buttonArray.count==2) {
        
        for (int i=0; i<self.buttonArray.count; i++) {
            self.button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.bgView addSubview:self.button];
            if (i==0) {
                self.button.frame = CGRectMake(0, self.grayHLine.frame.origin.y, kAlertWidth/2-1, 44);
            } else {
                self.button.frame = CGRectMake(kAlertWidth/2+1, self.grayHLine.frame.origin.y, kAlertWidth/2-1, 44);
            }
            [self.button setTitle:self.buttonArray[i] forState:UIControlStateNormal];
            self.button.tag = i;
            [self.button setTitleColor:[UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1] forState:UIControlStateNormal];
            [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i==self.buttonArray.count-1) {
                [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
        self.grayVLine.center = CGPointMake(kAlertWidth/2, self.grayHLine.frame.origin.y+22);
        [self.bgView addSubview:self.grayVLine];
        
    } else {//3个及以上按钮
        
        for (int i=0; i<self.buttonArray.count; i++) {
            
            self.button = [UIButton buttonWithType:UIButtonTypeCustom];
            self.button.frame = CGRectMake(0, rect.size.height+95+45*i, kAlertWidth, 44);
            [self.bgView addSubview:self.button];
            [self.button setTitle:self.buttonArray[i] forState:UIControlStateNormal];
            self.button.tag = i;
            [self.button setTitleColor:[UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1] forState:UIControlStateNormal];
            [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i==self.buttonArray.count-1) {
                [self.button setTitleColor:[UIColor colorWithRed:254/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
                
            }
            self.bgView.bounds = CGRectMake(0, 0, kAlertWidth, rect.size.height+95+45*self.buttonArray.count);
            
            self.grayHLine = [[UIView alloc]init];
            self.grayHLine.frame = CGRectMake(0, self.button.frame.origin.y+44, kAlertWidth, 0.5);
            self.grayHLine.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
            [self.bgView addSubview:self.grayHLine];
            if (i==self.buttonArray.count-1) {
                self.grayHLine.hidden = YES;
            }
        }
    }
}
- (void)buttonClick:(UIButton *)button {
    if (self.delegate)
    {
        [self.delegate alertView:self clickedCustomButtonAtIndex:button.tag];
    }
    [self removeFromSuperview];
}

- (NSMutableArray *)expandArr {
    if (_expandArr == nil) {
        _expandArr = [NSMutableArray new];
    }
    
    return _expandArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
