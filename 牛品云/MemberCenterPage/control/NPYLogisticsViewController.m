//
//  NPYLogisticsViewController.m
//  牛品云
//
//  Created by Eric on 16/11/23.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYLogisticsViewController.h"
#import "NPYBaseConstant.h"

#import "RightSlidetableViewCell.h"
#import "CommonDefine.h"
#import "TimeModel.h"

#define ExpressUrl @"/index.php/app/Order/get_express"

@interface NPYLogisticsViewController () <UITableViewDelegate,UITableViewDataSource> {
    UIView  *topView;
    UIImageView *goodsImgView;
    UILabel *logisticsStateL;
    UILabel *courierL;
    UILabel *waybillID;
}

@property(strong,nonatomic) UITableView *listTableview;
@property(strong,nonatomic) NSMutableArray *dataList;

@end

@implementation NPYLogisticsViewController

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    self.navigationItem.title = @"物流信息";
    
    self.view.backgroundColor = GRAY_BG;
    
    [self topViewLoad];
    
    [self initView];
    
    [self setData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = NO;
}

//设置UI视图
-(void)initView
{
    self.listTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + 10, ScreenWidth,ScreenHeight - CGRectGetMaxY(topView.frame) - 10) style:UITableViewStylePlain];
    self.listTableview.delegate=self;
    self.listTableview.dataSource=self;
    self.listTableview.showsVerticalScrollIndicator = NO;
    self.listTableview.separatorColor = [UIColor colorWithRed:230/255.0
                                                        green:230/255.0
                                                         blue:230/255.0
                                                        alpha:1.0];
    [self.view addSubview:self.listTableview];
}

//数据
-(void)setData
{
//    self.dataList=[NSMutableArray arrayWithCapacity:0];
//    NSDictionary *dic=@{@"timeStr":@"2016-07-20 16:49:39",@"titleStr":@"[苏州市]江苏省苏州市高新区科技城分部公司 已签收 签收人：本人 感谢使用顺丰快递，期待再次为您服务",@"detailSrtr":@"",@"isTop":@"YES"};
//    TimeModel *model=[[TimeModel alloc]initData:dic];
//    [self.dataList addObject:model];
//    
//    NSDictionary *dic2=@{@"timeStr":@"2016-07-21",@"titleStr":@"[苏州市]江苏省苏州市高新区科技城分部公司 已签收 签收人：本人 感谢使用顺丰快递，期待再次为您服务"};
//    TimeModel *model2=[[TimeModel alloc]initData:dic2];
//    [self.dataList addObject:model2];
//    
//    NSDictionary *dic3=@{@"timeStr":@"2016-07-22",@"titleStr":@"[苏州市]江苏省苏州市高新区科技城分部公司 已签收 签收人：本人 感谢使用顺丰快递，期待再次为您服务",};
//    TimeModel *model3=[[TimeModel alloc]initData:dic3];
//    [self.dataList addObject:model3];
//    
//    NSDictionary *dic4=@{@"timeStr":@"2016-07-23",@"titleStr":@"[苏州市]江苏省苏州市高新区科技城分部公司 已签收 签收人：本人 感谢使用顺丰快递，期待再次为您服务"};
//    TimeModel *model4=[[TimeModel alloc]initData:dic4];
//    [self.dataList addObject:model4];
//    
//    NSDictionary *dic5=@{@"timeStr":@"2016-07-24",@"titleStr":@"[苏州市]江苏省苏州市高新区科技城分部公司 已签收 签收人：本人 感谢使用顺丰快递，期待再次为您服务"};
//    TimeModel *model5=[[TimeModel alloc]initData:dic5];
//    [self.dataList addObject:model5];
//    NSDictionary *dic6=@{@"timeStr":@"2016-07-25",@"titleStr":@"[苏州市]江苏省苏州市高新区科技城分部公司 已签收 签收人：本人 感谢使用顺丰快递，期待再次为您服务"};
//    TimeModel *model6=[[TimeModel alloc]initData:dic6];
//    [self.dataList addObject:model6];
//    NSDictionary *dic7=@{@"timeStr":@"2016-07-26",@"titleStr":@"[苏州市]江苏省苏州市高新区科技城分部公司 已签收 签收人：本人 感谢使用顺丰快递，期待再次为您服务",@"isEnd":@"YES"};
//    TimeModel *model7=[[TimeModel alloc]initData:dic7];
//    [self.dataList addObject:model7];
//    [self.listTableview reloadData];
    
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"sign"],@"sign",model.user_id,@"user_id",self.order_id,@"order_id", nil];
    
    [self requestLogisticsInfoWithUrlString:ExpressUrl withParames:request];
    
}
#pragma mark-----------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"testTime";
//    RightSlidetableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    RightSlidetableViewCell *cell = [RightSlidetableViewCell new];
    if (!cell) {
        cell=[[RightSlidetableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    TimeModel *model=self.dataList[indexPath.row];
    cell.model = model;
    self.listTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeModel *model=self.dataList[indexPath.row];
    NSDictionary *fontDic=@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize size1=CGSizeMake(WIDTH_OF_PROCESS_LABLE,0);
    CGSize titleLabelSize=[model.detailSrtr boundingRectWithSize:size1 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading   attributes:fontDic context:nil].size;
    
    if (titleLabelSize.height < 15) {
        titleLabelSize.height = 40;
    }else{
        titleLabelSize.height = titleLabelSize.height + 30;
    }
    return titleLabelSize.height + 50;
    
}

- (void)topViewLoad {
    //topView
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, _isManyOrder ? 0 : 65, WIDTH_SCREEN, 90)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.borderColor = GRAY_BG.CGColor;
    topView.layer.borderWidth = 0.5;
    [self.view addSubview:topView];
    //
    goodsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 15, 60, 60)];
    [goodsImgView sd_setImageWithURL:[NSURL new] placeholderImage:[UIImage imageNamed:@"anli1_gouwu"]];
    goodsImgView.contentMode = UIViewContentModeScaleToFill;
    goodsImgView.layer.borderWidth = 0.5;
    goodsImgView.layer.borderColor = GRAY_BG.CGColor;
    [topView addSubview:goodsImgView];
    //
    UILabel *stateL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImgView.frame) + 10, CGRectGetMinY(goodsImgView.frame), 70, 20)];
    stateL.text = @"物流状态";
    stateL.textColor = [UIColor blackColor];
    stateL.font = [UIFont systemFontOfSize:15.0];
    [topView addSubview:stateL];
    
    logisticsStateL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stateL.frame), CGRectGetMinY(stateL.frame), WIDTH_SCREEN, CGRectGetHeight(stateL.frame))];
    logisticsStateL.text = @"已签收";
    logisticsStateL.textColor = XNColor(248, 31, 31, 1);
    logisticsStateL.font = [UIFont systemFontOfSize:15.0];
    [topView addSubview:logisticsStateL];
    //
    UILabel *courier = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImgView.frame) + 10, CGRectGetMaxY(stateL.frame) + Height_Space, CGRectGetWidth(stateL.frame), 20)];
    courier.text = @"承运公司：";
    courier.textColor = XNColor(153, 153, 153, 1);
    courier.font = [UIFont systemFontOfSize:13.0];
    [topView addSubview:courier];
    
    courierL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(courier.frame), CGRectGetMinY(courier.frame), WIDTH_SCREEN, CGRectGetHeight(stateL.frame))];
    courierL.text = @"顺丰快递";
    courierL.textColor = XNColor(153, 153, 153, 1);
    courierL.font = [UIFont systemFontOfSize:13.0];
    [topView addSubview:courierL];
    //
    UILabel *waybillIDL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImgView.frame) + 10, CGRectGetMaxY(courier.frame) + Height_Space, CGRectGetWidth(stateL.frame), 20)];
    waybillIDL.text = @"运单编号：";
    waybillIDL.textColor = XNColor(153, 153, 153, 1);
    waybillIDL.font = [UIFont systemFontOfSize:13.0];
    [topView addSubview:waybillIDL];
    
    waybillID = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(waybillIDL.frame), CGRectGetMinY(waybillIDL.frame), WIDTH_SCREEN, CGRectGetHeight(stateL.frame))];
    waybillID.text = @"26554646516546646165";
    waybillID.textColor = XNColor(153, 153, 153, 1);
    waybillID.font = [UIFont systemFontOfSize:13.0];
    [topView addSubview:waybillID];
}

