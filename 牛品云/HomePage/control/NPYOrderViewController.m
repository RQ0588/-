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

@interface NPYOrderViewController () <UITableViewDelegate,UITableViewDataSource,AddressValueToSuperViewDelegate> {
    UILabel *totalMoneyL;   //总计金额
    UILabel *timeL;         //倒计时
    UILabel *addAddressL;   //地址
    UILabel *freightL;      //运费
    UILabel *ticketL;       //优惠券
    UIImageView *proIcon,*proImage;
    UILabel *proName,*proDetail,*proPrice,*proTotal,*proCount,*proPrice2;
    UIButton *proRemark,*cutBtn,*sumBtn;
    UISwitch *NPYSwitch;
    
    UILabel *consigneeName; //收货人
    UILabel *phonNumber;    //手机号
    UILabel *address;       //收货地址
    
    UIImageView *topLineImg;
    
    BOOL isAddress;
    
    NSDictionary *addressDic;
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [topLineImg removeFromSuperview];
    topLineImg = nil;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)navigationViewLoad {
    //
    self.navigationItem.title = @"确认订单";
    
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
    
}

- (void)mainViewLoad {
    //
    self.mainTView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, WIDTH_SCREEN, HEIGHT_SCREEN - 41) style:UITableViewStyleGrouped];
    self.mainTView.backgroundColor = [UIColor clearColor];
    self.mainTView.dataSource = self;
    self.mainTView.delegate = self;
    [self.view addSubview:self.mainTView];
    [self.mainTView setSeparatorColor:XNColor(229, 229, 229, 1)];
    self.mainTView.estimatedRowHeight = 200;
    self.mainTView.rowHeight = UITableViewAutomaticDimension;
}

