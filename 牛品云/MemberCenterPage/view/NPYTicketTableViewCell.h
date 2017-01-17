//
//  NPYTicketTableViewCell.h
//  牛品云
//
//  Created by Eric on 17/1/6.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYBaseConstant.h"
#import "NPYTicketModel.h"

@interface NPYTicketTableViewCell : UITableViewCell

@property (nonatomic, strong) NPYTicketModel *ticketModel;

@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *detailName;
@property (weak, nonatomic) IBOutlet UILabel *endTimeL;

@end
