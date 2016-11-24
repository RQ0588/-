//
//  NPYProductDetailView.h
//  牛品云
//
//  Created by Eric on 16/11/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPYProductDetailView : UIView    //图文详情

@property (nonatomic, strong) NSString *imgName;

- (CGFloat)calculateHeightOfView;

@end
