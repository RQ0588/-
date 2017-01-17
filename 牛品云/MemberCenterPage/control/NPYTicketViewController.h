//
//  NPYTicketViewController.h
//  牛品云
//
//  Created by Eric on 17/1/4.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYBaseConstant.h"
#import "NPYTicketModel.h"

@protocol TicketViewControllerDelegate <NSObject>

- (void)selectedTicketAtIndexPath:(NSIndexPath *)indexPath withTicketInfo:(NPYTicketModel *)ticketModel;

@end

@interface NPYTicketViewController : UIViewController

@property (nonatomic, assign) BOOL isTicketManage;
@property (nonatomic, assign) BOOL isSelectTicket;

@property (nonatomic, strong) NSIndexPath *selectedIndex;

@property (nonatomic, weak) id<TicketViewControllerDelegate>delegate;

@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *shop_id;

@end
