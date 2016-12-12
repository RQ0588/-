//
//  NPYDicTopDetailTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/12/2.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol lookImageInfoDelegate <NSObject>

- (void)pushToImageInfoViewController;

@end

@interface NPYDicTopDetailTableViewCell : UITableViewCell

@property (nonatomic, weak) id<lookImageInfoDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *topADImg;
@property (weak, nonatomic) IBOutlet UIImageView *personIcon;
@property (weak, nonatomic) IBOutlet UIProgressView *proView;
@property (weak, nonatomic) IBOutlet UILabel *personNumber;
@property (weak, nonatomic) IBOutlet UILabel *cllectPrice;
@property (weak, nonatomic) IBOutlet UILabel *proValue;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UIButton *lookImg;

- (IBAction)lookImageButtonPressed:(id)sender;

@end
