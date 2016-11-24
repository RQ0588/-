//
//  NPYSettingTVCell.h
//  牛品云
//
//  Created by Eric on 16/11/21.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPYSettingTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *funName;
@property (weak, nonatomic) IBOutlet UIImageView *headPortrait;

@property (nonatomic, strong) NSArray *dataArray;

@end
