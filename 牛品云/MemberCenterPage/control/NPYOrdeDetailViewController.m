//
//  NPYOrdeDetailViewController.m
//  牛品云
//
//  Created by Eric on 16/11/23.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYOrdeDetailViewController.h"
#import "NPYBaseConstant.h"
#import "NPYLogisticsViewController.h"

@interface NPYOrdeDetailViewController () <UITableViewDelegate,UITableViewDataSource> {
    UILabel *totalMoneyL;   //总计金额
    UILabel *timeL;         //倒计时
    UILabel *addAddressL;   //地址
    UILabel *freightL;      //运费
    UILabel *ticketL;       //优惠券
    UILabel *consigneeName; //收货人
    UILabel *phonNumber;    //手机号
    UILabel *address;       //收货地址
    UILabel *orderState;    //交易状态
    UIImageView *proIcon,*proImage;
    UILabel *proName,*proDetail,*proPrice,*proTotal,*proCount;
    UIButton *proRemark,*oneBtn,*twoBtn;
}

@property (nonatomic, strong) UITableView *mainTView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NPYLogisticsViewController    *logisticsVC;

@end

@implementation NPYOrdeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = GRAY_BG;
    
    [self navigationViewLoad];
    
    [self mainViewLoad];
    
    [self bottomViewLoad];
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

- (void)navigationViewLoad {
    //
    self.navigationItem.title = @"订单详情";
    
    //    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0]};
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
}

- (void)mainViewLoad {
    //
    self.mainTView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStyleGrouped];
    self.mainTView.backgroundColor = [UIColor clearColor];
    self.mainTView.dataSource = self;
    self.mainTView.delegate = self;
    [self.view addSubview:self.mainTView];
    
    self.mainTView.estimatedRowHeight = 200;
    self.mainTView.rowHeight = UITableViewAutomaticDimension;
    self.mainTView.showsVerticalScrollIndicator = NO;
}

