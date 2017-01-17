//
//  NPYVacciniaViewController.h
//  牛品云
//
//  Created by Eric on 16/12/20.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPYVacciniaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *mainScroller;

- (IBAction)shareButtonPressed:(id)sender;

- (IBAction)wxClick:(id)sender;
- (IBAction)wxFriendClick:(id)sender;
- (IBAction)wbClick:(id)sender;

@end
