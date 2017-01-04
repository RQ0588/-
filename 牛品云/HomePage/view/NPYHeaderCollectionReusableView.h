//
//  NPYHeaderCollectionReusableView.h
//  牛品云
//
//  Created by Eric on 16/12/24.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadMoreDataDelegate <NSObject>

- (void)pushToNewViewController;

@end

@interface NPYHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) BOOL isHiddenAll;

@property (nonatomic, assign) BOOL isHideMore;

@property (nonatomic, weak) id<LoadMoreDataDelegate>delegate;

@end
