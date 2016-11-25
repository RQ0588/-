//
//  NPYPlaceHolderTextView.h
//  牛品云
//
//  Created by Eric on 16/11/25.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPYPlaceHolderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

- (void)textChanged:(NSNotification *)notification;

@end
