//
//  NPYSupporMidTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/12/6.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYDicMainCellModel.h"

@protocol SupportMidTableViewCellDelegate <NSObject>

- (void)passTotalPriceToSuperView:(NSString *)totalPrice withBuyNumber:(int)buyNum;

@end

@interface NPYSupporMidTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SupportMidTableViewCellDelegate>delegate;

@property (nonatomic, strong) NPYDicMainCellModel *model;

@property (nonatomic, assign) int countValue;               //购买的数量
@property (nonatomic, assign) int surplusValue;             //剩余可购买的数量

@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceL;
- (IBAction)cutButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *buyNumberL;
- (IBAction)addButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *totalBuyNumberL;
@property (weak, nonatomic) IBOutlet UILabel *supporL;

@end
