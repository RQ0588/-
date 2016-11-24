//
//  NPYAddressTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/11/10.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPYAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary  *dataDic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
