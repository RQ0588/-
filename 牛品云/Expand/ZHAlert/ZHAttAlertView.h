//
//  ZHAttAlertView.h
//  ZHAlertView
//
//  Created by 张慧 on 16/11/2.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHAttAlertView;

@protocol ZHAttAlertDelegate <NSObject>
@optional

- (void)alertView:(ZHAttAlertView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex;


@end

@interface ZHAttAlertView : UIView

/** 标题(默认“提示”)*/
@property (nonatomic, copy) NSString    *title;
/** 内容 */
@property (nonatomic, copy) NSAttributedString    *content;
/** 按钮名字数组 */
@property (nonatomic, strong)NSArray    *buttonArray;

@property (weak, nonatomic) id <ZHAttAlertDelegate> delegate;

+ (instancetype)alertViewDefault;
- (void)show;
@end
