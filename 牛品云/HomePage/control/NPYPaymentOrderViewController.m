//
//  NPYPaymentOrderViewController.m
//  牛品云
//
//  Created by Eric on 16/11/14.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYPaymentOrderViewController.h"
#import "NPYBaseConstant.h"
#import "NPYSuccessPaymentViewController.h"

#import <AlipaySDK/AlipaySDK.h> //支付宝支付
#import "WXApi.h"   //微信支付

@interface NPYPaymentOrderViewController () <UITableViewDelegate,UITableViewDataSource,WXApiDelegate> {
    UITableView *mainTableView;
    
    UILabel *orderIDL,*payAmountL;
    
    NSArray *cellImages,*cellNames;
    NSInteger oldSelectBtnTag;
    
    UIImageView *topLineImg;
}

@property (nonatomic, strong) NPYSuccessPaymentViewController   *sucPayVC;

@end

@implementation NPYPaymentOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [topLineImg removeFromSuperview];
    topLineImg = nil;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"支付订单";
    
    self.view.backgroundColor = GRAY_BG;
    
    cellImages = @[@"weixin_zhifu-",@"zhifubao_zhifu"];
    cellNames = @[@"微信支付",@"支付宝支付"];
    
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0]};
    
    topLineImg = [[UIImageView alloc] init];
    topLineImg.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height - 1, WIDTH_SCREEN, 1);
    topLineImg.image = [UIImage imageNamed:@"750huixian_88"];
    [self.navigationController.navigationBar addSubview:topLineImg];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    [self mainViewLoad];
    
    [self bottomViewLoad];
}

- (void)mainViewLoad {
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStylePlain];
    [self.view addSubview:mainTableView];
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.backgroundColor = [UIColor clearColor];
}

- (void)bottomViewLoad {
    UIButton *CPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 330, WIDTH_SCREEN - 24, 43)];
    [CPayBtn setBackgroundImage:[UIImage imageNamed:@"querenkuang_zhifu"] forState:UIControlStateNormal];
    [CPayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [CPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CPayBtn.titleLabel.font = XNFont(18.0);
    [CPayBtn addTarget:self action:@selector(ConfirmThePaymentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mainTableView addSubview:CPayBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellNames.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    mainTableView.tableHeaderView = headerView;
    headerView.backgroundColor = GRAY_BG;
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(3, 16, headerView.frame.size.width - 6, 123);
    bgImgView.image = [UIImage imageNamed:@"zhifubeijing_gouwu"];
    [headerView addSubview:bgImgView];
    
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.frame = CGRectMake(28, CGRectGetMidY(bgImgView.frame), headerView.frame.size.width - 56, 1);
    lineImg.image = [UIImage imageNamed:@"zhifuhuixian_gouwu"];
    [headerView addSubview:lineImg];
    
    UILabel *orderId = [[UILabel alloc] initWithFrame:CGRectMake(31, 44, 100, 20)];
    [headerView addSubview:orderId];
    orderId.text = @"订单编号：";
    orderId.textColor = XNColor(17, 17, 17, 1);
    orderId.font = [UIFont systemFontOfSize:15.0];
    
    orderIDL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(orderId.frame), CGRectGetMinY(orderId.frame), 200, 20)];
    [headerView addSubview:orderIDL];
    orderIDL.text = self.order_id;
    orderIDL.textColor = XNColor(17, 17, 17, 1);
    orderIDL.textAlignment = NSTextAlignmentCenter;
    orderIDL.font = [UIFont systemFontOfSize:15.0];
    
    UILabel *payAmount = [[UILabel alloc] initWithFrame:orderId.frame];
    [headerView addSubview:payAmount];
    payAmount.text = @"支付金额：";
    payAmount.textColor = XNColor(17, 17, 17, 1);
    payAmount.font = [UIFont systemFontOfSize:15.0];
    payAmount.center = CGPointMake(CGRectGetMidX(orderId.frame), CGRectGetMaxY(orderId.frame) + 32 + CGRectGetHeight(payAmount.frame) / 2);
    
    payAmountL = [[UILabel alloc] initWithFrame:orderIDL.frame];
    [headerView addSubview:payAmountL];
    payAmountL.text = [NSString stringWithFormat:@"￥%@",self.price];
    payAmountL.textColor = XNColor(17, 17, 17, 1);
    payAmountL.textAlignment = NSTextAlignmentCenter;
    payAmountL.font = [UIFont systemFontOfSize:15.0];
    payAmountL.center = CGPointMake(CGRectGetMidX(orderIDL.frame), CGRectGetMaxY(orderIDL.frame) + 32 + CGRectGetHeight(payAmountL.frame) / 2);
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mainCell";
    UITableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!mainCell) {
        mainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if (indexPath.row == 0) {
            mainCell.textLabel.text = @"选择支付方式";
            mainCell.textLabel.textColor = XNColor(102, 102, 102, 1);
            mainCell.textLabel.font = [UIFont systemFontOfSize:13.0];
        } else {
        
            mainCell.imageView.image = [UIImage imageNamed:cellImages[indexPath.row - 1]];
            mainCell.textLabel.text = cellNames[indexPath.row - 1];
            mainCell.textLabel.textColor = XNColor(17, 17, 17, 1);
            mainCell.textLabel.font = [UIFont systemFontOfSize:16.0];
            
            UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - 40, 0, 20, 20)];
            [mainCell addSubview:selectBtn];
            selectBtn.tag = indexPath.row + 1000;
            [selectBtn setImage:[UIImage imageNamed:@"xuanze_fou"] forState:UIControlStateNormal];
            [selectBtn setImage:[UIImage imageNamed:@"xuanze_shi"] forState:UIControlStateSelected];
            selectBtn.center = CGPointMake(CGRectGetMidX(selectBtn.frame), CGRectGetHeight(mainCell.frame) / 2);
            [selectBtn addTarget:self action:@selector(selectButtonChangePaymentWay:) forControlEvents:UIControlEventTouchUpInside];
            if (indexPath.row == 1) {
                selectBtn.selected = YES;
                oldSelectBtnTag = selectBtn.tag;
            } else {
                selectBtn.selected = NO;
            }
        }
    }
    
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return mainCell;
}

