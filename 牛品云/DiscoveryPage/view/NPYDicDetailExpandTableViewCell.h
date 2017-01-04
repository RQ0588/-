//
//  NPYDicDetailExpandTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/12/17.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYBaseConstant.h"
#import "NPYDicMainCellModel.h"

@interface NPYDicDetailExpandTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIImageView *detaiImage;

@property (nonatomic, strong) NPYDicMainCellModel *model;

@end
