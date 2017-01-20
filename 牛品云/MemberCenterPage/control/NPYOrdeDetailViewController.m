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
#import "NPYAfter_SalesViewController.h"
#import "NPYDiscusViewController.h"
#import "NPYAddressModel.h"
#import "NPYMyOrderDetailModel.h"
#import "BuyViewController.h"

#define OrderDetailUrl @"/index.php/app/Order/get_detailed"

#define ManyOrderDetailUrl @"/index.php/app/Order/get_many_id"

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
    UILabel *proName,*proDetail,*proPrice,*proTotal,*proCount,*proPrice2,*proState;
    UIButton *proRemark,*oneBtn,*twoBtn;
    
    NSDictionary *addressDic;
}

@property (nonatomic, strong) UITableView *mainTView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NPYLogisticsViewController    *logisticsVC;//物流

@property (nonatomic, strong) NPYDiscusViewController       *discusVC;  //评论页
@property (nonatomic, strong) NPYAfter_SalesViewController  *afterSalesVC;//售后

@property (nonatomic, strong) BuyViewController             *goodsView;//

@property (nonatomic, strong) NPYMyOrderDetailModel *model;

@end

@implementation NPYOrdeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"sign"],@"sign",model.user_id,@"user_id",self.order_id ? self.order_id : @"",@"order_id", nil];
    
    [self requestOrderInfoWithUrlString:_isManyOrder ? ManyOrderDetailUrl : OrderDetailUrl withParames:request];
    
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)mainViewLoad {
    //
    self.mainTView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, WIDTH_SCREEN, HEIGHT_SCREEN - 1) style:UITableViewStyleGrouped];
    self.mainTView.backgroundColor = [UIColor clearColor];
    self.mainTView.dataSource = self;
    self.mainTView.delegate = self;
    [self.view addSubview:self.mainTView];
    
    self.mainTView.estimatedRowHeight = 200;
    self.mainTView.rowHeight = UITableViewAutomaticDimension;
    self.mainTView.showsVerticalScrollIndicator = NO;
    self.mainTView.separatorColor = GRAY_BG;
}