- (void)bottomViewLoad {
    //
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0, HEIGHT_SCREEN - 40, WIDTH_SCREEN, 40);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.borderWidth = 0.5;
    self.bottomView.layer.borderColor = GRAY_BG.CGColor;
    [self.view addSubview:self.bottomView];
    //
    UILabel *tmpL = [[UILabel alloc] initWithFrame:CGRectMake(Height_Space * 2, 0, 50, CGRectGetHeight(self.bottomView.frame))];
    [self.bottomView addSubview:tmpL];
    tmpL.text = @"总计：";
    tmpL.textColor = XNColor(64, 65, 66, 1);
    tmpL.font = [UIFont systemFontOfSize:13.0];
    tmpL.textAlignment = NSTextAlignmentLeft;
    
    totalMoneyL = [[UILabel alloc] init];
    totalMoneyL.frame = CGRectMake(CGRectGetMaxX(tmpL.frame), 0, 80, CGRectGetHeight(tmpL.frame));
    [self.bottomView addSubview:totalMoneyL];
    totalMoneyL.textColor = [UIColor redColor];
    totalMoneyL.text = @"￥38.80";
    
    UIButton *canceBtn = [[UIButton alloc] init];
    canceBtn.frame = CGRectMake(WIDTH_SCREEN / 2, 8, (WIDTH_SCREEN / 2 - 30) / 2, CGRectGetHeight(self.bottomView.frame) - 16);
    [self.bottomView addSubview:canceBtn];
    canceBtn.layer.borderWidth = 0.5;
    canceBtn.layer.borderColor = [UIColor grayColor].CGColor;
    //    canceBtn.backgroundColor = [UIColor redColor];
    canceBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [canceBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [canceBtn setTitleColor:XNColor(64, 65, 66, 1) forState:UIControlStateNormal];
    [canceBtn addTarget:self action:@selector(canceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    oneBtn = canceBtn;
    
    UIButton *payBtn = [[UIButton alloc] init];
    payBtn.frame = CGRectMake(CGRectGetMaxX(canceBtn.frame) + Height_Space * 2, CGRectGetMinY(canceBtn.frame), CGRectGetWidth(canceBtn.frame), CGRectGetHeight(canceBtn.frame));
    [self.bottomView addSubview:payBtn];
    payBtn.layer.borderWidth = 0.5;
    payBtn.layer.borderColor = [UIColor redColor].CGColor;
    payBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    //    payBtn.backgroundColor = [UIColor redColor];
    [payBtn setTitle:@"继续支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    twoBtn = payBtn;
    
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return 3;
    } else if(section == 4) {
        return 3;
    } else {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"mainCell";
    UITableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (mainCell == nil) {
        mainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        //收货详情
        if (indexPath.section == 0) {
            UILabel *consigneeL = [[UILabel alloc] init];
            consigneeL.frame = CGRectMake(Height_Space * 2, Height_Space, 60, 20);
            consigneeL.text = @"收货人：";
            consigneeL.font = [UIFont systemFontOfSize:13.0];
            consigneeL.textColor = XNColor(64, 65, 66, 1);
            [mainCell.contentView addSubview:consigneeL];
            
            consigneeName = [[UILabel alloc] init];
            consigneeName.frame = CGRectMake(CGRectGetMaxX(consigneeL.frame), CGRectGetMinY(consigneeL.frame), 80, 20);
            consigneeName.text = @"牛品云";
            consigneeName.font = [UIFont systemFontOfSize:13.0];
            consigneeName.textColor = XNColor(64, 65, 66, 1);
            consigneeName.textAlignment = NSTextAlignmentLeft;
            [mainCell.contentView addSubview:consigneeName];
            
            phonNumber = [[UILabel alloc] init];
            phonNumber.frame = CGRectMake(CGRectGetMaxX(consigneeName.frame) + Height_Space, CGRectGetMinY(consigneeL.frame), 100, 20);
            phonNumber.text = @"15888888888";
            phonNumber.font = [UIFont systemFontOfSize:13.0];
            phonNumber.textColor = XNColor(64, 65, 66, 1);
            [mainCell.contentView addSubview:phonNumber];
            
            UILabel *addressL = [[UILabel alloc] init];
            addressL.frame = CGRectMake(Height_Space * 2, CGRectGetMaxY(consigneeL.frame) + Height_Space, 70, 20);
            addressL.text = @"收货地址：";
            addressL.font = [UIFont systemFontOfSize:13.0];
            addressL.textColor = XNColor(64, 65, 66, 1);
            [mainCell.contentView addSubview:addressL];
            
            address = [[UILabel alloc] init];
            address.frame = CGRectMake(CGRectGetMaxX(addressL.frame) + Height_Space, CGRectGetMinY(addressL.frame) - 10, WIDTH_SCREEN  - CGRectGetWidth(addressL.frame) - 30, 40);
            address.text = @"苏州高新区科技城致远大厦1010室";
            address.font = [UIFont systemFontOfSize:13.0];
            address.textColor = XNColor(64, 65, 66, 1);
            address.numberOfLines = 0;
            [mainCell.contentView addSubview:address];
        }
        //产品信息栏
        if (indexPath.section == 1) {
            proIcon = [[UIImageView alloc] init];
            proIcon.frame = CGRectMake(10, 10, 20, 20);
            proIcon.image = [UIImage imageNamed:@"placeholder"];
            proIcon.contentMode = UIViewContentModeScaleAspectFill;
            [mainCell.contentView addSubview:proIcon];
            
            proName = [[UILabel alloc] init];
            proName.frame = CGRectMake(CGRectGetMaxX(proIcon.frame) + 10, 10, 150, 20);
            proName.textColor = XNColor(64, 65, 66, 1);
            proName.font = [UIFont systemFontOfSize:15.0];
            proName.text = @"五常稻花香大米";
            [mainCell.contentView addSubview:proName];
            
            orderState = [[UILabel alloc] init];
            orderState.frame = CGRectMake(WIDTH_SCREEN - 170, 10, 150, 20);
            orderState.textColor = [UIColor redColor];
            orderState.font = [UIFont systemFontOfSize:13.0];
            orderState.text = @"交易完成";
            orderState.textAlignment = NSTextAlignmentRight;
            [mainCell.contentView addSubview:orderState];
            
            UIView *bg = [[UIView alloc] init];
            bg.frame = CGRectMake(0, CGRectGetMaxY(proIcon.frame) + 10, WIDTH_SCREEN, 120);
            bg.backgroundColor = GRAY_BG;
            [mainCell.contentView addSubview:bg];
            
            proImage = [[UIImageView alloc] init];
            proImage.frame = CGRectMake(CGRectGetMinX(proIcon.frame), 10, 60, 60);
            [proImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            proImage.contentMode = UIViewContentModeScaleToFill;
            [bg addSubview:proImage];
            
            proDetail = [[UILabel alloc] init];
            proDetail.frame = CGRectMake(CGRectGetMaxX(proImage.frame) + 10, CGRectGetMinY(proImage.frame), bg.frame.size.width - CGRectGetWidth(proImage.frame) - 40, 30);
            proDetail.text = @"八杂市 2016年新米东北五常稻花香大米2.5kg黑龙江五常粳米5斤";
            proDetail.textColor = XNColor(64, 65, 66, 1);
            proDetail.font = [UIFont systemFontOfSize:12.0];
            proDetail.numberOfLines = 0;
            [bg addSubview:proDetail];
            
            proPrice = [[UILabel alloc] init];
            proPrice.frame = CGRectMake(CGRectGetMaxX(proImage.frame) + 10, CGRectGetMaxY(proImage.frame) - 20, 80, 20);
            proPrice.text = @"￥38.80";
            proPrice.adjustsFontSizeToFitWidth = YES;
            proPrice.textColor = [UIColor redColor];
            proPrice.font = [UIFont systemFontOfSize:20.0];
            proPrice.numberOfLines = 0;
            [bg addSubview:proPrice];
            
            proCount = [[UILabel alloc] init];
            proCount.text = @"1";
            proCount.font = [UIFont systemFontOfSize:13.0];
            proCount.textColor = XNColor(64, 65, 66, 1);
            
            UILabel *proCountL = [[UILabel alloc] init];
            proCountL.frame = CGRectMake(WIDTH_SCREEN - 50, CGRectGetMinY(proPrice.frame), 30, 20);
            proCountL.text = [NSString stringWithFormat:@"X%@",proCount.text];
            proCountL.textColor = XNColor(64, 65, 66, 1);
            proCountL.font = [UIFont systemFontOfSize:13.0];
            proCountL.textAlignment = NSTextAlignmentCenter;
            proCountL.adjustsFontSizeToFitWidth = YES;
            [bg addSubview:proCountL];
            
            proRemark = [[UIButton alloc] init];
            proRemark.frame = CGRectMake(CGRectGetMinX(proImage.frame), CGRectGetMaxY(proImage.frame) + 15, CGRectGetWidth(bg.frame) - 30, 25);
            [proRemark setTitle:@"给卖家留言" forState:UIControlStateNormal];
            [proRemark setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [proRemark setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 0)];
            proRemark.titleLabel.font = [UIFont systemFontOfSize:12.0];
            proRemark.backgroundColor = [UIColor whiteColor];
            proRemark.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [bg addSubview:proRemark];
            
            proTotal = [[UILabel alloc] init];
            proTotal.frame = CGRectMake(0, CGRectGetMaxY(bg.frame) + 10, WIDTH_SCREEN - 15, 20);
            proTotal.text = [NSString stringWithFormat:@"共 %@ 件商品 合计：%@",proCount.text,proPrice.text];
            proTotal.textAlignment = NSTextAlignmentRight;
            proTotal.font = [UIFont systemFontOfSize:17.0];
            proTotal.attributedText = [self productTotalString:proTotal.text];
            [mainCell.contentView addSubview:proTotal];
        }
        //物流信息
        if (indexPath.section == 2) {
            mainCell.imageView.image = [UIImage imageNamed:@"dot1"];
            mainCell.textLabel.text = @"订单已被签收";
            mainCell.detailTextLabel.text = @"点击查看物流信息";
            mainCell.detailTextLabel.textColor = [UIColor grayColor];
            mainCell.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
            mainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        //优惠栏
        if (indexPath.section == 3) {
            mainCell.textLabel.text = @"运费";
            freightL = [[UILabel alloc] init];
            freightL.frame = CGRectMake(0, 10, WIDTH_SCREEN - 20, 30);
            freightL.textColor = [UIColor grayColor];
            freightL.text = @"+￥0.00";
            freightL.textAlignment = NSTextAlignmentRight;
            freightL.font = [UIFont systemFontOfSize:13.0];
            [mainCell.contentView addSubview:freightL];
            if (indexPath.row == 1) {
                mainCell.textLabel.text = @"优惠券";
                freightL.text = @"-￥0.00";
            } else if (indexPath.row == 2) {
                mainCell.textLabel.text = @"牛豆";
                freightL.text = @"-￥0.00";
            }
            //            mainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        //订单信息
        if (indexPath.section == 4) {
            freightL = [[UILabel alloc] init];
            freightL.frame = CGRectMake(0, 10, WIDTH_SCREEN - 20, 30);
            freightL.textColor = [UIColor grayColor];
            freightL.textAlignment = NSTextAlignmentRight;
            freightL.font = [UIFont systemFontOfSize:13.0];
            mainCell.textLabel.text = @"订单编号";
            [mainCell.contentView addSubview:freightL];
            freightL.text = @"6546565652300";
            if (indexPath.row == 1) {
                mainCell.textLabel.text = @"运单编号";
                freightL.text = @"64984164646465";
            } else if (indexPath.row == 2) {
                mainCell.textLabel.text = @"购买时间";
                freightL.text = @"2016-11-18";
            }
            
        }
        
        mainCell.textLabel.textColor = XNColor(64, 65, 66, 1);
        mainCell.textLabel.font = [UIFont systemFontOfSize:13.0];
        mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return mainCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    } else if (indexPath.section == 1) {
        return 200;
    } else if (indexPath.section == 2) {
        return 50;
    } else {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        //物流信息
        self.logisticsVC = [[NPYLogisticsViewController alloc] init];
        [self.navigationController pushViewController:self.logisticsVC animated:YES];
        
    }
}

#pragma mark - 更改tableView的分割线顶格显示
- (void)viewDidLayoutSubviews
{
    if ([self.mainTView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.mainTView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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

#pragma mark -

- (NSMutableAttributedString *)productTotalString:(NSString *)Tstr; {
    NSString *tmp = [Tstr componentsSeparatedByString:@"："][0];
    NSMutableAttributedString *mTmp = [[NSMutableAttributedString alloc] initWithString:Tstr];
    NSUInteger length = tmp.length;
    [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, length)];
    [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(length + 1, Tstr.length - length - 1)];
    [mTmp addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(length + 1, Tstr.length - length - 1)];
    
    return mTmp;
}

- (void)canceButtonPressed:(UIButton *)btn {
    
}

- (void)payButtonPressed:(UIButton *)btn {
    //    NSLog(@"继续支付");
    
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
