//
//  ShowTimeViewController.m
//  iOS 自定义时间轴
//
//  Created by Apple on 16/7/26.
//  Copyright © 2016年 zls. All rights reserved.
//

#import "ShowTimeViewController.h"
#import "RightSlidetableViewCell.h"
#import "CommonDefine.h"
#import "TimeModel.h"

@interface ShowTimeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView *listTableview;
@property(strong,nonatomic) NSMutableArray *dataList;

@end

@implementation ShowTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"时间轴";
    self.view.backgroundColor=[UIColor whiteColor];
    [self initView];
    [self setData];
}
//设置UI视图
-(void)initView
{
    self.listTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight) style:UITableViewStylePlain];
    self.listTableview.delegate=self;
    self.listTableview.dataSource=self;
    [self.view addSubview:self.listTableview];
}

//数据
-(void)setData
{
    self.dataList=[NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic=@{@"timeStr":@"2016-07-20",@"titleStr":@"第一步",@"detailSrtr":@"标题:关于zls是不是宇宙最帅的讨论"};
    TimeModel *model=[[TimeModel alloc]initData:dic];
    [self.dataList addObject:model];
    
    NSDictionary *dic2=@{@"timeStr":@"2016-07-21",@"titleStr":@"第二步",@"detailSrtr":@"关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论"};
    TimeModel *model2=[[TimeModel alloc]initData:dic2];
    [self.dataList addObject:model2];
    
    NSDictionary *dic3=@{@"timeStr":@"2016-07-22",@"titleStr":@"第三步",@"detailSrtr":@"关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论"};
    TimeModel *model3=[[TimeModel alloc]initData:dic3];
    [self.dataList addObject:model3];
    
    NSDictionary *dic4=@{@"timeStr":@"2016-07-23",@"titleStr":@"第四步",@"detailSrtr":@"关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论"};
    TimeModel *model4=[[TimeModel alloc]initData:dic4];
    [self.dataList addObject:model4];
    
    NSDictionary *dic5=@{@"timeStr":@"2016-07-24",@"titleStr":@"第五步",@"detailSrtr":@"关于zls是不是宇宙最帅的讨论"};
    TimeModel *model5=[[TimeModel alloc]initData:dic5];
    [self.dataList addObject:model5];
    NSDictionary *dic6=@{@"timeStr":@"2016-07-25",@"titleStr":@"第六步",@"detailSrtr":@"关于zls是不是宇宙最帅的讨论是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论"};
    TimeModel *model6=[[TimeModel alloc]initData:dic6];
    [self.dataList addObject:model6];
    NSDictionary *dic7=@{@"timeStr":@"2016-07-26",@"titleStr":@"第七步",@"detailSrtr":@"关于zls是不是宇宙最帅的讨论帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论关于zls是不是宇宙最帅的讨论"};
    TimeModel *model7=[[TimeModel alloc]initData:dic7];
    [self.dataList addObject:model7];
    [self.listTableview reloadData];
    
}
#pragma mark-----------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"testTime";
    RightSlidetableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[RightSlidetableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    TimeModel *model=self.dataList[indexPath.row];
    cell.model = model;
    self.listTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     TimeModel *model=self.dataList[indexPath.row];
    NSDictionary *fontDic=@{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGSize size1=CGSizeMake(WIDTH_OF_PROCESS_LABLE,0);
    CGSize titleLabelSize=[model.detailSrtr boundingRectWithSize:size1 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading   attributes:fontDic context:nil].size;
    if (titleLabelSize.height < 15) {
        titleLabelSize.height = 40;
    }else{
        titleLabelSize.height = titleLabelSize.height + 30;
    }
    return titleLabelSize.height + 50;
   
}


@end