- (void)bottomViewLoad {
    //
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0, HEIGHT_SCREEN - 50, WIDTH_SCREEN, 50);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.borderWidth = 0.5;
    self.bottomView.layer.borderColor = GRAY_BG.CGColor;
    [self.view addSubview:self.bottomView];
    //
    UILabel *tmpL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, CGRectGetHeight(self.bottomView.frame))];
    [self.bottomView addSubview:tmpL];
    tmpL.text = @"总计：";
    tmpL.textColor = XNColor(51, 51, 51, 1);
    tmpL.font = [UIFont systemFontOfSize:14.0];
    tmpL.textAlignment = NSTextAlignmentLeft;
    
    totalMoneyL = [[UILabel alloc] init];
    totalMoneyL.frame = CGRectMake(CGRectGetMaxX(tmpL.frame), 0, 80, CGRectGetHeight(tmpL.frame));
    totalMoneyL.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",[self.model.price doubleValue] * [self.model.num intValue] + [self.model.postage intValue]] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
    [self.bottomView addSubview:totalMoneyL];
    //    totalMoneyL.textColor = [UIColor redColor];
    //    totalMoneyL.text = @"￥38.80";
    
    UIButton *canceBtn = [[UIButton alloc] init];
    canceBtn.frame = CGRectMake(WIDTH_SCREEN / 2 - 30, 8, (WIDTH_SCREEN / 2) / 2, CGRectGetHeight(self.bottomView.frame) - 20);
    [self.bottomView addSubview:canceBtn];
    UIImage *bgImg = [UIImage imageNamed:@"huisekuang_zhifu"];
    [canceBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
    
    canceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [canceBtn setTitle:@"售后/退款" forState:UIControlStateNormal];
    [canceBtn setTitleColor:XNColor(102, 102, 102, 1) forState:UIControlStateNormal];
    [canceBtn addTarget:self action:@selector(canceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    oneBtn = canceBtn;
    
    UIButton *payBtn = [[UIButton alloc] init];
    payBtn.frame = CGRectMake(CGRectGetMaxX(canceBtn.frame) + Height_Space * 2, CGRectGetMinY(canceBtn.frame), CGRectGetWidth(canceBtn.frame), CGRectGetHeight(canceBtn.frame));
    [self.bottomView addSubview:payBtn];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"hongsekuang_zhifu"] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [payBtn setTitle:@"立即评价" forState:UIControlStateNormal];
    [payBtn setTitleColor:XNColor(248, 31, 31, 1) forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    twoBtn = payBtn;
    
    if (_isManyOrder) {
        oneBtn.hidden = YES;
        twoBtn.hidden = YES;
    }
    
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
//    UITableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UITableViewCell *mainCell;
    if (mainCell == nil) {
        mainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        //收货详情
        if (indexPath.section == 0) {
            UILabel *consigneeL = [[UILabel alloc] init];
            consigneeL.frame = CGRectMake(14, 15, 60, 20);
            consigneeL.text = @"收货人：";
            consigneeL.font = [UIFont systemFontOfSize:14.0];
            consigneeL.textColor = XNColor(17, 17, 17, 1);
            [mainCell.contentView addSubview:consigneeL];
            
            consigneeName = [[UILabel alloc] init];
            consigneeName.frame = CGRectMake(CGRectGetMaxX(consigneeL.frame), CGRectGetMinY(consigneeL.frame), 100, 20);
            consigneeName.text = [addressDic valueForKey:@"name"];//@"牛品云";
            consigneeName.font = [UIFont systemFontOfSize:14.0];
            consigneeName.textColor = XNColor(17, 17, 17, 1);
            consigneeName.textAlignment = NSTextAlignmentLeft;
            consigneeName.adjustsFontSizeToFitWidth = YES;
            [mainCell.contentView addSubview:consigneeName];
            
            phonNumber = [[UILabel alloc] init];
            phonNumber.frame = CGRectMake(CGRectGetMaxX(consigneeName.frame) + Height_Space, CGRectGetMinY(consigneeL.frame), 100, 20);
            phonNumber.text = [addressDic valueForKey:@"phone"];//@"15888888888";
            phonNumber.font = [UIFont systemFontOfSize:14.0];
            phonNumber.textColor = XNColor(17, 17, 17, 1);
            [mainCell.contentView addSubview:phonNumber];
            
            UILabel *addressL = [[UILabel alloc] init];
            addressL.frame = CGRectMake(14, CGRectGetMaxY(consigneeL.frame) + 15, 80, 20);
            addressL.text = @"收货地址：";
            addressL.font = [UIFont systemFontOfSize:14.0];
            addressL.textColor = XNColor(17, 17, 17, 1);
            [mainCell.contentView addSubview:addressL];
            
            address = [[UILabel alloc] init];
            address.frame = CGRectMake(CGRectGetMaxX(addressL.frame) + Height_Space, CGRectGetMinY(addressL.frame) - 10, WIDTH_SCREEN  - CGRectGetWidth(addressL.frame) - 30, 40);
            address.text = [addressDic valueForKey:@"address"];//@"苏州高新区科技城致远大厦1010室";
            address.font = [UIFont systemFontOfSize:14.0];
            address.textColor = XNColor(64, 65, 66, 1);
            address.numberOfLines = 0;
            [mainCell.contentView addSubview:address];
        }
        //产品信息栏
        if (indexPath.section == 1) {
            proIcon = [[UIImageView alloc] init];
            proIcon.frame = CGRectMake(14, 10, 20, 20);
//            proIcon.image = [UIImage imageNamed:@"anli1_gouwu"];
            [proIcon sd_setImageWithURL:[NSURL URLWithString:self.model.shop_img] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
            proIcon.contentMode = UIViewContentModeScaleToFill;
            [mainCell.contentView addSubview:proIcon];
            
            proName = [[UILabel alloc] init];
            proName.frame = CGRectMake(CGRectGetMaxX(proIcon.frame) + 10, 10, WIDTH_SCREEN - 60, 20);
            proName.textColor = XNColor(17, 17, 17, 1);
            proName.font = [UIFont systemFontOfSize:15.0];
            proName.text = self.model.shop_name;//@"五常稻花香大米";
            [mainCell.contentView addSubview:proName];
            
            proState = [[UILabel alloc] init];
            proState.frame = CGRectMake(WIDTH_SCREEN - 116, CGRectGetMinY(proName.frame), 100, 20);
            proState.textColor = XNColor(255, 80, 0, 1);
            proState.textAlignment = NSTextAlignmentRight;
            proState.font = XNFont(13.0);
            proState.text = [self orderStateString][0];//@"交易完成";
            [mainCell.contentView addSubview:proState];
            
            UIView *bg = [[UIView alloc] init];
            bg.frame = CGRectMake(0, CGRectGetMaxY(proIcon.frame) + 10, WIDTH_SCREEN, 105);
            bg.backgroundColor = XNColor(247, 247, 247, 1);
            [mainCell.contentView addSubview:bg];
            
            proImage = [[UIImageView alloc] init];
            proImage.frame = CGRectMake(CGRectGetMinX(proIcon.frame), 10, 80, 80);
            [proImage sd_setImageWithURL:[NSURL URLWithString:self.model.goods_img] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
            proImage.contentMode = UIViewContentModeScaleToFill;
            [bg addSubview:proImage];
            
            proDetail = [[UILabel alloc] init];
            proDetail.frame = CGRectMake(CGRectGetMaxX(proImage.frame) + 11, CGRectGetMinY(proImage.frame), bg.frame.size.width - CGRectGetWidth(proImage.frame) - 40, 30);
            proDetail.text = self.model.goods_name;//@"八杂市 2016年新米东北五常稻花香大米2.5kg黑龙江五常粳米5斤";
            proDetail.textColor = XNColor(35, 35, 35, 1);
            proDetail.font = [UIFont systemFontOfSize:12.0];
            proDetail.numberOfLines = 0;
            [bg addSubview:proDetail];
            
            proPrice = [[UILabel alloc] init];
            proPrice.frame = CGRectMake(CGRectGetMaxX(proImage.frame) + 10, CGRectGetMaxY(proImage.frame) - 20, 80, 20);
            proPrice.adjustsFontSizeToFitWidth = YES;
            proPrice.numberOfLines = 0;
            proPrice.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%@",self.model.price] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
            [bg addSubview:proPrice];
            
            proCount = [[UILabel alloc] init];
            proCount.frame = CGRectMake(WIDTH_SCREEN - 60, CGRectGetMinY(proPrice.frame), 30, 23);
            proCount.text = [NSString stringWithFormat:@"X%@",self.model.num];
            proCount.textColor = XNColor(35, 35, 35, 1);
            proCount.font = [UIFont systemFontOfSize:14.0];
            proCount.textAlignment = NSTextAlignmentCenter;
            proCount.adjustsFontSizeToFitWidth = YES;
            [bg addSubview:proCount];
            
            proRemark = [[UIButton alloc] init];
            proRemark.frame = CGRectMake(CGRectGetMinX(proImage.frame), CGRectGetMaxY(proImage.frame) + 17, CGRectGetWidth(bg.frame) - 30, 25);
            [proRemark setTitle:@"给卖家留言" forState:UIControlStateNormal];
            [proRemark setTitleColor:XNColor(191, 191, 191, 1) forState:UIControlStateNormal];
            [proRemark setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 0)];
            proRemark.titleLabel.font = [UIFont systemFontOfSize:12.0];
            proRemark.backgroundColor = [UIColor whiteColor];
            proRemark.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//            [bg addSubview:proRemark];
            
            proTotal = [[UILabel alloc] init];
            proTotal.frame = CGRectMake(0, CGRectGetMaxY(bg.frame) + 10, WIDTH_SCREEN - 96, 20);
            proTotal.text = [NSString stringWithFormat:@"共 %@ 件商品 合计：",self.model.num];
            proTotal.textAlignment = NSTextAlignmentRight;
            proTotal.font = [UIFont systemFontOfSize:13.0];
            proTotal.textColor = XNColor(51, 51, 51, 1);
            [mainCell.contentView addSubview:proTotal];
            
            proPrice2 = [[UILabel alloc] init];
            proPrice2.frame = CGRectMake(CGRectGetMaxX(proTotal.frame), CGRectGetMinY(proTotal.frame), 80, 20);
            proPrice2.adjustsFontSizeToFitWidth = YES;
            proPrice2.numberOfLines = 0;
            proPrice2.textAlignment = NSTextAlignmentRight;
            proPrice2.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",[self.model.price doubleValue] * [self.model.num intValue] ] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
            [bg addSubview:proPrice];
            [mainCell.contentView addSubview:proPrice2];
        }
        //物流信息
        if (indexPath.section == 2) {
            mainCell.imageView.image = [UIImage imageNamed:@"dingwei_icon"];
            mainCell.textLabel.text = @"订单信息";
            mainCell.detailTextLabel.text = @"点击查看物流信息";
            mainCell.detailTextLabel.textColor = XNColor(153, 153, 153, 1);
            mainCell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
            mainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        //优惠栏
        if (indexPath.section == 3) {
            NSArray *names = @[@"运费",@"优惠券",@"牛豆"];
            mainCell.textLabel.text = names[indexPath.row];
            mainCell.textLabel.font = XNFont(15.0);
            mainCell.textLabel.textColor = XNColor(17, 17, 17, 1);
            
            freightL = [[UILabel alloc] init];
            freightL.frame = CGRectMake(WIDTH_SCREEN - 116, 10, 100, 30);
            freightL.textColor = XNColor(166, 166, 166, 1);
            freightL.text = [NSString stringWithFormat:@"+￥%@",self.model.postage];//@"+￥0.00";
            freightL.textAlignment = NSTextAlignmentRight;
            freightL.font = XNFont(13.0);
            [mainCell.contentView addSubview:freightL];
            if (indexPath.row == 1) {
                freightL.text = [NSString stringWithFormat:@"-￥%@",self.model.integral];//@"-￥0.00";
            }
            if (indexPath.row == 2) {
                freightL.text = [NSString stringWithFormat:@"-￥%@",self.model.coupon];//@"-￥0.00";
            }
            mainCell.accessoryType = UITableViewCellAccessoryNone;
        }
        //订单信息
        if (indexPath.section == 4) {
            freightL = [[UILabel alloc] init];
            freightL.frame = CGRectMake(0, 10, WIDTH_SCREEN - 16, 30);
            freightL.textColor = XNColor(166, 166, 166, 1);
            freightL.textAlignment = NSTextAlignmentRight;
            freightL.font = [UIFont systemFontOfSize:13.0];
            mainCell.textLabel.text = @"订单编号";
            [mainCell.contentView addSubview:freightL];
            freightL.text = self.model.order_id;//@"6546565652300";
            if (indexPath.row == 1) {
                mainCell.textLabel.text = @"运单编号";
                freightL.text = self.model.courier_number;//@"64984164646465";
            } else if (indexPath.row == 2) {
                mainCell.textLabel.text = @"购买时间";
                freightL.text = [self calutTimeFromeTime:self.model.buy_time withType:1];//@"2016-11-18";
            }
            
        }
        
        mainCell.textLabel.font = XNFont(15.0);
        mainCell.textLabel.textColor = XNColor(17, 17, 17, 1);
        mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return mainCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 77;
    } else if (indexPath.section == 1) {
        return 215 - 25;
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
        self.logisticsVC.isManyOrder = self.isManyOrder;
        self.logisticsVC.order_id = self.model.order_id;
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

- (NSString *)calutTimeFromeTime:(NSString *)timeStr withType:(int)type {
    NSString *stringTime = @"";
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (type == 1) {
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        
    } else {
        [dateFormatter setDateFormat:@"HH:mm"];
        
    }
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[timeStr intValue]];
    
    stringTime = [dateFormatter stringFromDate:timeDate];
    
    return stringTime;
}


- (NSMutableAttributedString *)productTotalString:(NSString *)Tstr; {
    NSString *tmp = [Tstr componentsSeparatedByString:@"："][0];
    NSMutableAttributedString *mTmp = [[NSMutableAttributedString alloc] initWithString:Tstr];
    NSUInteger length = tmp.length;
    [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, length)];
    [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(length + 1, Tstr.length - length - 1)];
    [mTmp addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(length + 1, Tstr.length - length - 1)];
    
    return mTmp;
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

//售后(左侧按钮)
- (void)canceButtonPressed:(UIButton *)btn {
    
    switch ([self.model.type intValue]) {
        case 0:
            //            str = @"待付款";
            //            btnTitle = @"删除订单";
            //            btnTitle2 = @"立即付款";
            break;
            
        case 1:
            //            str = @"发货中";
            //            btnTitle = @"删除订单";
            //            btnTitle2 = @"确认收货";
            break;
            
        case 2:
            //            str = @"已发货";
            //            btnTitle = @"删除订单";
            //            btnTitle2 = @"确认收货";
            break;
            
        case 3:
            //            str = @"已完成";
            //            btnTitle = @"售后/退款";
            //            btnTitle2 = @"立即评价";
            
            self.afterSalesVC = [[NPYAfter_SalesViewController alloc] init];
            
            self.afterSalesVC.model.goods_img = self.model.goods_img;
            self.afterSalesVC.model.goods_name = self.model.goods_name;
            self.afterSalesVC.model.num = self.model.num;
            self.afterSalesVC.model.price = [NSString stringWithFormat:@"%.2f",[self.model.price doubleValue] * [self.model.num intValue]];
            
            [self.navigationController pushViewController:self.afterSalesVC animated:YES];
            
            break;
            
        case 4:
            //            str = @"已完成";
            //            btnTitle = @"售后/退款";
            //            btnTitle2 = @"立即评价";
            
            self.afterSalesVC = [[NPYAfter_SalesViewController alloc] init];
            
            [self.navigationController pushViewController:self.afterSalesVC animated:YES];
            
            break;
            
        case 5:
            //            str = @"售后";
            //            btnTitle2 = @"售后中";
            break;
            
        case -1:
            //            str = @"已取消";
            break;
            
        default:
            break;
    }
    
}

//评论
- (void)payButtonPressed:(UIButton *)btn {
    
    switch ([self.model.type intValue]) {
        case 0:
//            str = @"待付款";
//            btnTitle = @"删除订单";
//            btnTitle2 = @"立即付款";
            break;
            
        case 1:
//            str = @"发货中";
//            btnTitle = @"删除订单";
//            btnTitle2 = @"确认收货";
            break;
            
        case 2:
//            str = @"已发货";
//            btnTitle = @"删除订单";
//            btnTitle2 = @"确认收货";
            break;
            
        case 3:
//            str = @"已完成";
//            btnTitle = @"售后/退款";
//            btnTitle2 = @"立即评价";
            
            self.discusVC = [[NPYDiscusViewController alloc] init];
            self.discusVC.order_id = self.model.order_id;
            [self.navigationController pushViewController:self.discusVC animated:YES];
            
            break;
            
        case 4:
//            str = @"已完成";
//            btnTitle = @"售后/退款";
//            btnTitle2 = @"再次购买";

            self.goodsView = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
            self.goodsView.goodsModel.goods_id = self.model.goods_id;
            [self.navigationController pushViewController:self.goodsView animated:YES];
            
            break;
            
        case 5:
//            str = @"售后";
//            btnTitle2 = @"售后中";
            
            break;
            
        case -1:
//            str = @"已取消";
            break;
            
        default:
            break;
    }
    
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)orderStateString {
    NSArray *StringArr;
    NSString *str = @"";
    NSString *btnTitle = @"";
    NSString *btnTitle2 = @"";
    switch ([self.model.type intValue]) {
        case 0:
            str = @"待付款";
            btnTitle = @"删除订单";
            btnTitle2 = @"立即付款";
            break;
            
        case 1:
            str = @"发货中";
            btnTitle = @"售后/退款";
            btnTitle2 = @"确认收货";
            
            if (_isManyOrder) {
                str = @"已付款";
            }
            
            break;
            
        case 2:
            str = @"已发货";
            btnTitle = @"售后/退款";
            btnTitle2 = @"确认收货";
            break;
            
        case 3:
            str = @"待评价";
            btnTitle = @"售后/退款";
            btnTitle2 = @"立即评价";
            break;
            
        case 4:
            str = @"已完成";
            btnTitle = @"售后/退款";
            btnTitle2 = @"再次购买";
            break;
            
        case 5:
            str = @"售后";
            oneBtn.hidden = YES;
            btnTitle2 = @"售后中";
            break;
            
        case -1:
            str = @"已取消";
            oneBtn.hidden = YES;
            twoBtn.hidden = YES;
            break;
            
        default:
            break;
    }
    
    StringArr = @[str,btnTitle,btnTitle2];
    
    return StringArr;
}

- (void)requestOrderInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            //            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            NSDictionary *tpDict = dataDict[@"data"];
            NPYAddressModel *addressModel = [NPYAddressModel mj_objectWithKeyValues:dataDict[@"address"]];
            
            addressDic = [NSDictionary dictionaryWithObjectsAndKeys:addressModel.receiver,@"name",addressModel.phone,@"phone",addressModel.detailed,@"address",addressModel.address_id,@"address_id", nil];
            
            self.model = [NPYMyOrderDetailModel mj_objectWithKeyValues:tpDict];
            
            [totalMoneyL setAttributedText:[self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",[self.model.price doubleValue] * [self.model.num intValue] + [self.model.postage intValue]] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0]];
            
            [oneBtn setTitle:[self orderStateString][1] forState:UIControlStateNormal];
            [twoBtn setTitle:[self orderStateString][2] forState:UIControlStateNormal];
            
            [self.mainTView reloadData];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
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
