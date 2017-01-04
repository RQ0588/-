//
//  NPYFeatureStoreTVCell.h
//  牛品云
//
//  Created by Eric on 16/10/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPYShopModel.h"

@protocol PassMainTableViewValueDelegate <NSObject>

- (void)passButtonTag:(NSInteger)index withPressedButtonTag:(NSInteger)tag;

@end

@interface NPYFeatureStoreTVCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NPYShopModel *model;

@property (nonatomic, retain) id<PassMainTableViewValueDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
