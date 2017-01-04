//
//  NPYSpecViewController.h
//  牛品云
//
//  Created by Eric on 16/12/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol popValueToSuperViewDelegate <NSObject>

- (void)popValue:(NSDictionary *)dataDict withNumber:(int)number;

@end

@interface NPYSpecViewController : UIViewController

@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *goodsID;
@property (nonatomic, strong) NSString *goodsIconUrl;
@property (nonatomic, strong) NSString *storNumber;

@property (nonatomic, assign) int isSlected;

@property (nonatomic, weak) id<popValueToSuperViewDelegate>delegate;

@end
