//
//  NPYAddressTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/11/10.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYAddressModel.h"

@protocol editButtonPressedEventDelegate <NSObject>

- (void)passCellIndex:(NSInteger)index;

@end

@interface NPYAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) NPYAddressModel  *model;
@property (nonatomic, assign) NSInteger     index;

@property (nonatomic, retain) id<editButtonPressedEventDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
