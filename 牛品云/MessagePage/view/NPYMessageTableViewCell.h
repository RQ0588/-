//
//  NPYMessageTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/12/21.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYBaseConstant.h"

@interface NPYMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mesIcon;
@property (weak, nonatomic) IBOutlet UILabel *mesTitle;
@property (weak, nonatomic) IBOutlet UILabel *mesContent;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UILabel *mesStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;

- (IBAction)acceptButtonEvent:(id)sender;
- (IBAction)refuseButtonEvent:(id)sender;

@end
