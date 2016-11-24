//
//  NPYAddAddressViewController.h
//  牛品云
//
//  Created by Eric on 16/11/10.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol passValueToBackDeleagate<NSObject>

- (void)passValueToParentView:(NSInteger)index andValue:(NSDictionary *)dic;

- (void)passDeleteIndexToParentView:(NSInteger)index;

@end

@interface NPYAddressDetailViewController : UIViewController

@property (nonatomic, retain) id<passValueToBackDeleagate> delegate;

@property (nonatomic, assign) BOOL isEdit;

@end
