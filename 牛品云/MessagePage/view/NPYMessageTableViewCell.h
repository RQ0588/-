//
//  NPYMessageTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/12/21.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYBaseConstant.h"

@protocol MessageTableViewCellDelegate <NSObject>

@optional
- (void)acceptButtonPressedWithCellIndex:(int)index;
- (void)refuseButtonPressedWithCellIndex:(int)index;

@end

@interface NPYMessageTableViewCell : UITableViewCell

@property (nonatomic, assign) int typeIndex;
@property (nonatomic, assign) int cellIndex;

@property (nonatomic, weak) id<MessageTableViewCellDelegate>delegate;

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
