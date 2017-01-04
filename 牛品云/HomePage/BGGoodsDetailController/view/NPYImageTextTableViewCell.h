//
//  NPYImageTextTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/12/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYBaseConstant.h"

@interface NPYImageTextTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *imgUrlStr;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
