//
//  NPYOrderViewController.m
//  牛品云
//
//  Created by Eric on 16/11/8.
//  Copyright © 2016年 Eric. All rights reserved.
//
//  订单页面

#import "NPYOrderViewController.h"
#import "NPYBaseConstant.h"
#import "NPYAddressViewController.h"
#import "NPYPaymentOrderViewController.h"

@interface NPYOrderViewController () <UITableViewDelegate,UITableViewDataSource> {
    UILabel *totalMoneyL;   //总计金额
    UILabel *timeL;         //倒计时
    UILabel *addAddressL;   //地址
    UILabel *freightL;      //运费
    UILabel *ticketL;       //优惠券
    UIImageView *proIcon,*proImage;
    UILabel *proName,*proDetail,*proPrice,*proTotal,*proCount;
    UIButton *proRemark,*cutBtn,*sumBtn;
    
}

@property (nonatomic, strong) UITableView *mainTView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NPYAddressViewController          *addressVC;
@property (nonatomic, strong) NPYPaymentOrderViewController     *paymentOrderVC;

@end

@implementation NPYOrderViewController

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
    self.navigationItem.title = @"确认订单";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0]};
    
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
}

- (void)bottomViewLoad {
    //
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0, HEIGHT_SCREEN - 40, WIDTH_SCREEN, 40);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    //
    UILabel *tmpL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN / 3, CGRectGetHeight(self.bottomView.frame))];
    [self.bottomView addSubview:tmpL];
    tmpL.text = @"总计：";
    tmpL.textColor = [UIColor blackColor];
    tmpL.font = [UIFont systemFontOfSize:17.0];
    tmpL.textAlignment = NSTextAlignmentRight;
    
    totalMoneyL = [[UILabel alloc] init];
    totalMoneyL.frame = CGRectMake(CGRectGetMaxX(tmpL.frame), 0, 100, CGRectGetHeight(tmpL.frame));
    [self.bottomView addSubview:totalMoneyL];
    totalMoneyL.textColor = [UIColor redColor];
    totalMoneyL.text = @"￥38.80";
    
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.frame = CGRectMake(CGRectGetMaxX(totalMoneyL.frame), 0, WIDTH_SCREEN - CGRectGetMaxX(totalMoneyL.frame), CGRectGetHeight(self.bottomView.frame));
    [self.bottomView addSubview:submitBtn];
    submitBtn.backgroundColor = [UIColor redColor];
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return 2;
    } else {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"mainCell";
    UITableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (mainCell == nil) {
        mainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        mainCell.textLabel.text = @"Test!!";
        //顶部文字提醒栏
        if (indexPath.section == 0) {
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(Height_Space * 2, 15, mainCell.contentView.frame.size.width - 100, 30)];
            [mainCell.contentView addSubview:titleL];
            titleL.text = @"确认订单后请尽快付款，过时订单将自动取消。";
            titleL.font = [UIFont systemFontOfSize:15.0];
            titleL.textColor = [UIColor grayColor];
            titleL.adjustsFontSizeToFitWidth = YES;
            titleL.numberOfLines = 0;
            
            timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleL.frame), 15, WIDTH_SCREEN - CGRectGetMaxX(titleL.frame) - 3 * Height_Space, 30)];
            [mainCell.contentView addSubview:timeL];
            timeL.text = @"20:00";
            timeL.font = [UIFont systemFontOfSize:25.0];
            timeL.textAlignment = NSTextAlignmentRight;
            timeL.textColor = [UIColor orangeColor];
        }
        //地址栏
        if (indexPath.section == 1) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.frame = CGRectMake(Height_Space * 2, 0, 20, 20);
            [mainCell.contentView addSubview:imgView];
            imgView.center = CGPointMake(CGRectGetMidX(imgView.frame), CGRectGetMidY(mainCell.contentView.frame));
            imgView.backgroundColor = [UIColor yellowColor];
            
            addAddressL = [[UILabel alloc] init];
            addAddressL.frame = CGRectMake(CGRectGetMaxX(imgView.frame) + Height_Space, CGRectGetMinY(imgView.frame), 80, CGRectGetHeight(imgView.frame));
            [mainCell.contentView addSubview:addAddressL];
            addAddressL.text = @"新增地址";
            addAddressL.textColor = [UIColor blackColor];
            mainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        //产品信息栏
        if (indexPath.section == 2) {
            proIcon = [[UIImageView alloc] init];
            proIcon.frame = CGRectMake(10, 10, 20, 20);
            proIcon.image = [UIImage imageNamed:@"placeholder"];
            proIcon.contentMode = UIViewContentModeScaleAspectFill;
            [mainCell.contentView addSubview:proIcon];
            
            proName = [[UILabel alloc] init];
            proName.frame = CGRectMake(CGRectGetMaxX(proIcon.frame) + 10, 10, 150, 20);
            proName.textColor = [UIColor blackColor];
            proName.font = [UIFont systemFontOfSize:17.0];
            proName.text = @"五常稻花香大米";
            [mainCell.contentView addSubview:proName];
            
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
//            proDetail.adjustsFontSizeToFitWidth = YES;
            proDetail.textColor = [UIColor blackColor];
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
//            proPrice.backgroundColor = [UIColor greenColor];
            [bg addSubview:proPrice];
            
            cutBtn = [[UIButton alloc] init];
            cutBtn.tag = 5000;
            cutBtn.frame = CGRectMake(bg.frame.size.width - 90, CGRectGetMinY(proPrice.frame), 20, 20);
            [cutBtn setTitle:@" - " forState:UIControlStateNormal];
            [cutBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [cutBtn setBackgroundColor:[UIColor orangeColor]];
            [cutBtn addTarget:self action:@selector(cutAndAddButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:cutBtn];
            
            proCount = [[UILabel alloc] init];
            proCount.frame = CGRectMake(CGRectGetMaxX(cutBtn.frame), CGRectGetMinY(proPrice.frame), 30, 20);
            proCount.text = @"999";
            proCount.textColor = [UIColor blackColor];
            proCount.font = [UIFont systemFontOfSize:17.0];
            proCount.textAlignment = NSTextAlignmentCenter;
            proCount.adjustsFontSizeToFitWidth = YES;
            [bg addSubview:proCount];
            
            sumBtn = [[UIButton alloc] init];
            sumBtn.tag = 5001;
            sumBtn.frame = CGRectMake(CGRectGetMaxX(proCount.frame), CGRectGetMinY(proPrice.frame), 20, 20);
            [sumBtn setTitle:@" + " forState:UIControlStateNormal];
            [sumBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [sumBtn setBackgroundColor:[UIColor orangeColor]];
            [sumBtn addTarget:self action:@selector(cutAndAddButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:sumBtn];
            
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
        //优惠栏
        if (indexPath.section == 3) {
            mainCell.textLabel.text = @"运费";
            freightL = [[UILabel alloc] init];
            freightL.frame = CGRectMake(WIDTH_SCREEN - 140, 10, 100, 30);
            freightL.textColor = [UIColor grayColor];
            freightL.text = @"免邮";
            freightL.textAlignment = NSTextAlignmentRight;
            [mainCell.contentView addSubview:freightL];
            if (indexPath.row == 1) {
                mainCell.textLabel.text = @"是否使用券";
                freightL.text = @"无可用券";
            }
            mainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        mainCell.backgroundColor = [UIColor clearColor];
    }
    return mainCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    } else if (indexPath.section == 1) {
        return 50;
    } else if (indexPath.section == 2) {
        return 200;
    } else {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    } else {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        //跳到选择地址页
        self.addressVC = [[NPYAddressViewController alloc] init];
        [self.navigationController pushViewController:self.addressVC animated:YES];
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

//5000 (➖)，5001（➕）
- (void)cutAndAddButtonPressed:(UIButton *)btn {
    //
    int value = [proCount.text intValue];
    switch (btn.tag) {
        case 5000:
            value--;
            if (value <= 0) {
                value = 0;
            }
            proCount.text = [NSString stringWithFormat:@"%i",value];
            break;
        
        case 5001:
            value++;
            proCount.text = [NSString stringWithFormat:@"%i",value];
            break;
            
        default:
            break;
    }
    double b = [[proPrice.text substringWithRange:NSMakeRange(1,proPrice.text.length - 1)] doubleValue];
    proTotal.text = [NSString stringWithFormat:@"共 %i 件商品 合计：￥%.2f",value,value * b];
    proTotal.attributedText = [self productTotalString:proTotal.text];
    
    totalMoneyL.text = [NSString stringWithFormat:@"￥%.2f",value * b];
}

- (void)submitButtonPressed:(UIButton *)btn {
//    NSLog(@"提交订单");
    self.paymentOrderVC = [[NPYPaymentOrderViewController alloc] init];
    [self.navigationController pushViewController:self.paymentOrderVC animated:YES];
    
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
