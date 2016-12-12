//
//  starView.h
//  hahh
//
//  Created by 窦心东 on 2016/11/15.
//  Copyright © 2016年 窦心东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface starView : UIView

/** imageView1 */
@property (nonatomic,strong) UIImageView *starImageView1;
/** imageView2 */
@property (nonatomic,strong) UIImageView *starImageView2;
/** imageView3 */
@property (nonatomic,strong) UIImageView *starImageView3;
/** imageView4 */
@property (nonatomic,strong) UIImageView *starImageView4;
/** imageView5 */
@property (nonatomic,strong) UIImageView *starImageView5;
/** 星星的背景view */
@property(strong,nonatomic) UIView *star_bgView;
/** 计数label */
@property (nonatomic,strong) UILabel *number_label;
/** fell_label */
@property (nonatomic,strong) UILabel *fell_label;

@property (nonatomic, strong) UILabel *title_label;

@property NSInteger count;
@property BOOL can_changeStarNum;
@end
