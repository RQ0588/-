//
//  NPYTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/11/30.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPYGoodsDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *buyTime;
@property (weak, nonatomic) IBOutlet UIImageView *startOne;
@property (weak, nonatomic) IBOutlet UIImageView *startTwo;
@property (weak, nonatomic) IBOutlet UIImageView *startThree;
@property (weak, nonatomic) IBOutlet UIImageView *startFour;
@property (weak, nonatomic) IBOutlet UIImageView *startFive;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImgOne;
@property (weak, nonatomic) IBOutlet UIImageView *showImgTwo;
@property (weak, nonatomic) IBOutlet UIImageView *showImgThree;

@end
