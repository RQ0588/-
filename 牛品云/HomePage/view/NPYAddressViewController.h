//
//  NPYAddressViewController.h
//  牛品云
//
//  Created by Eric on 16/11/10.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressValueToSuperViewDelegate <NSObject>

- (void)popValue:(NSDictionary *)dic;

@end

@interface NPYAddressViewController : UIViewController

@property (nonatomic, weak) id<AddressValueToSuperViewDelegate>delegate;

@end
