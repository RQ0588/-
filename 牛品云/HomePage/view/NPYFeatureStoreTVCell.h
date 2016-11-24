//
//  NPYFeatureStoreTVCell.h
//  牛品云
//
//  Created by Eric on 16/10/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassMainTableViewValueDelegate <NSObject>

- (void)passButtonTag:(NSInteger)tag withButtonTitle:(NSString *)title;

@end

@interface NPYFeatureStoreTVCell : UITableViewCell

@property (nonatomic, retain) id<PassMainTableViewValueDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