#pragma mark - UIButton Event

- (void)selectButtonChangePaymentWay:(UIButton *)btn {
    if (oldSelectBtnTag == btn.tag) {
//        NSLog(@"选择微信支付");
        [ZHProgressHUD showMessage:@"暂未开通，敬请期待" inView:self.view];
        return;
    }
    
    btn.selected = YES;
    
    UIButton *oldBtn = [self.view viewWithTag:oldSelectBtnTag];
    oldBtn.selected = NO;
    
    oldSelectBtnTag = btn.tag;
}

- (void)ConfirmThePaymentButtonPressed:(UIButton *)btn {
//    NSLog(@"确定支付...");
    
    if (oldSelectBtnTag == 1001) {
        //微信支付
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = @"商家id";
        request.prepayId = @"预支付订单";
        request.package = @"财付通的数据和签名";
        request.sign = @"微信平台的数据签名";
        request.nonceStr = @"随机串，防重发";
        request.timeStamp = [@"时间戳，防重发" intValue];
        [WXApi sendReq:request];
        [ZHProgressHUD showMessage:@"暂未开通，敬请期待" inView:self.view];
    }
    
    if (oldSelectBtnTag == 1002) {
        //支付宝支付
        [self requestAliOrderString];
        
    }
    
}

#pragma mark - 微信支付结果回调
-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp*)resp;
        switch(response.errCode){
            caseWXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
                
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

#pragma mark - 更改tableView的分割线顶格显示
- (void)viewDidLayoutSubviews
{
    if ([mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - ...

- (void)requestAliOrderString {
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:self.sign,@"sign",self.user_id,@"user_id",self.order_type,@"order_type",self.order_id,@"order_id", nil];
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:requestDic] forKey:@"data"];
    
   [[NPYHttpRequest sharedInstance] getWithUrlString:@"http://npy.cq-vip.com/index.php/app/Alipay/home" parameters:paremes success:^(id responseObject) {
       
       NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
       
       if ([dataDict[@"r"] intValue] != 1) {
           [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
           return ;
           
       }
       
       NSString *appScheme = @"com.npy.niupinyun";    //应用注册scheme，在info。plist定义URL types
       NSString *orderString = [dataDict valueForKey:@"data"];
       
       // NOTE: 调用支付结果开始支付
       [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
           
           if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000) {
               self.sucPayVC = [[NPYSuccessPaymentViewController alloc] init];
               [self.navigationController pushViewController:self.sucPayVC animated:YES];
               
           }
           
       }];
       
       
   } failure:^(NSError *error) {
       
   }];
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
