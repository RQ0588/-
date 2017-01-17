//
//  NPYSupportViewController.h
//  牛品云
//
//  Created by Eric on 16/12/6.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYDicMainCellModel.h"

@interface NPYSupportViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) NPYDicMainCellModel *model;

@property (nonatomic, assign) int supportNumber;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceL;
- (IBAction)supportButtonPressed:(id)sender;

@end
