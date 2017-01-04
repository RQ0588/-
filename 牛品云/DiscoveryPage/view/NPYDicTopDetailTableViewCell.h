//
//  NPYDicTopDetailTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/12/2.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYDicHomeModel.h"

@protocol lookImageInfoDelegate <NSObject>

- (void)pushToImageInfoViewController;

@end

@interface NPYDicTopDetailTableViewCell : UITableViewCell

@property (nonatomic, weak) id<lookImageInfoDelegate>delegate;

@property (nonatomic, strong) NPYDicHomeModel *homeModel;

@property (weak, nonatomic) IBOutlet UIImageView *topADImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *personIcon;
@property (weak, nonatomic) IBOutlet UIProgressView *proView;
@property (weak, nonatomic) IBOutlet UILabel *personNumber;
@property (weak, nonatomic) IBOutlet UILabel *cllectPrice;
@property (weak, nonatomic) IBOutlet UILabel *proValue;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UIButton *lookImg;
@property (weak, nonatomic) IBOutlet UILabel *endTime;

- (IBAction)lookImageButtonPressed:(id)sender;

@end
