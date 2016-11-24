//
//  ZHActionSheetView.h
//  ZHAlertView
//
//  Created by 张慧 on 16/11/2.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DownSheetDelegate <NSObject>

-(void)didSelectIndex : (NSInteger) index;

@end
@interface ZHActionSheetView : UIView
@property (nonatomic , strong) id<DownSheetDelegate> delegate;

-(id)initWithList : (NSArray *)list title : (NSString *) title;

-(void) showInView : (UIViewController *)controller;
@end
