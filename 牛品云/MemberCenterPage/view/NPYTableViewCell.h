//
//  NPYTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/11/22.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYMyOrderModel.h"

@protocol MyOrederTableViewCellDelegate <NSObject>
@optional
- (void)cellButtonEventWithType:(int)typeValue withIndexPath:(NSIndexPath *)path;

- (void)cellLeftButtonEventWithType:(int)typeValue withIndexPath:(NSIndexPath *)path;

@end

@interface NPYTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MyOrederTableViewCellDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *cellPath;

@property (nonatomic, strong) NPYMyOrderModel *model;

@property (nonatomic, assign) BOOL isManyOrder;

@property (weak, nonatomic) IBOutlet UIImageView *shopIcon;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *buyNumber;
@property (weak, nonatomic) IBOutlet UILabel *goddsPrice;
@property (weak, nonatomic) IBOutlet UIButton *delOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

- (IBAction)oneButton:(id)sender;

- (IBAction)twoButton:(id)sender;


@end