#pragma mark - 更改tableView的分割线顶格显示
- (void)viewDidLayoutSubviews
{
    if ([self.listTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableview setSeparatorInset:UIEdgeInsetsMake(0,60,0,0)];
    }
    
    if ([self.listTableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.listTableview setLayoutMargins:UIEdgeInsetsMake(0,60,0,0)];
    }
}

- (void)requestLogisticsInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            NSDictionary *tpDict = dataDict[@"data"];
            
            courierL.text = [tpDict valueForKey:@"courier_company"];//快递公司
            
            if ([tpDict valueForKey:@"status"]) {
                logisticsStateL.text = @"已签收";
            } else {
                logisticsStateL.text = @"运输中";
            }
            
//            NSDictionary *dic=@{@"timeStr":@"2016-07-20 16:49:39",@"titleStr":@"[苏州市]江苏省苏州市高新区科技城分部公司 已签收 签收人：本人 感谢使用顺丰快递，期待再次为您服务",@"detailSrtr":@"",@"isTop":@"YES"};
            //    TimeModel *model=[[TimeModel alloc]initData:dic];
            
            self.dataList=[NSMutableArray arrayWithCapacity:0];
            
            NSArray *tpArr = [[tpDict valueForKey:@"list"] copy];
            for (int i = 0; i < tpArr.count; i++) {
                NSDictionary *tpData = tpArr[i];
                TimeModel *model;
                if (i == 0) {
                    NSDictionary *dic=@{@"timeStr":[tpData valueForKey:@"time"],@"titleStr":[tpData valueForKey:@"context"],@"isTop":@"YES"};
                    model=[[TimeModel alloc]initData:dic];
                    
                } else if (i == tpArr.count - 1) {
                    NSDictionary *dic=@{@"timeStr":[tpData valueForKey:@"time"],@"titleStr":[tpData valueForKey:@"context"],@"isEnd":@"YES"};
                    model=[[TimeModel alloc]initData:dic];
                    
                } else {
                    NSDictionary *dic=@{@"timeStr":[tpData valueForKey:@"time"],@"titleStr":[tpData valueForKey:@"context"]};
                   model =[[TimeModel alloc]initData:dic];
                    
                }
                
                [self.dataList addObject:model];
            }
            
            [self.listTableview reloadData];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
