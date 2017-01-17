//
//  NPYSpecViewController.h
//  牛品云
//
//  Created by Eric on 16/12/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol popValueToSuperViewDelegate <NSObject>

- (void)popValue:(NSDictionary *)dataDict withNumber:(int)number;

- (void)popValue:(NSDictionary *)dataDict withNumber:(int)number withIndex:(NSIndexPath *)indexPath;

@end

@interface NPYSpecViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *buyNumberShow;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *buyNumberL;
@property (weak, nonatomic) IBOutlet UILabel *buyNumber_lab;
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *goodsID;
@property (nonatomic, strong) NSString *goodsIconUrl;
@property (nonatomic, strong) NSString *storNumber;

@property (nonatomic, assign) int isSlected;

@property (nonatomic, weak) id<popValueToSuperViewDelegate>delegate;

@end
