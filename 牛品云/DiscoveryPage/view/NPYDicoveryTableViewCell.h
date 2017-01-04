//
//  NPYDicoveryTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/12/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYBaseConstant.h"
#import "NPYDicHomeModel.h"

@interface NPYDicoveryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *topTitle;
@property (weak, nonatomic) IBOutlet UILabel *remainingL;
@property (weak, nonatomic) IBOutlet UILabel *peopleL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *progressL;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) NPYDicHomeModel *homeModel;

@end
