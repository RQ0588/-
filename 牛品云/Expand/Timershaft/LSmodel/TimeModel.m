//
//  TimeModel.m
//  iOS 自定义时间轴
//
//  Created by Apple on 16/7/26.
//  Copyright © 2016年 zls. All rights reserved.
//

#import "TimeModel.h"

@implementation TimeModel
-(instancetype)initData:(NSDictionary*)dic
{
    if (self=[super init]) {
        self.timeStr=[dic objectForKey:@"timeStr"];
        self.titleStr=[dic objectForKey:@"titleStr"];
        self.detailSrtr=[dic objectForKey:@"detailSrtr"];
        self.isTop = [dic objectForKey:@"isTop"];
        self.isEnd = [dic objectForKey:@"isEnd"];
    }
    return self;
}
@end
