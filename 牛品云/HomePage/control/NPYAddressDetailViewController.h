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

@property (nonatomic, strong) NSString *isDefault;

@property (nonatomic, strong) NSString *address_id;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@property (nonatomic, retain) id<passValueToBackDeleagate> delegate;

@property (nonatomic, assign) BOOL isEdit;

@end