- (void)bottomViewLoad {
    //
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0, HEIGHT_SCREEN - 104, WIDTH_SCREEN, 40);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"750huixian_92"]];
    lineImg.frame = CGRectMake(0, 0, WIDTH_SCREEN, 1);
    [self.bottomView addSubview:lineImg];
    //
    UILabel *tmpL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN / 3, CGRectGetHeight(self.bottomView.frame))];
    [self.bottomView addSubview:tmpL];
    tmpL.text = @"总计：";
    tmpL.textColor = XNColor(51, 51, 51, 1);
    tmpL.font = [UIFont systemFontOfSize:13.0];
    tmpL.textAlignment = NSTextAlignmentRight;
    
    totalMoneyL = [[UILabel alloc] init];
    totalMoneyL.frame = CGRectMake(CGRectGetMaxX(tmpL.frame), 0, 100, CGRectGetHeight(tmpL.frame));
    [self.bottomView addSubview:totalMoneyL];
    totalMoneyL.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",38.80] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
    
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.frame = CGRectMake(CGRectGetMaxX(totalMoneyL.frame), 0, WIDTH_SCREEN - CGRectGetMaxX(totalMoneyL.frame), CGRectGetHeight(self.bottomView.frame));
    [self.bottomView addSubview:submitBtn];
    submitBtn.backgroundColor = [UIColor redColor];
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = XNFont(20.0);
    [submitBtn addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 3;
    } else {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"mainCell";
//    UITableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UITableViewCell *mainCell;
    if (mainCell == nil) {
        mainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //地址栏
        if (indexPath.section == 0) {
            if (isAddress == NO) {
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.frame = CGRectMake(14, 0, 19, 19);
                imgView.image = [UIImage imageNamed:@"xinzeng_gouwu"];
                [mainCell.contentView addSubview:imgView];
                imgView.center = CGPointMake(CGRectGetMidX(imgView.frame), CGRectGetMidY(mainCell.contentView.frame));
                
                addAddressL = [[UILabel alloc] init];
                addAddressL.frame = CGRectMake(CGRectGetMaxX(imgView.frame) + 15, CGRectGetMinY(imgView.frame), 80, CGRectGetHeight(imgView.frame));
                [mainCell.contentView addSubview:addAddressL];
                addAddressL.text = @"新增地址";
                addAddressL.textColor = XNColor(17, 17, 17, 1);
                addAddressL.font = XNFont(15.0);
                
            } else {
                UILabel *consigneeL = [[UILabel alloc] init];
                consigneeL.frame = CGRectMake(14, 15, 60, 20);
                consigneeL.text = @"收货人：";
                consigneeL.font = [UIFont systemFontOfSize:14.0];
                consigneeL.textColor = XNColor(17, 17, 17, 1);
                [mainCell.contentView addSubview:consigneeL];
                
                consigneeName = [[UILabel alloc] init];
                consigneeName.frame = CGRectMake(CGRectGetMaxX(consigneeL.frame), CGRectGetMinY(consigneeL.frame), 80, 20);
                consigneeName.text = [addressDic valueForKey:@"name"];
                consigneeName.font = [UIFont systemFontOfSize:14.0];
                consigneeName.textColor = XNColor(17, 17, 17, 1);
                consigneeName.textAlignment = NSTextAlignmentLeft;
                [mainCell.contentView addSubview:consigneeName];
                
                phonNumber = [[UILabel alloc] init];
                phonNumber.frame = CGRectMake(CGRectGetMaxX(consigneeName.frame) + Height_Space, CGRectGetMinY(consigneeL.frame), 100, 20);
                phonNumber.text = [addressDic valueForKey:@"phone"];
                phonNumber.font = [UIFont systemFontOfSize:14.0];
                phonNumber.textColor = XNColor(17, 17, 17, 1);
                [mainCell.contentView addSubview:phonNumber];
                
                UILabel *addressL = [[UILabel alloc] init];
                addressL.frame = CGRectMake(14, CGRectGetMaxY(consigneeL.frame) + 15, 70, 20);
                addressL.text = @"收货地址：";
                addressL.font = [UIFont systemFontOfSize:14.0];
                addressL.textColor = XNColor(17, 17, 17, 1);
                addressL.adjustsFontSizeToFitWidth = YES;
                [mainCell.contentView addSubview:addressL];
                
                address = [[UILabel alloc] init];
                address.frame = CGRectMake(CGRectGetMaxX(addressL.frame) + Height_Space, CGRectGetMinY(addressL.frame) - 10, WIDTH_SCREEN  - CGRectGetWidth(addressL.frame) - 50, 40);
                address.text = [addressDic valueForKey:@"address"];
                address.font = [UIFont systemFontOfSize:14.0];
                address.textColor = XNColor(17, 17, 17, 1);
                address.numberOfLines = 0;
                [mainCell.contentView addSubview:address];
            }
            
            mainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        //产品信息栏
        if (indexPath.section == 1) {
            proIcon = [[UIImageView alloc] init];
            proIcon.frame = CGRectMake(14, 10, 20, 20);
            proIcon.image = [UIImage imageNamed:@"anli1_gouwu"];
            proIcon.contentMode = UIViewContentModeScaleAspectFill;
            [mainCell.contentView addSubview:proIcon];
            
            proName = [[UILabel alloc] init];
            proName.frame = CGRectMake(CGRectGetMaxX(proIcon.frame) + 10, 10, WIDTH_SCREEN - 60, 20);
            proName.textColor = XNColor(17, 17, 17, 1);
            proName.font = [UIFont systemFontOfSize:15.0];
            proName.text = @"五常稻花香大米";
            [mainCell.contentView addSubview:proName];
            
            UIView *bg = [[UIView alloc] init];
            bg.frame = CGRectMake(0, CGRectGetMaxY(proIcon.frame) + 10, WIDTH_SCREEN, 140);
            bg.backgroundColor = XNColor(247, 247, 247, 1);
            [mainCell.contentView addSubview:bg];
            
            proImage = [[UIImageView alloc] init];
            proImage.frame = CGRectMake(CGRectGetMinX(proIcon.frame), 10, 80, 80);
            [proImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"anli1_gouwu"]];
            proImage.contentMode = UIViewContentModeScaleToFill;
            [bg addSubview:proImage];
            
            proDetail = [[UILabel alloc] init];
            proDetail.frame = CGRectMake(CGRectGetMaxX(proImage.frame) + 11, CGRectGetMinY(proImage.frame), bg.frame.size.width - CGRectGetWidth(proImage.frame) - 40, 30);
            proDetail.text = @"八杂市 2016年新米东北五常稻花香大米2.5kg黑龙江五常粳米5斤";
            proDetail.textColor = XNColor(35, 35, 35, 1);
            proDetail.font = [UIFont systemFontOfSize:12.0];
            proDetail.numberOfLines = 0;
            [bg addSubview:proDetail];
            
            proPrice = [[UILabel alloc] init];
            proPrice.frame = CGRectMake(CGRectGetMaxX(proImage.frame) + 10, CGRectGetMaxY(proImage.frame) - 20, 80, 20);
            proPrice.adjustsFontSizeToFitWidth = YES;
            proPrice.numberOfLines = 0;
            proPrice.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",38.80] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
            [bg addSubview:proPrice];
            
            cutBtn = [[UIButton alloc] init];
            cutBtn.tag = 5000;
            cutBtn.frame = CGRectMake(bg.frame.size.width - 90, CGRectGetMinY(proPrice.frame), 23, 23);
            [cutBtn setImage:[UIImage imageNamed:@"jian_zhongchou"] forState:UIControlStateNormal];
            [cutBtn addTarget:self action:@selector(cutAndAddButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:cutBtn];
            
            proCount = [[UILabel alloc] init];
            proCount.frame = CGRectMake(CGRectGetMaxX(cutBtn.frame), CGRectGetMinY(proPrice.frame), 30, 23);
            proCount.text = @"999";
            proCount.textColor = XNColor(17, 17, 17, 1);
            proCount.font = [UIFont systemFontOfSize:14.0];
            proCount.textAlignment = NSTextAlignmentCenter;
            proCount.adjustsFontSizeToFitWidth = YES;
            [bg addSubview:proCount];
            
            sumBtn = [[UIButton alloc] init];
            sumBtn.tag = 5001;
            sumBtn.frame = CGRectMake(CGRectGetMaxX(proCount.frame), CGRectGetMinY(proPrice.frame), 23, 23);
            [sumBtn setImage:[UIImage imageNamed:@"jia_zhongchou"] forState:UIControlStateNormal];
            [sumBtn addTarget:self action:@selector(cutAndAddButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:sumBtn];
            
            proRemark = [[UIButton alloc] init];
            proRemark.frame = CGRectMake(CGRectGetMinX(proImage.frame), CGRectGetMaxY(proImage.frame) + 17, CGRectGetWidth(bg.frame) - 30, 25);
            [proRemark setTitle:@"给卖家留言" forState:UIControlStateNormal];
            [proRemark setTitleColor:XNColor(191, 191, 191, 1) forState:UIControlStateNormal];
            [proRemark setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 0)];
            proRemark.titleLabel.font = [UIFont systemFontOfSize:12.0];
            proRemark.backgroundColor = [UIColor whiteColor];
            proRemark.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [bg addSubview:proRemark];
            
            proTotal = [[UILabel alloc] init];
            proTotal.frame = CGRectMake(0, CGRectGetMaxY(bg.frame) + 10, WIDTH_SCREEN - 96, 20);
            proTotal.text = [NSString stringWithFormat:@"共 %@ 件商品 合计：",proCount.text];
            proTotal.textAlignment = NSTextAlignmentRight;
            proTotal.font = [UIFont systemFontOfSize:13.0];
            proTotal.textColor = XNColor(51, 51, 51, 1);
            [mainCell.contentView addSubview:proTotal];
            
            proPrice2 = [[UILabel alloc] init];
            proPrice2.frame = CGRectMake(CGRectGetMaxX(proTotal.frame), CGRectGetMinY(proTotal.frame), 80, 20);
            proPrice2.adjustsFontSizeToFitWidth = YES;
            proPrice2.numberOfLines = 0;
            proPrice2.textAlignment = NSTextAlignmentRight;
            proPrice2.attributedText = proPrice.attributedText;
            [mainCell.contentView addSubview:proPrice2];
            
        }
        //优惠栏
        if (indexPath.section == 2) {
            NSArray *names = @[@"运费",@"优惠券",@"牛豆"];
            mainCell.textLabel.text = names[indexPath.row];
            mainCell.textLabel.font = XNFont(15.0);
            mainCell.textLabel.textColor = XNColor(17, 17, 17, 1);
            
            freightL = [[UILabel alloc] init];
            freightL.frame = CGRectMake(WIDTH_SCREEN - 140, 10, 100, 30);
            freightL.textColor = XNColor(166, 166, 166, 1);
            freightL.text = @"免邮";
            freightL.textAlignment = NSTextAlignmentRight;
            freightL.font = XNFont(13.0);
            [mainCell.contentView addSubview:freightL];
            if (indexPath.row == 1) {
                freightL.text = @"两张可用";
                mainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                mainCell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            if (indexPath.row == 2) {
                CGSize strSize = [self calculateStringSize:[NSString stringWithFormat:@"%@",mainCell.textLabel.text] withFontSize:13.0];
                freightL.frame = CGRectMake(strSize.width + 5, 10, 100, 30);
                freightL.text = @"(可用20牛豆)";
                NPYSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - 60, 10, 100, 20)];
                [NPYSwitch setOn:YES];
                NPYSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
                [NPYSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                [mainCell.contentView addSubview:NPYSwitch];
            }
        }
        
        mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return mainCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 215;
    }
    if (isAddress && indexPath.section == 0) {
        return 90;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //跳到选择地址页
        self.addressVC = [[NPYAddressViewController alloc] init];
        self.addressVC.delegate = self;
        [self.navigationController pushViewController:self.addressVC animated:YES];
    }
}

- (void)popValue:(NSDictionary *)dic {
    addressDic = [dic copy];
    isAddress = YES;
    
    [self.mainTView reloadData];
}

-(void)viewDidLayoutSubviews
{
    if ([self.mainTView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_mainTView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mainTView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 

- (NSMutableAttributedString *)attributedStringWithSegmentationString:(NSString *)segStr withOriginalString:(NSString *)orStr withOneColor:(UIColor *)oneColor withTwoColor:(UIColor *)twoColor withOneFontSize:(CGFloat)oneSize twoFontSize:(CGFloat)twoSize {
    NSString *tmp = [orStr componentsSeparatedByString:segStr][0];
    NSMutableAttributedString *mTmp = [[NSMutableAttributedString alloc] initWithString:orStr];
    NSUInteger length = tmp.length;
    if (length == 0) {
        length = 1;
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:oneSize] range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:twoSize] range:NSMakeRange(length, orStr.length - 1)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:oneColor range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:twoColor range:NSMakeRange(length, orStr.length - 1)];
        
    } else {
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:oneSize] range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:twoSize] range:NSMakeRange(length + 1, orStr.length - length - 1)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:oneColor range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:twoColor range:NSMakeRange(length + 1, orStr.length - length - 1)];
        
    }
    
    return mTmp;
}

- (CGSize)calculateStringSize:(NSString *)str withFontSize:(CGFloat)fontSize{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]};
    CGSize size=[str sizeWithAttributes:attrs];
    
    return size;
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
    proTotal.text = [NSString stringWithFormat:@"共 %i 件商品 合计：",value];
    
    proPrice2.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",value * b] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
    
    totalMoneyL.attributedText = proPrice2.attributedText;
}

- (void)submitButtonPressed:(UIButton *)btn {
//    NSLog(@"提交订单");
    self.paymentOrderVC = [[NPYPaymentOrderViewController alloc] init];
    [self.navigationController pushViewController:self.paymentOrderVC animated:YES];
    
}

-(void)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"使用牛豆");
    }else {
        NSLog(@"不用牛豆");
    }
}

#pragma mark - 网络请求

- (void)requestOrderInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            NSDictionary *tpDict = dataDict[@"data"];
            
            
        } else {
            //失败
            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
            //            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
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
