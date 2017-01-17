//
//  NPYSupporTopTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/12/6.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYAddressModel.h"

@interface NPYSupporTopTableViewCell : UITableViewCell

@property (nonatomic, strong) NPYAddressModel *model;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;

@end
