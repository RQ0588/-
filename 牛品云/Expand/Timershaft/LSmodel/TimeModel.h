//
//  TimeModel.h
//  iOS 自定义时间轴
//
//  Created by Apple on 16/7/26.
//  Copyright © 2016年 zls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeModel : NSObject
@property(strong,nonatomic) NSString *timeStr;  //时间
@property(strong,nonatomic) NSString *titleStr; //标题
@property(strong,nonatomic) NSString *detailSrtr; //平均分
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isEnd;

-(instancetype)initData:(NSDictionary*)dic;
@end
